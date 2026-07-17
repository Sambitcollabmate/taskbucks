import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_colors.dart';

/// Gradient balance card reused on Home and Wallet (see PROJECT.md 6.3).
/// The two action buttons are configurable so each screen can label them
/// for its own context (Home: Wallet/Refer & earn, Wallet: Withdraw/History)
/// while keeping the same gradient card and layout.
class BalanceHeroCard extends StatelessWidget {
  final double balance;
  final String primaryLabel;
  final IconData primaryIcon;
  final VoidCallback onPrimaryTap;
  final String secondaryLabel;
  final IconData secondaryIcon;
  final VoidCallback onSecondaryTap;

  const BalanceHeroCard({
    super.key,
    required this.balance,
    required this.primaryLabel,
    required this.primaryIcon,
    required this.onPrimaryTap,
    required this.secondaryLabel,
    required this.secondaryIcon,
    required this.onSecondaryTap,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 2,
    );

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
            'Total balance',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            formatter.format(balance),
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _HeroButton(
                  icon: primaryIcon,
                  label: primaryLabel,
                  onTap: onPrimaryTap,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _HeroButton(
                  icon: secondaryIcon,
                  label: secondaryLabel,
                  onTap: onSecondaryTap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _HeroButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

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
