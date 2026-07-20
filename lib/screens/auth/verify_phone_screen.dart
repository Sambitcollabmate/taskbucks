import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../shared/widgets/notice_card.dart';
import '../../shared/widgets/otp_row.dart';

const _resendCooldownSeconds = 30;

/// Stub states for the three error cases called out in PROJECT.md's Verify
/// Phone notes. Nothing currently drives these transitions since there's no
/// backend yet — real OTP verification wiring will set [_errorState] based
/// on the API response.
enum _OtpError { none, wrongCode, expiredCode, tooManyAttempts }

/// Verify Phone screen (PROJECT.md 7, Phase 3). Pushed from Register with
/// the 10-digit number as `extra` so the masked number can be shown here.
class VerifyPhoneScreen extends StatefulWidget {
  final String phoneNumber;

  const VerifyPhoneScreen({super.key, this.phoneNumber = ''});

  @override
  State<VerifyPhoneScreen> createState() => _VerifyPhoneScreenState();
}

class _VerifyPhoneScreenState extends State<VerifyPhoneScreen> {
  final _otpKey = GlobalKey<OtpRowState>();

  _OtpError _error = _OtpError.none;
  int _resendSecondsLeft = _resendCooldownSeconds;
  Timer? _resendTimer;
  bool _isVerifying = false;
  String _currentCode = '';

  // TODO: wire SMS auto-fill (see PROJECT.md Verify Phone notes) — Android
  // SMS Retriever/User Consent API is a native-integration task for later.
  // The otp_row above should be filled programmatically once that lands.

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _resendTimer?.cancel();
    setState(() => _resendSecondsLeft = _resendCooldownSeconds);
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSecondsLeft <= 1) {
        timer.cancel();
        setState(() => _resendSecondsLeft = 0);
      } else {
        setState(() => _resendSecondsLeft -= 1);
      }
    });
  }

  bool get _canResend => _resendSecondsLeft == 0 || _error == _OtpError.expiredCode;

  void _onResendTap() {
    if (!_canResend) return;
    // TODO: call resend-OTP API.
    setState(() => _error = _OtpError.none);
    _otpKey.currentState?.clear();
    _startResendTimer();
  }

  void _onOtpChanged(String code) {
    setState(() {
      _currentCode = code;
      if (_error != _OtpError.none) _error = _OtpError.none;
    });
  }

  void _onOtpCompleted(String code) {
    _verify(code);
  }

  Future<void> _verify(String code) async {
    if (_isVerifying || _error == _OtpError.tooManyAttempts) return;
    setState(() => _isVerifying = true);

    // TODO: replace with a real verify-OTP API call. For now any complete
    // 6-digit code is treated as correct — wrong/expired/lockout states
    // above are stubbed but nothing sets them yet without a backend.
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    setState(() => _isVerifying = false);
    context.go('/home');
  }

  String get _maskedPhone {
    final digits = widget.phoneNumber;
    if (digits.length != 10) return digits;
    return '${digits.substring(0, 2)}${'•' * 6}${digits.substring(8)}';
  }

  String? get _errorMessage {
    switch (_error) {
      case _OtpError.wrongCode:
        return 'Incorrect code. Please check and try again.';
      case _OtpError.expiredCode:
        return 'This code has expired. Request a new one.';
      case _OtpError.tooManyAttempts:
        return "Too many attempts. You're temporarily locked out — try again later.";
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
            Text(
              'Verify your number',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 6),
            Text(
              'Enter the 6-digit code sent to +91 $_maskedPhone',
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
                        "Didn't get the code? Resend in 0:${_resendSecondsLeft.toString().padLeft(2, '0')}",
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
              message: "On DND or don't see the SMS? It can take up to 2 minutes to arrive — "
                  "double-check your messages app before requesting a resend.",
            ),
          ],
        ),
      ),
    );
  }
}
