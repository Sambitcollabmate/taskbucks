import 'dart:math';

import '../models/contact_topic.dart';
import '../models/support_ticket.dart';

/// Fake data source for the Support Tickets screen — same fake-service-now/
/// real-API-later convention as the rest of the app (PROJECT.md Section
/// 4/7). `raiseTicket`/`sendReply` don't persist anywhere real yet; the
/// provider is responsible for updating its own in-memory list.
class SupportService {
  Future<List<SupportTicket>> fetchTickets() async {
    await Future.delayed(const Duration(milliseconds: 400));

    final now = DateTime.now();

    return [
      SupportTicket(
        id: 'TCK-2041',
        topic: ContactTopic.withdrawalIssue,
        status: SupportTicketStatus.inProgress,
        date: now.subtract(const Duration(days: 2)),
        messages: [
          TicketMessage(
            text:
                "My withdrawal from last month's payout cycle hasn't reached "
                'my UPI account yet. It has been 5 days since the 1st. Can '
                'you check the status?',
            timestamp: now.subtract(const Duration(days: 2)),
            isFromUser: true,
          ),
          TicketMessage(
            text:
                "We've located your payout in the batch — it's confirmed "
                'sent and should reflect within 24 hours. Sorry for the '
                'delay.',
            timestamp: now.subtract(const Duration(days: 1, hours: 20)),
            isFromUser: false,
            authorName: 'Aman',
          ),
        ],
      ),
      SupportTicket(
        id: 'TCK-2039',
        topic: ContactTopic.adNotCredited,
        status: SupportTicketStatus.open,
        date: now.subtract(const Duration(days: 4)),
        messages: [
          TicketMessage(
            text:
                'Watched a full rewarded video task this morning but my '
                "balance didn't update. The ad played to the end before I "
                'closed it.',
            timestamp: now.subtract(const Duration(days: 4)),
            isFromUser: true,
          ),
        ],
      ),
      SupportTicket(
        id: 'TCK-2022',
        topic: ContactTopic.referralCommissionMissing,
        status: SupportTicketStatus.resolved,
        date: now.subtract(const Duration(days: 10)),
        messages: [
          TicketMessage(
            text:
                'My referral went Premium two weeks ago but I never '
                'received the ₹125 commission in my wallet.',
            timestamp: now.subtract(const Duration(days: 10)),
            isFromUser: true,
          ),
          TicketMessage(
            text:
                'Confirmed and credited — the commission was delayed due to '
                'a processing backlog. It now shows in your Transactions '
                'list.',
            timestamp: now.subtract(const Duration(days: 9, hours: 14)),
            isFromUser: false,
            authorName: 'Priya',
          ),
          TicketMessage(
            text: 'Thank you, I can see it now!',
            timestamp: now.subtract(const Duration(days: 9, hours: 10)),
            isFromUser: true,
          ),
        ],
      ),
      SupportTicket(
        id: 'TCK-2005',
        topic: ContactTopic.accountAccess,
        status: SupportTicketStatus.resolved,
        date: now.subtract(const Duration(days: 21)),
        messages: [
          TicketMessage(
            text:
                "I changed my phone number and can't log back in with the "
                'OTP flow anymore. What are my options?',
            timestamp: now.subtract(const Duration(days: 21)),
            isFromUser: true,
          ),
          TicketMessage(
            text:
                "We've updated your registered number manually. You should "
                'be able to log in with your new number now.',
            timestamp: now.subtract(const Duration(days: 20, hours: 16)),
            isFromUser: false,
            authorName: 'Aman',
          ),
        ],
      ),
    ];
  }

  Future<SupportTicket> raiseTicket({
    required ContactTopic topic,
    required String message,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final id = 'TCK-${1000 + Random().nextInt(9000)}';

    return SupportTicket(
      id: id,
      topic: topic,
      status: SupportTicketStatus.open,
      date: DateTime.now(),
      messages: [
        TicketMessage(text: message, timestamp: DateTime.now(), isFromUser: true),
      ],
    );
  }

  /// Appends the user's reply — doesn't change ticket status; a real backend
  /// would likely flip it back to "awaiting support," but there's no
  /// support-side simulation to reply again here yet.
  Future<TicketMessage> sendReply(String text) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return TicketMessage(text: text, timestamp: DateTime.now(), isFromUser: true);
  }
}
