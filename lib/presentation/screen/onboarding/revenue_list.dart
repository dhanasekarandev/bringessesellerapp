import 'package:bringessesellerapp/presentation/widget/custome_appbar.dart';
import 'package:flutter/material.dart';

class RevenueScreen extends StatelessWidget {
  const RevenueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: CustomAppBar(
        title: "Revenue",
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 12, bottom: 20),
        children: [
          revenueItem(
            image: "https://picsum.photos/200",
            title: "Pink Cotton Tshirt",
            date: "24 Jun, 10:49",
            orderId: "224154",
            amount: "30.00",
            amountColor: Colors.green,
          ),
          revenueItem(
            image: "https://picsum.photos/220",
            title: "Summer Full Sleeve Tshirt",
            date: "24 Jun, 10:23",
            orderId: "224121",
            amount: "39.00",
            amountColor: Colors.green,
          ),
          revenueItem(
            image: "https://picsum.photos/230",
            title: "Send to Bank",
            date: "24 Jun, 10:39",
            orderId: "Sent Successfully",
            amount: "29.00",
            amountColor: Colors.red,
          ),
          revenueItem(
            image: "https://picsum.photos/240",
            title: "Pink Cotton Tshirt",
            date: "24 Jun, 10:21",
            orderId: "224188",
            amount: "32.00",
            amountColor: Colors.green,
          ),
        ],
      ),
    );
  }
}

Widget revenueItem({
  required String image,
  required String title,
  required String date,
  required String orderId,
  required String amount,
  required Color amountColor,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 8,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Image
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            image,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),

        // Text Information
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Ordered on $date",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
                "Order ID  $orderId",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        // Amount
        Text(
          "\$$amount",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: amountColor,
          ),
        ),
      ],
    ),
  );
}
