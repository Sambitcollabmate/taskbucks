import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/theme/app_colors.dart';

/// Gradient referral link card — same gradient as [BalanceHeroCard] (see
/// PROJECT.md 5) but its own layout, since it shows a code/link instead of
/// a balance. Copy writes to the real clipboard; Share opens the device's
/// native share sheet — neither is a fake visual-only state change.
class ReferralLinkCard extends StatelessWidget {
  final String referralCode;

  const ReferralLinkCard({super.key, required this.referralCode});

  String get _referralLink => 'https://taskbucks.in/r/$referralCode';

  Future<void> _onCopy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: _referralLink));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Referral link copied')),
      );
    }
  }

  void _onShare(BuildContext context) {
    SharePlus.instance.share(
      ShareParams(
        text: 'Join me on TaskBucks and start earning! Use my link: $_referralLink',
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
          const SizedBox(height: 8),
          Text(
            referralCode,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 20),
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
