import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/material.dart';

class PaymentRepository {
  late Razorpay _razorpay;

  PaymentRepository() {
    _razorpay = Razorpay();
  }

  void init({
    required Function(PaymentSuccessResponse) onSuccess,
    required Function(PaymentFailureResponse) onError,
    required Function(ExternalWalletResponse) onExternalWallet,
  }) {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, onSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, onError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, onExternalWallet);
  }

  void clear() {
    _razorpay.clear();
  }

  void openCheckout({
    required String key,
    required int amount,
    required String name,
    required String description,
    String? contact,
    String? orderId,
    String? email,
  }) {
    var options = {
      'key': key,
      'amount': amount, // Amount in paise (₹1 = 100)
      'name': name,
      if (orderId != null) 'order_id': orderId,
      'description': description,
      'prefill': {
        'contact': '$contact',
        'email': email ?? '',
      },
      'external': {
        'wallets': ['paytm', 'phonepe', 'amazonpay']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Razorpay error: $e');
    }
  }
}
