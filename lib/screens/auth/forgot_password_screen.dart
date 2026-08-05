import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:sendotp_flutter_sdk/sendotp_flutter_sdk.dart';

import '../../core/config/app_config.dart';
import '../../core/network/api_exception.dart';
import '../../core/theme/app_colors.dart';
import '../../data/services/auth_service.dart';
import '../../shared/widgets/otp_row.dart';
import '../../shared/widgets/phone_input.dart';
import 'widgets/auth_text_field.dart';

enum _Step { requestOtp, resetPassword }

// SMS retry channel per MSG91's widget SDK (`retryOTP`'s `retryChannel`):
// 1 = text, 11 = SMS, 2 = voice call.
const _smsRetryChannel = 11;

/// Forgot Password screen (PROJECT.md 7, Phase 3). Reuses phone_input and
/// otp_row directly rather than rebuilding either. The mockup shows both
/// steps stacked for review, but they're sequential in the real app: one
/// screen, internal state toggles between them (no route change) so the
/// back button can always return straight to Login regardless of step.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _phoneController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _otpKey = GlobalKey<OtpRowState>();
  final _authService = AuthService();

  _Step _step = _Step.requestOtp;
  String? _reqId;
  String _otpCode = '';
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isSendingOtp = false;
  bool _isUpdating = false;
  String? _requestError;
  String? _resetError;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_revalidate);
    _newPasswordController.addListener(_revalidate);
    _confirmPasswordController.addListener(_revalidate);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _revalidate() => setState(() {});

  bool get _canSendOtp => _phoneController.text.length == 10 && !_isSendingOtp;

  bool get _passwordsMismatch =>
      _confirmPasswordController.text.isNotEmpty &&
      _newPasswordController.text != _confirmPasswordController.text;

  bool get _canUpdatePassword =>
      _otpCode.length == otpLength &&
      _newPasswordController.text.length >= 6 &&
      _newPasswordController.text == _confirmPasswordController.text &&
      !_isUpdating;

  Future<void> _onSendOtp() async {
    if (!_canSendOtp) return;
    setState(() {
      _isSendingOtp = true;
      _requestError = null;
    });

    try {
      // Pre-check only — confirms an account exists for this mobile before
      // MSG91 is asked to send anything.
      await _authService.forgotPasswordPrecheck(_phoneController.text);
      OTPWidget.initializeWidget(AppConfig.msg91WidgetId, AppConfig.msg91AuthToken);
      final response = await OTPWidget.sendOTP({
        'identifier': '91${_phoneController.text}',
      }) as Map;
      if (!mounted) return;
      if (response['type'] == 'success') {
        setState(() {
          _reqId = response['message'] as String?;
          _step = _Step.resetPassword;
        });
      } else {
        setState(() => _requestError =
            response['message'] as String? ?? 'Could not send OTP right now.');
      }
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _requestError = e.fieldError('mobile') ?? e.message);
    } finally {
      if (mounted) setState(() => _isSendingOtp = false);
    }
  }

  Future<void> _onUpdatePassword() async {
    if (!_canUpdatePassword || _reqId == null) return;
    setState(() {
      _isUpdating = true;
      _resetError = null;
    });

    try {
      final verifyResponse = await OTPWidget.verifyOTP({
        'reqId': _reqId,
        'otp': _otpCode,
      }) as Map;

      if (verifyResponse['type'] != 'success') {
        if (!mounted) return;
        setState(() => _resetError =
            verifyResponse['message'] as String? ?? "That code didn't match.");
        return;
      }

      final accessToken = verifyResponse['message'] as String;
      final challenge = await _authService.verifyPasswordResetOtp(
        accessToken: accessToken,
        mobile: _phoneController.text,
      );
      await _authService.forgotPasswordReset(
        resetToken: challenge.resetToken,
        password: _newPasswordController.text,
        passwordConfirmation: _confirmPasswordController.text,
      );
      if (!mounted) return;
      context.go('/login', extra: 'Password updated. Log in with your new password.');
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _resetError = e.fieldError('password') ?? e.message);
    } finally {
      if (mounted) setState(() => _isUpdating = false);
    }
  }

  Future<void> _onResendOtp() async {
    if (_reqId == null) return;
    setState(() => _resetError = null);
    final response = await OTPWidget.retryOTP({
      'reqId': _reqId,
      'retryChannel': _smsRetryChannel,
    }) as Map;
    if (!mounted) return;
    if (response['type'] == 'success') {
      if (response['message'] is String) {
        setState(() => _reqId = response['message'] as String);
      }
      _otpKey.currentState?.clear();
      setState(() => _otpCode = '');
    } else {
      setState(() => _resetError =
          response['message'] as String? ?? 'Could not resend OTP right now.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, elevation: 0),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
          children: _step == _Step.requestOtp ? _buildRequestStep() : _buildResetStep(),
        ),
      ),
    );
  }

  List<Widget> _buildRequestStep() {
    return [
      Text(
        'Reset your password',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      const SizedBox(height: 6),
      const Text(
        "Enter your mobile number and we'll send a 6-digit OTP to reset "
        'your password.',
        style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
      ),
      const SizedBox(height: 24),
      const Text(
        'Mobile number',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      const SizedBox(height: 6),
      PhoneInput(controller: _phoneController),
      const SizedBox(height: 8),
      const Text(
        "Didn't get it? Check that your number can receive SMS, or wait a "
        'few minutes and try again.',
        style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
      ),
      if (_requestError != null) ...[
        const SizedBox(height: 12),
        Text(
          _requestError!,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: AppColors.danger,
          ),
        ),
      ],
      const SizedBox(height: 24),
      _PrimaryButton(
        label: 'Send OTP',
        enabled: _canSendOtp,
        isLoading: _isSendingOtp,
        onTap: _onSendOtp,
      ),
      const SizedBox(height: 20),
      Center(
        child: GestureDetector(
          onTap: () => context.pop(),
          child: RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              children: [
                TextSpan(text: 'Remembered it? '),
                TextSpan(
                  text: 'Back to log in',
                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildResetStep() {
    return [
      Text(
        'Verify & reset',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      const SizedBox(height: 6),
      Text(
        'Enter the 6-digit code sent to +91 $_maskedPhone, then choose a new password.',
        style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
      ),
      const SizedBox(height: 24),
      OtpRow(
        key: _otpKey,
        onChanged: (code) => setState(() => _otpCode = code),
        onCompleted: (code) => setState(() => _otpCode = code),
      ),
      const SizedBox(height: 8),
      Center(
        child: GestureDetector(
          onTap: _onResendOtp,
          child: const Text(
            'Resend OTP',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
      const SizedBox(height: 16),
      AuthTextField(
        controller: _newPasswordController,
        label: 'New password',
        hintText: 'At least 8 characters',
        obscureText: _obscureNewPassword,
        suffixIcon: IconButton(
          icon: Icon(
            _obscureNewPassword ? LucideIcons.eye : LucideIcons.eyeOff,
            size: 18,
            color: AppColors.textSecondary,
          ),
          onPressed: () => setState(() => _obscureNewPassword = !_obscureNewPassword),
        ),
      ),
      const SizedBox(height: 16),
      AuthTextField(
        controller: _confirmPasswordController,
        label: 'Confirm password',
        hintText: 'Re-enter new password',
        obscureText: _obscureConfirmPassword,
        suffixIcon: IconButton(
          icon: Icon(
            _obscureConfirmPassword ? LucideIcons.eye : LucideIcons.eyeOff,
            size: 18,
            color: AppColors.textSecondary,
          ),
          onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
        ),
      ),
      if (_passwordsMismatch) ...[
        const SizedBox(height: 8),
        const Text(
          'Passwords do not match.',
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: AppColors.danger,
          ),
        ),
      ],
      if (_resetError != null) ...[
        const SizedBox(height: 8),
        Text(
          _resetError!,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: AppColors.danger,
          ),
        ),
      ],
      const SizedBox(height: 24),
      _PrimaryButton(
        label: 'Update password',
        enabled: _canUpdatePassword,
        isLoading: _isUpdating,
        onTap: _onUpdatePassword,
      ),
    ];
  }

  String get _maskedPhone {
    final digits = _phoneController.text;
    if (digits.length != 10) return digits;
    return '${digits.substring(0, 2)}${'•' * 6}${digits.substring(8)}';
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final bool isLoading;
  final VoidCallback onTap;

  const _PrimaryButton({
    required this.label,
    required this.enabled,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: enabled
              ? const LinearGradient(
                  colors: [AppColors.primaryGradientStart, AppColors.primaryGradientEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: enabled ? null : AppColors.textSecondary.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: enabled ? onTap : null,
            borderRadius: BorderRadius.circular(14),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : Text(
                      label,
                      style: TextStyle(
                        color: enabled ? Colors.white : Colors.white.withValues(alpha: 0.7),
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
