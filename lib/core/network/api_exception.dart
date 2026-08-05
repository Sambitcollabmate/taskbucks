import 'package:dio/dio.dart';

/// Normalizes every backend failure shape (AUTH_API.md's `422` field-keyed
/// validation errors, `429` rate-limit responses with `retry_after_seconds`,
/// and plain `{ "message": ... }` errors) into one type screens can branch
/// on, instead of each call site re-parsing a raw [DioException].
class ApiException implements Exception {
  final int? statusCode;
  final String message;

  /// Laravel validation errors, field name -> messages. Empty when the
  /// failure wasn't a `422` validation error.
  final Map<String, List<String>> fieldErrors;

  /// Present only on `429` responses (AUTH_API.md's rate-limit cases).
  final int? retryAfterSeconds;

  const ApiException({
    required this.message,
    this.statusCode,
    this.fieldErrors = const {},
    this.retryAfterSeconds,
  });

  /// First message for [field], if the server flagged it — e.g.
  /// `fieldError('referral_code')` after a failed register call.
  String? fieldError(String field) => fieldErrors[field]?.firstOrNull;

  factory ApiException.fromDioException(DioException error) {
    final response = error.response;
    if (response == null) {
      return ApiException(
        message: error.type == DioExceptionType.connectionError ||
                error.type == DioExceptionType.connectionTimeout
            ? "Can't reach the server. Check your connection and try again."
            : 'Something went wrong. Please try again.',
      );
    }

    final data = response.data;
    final body = data is Map<String, dynamic> ? data : <String, dynamic>{};
    final message = body['message'] as String? ?? 'Something went wrong. Please try again.';

    final rawErrors = body['errors'];
    final fieldErrors = <String, List<String>>{};
    if (rawErrors is Map) {
      rawErrors.forEach((key, value) {
        if (value is List) {
          fieldErrors[key as String] = value.map((e) => e.toString()).toList();
        }
      });
    }

    return ApiException(
      statusCode: response.statusCode,
      message: message,
      fieldErrors: fieldErrors,
      retryAfterSeconds: body['retry_after_seconds'] as int?,
    );
  }
}
