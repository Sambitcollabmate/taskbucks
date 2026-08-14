import 'package:razorpay_flutter/razorpay_flutter.dart';

/// Wraps `razorpay_flutter`'s `Razorpay` widget-launcher for the Premium
/// checkout flow — Checkout itself is synchronous (open → one of
/// success/error/externalWallet fires once), unlike Play Billing's
/// stream-based purchase delivery, so there's no `listen()`/dispose-once
/// pattern to mirror; a new instance per checkout attempt is simplest.
class RazorpayCheckoutService {
  Razorpay? _razorpay;

  /// Opens Razorpay's Checkout sheet for [orderId]/[amountPaise] (from
  /// `BillingService.createOrder`). Exactly one of [onSuccess]/[onError]
  /// fires once the user finishes (or cancels/fails) the payment.
  void open({
    required String orderId,
    required int amountPaise,
    required String keyId,
    String? prefillName,
    String? prefillEmail,
    String? prefillContact,
    required void Function(String paymentId, String signature) onSuccess,
    required void Function(String message) onError,
  }) {
    _razorpay?.clear();
    final razorpay = Razorpay();
    _razorpay = razorpay;

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse response) {
      final paymentId = response.paymentId;
      final signature = response.signature;
      if (paymentId == null || signature == null) {
        onError('Payment completed but Razorpay did not return a payment id/signature.');
        return;
      }
      onSuccess(paymentId, signature);
    });

    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (PaymentFailureResponse response) {
      onError(response.message ?? 'Payment failed.');
    });

    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (ExternalWalletResponse response) {
      onError('Selected an external wallet (${response.walletName}) — not supported yet.');
    });

    razorpay.open({
      'key': keyId,
      'order_id': orderId,
      'amount': amountPaise,
      'currency': 'INR',
      'name': 'EarnBucks',
      'description': 'Premium subscription',
      if (prefillName != null || prefillEmail != null || prefillContact != null)
        'prefill': {
          'name': ?prefillName,
          'email': ?prefillEmail,
          'contact': ?prefillContact,
        },
    });
  }

  void dispose() {
    _razorpay?.clear();
    _razorpay = null;
  }
}
