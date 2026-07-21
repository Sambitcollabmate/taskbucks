import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/user_profile.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../shared/widgets/upgrade_banner.dart';
import 'widgets/logout_row.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_menu_card.dart';
import 'widgets/profile_menu_row.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileProvider(),
      child: const _ProfileScreenBody(),
    );
  }
}

class _ProfileScreenBody extends StatelessWidget {
  const _ProfileScreenBody();

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
                      // Edit profile / Security / Payment details all
                      // deep-link into the consolidated Settings screen's
                      // anchored sections once it exists (PROJECT.md 3, 6.1,
                      // Phase 4) — placeholder no-ops until then.
                      ProfileMenuRow(
                        icon: LucideIcons.userPen,
                        label: 'Edit profile',
                        onTap: () {},
                      ),
                      ProfileMenuRow(
                        icon: LucideIcons.shield,
                        label: 'Security & password',
                        onTap: () {},
                      ),
                      ProfileMenuRow(
                        icon: LucideIcons.creditCard,
                        label: 'Payment details',
                        onTap: () {},
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
                        onTap: () {},
                      ),
                      ProfileMenuRow(
                        icon: LucideIcons.lifeBuoy,
                        label: 'Support tickets',
                        onTap: () {},
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
