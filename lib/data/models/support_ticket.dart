import 'contact_topic.dart';

/// Gray open / orange in-progress / green resolved — color mapping lives on
/// `SupportTicketRow`/the detail sheet, not here (same "enum drives color in
/// the widget, not stored on the model" convention as `TransactionCategory`/
/// `NotificationType`).
enum SupportTicketStatus {
  open('Open'),
  inProgress('In progress'),
  resolved('Resolved');

  final String label;

  const SupportTicketStatus(this.label);
}

class SupportTicket {
  final String id;
  final ContactTopic topic;
  final String message;
  final SupportTicketStatus status;
  final DateTime date;
  final String? reply;

  const SupportTicket({
    required this.id,
    required this.topic,
    required this.message,
    required this.status,
    required this.date,
    this.reply,
  });

  /// Truncated preview shown on the ticket list row — the detail view shows
  /// [message] in full.
  String get snippet => message.length <= 90 ? message : '${message.substring(0, 90)}…';
}
