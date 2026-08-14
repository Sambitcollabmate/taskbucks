import 'dart:async';

import 'package:app_links/app_links.dart';

/// App-wide singleton wrapping `app_links` — the only inbound deep link the
/// app currently handles is `earnbucks://task-complete?session_token=...`,
/// which the Adsterra task page (earnbucks-site's task.blade.php) navigates
/// to once its timer finishes (see AdsterraTaskService). Initialized once
/// in main.dart so the stream subscription exists app-wide, not just while
/// some particular screen is mounted — the link can arrive while the app
/// was backgrounded on any screen.
class DeepLinkListener {
  DeepLinkListener._();

  static final DeepLinkListener instance = DeepLinkListener._();

  final _appLinks = AppLinks();
  final _controller = StreamController<Uri>.broadcast();
  StreamSubscription<Uri>? _subscription;

  Future<void> init() async {
    _subscription = _appLinks.uriLinkStream.listen(_controller.add);

    // Covers the cold-start case: the app was fully closed and the OS
    // launched it directly via the deep link, so uriLinkStream's first
    // event would otherwise be missed.
    final initialLink = await _appLinks.getInitialLink();
    if (initialLink != null) {
      _controller.add(initialLink);
    }
  }

  /// Resolves with the first incoming [Uri] whose host matches [host]
  /// (e.g. `'task-complete'`), or throws a [TimeoutException] if none
  /// arrives within [timeout].
  Future<Uri> waitForHost(String host, {Duration timeout = const Duration(minutes: 5)}) {
    return _controller.stream.firstWhere((uri) => uri.host == host).timeout(timeout);
  }

  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }
}
