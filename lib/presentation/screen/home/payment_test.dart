import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaymentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Juspay Payment")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _startPayment(context);
          },
          child: Text("Pay Now"),
        ),
      ),
    );
  }

  void _startPayment(BuildContext context) async {
    Map<String, dynamic> paymentDetails = {
      "merchantId": "YOUR_MERCHANT_ID",
      "clientId": "YOUR_CLIENT_ID",
      "orderId": "ORDER123",
      "amount": 10000, // 100 INR in paise
      "currency": "INR",
      "customerEmail": "test@example.com",
    };

    final result = await PaymentChannel.startPayment(paymentDetails);

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment Successful!")),
      );
      print("Payment result: $result");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment Failed")),
      );
    }
  }
}

class PaymentChannel {
  static const MethodChannel _channel = MethodChannel('juspay_payment');

  static Future<String?> startPayment(
      Map<String, dynamic> paymentDetails) async {
    try {
      final result =
          await _channel.invokeMethod('startPayment', paymentDetails);
      return result as String?;
    } on PlatformException catch (e) {
      print("Payment failed: ${e.message}");
      return null;
    }
  }
}
