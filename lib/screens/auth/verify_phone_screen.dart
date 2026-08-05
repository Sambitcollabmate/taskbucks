import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sendotp_flutter_sdk/sendotp_flutter_sdk.dart';

import '../../core/config/app_config.dart';
import '../../core/network/api_exception.dart';
import '../../core/theme/app_colors.dart';
import '../../data/services/auth_service.dart';
import '../../providers/auth_provider.dart';
import '../../shared/widgets/notice_card.dart';
import '../../shared/widgets/otp_row.dart';

const _defaultResendCooldownSeconds = 30;

// SMS retry channel per MSG91's widget SDK (`retryOTP`'s `retryChannel`):
// 1 = text, 11 = SMS, 2 = voice call.
const _smsRetryChannel = 11;

/// Error cases surfaced by MSG91's widget (`OTPWidget.verifyOTP`) — the
/// widget owns OTP generation/expiry/attempt-limiting entirely now
/// (MSG91_WIDGET_REVIEW.md), so this only classifies its failure callback,
/// it doesn't enforce any of these itself.
enum _OtpError { none, wrongCode, expiredCode, tooManyAttempts }

/// Router `extra` for `/verify-phone` — carries the registration form data
/// collected on Register, since nothing is persisted server-side until
/// `verify-otp` succeeds (there's no more `reference_token`/pending record;
/// MSG91's widget owns the OTP lifecycle end to end).
class VerifyPhoneArgs {
  final String name;
  final String phoneNumber;
  final String? email;
  final String password;
  final String? referralCode;

  const VerifyPhoneArgs({
    required this.name,
    required this.phoneNumber,
    this.email,
    required this.password,
    this.referralCode,
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

  String? _reqId;
  _OtpError _error = _OtpError.none;
  String? _errorMessageOverride;
  int _resendSecondsLeft = _defaultResendCooldownSeconds;
  Timer? _resendTimer;
  bool _isSendingInitialOtp = true;
  bool _isVerifying = false;
  bool _isResending = false;
  String _currentCode = '';

  // TODO: wire SMS auto-fill (see PROJECT.md Verify Phone notes) — Android
  // SMS Retriever/User Consent API is a native-integration task for later.
  // The otp_row above should be filled programmatically once that lands.

  @override
  void initState() {
    super.initState();
    _initWidgetAndSendOtp();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }

  Future<void> _initWidgetAndSendOtp() async {
    OTPWidget.initializeWidget(AppConfig.msg91WidgetId, AppConfig.msg91AuthToken);
    await _sendOtp();
  }

  Future<void> _sendOtp() async {
    setState(() => _isSendingInitialOtp = true);
    try {
      final response = await OTPWidget.sendOTP({
        'identifier': '91${widget.args.phoneNumber}',
      }) as Map;
      if (response['type'] == 'success') {
        if (!mounted) return;
        setState(() {
          _reqId = response['message'] as String?;
          _errorMessageOverride = null;
        });
        _startResendTimer(_defaultResendCooldownSeconds);
      } else if (mounted) {
        setState(() => _errorMessageOverride =
            response['message'] as String? ?? 'Could not send OTP right now.');
      }
    } finally {
      if (mounted) setState(() => _isSendingInitialOtp = false);
    }
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
      (_resendSecondsLeft == 0 || _error == _OtpError.expiredCode) &&
      !_isResending &&
      _reqId != null;

  Future<void> _onResendTap() async {
    if (!_canResend) return;
    setState(() => _isResending = true);
    try {
      final response = await OTPWidget.retryOTP({
        'reqId': _reqId,
        'retryChannel': _smsRetryChannel,
      }) as Map;
      if (!mounted) return;
      if (response['type'] == 'success') {
        setState(() {
          if (response['message'] is String) _reqId = response['message'] as String;
          _error = _OtpError.none;
          _errorMessageOverride = null;
        });
        _otpKey.currentState?.clear();
        _startResendTimer(_defaultResendCooldownSeconds);
      } else {
        setState(() => _errorMessageOverride =
            response['message'] as String? ?? 'Could not resend OTP right now.');
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
    if (_isVerifying || _reqId == null || _error == _OtpError.tooManyAttempts) return;
    setState(() => _isVerifying = true);

    final response = await OTPWidget.verifyOTP({'reqId': _reqId, 'otp': code}) as Map;

    if (response['type'] != 'success') {
      if (!mounted) return;
      final message = response['message'] as String? ?? "That code didn't match.";
      setState(() {
        _isVerifying = false;
        _errorMessageOverride = message;
        final lower = message.toLowerCase();
        if (lower.contains('max') || lower.contains('too many')) {
          _error = _OtpError.tooManyAttempts;
        } else if (lower.contains('expired') || lower.contains('invalid')) {
          _error = _OtpError.expiredCode;
        } else {
          _error = _OtpError.wrongCode;
        }
      });
      return;
    }

    final accessToken = response['message'] as String;

    try {
      final session = await _authService.verifyRegistration(
        accessToken: accessToken,
        name: widget.args.name,
        mobile: widget.args.phoneNumber,
        email: widget.args.email,
        password: widget.args.password,
        referralCode: widget.args.referralCode,
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
      setState(() {
        _isVerifying = false;
        _errorMessageOverride = e.fieldError('mobile') ?? e.message;
        _error = _OtpError.wrongCode;
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
    final canSubmit = notLockedOut &&
        _currentCode.length == otpLength &&
        !_isVerifying &&
        _reqId != null;

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
              _isSendingInitialOtp
                  ? 'Sending a 6-digit code by SMS to +91 $_maskedPhone…'
                  : "We've sent a 6-digit code by SMS to +91 $_maskedPhone.",
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
