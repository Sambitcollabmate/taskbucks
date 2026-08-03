import 'dart:math';

final _random = Random.secure();

/// Generates an RFC 4122 v4 UUID — used as the `idempotency_key` on
/// task/bonus-slot completion calls (backend validates it with Laravel's
/// `uuid` rule), so a retried request (flaky network, double tap) is
/// recognized as the same attempt instead of double-crediting.
String generateUuidV4() {
  final bytes = List<int>.generate(16, (_) => _random.nextInt(256));
  bytes[6] = (bytes[6] & 0x0F) | 0x40;
  bytes[8] = (bytes[8] & 0x3F) | 0x80;

  String hex(int start, int end) =>
      bytes.sublist(start, end).map((b) => b.toRadixString(16).padLeft(2, '0')).join();

  return '${hex(0, 4)}-${hex(4, 6)}-${hex(6, 8)}-${hex(8, 10)}-${hex(10, 16)}';
}
