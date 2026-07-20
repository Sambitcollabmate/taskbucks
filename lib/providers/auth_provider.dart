import 'package:flutter/foundation.dart';

import '../data/services/session_service.dart';

/// Tracks whether the user is logged in, so `core/router/app_router.dart`'s
/// redirect callback can gate the pre-auth and post-auth route stacks
/// (PROJECT.md 6.1). Backed by the session token persisted via Login's
/// "Remember me" (`SessionService`) — on cold start it checks for a stored
/// token; [login] sets state directly for the current run so a login
/// without "Remember me" still counts as logged in until the app is closed.
class AuthProvider extends ChangeNotifier {
  final SessionService _sessionService;

  bool _isLoggedIn = false;

  AuthProvider({SessionService? sessionService})
      : _sessionService = sessionService ?? SessionService() {
    _restoreSession();
  }

  bool get isLoggedIn => _isLoggedIn;

  Future<void> _restoreSession() async {
    final token = await _sessionService.readToken();
    if (token == null) return;
    _isLoggedIn = true;
    notifyListeners();
  }

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> logout() async {
    await _sessionService.clearToken();
    _isLoggedIn = false;
    notifyListeners();
  }
}
