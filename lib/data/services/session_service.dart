import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persists the session token behind "Remember me" (PROJECT.md 4) — a real
/// secure-storage-backed token, not just pre-filling the identifier field.
/// Absence of a stored token simply means the user isn't remembered; it
/// doesn't gate routing here since auth-redirect logic isn't wired yet
/// (PROJECT.md 7, Phase 3 final item).
class SessionService {
  static const _tokenKey = 'session_token';

  final FlutterSecureStorage _storage;

  SessionService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  Future<void> saveToken(String token) => _storage.write(key: _tokenKey, value: token);

  Future<String?> readToken() => _storage.read(key: _tokenKey);

  Future<void> clearToken() => _storage.delete(key: _tokenKey);
}
