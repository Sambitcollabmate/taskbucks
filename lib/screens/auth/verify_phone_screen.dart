import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/network/api_exception.dart';
import '../../core/theme/app_colors.dart';
import '../../data/services/auth_service.dart';
import '../../providers/auth_provider.dart';
import '../../shared/widgets/notice_card.dart';
import '../../shared/widgets/otp_row.dart';

const _defaultResendCooldownSeconds = 30;

/// Error cases called out in PROJECT.md's Verify Phone notes, now driven by
/// the real `POST /v1/auth/verify-otp` response (AUTH_API.md): wrong code
/// (with attempts-remaining in the message), expired/invalidated reference,
/// and the 5th-wrong-attempt lockout.
enum _OtpError { none, wrongCode, expiredCode, tooManyAttempts }

/// Router `extra` for `/verify-phone` — carries what Register's
/// `POST /v1/auth/register` call returned, so this screen has a
/// `reference_token` to verify against and knows the real resend cooldown.
class VerifyPhoneArgs {
  final String phoneNumber;
  final String referenceToken;
  final int resendCooldownSeconds;

  const VerifyPhoneArgs({
    required this.phoneNumber,
    required this.referenceToken,
    this.resendCooldownSeconds = _defaultResendCooldownSeconds,
  });
}

/// Verify Phone screen (PROJECT.md 7, Phase 3). Pushed from Register with a
/// [VerifyPhoneArgs] as `extra`.
class VerifyPhoneScreen extends StatefulWidget {
  final VerifyPhoneArgs args;

  const VerifyPhoneScreen({super.key, required this.args});

  @override
  State<VerifyPhoneScreen> createState() => _VerifyPhoneScreenState();
}

class _VerifyPhoneScreenState extends State<VerifyPhoneScreen> {
  final _otpKey = GlobalKey<OtpRowState>();
  final _authService = AuthService();

  late String _referenceToken = widget.args.referenceToken;
  _OtpError _error = _OtpError.none;
  String? _errorMessageOverride;
  int _resendSecondsLeft = _defaultResendCooldownSeconds;
  Timer? _resendTimer;
  bool _isVerifying = false;
  bool _isResending = false;
  String _currentCode = '';

  // TODO: wire SMS auto-fill (see PROJECT.md Verify Phone notes) — Android
  // SMS Retriever/User Consent API is a native-integration task for later.
  // The otp_row above should be filled programmatically once that lands.

  @override
  void initState() {
    super.initState();
    _startResendTimer(widget.args.resendCooldownSeconds);
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer(int seconds) {
    _resendTimer?.cancel();
    setState(() => _resendSecondsLeft = seconds);
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSecondsLeft <= 1) {
        timer.cancel();
        setState(() => _resendSecondsLeft = 0);
      } else {
        setState(() => _resendSecondsLeft -= 1);
      }
    });
  }

  bool get _canResend =>
      (_resendSecondsLeft == 0 || _error == _OtpError.expiredCode) && !_isResending;

  Future<void> _onResendTap() async {
    if (!_canResend) return;
    setState(() => _isResending = true);
    try {
      final challenge = await _authService.resendOtp(_referenceToken);
      if (!mounted) return;
      setState(() {
        _referenceToken = challenge.referenceToken;
        _error = _OtpError.none;
        _errorMessageOverride = null;
      });
      _otpKey.currentState?.clear();
      _startResendTimer(challenge.resendCooldownSeconds);
    } on ApiException catch (e) {
      if (!mounted) return;
      if (e.statusCode == 429 && e.retryAfterSeconds != null) {
        _startResendTimer(e.retryAfterSeconds!);
      } else {
        setState(() => _errorMessageOverride = e.fieldError('reference_token') ?? e.message);
      }
    } finally {
      if (mounted) setState(() => _isResending = false);
    }
  }

  void _onOtpChanged(String code) {
    setState(() {
      _currentCode = code;
      if (_error != _OtpError.none) _error = _OtpError.none;
      _errorMessageOverride = null;
    });
  }

  void _onOtpCompleted(String code) {
    _verify(code);
  }

  Future<void> _verify(String code) async {
    if (_isVerifying || _error == _OtpError.tooManyAttempts) return;
    setState(() => _isVerifying = true);

    try {
      final session = await _authService.verifyOtp(
        referenceToken: _referenceToken,
        otp: code,
      );
      if (!mounted) return;
      // Registration establishes a fresh session with no "remember me"
      // checkbox on this flow — persist by default so a freshly-registered
      // user doesn't get logged out on the next app restart.
      await context.read<AuthProvider>().completeLogin(session, rememberMe: true);
      if (!mounted) return;
      context.go('/home');
    } on ApiException catch (e) {
      if (!mounted) return;
      // Laravel's ValidationException puts the actual reason in
      // errors.otp/errors.reference_token — the top-level `message` is
      // just the generic "The given data was invalid."
      // (AuthController::consumeOtp).
      final otpError = e.fieldError('otp');
      final referenceError = e.fieldError('reference_token');
      setState(() {
        _isVerifying = false;
        _errorMessageOverride = otpError ?? referenceError ?? e.message;
        if (otpError?.contains('Too many incorrect attempts') == true) {
          _error = _OtpError.tooManyAttempts;
        } else if (otpError?.contains('expired') == true || referenceError != null) {
          _error = _OtpError.expiredCode;
        } else {
          _error = _OtpError.wrongCode;
        }
      });
      return;
    }
    if (mounted) setState(() => _isVerifying = false);
  }

  String get _maskedPhone {
    final digits = widget.args.phoneNumber;
    if (digits.length != 10) return digits;
    return '${digits.substring(0, 2)}${'•' * 6}${digits.substring(8)}';
  }

  String? get _errorMessage {
    if (_errorMessageOverride != null) return _errorMessageOverride;
    switch (_error) {
      case _OtpError.wrongCode:
        return "That code didn't match. Check and try again.";
      case _OtpError.expiredCode:
        return 'This code has expired — request a new one.';
      case _OtpError.tooManyAttempts:
        return "Too many attempts. You're temporarily locked out for 5 minutes.";
      case _OtpError.none:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final notLockedOut = _error != _OtpError.tooManyAttempts;
    final canSubmit = notLockedOut && _currentCode.length == otpLength && !_isVerifying;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, elevation: 0),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
          children: [
            const Text(
              'One more step',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Verify your phone number',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 6),
            Text(
              "We've sent a 6-digit code by SMS to +91 $_maskedPhone.",
              style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            OtpRow(
              key: _otpKey,
              hasError: _error == _OtpError.wrongCode,
              onChanged: _onOtpChanged,
              onCompleted: notLockedOut ? _onOtpCompleted : (_) {},
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 10),
              Text(
                _errorMessage!,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.danger,
                ),
              ),
            ],
            const SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap: _canResend ? _onResendTap : null,
                child: _canResend
                    ? const Text(
                        'Resend OTP',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      )
                    : Text(
                        "Didn't get the code? Resend OTP in 0:${_resendSecondsLeft.toString().padLeft(2, '0')}",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary.withValues(alpha: 0.6),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: canSubmit
                      ? const LinearGradient(
                          colors: [
                            AppColors.primaryGradientStart,
                            AppColors.primaryGradientEnd,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: canSubmit ? null : AppColors.textSecondary.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: canSubmit
                        ? () => _verify(_otpKey.currentState?.code ?? '')
                        : null,
                    borderRadius: BorderRadius.circular(14),
                    child: Center(
                      child: _isVerifying
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.4,
                                valueColor: AlwaysStoppedAnimation(Colors.white),
                              ),
                            )
                          : Text(
                              'Verify & continue',
                              style: TextStyle(
                                color: canSubmit
                                    ? Colors.white
                                    : Colors.white.withValues(alpha: 0.7),
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: GestureDetector(
                onTap: () => context.pop(),
                child: const Text(
                  'Change mobile number',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const NoticeCard(
              variant: NoticeVariant.info,
              message: 'Make sure your number can receive SMS — some DND (Do '
                  'Not Disturb) settings block OTP messages. Code expires in '
                  '10 minutes.',
            ),
          ],
        ),
      ),
    );
  }
}
