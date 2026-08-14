import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/network/api_exception.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/auth_user.dart';
import '../../data/services/auth_service.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../shared/widgets/notice_card.dart';
import '../../shared/widgets/otp_row.dart';

const _defaultResendCooldownSeconds = 30;

/// Router `extra` for `/verify-login-otp` — carries the challenge Login's
/// password check returned (AUTH_API.md's `two_step_required` response), and
/// the credentials that produced it, so "resend" can re-run `login()` to get
/// a fresh challenge/OTP (there's no separate resend endpoint — the OTP
/// email is sent as a side effect of `login()` itself).
class VerifyLoginOtpArgs {
  final String challengeToken;
  final String email;
  final String identifier;
  final String password;
  final bool rememberMe;

  const VerifyLoginOtpArgs({
    required this.challengeToken,
    required this.email,
    required this.identifier,
    required this.password,
    required this.rememberMe,
  });
}

/// Second step of a two-step login (PROJECT.md Settings: "two-step
/// verification"). Pushed from Login when its response is
/// `LoginTwoStepRequired` instead of a session — password already checked
/// out, this is the second factor.
class VerifyLoginOtpScreen extends StatefulWidget {
  final VerifyLoginOtpArgs args;

  const VerifyLoginOtpScreen({super.key, required this.args});

  @override
  State<VerifyLoginOtpScreen> createState() => _VerifyLoginOtpScreenState();
}

class _VerifyLoginOtpScreenState extends State<VerifyLoginOtpScreen> {
  final _otpKey = GlobalKey<OtpRowState>();
  final _authService = AuthService();

  late String _challengeToken = widget.args.challengeToken;
  String? _errorMessage;
  int _resendSecondsLeft = _defaultResendCooldownSeconds;
  Timer? _resendTimer;
  bool _isVerifying = false;
  bool _isResending = false;
  String _currentCode = '';

  @override
  void initState() {
    super.initState();
    _startResendTimer(_defaultResendCooldownSeconds);
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

  bool get _canResend => !_isResending && _resendSecondsLeft == 0;

  Future<void> _onResendTap() async {
    if (!_canResend) return;
    setState(() {
      _isResending = true;
      _errorMessage = null;
    });
    try {
      // login() re-issues a fresh challenge_token and sends a new OTP email
      // — there's no standalone resend endpoint for the 2FA step.
      final result = await _authService.login(
        identifier: widget.args.identifier,
        password: widget.args.password,
      );
      if (!mounted) return;
      if (result case LoginTwoStepRequired(:final challengeToken)) {
        setState(() => _challengeToken = challengeToken);
      }
      _otpKey.currentState?.clear();
      _startResendTimer(_defaultResendCooldownSeconds);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _errorMessage = e.message);
    } finally {
      if (mounted) setState(() => _isResending = false);
    }
  }

  void _onOtpChanged(String code) {
    setState(() {
      _currentCode = code;
      _errorMessage = null;
    });
  }

  void _onOtpCompleted(String code) {
    _verify(code);
  }

  Future<void> _verify(String code) async {
    if (_isVerifying) return;
    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    try {
      final session = await _authService.verifyLoginTwoStep(
        challengeToken: _challengeToken,
        otp: code,
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
        _errorMessage = e.fieldError('challenge_token') ?? e.fieldError('otp') ?? e.message;
      });
      return;
    }
    if (mounted) setState(() => _isVerifying = false);
  }

  String get _maskedEmail {
    final email = widget.args.email;
    final atIndex = email.indexOf('@');
    if (atIndex <= 0) return email;
    final visibleLength = atIndex > 2 ? 2 : 1;
    return '${email.substring(0, visibleLength)}${'•' * 3}${email.substring(atIndex)}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final canSubmit = _currentCode.length == otpLength && !_isVerifying;

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
              l10n.sentCodeMessage(_maskedEmail),
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            OtpRow(
              key: _otpKey,
              hasError: _errorMessage != null,
              onChanged: _onOtpChanged,
              onCompleted: _onOtpCompleted,
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
                        l10n.resendOtp,
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
