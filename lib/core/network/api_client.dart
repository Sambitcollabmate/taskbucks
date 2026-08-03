import 'package:dio/dio.dart';

import '../../data/services/token_store.dart';
import '../config/app_config.dart';
import 'api_exception.dart';

/// Shared Dio instance for every backend call (`earnbucks-api`). Attaches
/// the bearer token from [TokenStore] when one is set, and translates every
/// failure into an [ApiException] so services/providers never touch
/// [DioException] directly.
class ApiClient {
  ApiClient._();

  static final Dio instance = _build();

  /// Set once by `AuthProvider` at startup. Called whenever any
  /// authenticated request comes back `401` (token expired/revoked
  /// mid-session, e.g. after a password reset elsewhere) — lets the app
  /// force a local logout instead of every screen having to notice its own
  /// requests silently failing.
  static void Function()? onUnauthorized;

  static Dio _build() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.resolveApiBaseUrl(),
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = TokenStore.instance.token;
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          if (error.response?.statusCode == 401 && TokenStore.instance.token != null) {
            onUnauthorized?.call();
          }
          handler.next(error);
        },
      ),
    );

    return dio;
  }

  /// Runs [request] and rethrows any failure as an [ApiException] — the one
  /// error type the rest of the app needs to know about.
  static Future<T> call<T>(Future<T> Function(Dio dio) request) async {
    try {
      return await request(instance);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
