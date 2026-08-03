import 'package:flutter/foundation.dart';

import '../core/network/api_client.dart';
import '../core/network/api_exception.dart';
import '../data/models/auth_user.dart';
import '../data/services/auth_service.dart';
import '../data/services/session_service.dart';
import '../data/services/token_store.dart';
import 'notifications_provider.dart';
import 'profile_provider.dart';

/// Tracks whether the user is logged in, so `core/router/app_router.dart`'s
/// redirect callback can gate the pre-auth and post-auth route stacks
/// (PROJECT.md 6.1). Backed by the session token persisted via Login's
/// "Remember me" (`SessionService`) — on cold start it checks for a stored
/// token; [completeLogin] sets state directly for the current run so a
/// login without "Remember me" still counts as logged in until the app is
/// closed, it just won't survive a restart.
///
/// The bearer token itself lives in [TokenStore] (read by `ApiClient`'s
/// interceptor), not here — this class only decides whether/when to persist
/// it to secure storage.
class AuthProvider extends ChangeNotifier {
  final SessionService _sessionService;
  final AuthService _authService;

  bool _isLoggedIn = false;
  AuthUser? _currentUser;
  bool _isRestoring = true;

  AuthProvider({SessionService? sessionService, AuthService? authService})
      : _sessionService = sessionService ?? SessionService(),
        _authService = authService ?? AuthService() {
    ApiClient.onUnauthorized = _forceLogout;
    _restoreSession();
  }

  bool get isLoggedIn => _isLoggedIn;
  AuthUser? get currentUser => _currentUser;

  /// True until the stored-token check on cold start finishes — lets a
  /// splash/loading state avoid flashing the pre-auth stack before a
  /// remembered session is restored.
  bool get isRestoring => _isRestoring;

  Future<void> _restoreSession() async {
    final token = await _sessionService.readToken();
    if (token == null) {
      _isRestoring = false;
      notifyListeners();
      return;
    }

    TokenStore.instance.set(token);
    try {
      _currentUser = await _authService.me();
      _isLoggedIn = true;
      notificationsProvider.load();
      profileProvider.load();
    } on ApiException {
      // Stored token no longer valid (revoked/expired) — fall back to
      // logged out rather than sending authenticated requests that will
      // keep 401ing.
      TokenStore.instance.clear();
      await _sessionService.clearToken();
      _isLoggedIn = false;
    }
    _isRestoring = false;
    notifyListeners();
  }

  /// Called after a successful register→verify-otp or login call.
  /// [rememberMe] controls only whether the token survives an app restart —
  /// it's usable for API calls for the rest of this run either way.
  Future<void> completeLogin(AuthSession session, {required bool rememberMe}) async {
    TokenStore.instance.set(session.token);
    _currentUser = session.user;
    _isLoggedIn = true;
    if (rememberMe) {
      await _sessionService.saveToken(session.token);
    } else {
      await _sessionService.clearToken();
    }
    notificationsProvider.load();
    profileProvider.load();
    notifyListeners();
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
    } on ApiException {
      // Best-effort: still clear local state even if the network call
      // fails, so a user with no connectivity can still log out locally.
    }
    await _forceLogout();
  }

  /// Local-only logout with no outbound `/auth/logout` call — used when the
  /// token itself is already invalid (a 401 from any endpoint, via
  /// [ApiClient.onUnauthorized]), so there's nothing valid left to revoke.
  Future<void> _forceLogout() async {
    if (!_isLoggedIn) return;
    TokenStore.instance.clear();
    await _sessionService.clearToken();
    _currentUser = null;
    _isLoggedIn = false;
    notificationsProvider.clear();
    profileProvider.clear();
    notifyListeners();
  }
}
