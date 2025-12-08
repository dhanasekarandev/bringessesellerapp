import 'package:bringessesellerapp/config/constant/contsant.dart';
import 'package:bringessesellerapp/presentation/screen/onboarding/withdraw_screen.dart';
import 'package:bringessesellerapp/presentation/widget/custome_appbar.dart';
import 'package:bringessesellerapp/presentation/widget/medium_text.dart';
import 'package:flutter/material.dart';

class RevenueScreen extends StatefulWidget {
  const RevenueScreen({super.key});

  @override
  State<RevenueScreen> createState() => _RevenueScreenState();
}

class _RevenueScreenState extends State<RevenueScreen> {
  double balance = 4570.80;

  // 🔹 Dummy List (replace with API response later)
  List<Map<String, dynamic>> transactions = [
    {
      "image": "https://picsum.photos/200",
      "title": "Pink Cotton Tshirt",
      "date": "24 Jun, 10:49",
      "orderId": "224154",
      "amount": "30.00",
      "color": Colors.green
    },
    {
      "image": "https://picsum.photos/220",
      "title": "Summer Full Sleeve Tshirt",
      "date": "24 Jun, 10:23",
      "orderId": "224121",
      "amount": "39.00",
      "color": Colors.green
    },
    {
      "image": "https://picsum.photos/230",
      "title": "Send to Bank",
      "date": "24 Jun, 10:39",
      "orderId": "Sent Successfully",
      "amount": "29.00",
      "color": Colors.red
    },
    {
      "image": "https://picsum.photos/240",
      "title": "Pink Cotton Tshirt",
      "date": "24 Jun, 10:21",
      "orderId": "224188",
      "amount": "32.00",
      "color": Colors.green
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: const CustomAppBar(title: "Revenue"),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            balanceCard(),
            vericalSpaceMedium,
            MediumText(title: "Recent Transactions"),

            // 🔹 ListView.builder
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 20, top: 12),
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final item = transactions[index];

                  return revenueItem(
                    image: item["image"],
                    title: item["title"],
                    date: item["date"],
                    orderId: item["orderId"],
                    amount: item["amount"],
                    amountColor: item["color"],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Balance card UI
  Widget balanceCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            Colors.purple.shade400,
            Colors.purple.shade200,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Current Balance",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "\$${balance.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WithdrawScreen(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "Withdraw",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 🔹 Revenue Item UI
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
