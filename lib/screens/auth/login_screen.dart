import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../core/config/app_config.dart';
import '../../core/network/api_exception.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/auth_user.dart';
import '../../data/services/auth_service.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import 'verify_login_otp_screen.dart';
import 'widgets/auth_text_field.dart';

final _mobilePattern = RegExp(r'^\d{10}$');
final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

/// Login screen (PROJECT.md 7, Phase 3). Deliberately the simplest pre-auth
/// screen — no back button, no stats/trust badges/upsell — just the form.
class LoginScreen extends StatefulWidget {
  final String? successMessage;

  const LoginScreen({super.key, this.successMessage});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _isLoggingIn = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _identifierController.addListener(_revalidate);
    _passwordController.addListener(_revalidate);
    if (widget.successMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(widget.successMessage!)));
      });
    }
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _revalidate() => setState(() {});

  bool get _isIdentifierValid {
    final value = _identifierController.text.trim();
    return _mobilePattern.hasMatch(value) || _emailPattern.hasMatch(value);
  }

  bool get _isValid =>
      _isIdentifierValid && _passwordController.text.isNotEmpty;

  Future<void> _onLogin() async {
    if (!_isValid || _isLoggingIn) return;
    setState(() {
      _isLoggingIn = true;
      _errorMessage = null;
    });

    try {
      final result = await _authService.login(
        identifier: _identifierController.text.trim(),
        password: _passwordController.text,
      );
      if (!mounted) return;
      switch (result) {
        case LoginSuccess(:final session):
          await context.read<AuthProvider>().completeLogin(
            session,
            rememberMe: _rememberMe,
          );
          if (!mounted) return;
          context.go('/home');
        case LoginTwoStepRequired(:final challengeToken, :final mobile):
          context.push(
            '/verify-login-otp',
            extra: VerifyLoginOtpArgs(
              challengeToken: challengeToken,
              mobile: mobile,
              rememberMe: _rememberMe,
            ),
          );
      }
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _errorMessage = e.fieldError('identifier') ?? e.message);
    } finally {
      if (mounted) setState(() => _isLoggingIn = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
          children: [
            Text(
              l10n.loginTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 6),
            Text(
              l10n.loginSubtitle,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            AuthTextField(
              controller: _identifierController,
              label: l10n.mobileOrEmailLabel,
              hintText: l10n.mobileOrEmailHint,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            AuthTextField(
              controller: _passwordController,
              label: l10n.passwordLabel,
              hintText: l10n.passwordHint,
              obscureText: _obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? LucideIcons.eye : LucideIcons.eyeOff,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => setState(() => _rememberMe = !_rememberMe),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 22,
                        height: 22,
                        child: Checkbox(
                          value: _rememberMe,
                          onChanged: (v) =>
                              setState(() => _rememberMe = v ?? false),
                          activeColor: AppColors.primary,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        l10n.rememberMe,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => context.push('/forgot-password'),
                  child: Text(
                    l10n.forgotPassword,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.danger,
                ),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: _isValid
                      ? const LinearGradient(
                          colors: [
                            AppColors.primaryGradientStart,
                            AppColors.primaryGradientEnd,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: _isValid
                      ? null
                      : AppColors.textSecondary.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _isValid && !_isLoggingIn ? _onLogin : null,
                    borderRadius: BorderRadius.circular(14),
                    child: Center(
                      child: _isLoggingIn
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
                              l10n.logIn,
                              style: TextStyle(
                                color: _isValid
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
            const SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap: () => context.push('/register'),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                    children: [
                      TextSpan(text: l10n.newToApp(AppConfig.brandName)),
                      TextSpan(
                        text: l10n.createAccountLink,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
