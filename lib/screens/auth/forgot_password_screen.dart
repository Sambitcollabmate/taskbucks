import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../shared/widgets/otp_row.dart';
import '../../shared/widgets/phone_input.dart';
import 'widgets/auth_text_field.dart';

enum _Step { requestOtp, resetPassword }

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

  _Step _step = _Step.requestOtp;
  String _otpCode = '';
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isSendingOtp = false;
  bool _isUpdating = false;

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
    setState(() => _isSendingOtp = true);

    // TODO: replace with a real send-OTP API call once the Laravel backend
    // exists (PROJECT.md 4).
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    setState(() {
      _isSendingOtp = false;
      _step = _Step.resetPassword;
    });
  }

  Future<void> _onUpdatePassword() async {
    if (!_canUpdatePassword) return;
    setState(() => _isUpdating = true);

    // TODO: replace with a real verify-OTP + reset-password API call once
    // the Laravel backend exists (PROJECT.md 4).
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    setState(() => _isUpdating = false);
    context.go('/login', extra: 'Password updated. Log in with your new password.');
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
        "Enter the mobile number on your account and we'll send a 6-digit "
        'code to verify it\'s you before you set a new password.',
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
      const SizedBox(height: 24),
      _PrimaryButton(
        label: 'Send OTP',
        enabled: _canSendOtp,
        isLoading: _isSendingOtp,
        onTap: _onSendOtp,
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
      const SizedBox(height: 24),
      AuthTextField(
        controller: _newPasswordController,
        label: 'New password',
        hintText: 'Create a new password',
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
        hintText: 'Re-enter your new password',
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
