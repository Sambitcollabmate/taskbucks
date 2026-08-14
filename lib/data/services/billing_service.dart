import '../../core/network/api_client.dart';

/// {order_id, amount, currency, key_id} — returned by `POST
/// /v1/billing/create-order`, handed straight to
/// [RazorpayCheckoutService.open].
class RazorpayOrder {
  final String orderId;
  final int amount;
  final String currency;
  final String keyId;

  const RazorpayOrder({
    required this.orderId,
    required this.amount,
    required this.currency,
    required this.keyId,
  });

  factory RazorpayOrder.fromJson(Map<String, dynamic> json) {
    return RazorpayOrder(
      orderId: json['order_id'] as String,
      amount: json['amount'] as int,
      currency: json['currency'] as String,
      keyId: json['key_id'] as String,
    );
  }
}

/// Real `POST /v1/billing/create-order`/`POST /v1/billing/verify-payment`
/// calls (AUTH_API.md-adjacent contract in BillingController). Premium is a
/// manual monthly repurchase via Razorpay Checkout, not an auto-renewing
/// subscription — see ProfileProvider.subscribeToPremium and
/// RazorpayCheckoutService.
class BillingService {
  Future<RazorpayOrder> createOrder() {
    return ApiClient.call((dio) async {
      final response = await dio.post('/billing/create-order');
      return RazorpayOrder.fromJson(response.data as Map<String, dynamic>);
    });
  }

  Future<void> verifyPayment({
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  }) {
    return ApiClient.call((dio) => dio.post('/billing/verify-payment', data: {
          'razorpay_order_id': razorpayOrderId,
          'razorpay_payment_id': razorpayPaymentId,
          'razorpay_signature': razorpaySignature,
        }));
  }
}
