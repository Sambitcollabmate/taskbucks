import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/user_profile.dart';
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
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 8, 20, 12),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'App language',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
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
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 8, 20, 12),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Terms & Privacy',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(LucideIcons.fileText, size: 18),
                  title: const Text('Terms of Service'),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    context.push('/terms');
                  },
                ),
                ListTile(
                  leading: const Icon(LucideIcons.shieldCheck, size: 18),
                  title: const Text('Privacy Policy'),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    context.push('/privacy');
                  },
                ),
                ListTile(
                  leading: const Icon(LucideIcons.receiptText, size: 18),
                  title: const Text('Refund Policy'),
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
                  Text('Profile', style: Theme.of(context).textTheme.headlineSmall),
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
                  Text('Account', style: Theme.of(context).textTheme.titleLarge),
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
                        label: 'Edit profile',
                        onTap: () => _openSettings(
                          context,
                          provider,
                          SettingsSection.profile,
                        ),
                      ),
                      ProfileMenuRow(
                        icon: LucideIcons.languages,
                        label: 'App language',
                        trailingValue: context.watch<LanguageProvider>().language.label,
                        onTap: () => _openLanguagePicker(context),
                      ),
                      ProfileMenuRow(
                        icon: LucideIcons.shield,
                        label: 'Security & password',
                        onTap: () => _openSettings(
                          context,
                          provider,
                          SettingsSection.security,
                        ),
                      ),
                      ProfileMenuRow(
                        icon: LucideIcons.creditCard,
                        label: 'Payment details',
                        onTap: () => _openSettings(
                          context,
                          provider,
                          SettingsSection.payment,
                        ),
                      ),
                      ProfileMenuRow(
                        icon: LucideIcons.repeat,
                        label: 'Manage subscription',
                        onTap: () => context.push('/upgrade'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text('Support', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  ProfileMenuCard(
                    rows: [
                      ProfileMenuRow(
                        icon: LucideIcons.bell,
                        label: 'Notifications',
                        onTap: () => context.push('/notifications'),
                      ),
                      ProfileMenuRow(
                        icon: LucideIcons.lifeBuoy,
                        label: 'Support tickets',
                        onTap: () => context.push('/support-tickets'),
                      ),
                      ProfileMenuRow(
                        icon: LucideIcons.circleHelp,
                        label: 'How it works',
                        onTap: () => context.push('/how-it-works'),
                      ),
                      ProfileMenuRow(
                        icon: LucideIcons.info,
                        label: 'About',
                        onTap: () => context.push('/about'),
                      ),
                      ProfileMenuRow(
                        icon: LucideIcons.messageCircleQuestion,
                        label: 'FAQ',
                        onTap: () => context.push('/faq'),
                      ),
                      ProfileMenuRow(
                        icon: LucideIcons.mail,
                        label: 'Contact us',
                        onTap: () => context.push('/contact'),
                      ),
                      ProfileMenuRow(
                        icon: LucideIcons.badgeCheck,
                        label: 'Payment proofs',
                        onTap: () => context.push('/payment-proofs'),
                      ),
                      ProfileMenuRow(
                        icon: LucideIcons.fileText,
                        label: 'Terms & Privacy',
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
