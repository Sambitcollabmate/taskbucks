import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/support_ticket.dart';
import 'ticket_status_pill.dart';

/// Single ticket row on the Support Tickets list — topic + status pill,
/// truncated message snippet, ticket ID + date. Tap handling (opening the
/// detail sheet) is the caller's job via [onTap].
class SupportTicketRow extends StatelessWidget {
  final SupportTicket ticket;
  final VoidCallback onTap;

  const SupportTicketRow({super.key, required this.ticket, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('d MMM yyyy');

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    ticket.topic.label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                TicketStatusPill(status: ticket.status),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              ticket.snippet,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${ticket.id} · ${dateFormat.format(ticket.date)}',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
