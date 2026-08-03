import 'package:flutter/foundation.dart';

import '../data/models/contact_topic.dart';
import '../data/models/support_ticket.dart';
import '../data/services/support_service.dart';

/// Which of the Support Tickets screen's two tabs is active. "Open" covers
/// both [SupportTicketStatus.open] and [SupportTicketStatus.inProgress] —
/// anything not yet closed; "Closed" is [SupportTicketStatus.resolved].
enum SupportTicketFilter { open, closed }

/// Holds Support Tickets screen state — same role as [NotificationsProvider].
class SupportProvider extends ChangeNotifier {
  final SupportService _service;

  SupportProvider({SupportService? service}) : _service = service ?? SupportService() {
    load();
  }

  List<SupportTicket> _tickets = [];
  bool _isLoading = false;
  bool _isSubmitting = false;
  bool _isSendingReply = false;
  SupportTicketFilter _filter = SupportTicketFilter.open;

  List<SupportTicket> get allTickets => _tickets;
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  bool get isSendingReply => _isSendingReply;
  SupportTicketFilter get filter => _filter;

  List<SupportTicket> get openTickets =>
      _tickets.where((t) => t.status != SupportTicketStatus.resolved).toList();
  List<SupportTicket> get closedTickets =>
      _tickets.where((t) => t.status == SupportTicketStatus.resolved).toList();

  List<SupportTicket> get tickets =>
      _filter == SupportTicketFilter.open ? openTickets : closedTickets;

  SupportTicket ticketById(String id) => _tickets.firstWhere((t) => t.id == id);

  void setFilter(SupportTicketFilter filter) {
    if (filter == _filter) return;
    _filter = filter;
    notifyListeners();
  }

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    _tickets = await _service.fetchTickets();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> raiseTicket({required ContactTopic topic, required String message}) async {
    _isSubmitting = true;
    notifyListeners();

    final ticket = await _service.raiseTicket(topic: topic, message: message);
    _tickets = [ticket, ..._tickets];

    _isSubmitting = false;
    notifyListeners();
  }

  Future<void> sendReply(String ticketId, String text) async {
    _isSendingReply = true;
    notifyListeners();

    // The server returns the full updated ticket (all messages, including
    // this new reply), so it replaces the local copy wholesale rather than
    // this appending a locally-constructed message.
    final updatedTicket = await _service.sendReply(ticketId, text);
    final index = _tickets.indexWhere((t) => t.id == ticketId);
    if (index != -1) {
      _tickets[index] = updatedTicket;
    }

    _isSendingReply = false;
    notifyListeners();
  }
}
