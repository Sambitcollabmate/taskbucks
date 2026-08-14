import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/network/api_exception.dart';
import '../../core/theme/app_colors.dart';
import '../../data/services/auth_service.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/otp_row.dart';
import 'widgets/auth_text_field.dart';

enum _Step { requestOtp, resetPassword }

/// Forgot Password screen (PROJECT.md 7, Phase 3). Reuses otp_row directly
/// rather than rebuilding it. The mockup shows both steps stacked for
/// review, but they're sequential in the real app: one screen, internal
/// state toggles between them (no route change) so the back button can
/// always return straight to Login regardless of step.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _otpKey = GlobalKey<OtpRowState>();
  final _authService = AuthService();

  _Step _step = _Step.requestOtp;
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
    _emailController.addListener(_revalidate);
    _newPasswordController.addListener(_revalidate);
    _confirmPasswordController.addListener(_revalidate);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _revalidate() => setState(() {});

  bool get _canSendOtp => _emailController.text.trim().isNotEmpty && !_isSendingOtp;

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
      // Pre-check, but also the moment EmailOtpService actually sends the
      // code — confirms an account exists for this email first.
      await _authService.forgotPasswordPrecheck(_emailController.text.trim());
      if (!mounted) return;
      setState(() => _step = _Step.resetPassword);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _requestError = e.fieldError('email') ?? e.message);
    } finally {
      if (mounted) setState(() => _isSendingOtp = false);
    }
  }

  Future<void> _onUpdatePassword() async {
    if (!_canUpdatePassword) return;
    setState(() {
      _isUpdating = true;
      _resetError = null;
    });

    try {
      final challenge = await _authService.verifyPasswordResetOtp(
        otp: _otpCode,
        email: _emailController.text.trim(),
      );
      await _authService.forgotPasswordReset(
        resetToken: challenge.resetToken,
        password: _newPasswordController.text,
        passwordConfirmation: _confirmPasswordController.text,
      );
      if (!mounted) return;
      context.go('/login', extra: AppLocalizations.of(context).passwordUpdatedLoginMessage);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _resetError = e.fieldError('otp') ?? e.fieldError('password') ?? e.message);
    } finally {
      if (mounted) setState(() => _isUpdating = false);
    }
  }

  Future<void> _onResendOtp() async {
    setState(() => _resetError = null);
    try {
      await _authService.forgotPasswordPrecheck(_emailController.text.trim());
      if (!mounted) return;
      _otpKey.currentState?.clear();
      setState(() => _otpCode = '');
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _resetError = e.message);
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
    final l10n = AppLocalizations.of(context);
    return [
      Text(
        l10n.resetPasswordTitle,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      const SizedBox(height: 6),
      Text(
        l10n.resetPasswordSubtitle,
        style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
      ),
      const SizedBox(height: 24),
      AuthTextField(
        controller: _emailController,
        label: l10n.emailAddressLabel,
        hintText: 'you@example.com',
        keyboardType: TextInputType.emailAddress,
      ),
      const SizedBox(height: 8),
      Text(
        l10n.didntGetOtp,
        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
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
        label: l10n.sendOtp,
        enabled: _canSendOtp,
        isLoading: _isSendingOtp,
        onTap: _onSendOtp,
      ),
      const SizedBox(height: 20),
      Center(
        child: GestureDetector(
          onTap: () => context.pop(),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
              children: [
                TextSpan(text: l10n.remembered),
                TextSpan(
                  text: l10n.backToLogin,
                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildResetStep() {
    final l10n = AppLocalizations.of(context);
    return [
      Text(
        l10n.verifyAndReset,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      const SizedBox(height: 6),
      Text(
        l10n.verifyResetSubtitle(_maskedEmail),
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
          child: Text(
            l10n.resendOtp,
            style: const TextStyle(
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
        label: l10n.newPasswordLabel,
        hintText: l10n.passwordHintChars,
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
        label: l10n.confirmPasswordLabel,
        hintText: l10n.confirmPasswordHint,
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
        Text(
          l10n.passwordsDoNotMatch,
          style: const TextStyle(
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
        label: l10n.updatePassword,
        enabled: _canUpdatePassword,
        isLoading: _isUpdating,
        onTap: _onUpdatePassword,
      ),
    ];
  }

  String get _maskedEmail {
    final email = _emailController.text.trim();
    final atIndex = email.indexOf('@');
    if (atIndex <= 0) return email;
    final visibleLength = atIndex > 2 ? 2 : 1;
    return '${email.substring(0, visibleLength)}${'•' * 3}${email.substring(atIndex)}';
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
