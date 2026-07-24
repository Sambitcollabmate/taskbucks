import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/support_ticket.dart';
import '../../providers/support_provider.dart';
import '../../shared/widgets/gradient_cta_button.dart';
import 'widgets/raise_ticket_sheet.dart';
import 'widgets/support_ticket_row.dart';
import 'widgets/ticket_detail_sheet.dart';

/// Push-only screen (PROJECT.md 6.1), reached from Profile's Support
/// section. Both the "Raise a new ticket" form and a ticket's detail view
/// are modal bottom sheets rather than separate routes — same
/// `showModalBottomSheet` pattern Settings' `ProfileAvatarPicker` already
/// uses — since neither needs its own back-stack entry.
class SupportTicketsScreen extends StatelessWidget {
  const SupportTicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SupportProvider(),
      child: const _SupportTicketsScreenBody(),
    );
  }
}

class _SupportTicketsScreenBody extends StatelessWidget {
  const _SupportTicketsScreenBody();

  void _showRaiseTicketSheet(BuildContext context, SupportProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => RaiseTicketSheet(provider: provider),
    );
  }

  void _showTicketDetail(BuildContext context, SupportTicket ticket) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => TicketDetailSheet(ticket: ticket),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Support tickets'),
      ),
      body: SafeArea(
        top: false,
        child: Consumer<SupportProvider>(
          builder: (context, provider, _) {
            final tickets = provider.tickets;

            return RefreshIndicator(
              onRefresh: provider.load,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
                children: [
                  GradientCtaButton(
                    label: 'Raise a new ticket',
                    onTap: () => _showRaiseTicketSheet(context, provider),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Your tickets',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  if (provider.isLoading && tickets.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (tickets.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 24),
                      child: Center(
                        child: Text(
                          'No support tickets yet',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          for (final ticket in tickets) ...[
                            SupportTicketRow(
                              ticket: ticket,
                              onTap: () => _showTicketDetail(context, ticket),
                            ),
                            if (ticket != tickets.last) const Divider(height: 8),
                          ],
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
