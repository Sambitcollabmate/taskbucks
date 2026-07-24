import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/config/app_config.dart';
import '../../../core/theme/app_colors.dart';

/// Gradient referral link card — same gradient as [BalanceHeroCard] (see
/// PROJECT.md 5) but its own layout, since it shows a code/link instead of
/// a balance. Copy writes to the real clipboard; Share opens the device's
/// native share sheet — neither is a fake visual-only state change.
class ReferralLinkCard extends StatelessWidget {
  final String referralCode;

  const ReferralLinkCard({super.key, required this.referralCode});

  String get _referralLink => 'https://${AppConfig.brandDomain}/r/$referralCode';

  /// Same link shown to the user, without the scheme — matches the
  /// "[brand].com/join?ref=" style called for in the design doc while
  /// staying the real, copyable/shareable URL (not a decorative fake one).
  String get _displayLink => '${AppConfig.brandDomain}/r/$referralCode';

  Future<void> _onCopy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: _referralLink));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Referral link copied')),
      );
    }
  }

  Future<void> _onCopyCode(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: referralCode));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Referral code copied')),
      );
    }
  }

  void _onShare(BuildContext context) {
    SharePlus.instance.share(
      ShareParams(
        text: 'Join me on ${AppConfig.brandName} and start earning! Use my link: $_referralLink',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryGradientStart, AppColors.primaryGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your referral code',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                referralCode,
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => _onCopyCode(context),
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    LucideIcons.copy,
                    size: 16,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _DashedLinkPill(link: _displayLink),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _LinkButton(
                  icon: LucideIcons.copy,
                  label: 'Copy link',
                  onTap: () => _onCopy(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _LinkButton(
                  icon: LucideIcons.share2,
                  label: 'Share',
                  onTap: () => _onShare(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LinkButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _LinkButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Dashed-border capsule showing the actual referral URL beneath the code
/// (design doc's `ref-link-row`) — display only, Copy/Share below do the
/// real clipboard/share-sheet work.
class _DashedLinkPill extends StatelessWidget {
  final String link;

  const _DashedLinkPill({required this.link});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedPillPainter(color: Colors.white.withValues(alpha: 0.45)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        child: Text(
          link,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _DashedPillPainter extends CustomPainter {
  final Color color;
  static const _dashWidth = 4.0;
  static const _dashGap = 3.0;

  const _DashedPillPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final radius = size.height / 2;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0.6, 0.6, size.width - 1.2, size.height - 1.2),
      Radius.circular(radius),
    );

    final path = Path()..addRRect(rrect);
    final dashedPath = Path();

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + _dashWidth;
        dashedPath.addPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          Offset.zero,
        );
        distance = next + _dashGap;
      }
    }

    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(covariant _DashedPillPainter oldDelegate) =>
      oldDelegate.color != color;
}
