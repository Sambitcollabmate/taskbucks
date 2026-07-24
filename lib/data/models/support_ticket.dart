import 'contact_topic.dart';

/// Gray open / orange in-progress / green resolved — color mapping lives on
/// `SupportTicketRow`/the detail sheet, not here (same "enum drives color in
/// the widget, not stored on the model" convention as `TransactionCategory`/
/// `NotificationType`). Display labels are Open/Reply/Closed (PROJECT.md
/// Support Tickets doc) — `inProgress` reads as "Reply" since that state
/// means support has replied and it's the user's turn, not that nothing's
/// happened yet.
enum SupportTicketStatus {
  open('Open'),
  inProgress('Reply'),
  resolved('Closed');

  final String label;

  const SupportTicketStatus(this.label);
}

/// One message in a ticket's back-and-forth — a real chat thread (design
/// doc: "chat-bubble thread, not a plain reply list"), not a single
/// message+reply pair. [authorName] is set only for support replies (e.g.
/// "Aman") — a named person reading a ticket is a concrete trust signal,
/// not just an assertion elsewhere in the app that "a human reads every
/// ticket."
class TicketMessage {
  final String text;
  final DateTime timestamp;
  final bool isFromUser;
  final String? authorName;

  const TicketMessage({
    required this.text,
    required this.timestamp,
    required this.isFromUser,
    this.authorName,
  });
}

class SupportTicket {
  final String id;
  final ContactTopic topic;
  final SupportTicketStatus status;
  final DateTime date;
  final List<TicketMessage> messages;

  const SupportTicket({
    required this.id,
    required this.topic,
    required this.status,
    required this.date,
    required this.messages,
  });

  SupportTicket copyWith({
    SupportTicketStatus? status,
    List<TicketMessage>? messages,
  }) {
    return SupportTicket(
      id: id,
      topic: topic,
      status: status ?? this.status,
      date: date,
      messages: messages ?? this.messages,
    );
  }

  /// Truncated preview of the original message, shown on the ticket list row.
  String get snippet {
    final message = messages.first.text;
    return message.length <= 90 ? message : '${message.substring(0, 90)}…';
  }
}
