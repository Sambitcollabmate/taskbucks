import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/config/app_config.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/gradient_cta_button.dart';
import 'widgets/how_it_works_list.dart';
import 'widgets/legal_support_sheet.dart';
import 'widgets/live_stats_strip.dart';
import 'widgets/trust_pills_row.dart';

/// The app's true entry point (PROJECT.md 6.1, Phase 3) — no tab bar, no
/// back button. Lives in a separate pre-auth route stack, disconnected
/// from the post-auth StatefulShellRoute until auth redirect logic is
/// wired up at the end of Phase 3.
class WelcomeScreen extends StatelessWidget {
  final VoidCallback onCreateAccount;
  final VoidCallback onLogIn;

  const WelcomeScreen({super.key, required this.onCreateAccount, required this.onLogIn});

  void _showLegalSupportSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const LegalSupportSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primaryGradientStart,
                                AppColors.primaryGradientEnd,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            LucideIcons.coins,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          AppConfig.brandName,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'Earn money in your free time',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Complete up to 25 simple tasks a day at ₹100 each, refer '
                      'friends for ₹125 a pop, and get paid straight to your '
                      'UPI or bank account every month.',
                      style: TextStyle(
                        fontSize: 14.5,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const LiveStatsStrip(),
                    const SizedBox(height: 20),
                    const TrustPillsRow(),
                    const SizedBox(height: 14),
                    // Given its own prominent row, not folded into the
                    // small footer link list below — this is the
                    // highest-priority trust surface in the app (PROJECT.md
                    // Phase 5), so it gets more visual weight than "About
                    // us"/"FAQ"/"Contact".
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => context.push('/payment-proofs'),
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                          decoration: BoxDecoration(
                            color: AppColors.earningsGreen.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: AppColors.earningsGreen.withValues(alpha: 0.25),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                LucideIcons.badgeCheck,
                                size: 18,
                                color: AppColors.earningsGreen,
                              ),
                              const SizedBox(width: 10),
                              const Expanded(
                                child: Text(
                                  'See real payment proofs',
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              const Icon(
                                LucideIcons.chevronRight,
                                size: 18,
                                color: AppColors.textSecondary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    HowItWorksList(
                      onSeeMore: () => context.push('/how-it-works'),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 16,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    GradientCtaButton(label: 'Create free account', onTap: onCreateAccount),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton(
                        onPressed: onLogIn,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Log in',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => _showLegalSupportSheet(context),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Legal & support',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Icon(
                            LucideIcons.chevronDown,
                            size: 14,
                            color: AppColors.textSecondary.withValues(alpha: 0.8),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
