/// Holds the current Sanctum bearer token in memory for the running app.
///
/// Kept separate from [SessionService]/`AuthProvider` so `ApiClient`'s
/// interceptor can read it without depending on the provider layer — a
/// login without "Remember me" still needs every subsequent API call
/// authenticated for the rest of the run, even though nothing is persisted
/// to secure storage in that case.
class TokenStore {
  TokenStore._();

  static final TokenStore instance = TokenStore._();

  String? _token;

  String? get token => _token;

  void set(String token) => _token = token;

  void clear() => _token = null;
}
