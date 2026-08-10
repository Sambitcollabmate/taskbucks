import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sendotp_flutter_sdk/sendotp_flutter_sdk.dart';

import '../../core/config/app_config.dart';
import '../../core/network/api_exception.dart';
import '../../core/theme/app_colors.dart';
import '../../data/services/auth_service.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../shared/widgets/notice_card.dart';
import '../../shared/widgets/otp_row.dart';

const _defaultResendCooldownSeconds = 30;

// SMS retry channel per MSG91's widget SDK (`retryOTP`'s `retryChannel`):
// 1 = text, 11 = SMS, 2 = voice call.
const _smsRetryChannel = 11;

/// Same failure classification as Verify Phone's `_OtpError` — the widget
/// owns OTP generation/expiry/attempt-limiting entirely, this only
/// classifies its failure callback.
enum _OtpError { none, wrongCode, expiredCode, tooManyAttempts }

/// Router `extra` for `/verify-login-otp` — carries the challenge Login's
/// password check returned (AUTH_API.md's `two_step_required` response),
/// since no session exists yet for this backend to key state off of.
class VerifyLoginOtpArgs {
  final String challengeToken;
  final String mobile;
  final bool rememberMe;

  const VerifyLoginOtpArgs({
    required this.challengeToken,
    required this.mobile,
    required this.rememberMe,
  });
}

/// Second step of a two-step login (PROJECT.md Settings: "two-step
/// verification"). Pushed from Login when its response is
/// `LoginTwoStepRequired` instead of a session — password already checked
/// out, this is the second factor. Deliberately mirrors Verify Phone's
/// OTPWidget usage verbatim rather than introducing a new pattern.
class VerifyLoginOtpScreen extends StatefulWidget {
  final VerifyLoginOtpArgs args;

  const VerifyLoginOtpScreen({super.key, required this.args});

  @override
  State<VerifyLoginOtpScreen> createState() => _VerifyLoginOtpScreenState();
}

class _VerifyLoginOtpScreenState extends State<VerifyLoginOtpScreen> {
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
    OTPWidget.initializeWidget(
      AppConfig.msg91WidgetId,
      AppConfig.msg91AuthToken,
    );
    await _sendOtp();
  }

  Future<void> _sendOtp() async {
    setState(() => _isSendingInitialOtp = true);
    try {
      final response =
          await OTPWidget.sendOTP({'identifier': '91${widget.args.mobile}'})
              as Map;
      if (response['type'] == 'success') {
        if (!mounted) return;
        setState(() {
          _reqId = response['message'] as String?;
          _errorMessageOverride = null;
        });
        _startResendTimer(_defaultResendCooldownSeconds);
      } else if (mounted) {
        setState(
          () => _errorMessageOverride =
              response['message'] as String? ??
              AppLocalizations.of(context).couldNotSendOtp,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(
          () => _errorMessageOverride = AppLocalizations.of(
            context,
          ).couldNotSendOtpWithError('$e'),
        );
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

  bool get _initialSendFailed => _reqId == null && !_isSendingInitialOtp;

  bool get _canResend =>
      !_isResending &&
      !_isSendingInitialOtp &&
      (_initialSendFailed ||
          _resendSecondsLeft == 0 ||
          _error == _OtpError.expiredCode);

  Future<void> _onResendTap() async {
    if (!_canResend) return;

    if (_initialSendFailed) {
      await _sendOtp();
      return;
    }

    setState(() => _isResending = true);
    try {
      final response =
          await OTPWidget.retryOTP({
                'reqId': _reqId,
                'retryChannel': _smsRetryChannel,
              })
              as Map;
      if (!mounted) return;
      if (response['type'] == 'success') {
        setState(() {
          if (response['message'] is String) {
            _reqId = response['message'] as String;
          }
          _error = _OtpError.none;
          _errorMessageOverride = null;
        });
        _otpKey.currentState?.clear();
        _startResendTimer(_defaultResendCooldownSeconds);
      } else {
        setState(
          () => _errorMessageOverride =
              response['message'] as String? ??
              AppLocalizations.of(context).couldNotResendOtp,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(
          () => _errorMessageOverride = AppLocalizations.of(
            context,
          ).couldNotResendOtpWithError('$e'),
        );
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
    if (_isVerifying || _reqId == null || _error == _OtpError.tooManyAttempts) {
      return;
    }
    setState(() => _isVerifying = true);

    final Map response;
    try {
      response =
          await OTPWidget.verifyOTP({'reqId': _reqId, 'otp': code}) as Map;
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isVerifying = false;
        _errorMessageOverride = AppLocalizations.of(
          context,
        ).couldNotVerifyRightNow('$e');
        _error = _OtpError.wrongCode;
      });
      return;
    }

    if (response['type'] != 'success') {
      if (!mounted) return;
      final message =
          response['message'] as String? ??
          AppLocalizations.of(context).otpDidNotMatch;
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
      final session = await _authService.verifyLoginTwoStep(
        challengeToken: widget.args.challengeToken,
        accessToken: accessToken,
      );
      if (!mounted) return;
      await context.read<AuthProvider>().completeLogin(
        session,
        rememberMe: widget.args.rememberMe,
      );
      if (!mounted) return;
      context.go('/home');
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _isVerifying = false;
        // A challenge_token error here means the 10-minute window on the
        // backend's Cache::put lapsed — no amount of retrying the OTP fixes
        // that, the user needs a fresh password+challenge round trip.
        _errorMessageOverride =
            e.fieldError('challenge_token') ??
            e.fieldError('access_token') ??
            e.message;
        _error = _OtpError.wrongCode;
      });
      return;
    }
    if (mounted) setState(() => _isVerifying = false);
  }

  String get _maskedPhone {
    final digits = widget.args.mobile;
    if (digits.length != 10) return digits;
    return '${digits.substring(0, 2)}${'•' * 6}${digits.substring(8)}';
  }

  String? get _errorMessage {
    if (_errorMessageOverride != null) return _errorMessageOverride;
    final l10n = AppLocalizations.of(context);
    switch (_error) {
      case _OtpError.wrongCode:
        return l10n.otpCodeMismatchRetry;
      case _OtpError.expiredCode:
        return l10n.otpCodeExpired;
      case _OtpError.tooManyAttempts:
        return l10n.otpTooManyAttempts;
      case _OtpError.none:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final notLockedOut = _error != _OtpError.tooManyAttempts;
    final canSubmit =
        notLockedOut &&
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
            Text(
              l10n.twoStepVerification,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.verifyYourPhone,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 6),
            Text(
              _isSendingInitialOtp
                  ? l10n.sendingCodeMessage(_maskedPhone)
                  : l10n.sentCodeMessage(_maskedPhone),
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
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
                    ? Text(
                        _initialSendFailed ? l10n.tryAgain : l10n.resendOtp,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      )
                    : Text(
                        l10n.resendOtpInCountdown(
                          _resendSecondsLeft.toString().padLeft(2, '0'),
                        ),
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
                  color: canSubmit
                      ? null
                      : AppColors.textSecondary.withValues(alpha: 0.25),
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
                                valueColor: AlwaysStoppedAnimation(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              l10n.verifyAndContinue,
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
                onTap: () => context.go('/login'),
                child: Text(
                  l10n.backToLogin,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            NoticeCard(variant: NoticeVariant.info, message: l10n.smsDndNotice),
          ],
        ),
      ),
    );
  }
}
