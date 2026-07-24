import 'dart:math';

import '../models/contact_topic.dart';
import '../models/support_ticket.dart';

/// Fake data source for the Support Tickets screen — same fake-service-now/
/// real-API-later convention as the rest of the app (PROJECT.md Section
/// 4/7). `raiseTicket` doesn't persist anywhere real yet; the screen is
/// responsible for prepending the returned ticket to its own list.
class SupportService {
  Future<List<SupportTicket>> fetchTickets() async {
    await Future.delayed(const Duration(milliseconds: 400));

    final now = DateTime.now();

    return [
      SupportTicket(
        id: 'TCK-2041',
        topic: ContactTopic.withdrawalIssue,
        message:
            "My withdrawal from last month's payout cycle hasn't reached my "
            'UPI account yet. It has been 5 days since the 1st. Can you '
            'check the status?',
        status: SupportTicketStatus.inProgress,
        date: now.subtract(const Duration(days: 2)),
        reply:
            "We've located your payout in the batch — it's confirmed sent "
            'and should reflect within 24 hours. Sorry for the delay.',
      ),
      SupportTicket(
        id: 'TCK-2039',
        topic: ContactTopic.adNotCredited,
        message:
            'Watched a full rewarded video task this morning but my balance '
            "didn't update. The ad played to the end before I closed it.",
        status: SupportTicketStatus.open,
        date: now.subtract(const Duration(days: 4)),
      ),
      SupportTicket(
        id: 'TCK-2022',
        topic: ContactTopic.referralCommissionMissing,
        message:
            'My referral went Premium two weeks ago but I never received '
            'the ₹125 commission in my wallet.',
        status: SupportTicketStatus.resolved,
        date: now.subtract(const Duration(days: 10)),
        reply:
            'Confirmed and credited — the commission was delayed due to a '
            'processing backlog. It now shows in your Transactions list.',
      ),
      SupportTicket(
        id: 'TCK-2005',
        topic: ContactTopic.accountAccess,
        message:
            "I changed my phone number and can't log back in with the OTP "
            'flow anymore. What are my options?',
        status: SupportTicketStatus.resolved,
        date: now.subtract(const Duration(days: 21)),
        reply:
            "We've updated your registered number manually. You should be "
            'able to log in with your new number now.',
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
      message: message,
      status: SupportTicketStatus.open,
      date: DateTime.now(),
    );
  }
}
