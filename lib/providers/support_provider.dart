import 'package:flutter/foundation.dart';

import '../data/models/contact_topic.dart';
import '../data/models/support_ticket.dart';
import '../data/services/support_service.dart';

/// Holds Support Tickets screen state — same role as [NotificationsProvider].
class SupportProvider extends ChangeNotifier {
  final SupportService _service;

  SupportProvider({SupportService? service}) : _service = service ?? SupportService() {
    load();
  }

  List<SupportTicket> _tickets = [];
  bool _isLoading = false;
  bool _isSubmitting = false;

  List<SupportTicket> get tickets => _tickets;
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;

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
}
