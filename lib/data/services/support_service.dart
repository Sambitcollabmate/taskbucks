import '../../core/network/api_client.dart';
import '../models/contact_topic.dart';
import '../models/support_ticket.dart';

/// Real `GET`/`POST /v1/support/tickets` and
/// `POST /v1/support/tickets/{id}/reply` calls (api_requirements.md §9).
class SupportService {
  Future<List<SupportTicket>> fetchTickets() {
    return ApiClient.call((dio) async {
      final response = await dio.get('/support/tickets', queryParameters: {'per_page': 50});
      final json = response.data as Map<String, dynamic>;
      return (json['data'] as List).cast<Map<String, dynamic>>().map(_ticketFromJson).toList();
    });
  }

  Future<SupportTicket> raiseTicket({required ContactTopic topic, required String message}) {
    return ApiClient.call((dio) async {
      final response = await dio.post('/support/tickets', data: {
        'topic': _topicWireValue(topic),
        'message': message,
      });
      return _ticketFromJson(response.data as Map<String, dynamic>);
    });
  }

  /// Returns the full updated ticket (all messages, including the new
  /// reply) — `SupportTicketController::reply`'s response, not just the
  /// single new message.
  Future<SupportTicket> sendReply(String ticketId, String text) {
    return ApiClient.call((dio) async {
      final response = await dio.post('/support/tickets/$ticketId/reply', data: {'text': text});
      return _ticketFromJson(response.data as Map<String, dynamic>);
    });
  }

  String _topicWireValue(ContactTopic topic) {
    return switch (topic) {
      ContactTopic.accountAccess => 'account_access',
      ContactTopic.withdrawalIssue => 'withdrawal_issue',
      ContactTopic.adNotCredited => 'ad_not_credited',
      ContactTopic.referralCommissionMissing => 'referral_commission_missing',
      ContactTopic.somethingElse => 'something_else',
    };
  }

  ContactTopic _topicFromWire(String wire) {
    return switch (wire) {
      'account_access' => ContactTopic.accountAccess,
      'withdrawal_issue' => ContactTopic.withdrawalIssue,
      'ad_not_credited' => ContactTopic.adNotCredited,
      'referral_commission_missing' => ContactTopic.referralCommissionMissing,
      _ => ContactTopic.somethingElse,
    };
  }

  SupportTicketStatus _statusFromWire(String wire) {
    return switch (wire) {
      'in_progress' => SupportTicketStatus.inProgress,
      'resolved' => SupportTicketStatus.resolved,
      _ => SupportTicketStatus.open,
    };
  }

  SupportTicket _ticketFromJson(Map<String, dynamic> json) {
    return SupportTicket(
      id: json['id'].toString(),
      topic: _topicFromWire(json['topic'] as String),
      status: _statusFromWire(json['status'] as String),
      date: DateTime.parse(json['date'] as String),
      messages: (json['messages'] as List)
          .cast<Map<String, dynamic>>()
          .map(_messageFromJson)
          .toList(),
    );
  }

  TicketMessage _messageFromJson(Map<String, dynamic> json) {
    return TicketMessage(
      text: json['text'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isFromUser: json['is_from_user'] as bool,
      authorName: json['author_name'] as String?,
    );
  }
}
