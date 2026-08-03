import '../../core/network/api_client.dart';
import '../models/refer_summary.dart';
import '../models/referral.dart';
import '../models/top_referrer.dart';

/// Real `GET /v1/refer` call (api_requirements.md §7).
class ReferService {
  Future<ReferSummary> fetchReferSummary() {
    return ApiClient.call((dio) async {
      final response = await dio.get('/refer');
      final json = response.data as Map<String, dynamic>;

      return ReferSummary(
        referralCode: json['referral_code'] as String,
        totalReferred: json['total_referred'] as int,
        totalConverted: json['total_converted'] as int,
        totalEarned: double.parse(json['total_earned'] as String),
        isPremium: json['is_premium'] as bool,
        conversionsThisWeek: json['conversions_this_week'] as int,
        bonusAdSlotsAvailable: json['bonus_ad_slots_available'] as int,
        recentReferrals: (json['recent_referrals'] as List)
            .cast<Map<String, dynamic>>()
            .map(_referralFromJson)
            .toList(),
        topReferrers: (json['top_referrers'] as List)
            .cast<Map<String, dynamic>>()
            .map(_topReferrerFromJson)
            .toList(),
      );
    });
  }

  Referral _referralFromJson(Map<String, dynamic> json) {
    return Referral(
      id: json['id'].toString(),
      maskedUsername: json['masked_username'] as String,
      date: DateTime.parse(json['date'] as String),
      status: json['status'] == 'converted' ? ReferralStatus.converted : ReferralStatus.pending,
      amount: double.parse(json['amount'] as String),
    );
  }

  TopReferrer _topReferrerFromJson(Map<String, dynamic> json) {
    return TopReferrer(
      rank: json['rank'] as int,
      maskedUsername: json['masked_username'] as String,
      conversions: json['conversions'] as int,
    );
  }
}
