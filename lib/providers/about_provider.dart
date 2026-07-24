import 'package:flutter/foundation.dart';

import '../data/models/about_info.dart';
import '../data/services/about_service.dart';

/// Holds About screen state — same role as [ReferProvider]/[HomeProvider]:
/// widgets that watch this rebuild whenever [notifyListeners] fires.
class AboutProvider extends ChangeNotifier {
  final AboutService _service;

  AboutProvider({AboutService? service}) : _service = service ?? AboutService() {
    load();
  }

  AboutInfo? _info;
  bool _isLoading = false;

  AboutInfo? get info => _info;
  bool get isLoading => _isLoading;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    _info = await _service.fetchAboutInfo();

    _isLoading = false;
    notifyListeners();
  }
}
