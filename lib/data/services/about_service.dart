import '../models/about_info.dart';

/// Fake data source for the About screen — same fake-service-now/real-API-
/// later convention as the rest of the app (PROJECT.md Section 4/7).
/// Founding year matches the "7 yrs paying" trust pill on Welcome
/// (screens/auth/widgets/trust_pills_row.dart) — keep both in sync if either
/// changes.
class AboutService {
  Future<AboutInfo> fetchAboutInfo() async {
    await Future.delayed(const Duration(milliseconds: 400));

    return const AboutInfo(
      foundingYear: 2019,
      earnerCount: 12000,
      statesCovered: 28,
    );
  }
}
