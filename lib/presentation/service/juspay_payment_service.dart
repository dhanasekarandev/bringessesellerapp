// // lib/services/juspay_payment_service.dart

// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class JuspayPaymentService {
//   final String baseUrl;

//   JuspayPaymentService({required this.baseUrl});

//   /// -------------------------------------------------------------
//   /// STEP 1: Create Order in Backend -> Get JusPay Session/Checkout URL
//   /// -------------------------------------------------------------
//   Future<String?> createJuspayOrder({
//     required String orderId,
//     required double amount,
//     required String customerEmail,
//     required String customerPhone,
//   }) async {
//     final url = Uri.parse("$baseUrl/create-juspay-order");

//     try {
//       final response = await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "order_id": orderId,
//           "amount": amount,
//           "customer_email": customerEmail,
//           "customer_phone": customerPhone,
//         }),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);

//         // The backend should return: { checkoutUrl: "https://..."}
//         return data["checkoutUrl"];
//       } else {
//         print("❌ JusPay Order Error: ${response.body}");
//         return null;
//       }
//     } catch (e) {
//       print("❌ JusPay Order Exception: $e");
//       return null;
//     }
//   }

//   /// -------------------------------------------------------------
//   /// STEP 2: Verify Payment Status from Backend
//   /// -------------------------------------------------------------
//   Future<bool> verifyPayment(String orderId) async {
//     final url = Uri.parse("$baseUrl/verify-payment");

//     try {
//       final response = await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"order_id": orderId}),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         return data["status"] == "success";
//       } else {
//         print("❌ Verify Payment Error: ${response.body}");
//         return false;
//       }
//     } catch (e) {
//       print("❌ Verify Payment Exception: $e");
//       return false;
//     }
//   }
// }
