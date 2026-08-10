import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/user_profile.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/profile_provider.dart';
import '../../shared/widgets/upgrade_banner.dart';
import '../settings/settings_screen.dart';
import 'widgets/logout_row.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_menu_card.dart';
import 'widgets/profile_menu_row.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ProfileProvider is now a shared app-wide instance (provided in
    // main.dart, same pattern as BalanceProvider) rather than a local one
    // created here — Upgrade/Contact read and write the same instance, so
    // e.g. subscribing to Premium there shows up here immediately.
    return const _ProfileScreenBody();
  }
}

class _ProfileScreenBody extends StatelessWidget {
  const _ProfileScreenBody();

  // Settings is a pushed route, not a bottom-nav tab, so this screen's
  // ProfileProvider stays alive underneath it — reload once it's popped so
  // an avatar/name change made in Settings shows up here immediately.
  Future<void> _openSettings(
    BuildContext context,
    ProfileProvider provider,
    SettingsSection section,
  ) async {
    await context.push('/settings', extra: section);
    if (context.mounted) {
      provider.load();
    }
  }

  void _openLanguagePicker(BuildContext context) {
    final current = context.read<LanguageProvider>().language;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocalizations.of(context).appLanguageLabel,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                for (final language in AppLanguage.values)
                  ListTile(
                    title: Text(language.label),
                    trailing: language == current
                        ? const Icon(LucideIcons.check, color: AppColors.primary)
                        : null,
                    onTap: () {
                      sheetContext.read<LanguageProvider>().setLanguage(language);
                      Navigator.of(sheetContext).pop();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openLegalLinks(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        final l10n = AppLocalizations.of(context);
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      l10n.termsAndPrivacy,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(LucideIcons.fileText, size: 18),
                  title: Text(l10n.termsOfService),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    context.push('/terms');
                  },
                ),
                ListTile(
                  leading: const Icon(LucideIcons.shieldCheck, size: 18),
                  title: Text(l10n.privacyPolicy),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    context.push('/privacy');
                  },
                ),
                ListTile(
                  leading: const Icon(LucideIcons.receiptText, size: 18),
                  title: Text(l10n.refundPolicy),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    context.push('/refund');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Consumer<ProfileProvider>(
          builder: (context, provider, _) {
            final l10n = AppLocalizations.of(context);
            final profile = provider.profile;

            if (provider.isLoading && profile == null) {
              return const Center(child: CircularProgressIndicator());
            }
            if (profile == null) {
              return const SizedBox.shrink();
            }

            return RefreshIndicator(
              onRefresh: provider.load,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                children: [
                  Text(l10n.profileTitle, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 16),
                  ProfileHeader(profile: profile),
                  // Not just visually hidden — omitted from the widget tree
                  // entirely for Premium users (PROJECT.md 5, Home's
                  // upgrade banner does the same).
                  if (profile.tier == UserTier.free) ...[
                    const SizedBox(height: 16),
                    UpgradeBanner(onTap: () => context.push('/upgrade')),
                  ],
                  const SizedBox(height: 20),
                  Text(l10n.accountLabel, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  ProfileMenuCard(
                    rows: [
                      // Edit profile / Security / Payment details deep-link
                      // into the consolidated Settings screen's anchored
                      // sections (PROJECT.md 3, 6.1, Phase 4). Manage
                      // subscription goes to Upgrade instead, since that's
                      // where subscription state actually lives.
                      ProfileMenuRow(
                        icon: LucideIcons.userPen,
                        label: l10n.editProfile,
                        onTap: () => _openSettings(
                          context,
                          provider,
                          SettingsSection.profile,
                        ),
                      ),
                      ProfileMenuRow(
                        icon: LucideIcons.languages,
                        label: l10n.appLanguageLabel,
                        trailingValue: context.watch<LanguageProvider>().language.label,
                        onTap: () => _openLanguagePicker(context),
                      ),
                      ProfileMenuRow(
                        icon: LucideIcons.shield,
                        label: l10n.securityAndPassword,
                        onTap: () => _openSettings(
                          context,
                          provider,
                          SettingsSection.security,
                        ),
                      ),
                      ProfileMenuRow(
                        icon: LucideIcons.creditCard,
                        label: l10n.paymentDetails,
                        onTap: () => _openSettings(
                          context,
                          provider,
                          SettingsSection.payment,
                        ),
                      ),
                      ProfileMenuRow(
                        icon: LucideIcons.repeat,
                        label: l10n.manageSubscription,
                        onTap: () => context.push('/upgrade'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(l10n.supportLabel, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  ProfileMenuCard(
                    rows: [
                      ProfileMenuRow(
                        icon: LucideIcons.bell,
                        label: l10n.notificationsLabel,
                        onTap: () => context.push('/notifications'),
                      ),
                      ProfileMenuRow(
                        icon: LucideIcons.lifeBuoy,
                        label: l10n.supportTickets,
                        onTap: () => context.push('/support-tickets'),
                      ),
                      ProfileMenuRow(
                        icon: LucideIcons.circleHelp,
                        label: l10n.howItWorks,
                        onTap: () => context.push('/how-it-works'),
                      ),
                      ProfileMenuRow(
                        icon: LucideIcons.info,
                        label: l10n.aboutUs,
                        onTap: () => context.push('/about'),
                      ),
                      ProfileMenuRow(
                        icon: LucideIcons.messageCircleQuestion,
                        label: l10n.faq,
                        onTap: () => context.push('/faq'),
                      ),
                      ProfileMenuRow(
                        icon: LucideIcons.mail,
                        label: l10n.contactUs,
                        onTap: () => context.push('/contact'),
                      ),
                      ProfileMenuRow(
                        icon: LucideIcons.badgeCheck,
                        label: l10n.paymentProofs,
                        onTap: () => context.push('/payment-proofs'),
                      ),
                      ProfileMenuRow(
                        icon: LucideIcons.fileText,
                        label: l10n.termsAndPrivacy,
                        onTap: () => _openLegalLinks(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  LogoutRow(onTap: () => context.read<AuthProvider>().logout()),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
