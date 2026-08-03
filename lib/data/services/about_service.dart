import '../../core/network/api_client.dart';
import '../models/about_info.dart';

/// Real `GET /v1/about` call (api_requirements.md §10) — deliberately
/// public, no auth required.
class AboutService {
  Future<AboutInfo> fetchAboutInfo() {
    return ApiClient.call((dio) async {
      final response = await dio.get('/about');
      final json = response.data as Map<String, dynamic>;
      return AboutInfo(
        foundingYear: json['founding_year'] as int,
        earnerCount: json['earner_count'] as int,
        statesCovered: json['states_covered'] as int,
      );
    });
  }
}
