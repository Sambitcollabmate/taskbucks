import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';

const _cardRadius = 20.0;

/// Dark gradient price card for the Upgrade screen (PROJECT.md Section 5:
/// `premiumSurfaceStart`/`premiumSurfaceEnd`, the same charcoal gradient
/// [UpgradeBanner] uses, so gold reads as a membership signal rather than
/// a flat yellow fill). Price is shown regardless of subscription state —
/// only the row beneath it (Subscribe button vs. active status) changes.
///
/// Same footprint as a plain card — the premium feel comes from a light
/// sweep that glides across the surface every few seconds (paused most of
/// the cycle, so it reads as an occasional glint rather than a loading
/// shimmer), a soft gold halo behind the crown, and a corner "PRO" tag —
/// not from extra content that would grow the card taller.
class PremiumPriceCard extends StatefulWidget {
  const PremiumPriceCard({super.key});

  @override
  State<PremiumPriceCard> createState() => _PremiumPriceCardState();
}

class _PremiumPriceCardState extends State<PremiumPriceCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _sweepController;

  @override
  void initState() {
    super.initState();
    _sweepController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3400),
    )..repeat();
  }

  @override
  void dispose() {
    _sweepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(_cardRadius),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.premiumSurfaceStart, AppColors.premiumSurfaceEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: AppColors.premiumGold.withValues(alpha: 0.4)),
          boxShadow: [
            BoxShadow(
              color: AppColors.premiumGold.withValues(alpha: 0.12),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Card height is intrinsic (fits its content), but the Stack's
            // own height constraint can be unbounded here since the card
            // sits inside a scrolling ListView — so only maxWidth (always
            // bounded) feeds the sweep distance, plus a fixed buffer to
            // clear the rotated band's diagonal overhang.
            final sweepDistance = constraints.maxWidth + 120;
            return Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: _sweepController,
                  builder: (context, _) {
                    // Sweeps left-to-right over the first 45% of the cycle,
                    // then idles off-card for the rest — an occasional
                    // glint rather than a constant loading shimmer.
                    final t = Curves.easeInOut.transform(
                      Interval(0, 0.45).transform(_sweepController.value),
                    );
                    final dx = -sweepDistance + t * sweepDistance * 2;
                    return Positioned(
                      top: -60,
                      bottom: -60,
                      left: dx,
                      width: 70,
                      child: Transform.rotate(
                        angle: 0.5,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.white.withValues(alpha: 0),
                                Colors.white.withValues(alpha: 0.14),
                                Colors.white.withValues(alpha: 0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  top: 14,
                  right: -34,
                  child: Transform.rotate(
                    angle: 0.7854, // 45°
                    child: Container(
                      width: 120,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      color: AppColors.premiumGold,
                      child: const Text(
                        'PRO',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                          color: AppColors.premiumSurfaceEnd,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                  SizedBox(
                    width: 72,
                    height: 72,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Soft halo behind the icon, larger than the circle
                        // itself but still contained within the padding.
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                AppColors.premiumGold.withValues(alpha: 0.25),
                                AppColors.premiumGold.withValues(alpha: 0),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                AppColors.premiumGold.withValues(alpha: 0.3),
                                AppColors.premiumGold.withValues(alpha: 0.1),
                              ],
                            ),
                            border: Border.all(
                              color: AppColors.premiumGold.withValues(alpha: 0.6),
                            ),
                          ),
                          child: const Icon(
                            LucideIcons.crown,
                            color: AppColors.premiumGold,
                            size: 26,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: '₹49',
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: ' /month',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Cancel anytime — benefits continue until the end of your paid cycle',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha: 0.6),
                      height: 1.4,
                    ),
                  ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
