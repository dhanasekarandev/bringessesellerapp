import 'package:flutter/material.dart';

class RevenueOtpScreen extends StatelessWidget {
  final double amount;

  const RevenueOtpScreen({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    TextEditingController otpController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Enter OTP")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Enter OTP to confirm withdrawal of ₹$amount",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "OTP",
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                String otp = otpController.text;
                // You can validate OTP here
                print("OTP entered: $otp for ₹$amount");
              },
              child: const Text("Submit"),
            )
          ],
        ),
      ),
    );
  }
}
