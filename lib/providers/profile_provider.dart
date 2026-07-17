import 'package:flutter/foundation.dart';

import '../data/models/user_profile.dart';
import '../data/services/profile_service.dart';

/// Holds Profile screen state — same role as [HomeProvider]/[WalletProvider]:
/// widgets that watch this rebuild whenever [notifyListeners] fires.
class ProfileProvider extends ChangeNotifier {
  final ProfileService _service;

  ProfileProvider({ProfileService? service}) : _service = service ?? ProfileService() {
    load();
  }

  UserProfile? _profile;
  bool _isLoading = false;

  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    _profile = await _service.fetchProfile();

    _isLoading = false;
    notifyListeners();
  }
}
