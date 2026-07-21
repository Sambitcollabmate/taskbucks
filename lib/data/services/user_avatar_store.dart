/// In-memory stand-in for the shared backend field that will eventually
/// back both the Profile and Settings screens' avatar (PROJECT.md 4/7) —
/// until the Laravel endpoint exists, [ProfileService] and [SettingsService]
/// read/write this single static value so a photo picked in Settings shows
/// up on the Profile tab without a real round-trip.
class UserAvatarStore {
  static String? imagePath;
}
