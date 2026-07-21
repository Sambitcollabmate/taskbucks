import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../providers/settings_provider.dart';
import '../auth/widgets/auth_text_field.dart';
import 'widgets/settings_section_card.dart';
import 'widgets/two_step_toggle_row.dart';
import 'widgets/upi_id_field.dart';

/// Which section to scroll to on open — Profile's four menu rows deep-link
/// here (PROJECT.md 3, 6.1) instead of each opening its own screen.
enum SettingsSection { profile, security, payment }

class SettingsScreen extends StatelessWidget {
  final SettingsSection? initialSection;

  const SettingsScreen({super.key, this.initialSection});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SettingsProvider(),
      child: _SettingsScreenBody(initialSection: initialSection),
    );
  }
}

class _SettingsScreenBody extends StatefulWidget {
  final SettingsSection? initialSection;

  const _SettingsScreenBody({this.initialSection});

  @override
  State<_SettingsScreenBody> createState() => _SettingsScreenBodyState();
}

class _SettingsScreenBodyState extends State<_SettingsScreenBody> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _newPasswordController = TextEditingController();

  final _profileKey = GlobalKey();
  final _securityKey = GlobalKey();
  final _paymentKey = GlobalKey();

  bool _controllersInitialized = false;
  bool _scrolledToInitialSection = false;
  bool _obscureNewPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  GlobalKey _keyFor(SettingsSection section) {
    switch (section) {
      case SettingsSection.profile:
        return _profileKey;
      case SettingsSection.security:
        return _securityKey;
      case SettingsSection.payment:
        return _paymentKey;
    }
  }

  void _scrollToInitialSectionIfNeeded() {
    if (_scrolledToInitialSection || widget.initialSection == null) return;
    final targetContext = _keyFor(widget.initialSection!).currentContext;
    if (targetContext == null) return;

    _scrolledToInitialSection = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Scrollable.ensureVisible(
        targetContext,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        alignment: 0.05,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Settings'),
      ),
      body: SafeArea(
        top: false,
        child: Consumer<SettingsProvider>(
          builder: (context, provider, _) {
            final data = provider.data;

            if (provider.isLoading && data == null) {
              return const Center(child: CircularProgressIndicator());
            }
            if (data == null) {
              return const SizedBox.shrink();
            }

            if (!_controllersInitialized) {
              _nameController.text = data.name;
              _emailController.text = data.email;
              _controllersInitialized = true;
            }

            WidgetsBinding.instance.addPostFrameCallback(
              (_) => _scrollToInitialSectionIfNeeded(),
            );

            // A plain Column, not ListView.builder-style lazy sliver
            // children — with only 3 short sections there's no need for
            // virtualization, and it means every section's GlobalKey has a
            // real currentContext from the first frame, which the anchor
            // scroll below (Scrollable.ensureVisible) depends on. A lazily
            // -mounted sliver child (even ListView(children: [...]) mounts
            // lazily under the hood) would have a null currentContext for
            // whichever section starts outside the initial viewport.
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Settings',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  SettingsSectionCard(
                    key: _profileKey,
                    title: 'Profile',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AuthTextField(
                          controller: _nameController,
                          label: 'Name',
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 16),
                        AuthTextField(
                          controller: _emailController,
                          label: 'Email',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: _SectionButton(
                            label: 'Save changes',
                            isLoading: provider.isSavingProfile,
                            enabled: _nameController.text.trim().isNotEmpty,
                            onTap: () async {
                              await provider.saveProfile(
                                name: _nameController.text.trim(),
                                email: _emailController.text.trim(),
                              );
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Profile updated'),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SettingsSectionCard(
                    key: _securityKey,
                    title: 'Security',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AuthTextField(
                          controller: _newPasswordController,
                          label: 'New password',
                          hintText: 'Create a new password',
                          obscureText: _obscureNewPassword,
                          onChanged: (_) => setState(() {}),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureNewPassword
                                  ? LucideIcons.eye
                                  : LucideIcons.eyeOff,
                              size: 18,
                              color: AppColors.textSecondary,
                            ),
                            onPressed: () => setState(
                              () => _obscureNewPassword = !_obscureNewPassword,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: _SectionButton(
                            label: 'Update password',
                            isLoading: provider.isUpdatingPassword,
                            enabled: _newPasswordController.text.length >= 6,
                            onTap: () async {
                              await provider.updatePassword(
                                _newPasswordController.text,
                              );
                              _newPasswordController.clear();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Password updated'),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(height: 1),
                        const SizedBox(height: 16),
                        TwoStepToggleRow(
                          value: data.twoStepEnabled,
                          isSaving: provider.isTogglingTwoStep,
                          onChanged: (enabled) async {
                            await provider.setTwoStepEnabled(enabled);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    enabled
                                        ? 'Two-step verification turned on'
                                        : 'Two-step verification turned off',
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // LEGAL-REVIEW: PAN/TDS collection may be required here once
                  // payout volume crosses a threshold — not yet confirmed by
                  // finance/legal (PROJECT.md Section 3, item 2). No PAN field
                  // added until that's resolved.
                  SettingsSectionCard(
                    key: _paymentKey,
                    title: 'Payment details',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        UpiIdField(
                          initialValue: data.upiId,
                          isDefault: data.isUpiDefault,
                          isSaving: provider.isSavingUpi,
                          onSave: (upiId) async {
                            await provider.saveUpiId(upiId);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('UPI ID updated')),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        const Divider(height: 1),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                LucideIcons.landmark,
                                size: 18,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Bank account',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    data.bankAccountMasked,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SectionButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final bool isLoading;
  final VoidCallback onTap;

  const _SectionButton({
    required this.label,
    required this.enabled,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = enabled && !isLoading;
    return SizedBox(
      height: 42,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: isActive
              ? const LinearGradient(
                  colors: [
                    AppColors.primaryGradientStart,
                    AppColors.primaryGradientEnd,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isActive
              ? null
              : AppColors.textSecondary.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isActive ? onTap : null,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : Text(
                        label,
                        style: TextStyle(
                          color: isActive
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.7),
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
