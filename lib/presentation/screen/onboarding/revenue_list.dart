import 'package:bringessesellerapp/config/constant/contsant.dart';
import 'package:bringessesellerapp/config/constant/sharedpreference_helper.dart';
import 'package:bringessesellerapp/model/request/account_req_model.dart';
import 'package:bringessesellerapp/presentation/screen/onboarding/withdraw_screen.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/get_account_detail_cubit.dart';
import 'package:bringessesellerapp/presentation/widget/custome_appbar.dart';
import 'package:bringessesellerapp/presentation/widget/medium_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RevenueScreen extends StatefulWidget {
  const RevenueScreen({super.key});

  @override
  State<RevenueScreen> createState() => _RevenueScreenState();
}

class _RevenueScreenState extends State<RevenueScreen> {
  late SharedPreferenceHelper sharedPreferenceHelper;

  double balance = 4570.80;

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
  void initState() {
    sharedPreferenceHelper = SharedPreferenceHelper();
    sharedPreferenceHelper.init();
    _loadProfile();
    super.initState();
  }

  void _loadProfile() {
    context.read<GetAccountDetailCubit>().login(
          AccountReqModel(sellerId: sharedPreferenceHelper.getSellerId),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: const CustomAppBar(title: "Revenue"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              gridStats(),
              const SizedBox(height: 12),
              balanceCard(),
              vericalSpaceMedium,

              MediumText(title: "Recent Transactions"),
              const SizedBox(height: 10),

              // 🔹 FIXED LISTVIEW — NO OVERFLOW
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
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
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 GRID 4 BOXES
  Widget gridStats() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      childAspectRatio: 1.3,
      padding: const EdgeInsets.all(8),
      children: [
        statBox("Total Orders", "245", "Today's Orders", "12"),
        statBox("Total Income", "₹18,450", "Today's Income", "₹920"),
        statBox("Total Returns", "32", "Today's Returns", "1"),
        statBox("Total Refund", "₹2,140", "Today's Refund", "₹120"),
      ],
    );
  }

  // 🔹 STAT BOX UI
  Widget statBox(
    String title1,
    String value1,
    String title2,
    String value2,
  ) {
    return Container(
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title1,
              style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500)),
          Text(value1,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(title2,
              style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500)),
          Text(value2,
              style:
                  const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // 🔹 BALANCE CARD
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
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 6),
              Text(
                "₹${balance.toStringAsFixed(2)}",
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WithdrawScreen(
                    accountDetailModel: context
                        .read<GetAccountDetailCubit>()
                        .state
                        .accountDetailModel,
                  ),
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
                    fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 🔹 Revenue item UI
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
              Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text("Ordered on $date",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
              const SizedBox(height: 4),
              Text("Order ID  $orderId",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        Text(
          "₹$amount",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: amountColor),
        ),
      ],
    ),
  );
}
