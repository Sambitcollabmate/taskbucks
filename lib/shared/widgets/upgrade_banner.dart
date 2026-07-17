import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_colors.dart';

/// Promotes Premium (₹49/mo, 30 tasks/day — PROJECT.md Section 2). Reused
/// on Home and Profile. Dark card with gold accents, so gold reads as a
/// membership signal rather than a flat yellow fill. Caller must omit this
/// from the widget tree entirely for Premium users, not just hide it.
class UpgradeBanner extends StatelessWidget {
  final VoidCallback onTap;

  const UpgradeBanner({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                AppColors.premiumSurfaceStart,
                AppColors.premiumSurfaceEnd,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppColors.premiumGold.withValues(alpha: 0.35),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.premiumGold.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.premiumGold.withValues(alpha: 0.5),
                  ),
                ),
                child: const Icon(
                  LucideIcons.crown,
                  color: AppColors.premiumGold,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Go Premium ',
                            style: TextStyle(color: Colors.white),
                          ),
                          TextSpan(
                            text: '— ₹49/month',
                            style: TextStyle(
                              color: AppColors.premiumGold.withValues(
                                alpha: 0.9,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Unlock 30 tasks/day at the same rate',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.premiumGold.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.chevronRight,
                  color: AppColors.premiumGold,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
