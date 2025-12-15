import 'package:bringessesellerapp/config/constant/contsant.dart';
import 'package:bringessesellerapp/config/constant/sharedpreference_helper.dart';
import 'package:bringessesellerapp/model/request/account_req_model.dart';
import 'package:bringessesellerapp/model/request/store_id_reqmodel.dart';
import 'package:bringessesellerapp/model/response/revenue_response_model.dart';
import 'package:bringessesellerapp/presentation/screen/onboarding/bloc/revenue_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/onboarding/bloc/revenue_state.dart';
import 'package:bringessesellerapp/presentation/screen/onboarding/withdraw_screen.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/get_account_detail_cubit.dart';
import 'package:bringessesellerapp/presentation/widget/custome_appbar.dart';
import 'package:bringessesellerapp/presentation/widget/medium_text.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RevenueScreen extends StatefulWidget {
  const RevenueScreen({super.key});

  @override
  State<RevenueScreen> createState() => _RevenueScreenState();
}

class _RevenueScreenState extends State<RevenueScreen> {
  late SharedPreferenceHelper sharedPreferenceHelper;
  @override
  void initState() {
    super.initState();
    sharedPreferenceHelper = SharedPreferenceHelper();
    sharedPreferenceHelper.init();
    _loadProfile();
    revenue();
  }

  revenue() {
    context
        .read<RevenueCubit>()
        .login(StoreIdReqmodel(storeId: sharedPreferenceHelper.getStoreId));
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
      body: BlocBuilder<RevenueCubit, RevenueState>(
        builder: (context, state) {
          if (state.networkStatusEnum == NetworkStatusEnum.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.networkStatusEnum == NetworkStatusEnum.failed) {
            return const Center(child: Text("Failed to load revenue data"));
          }

          final ordersData = state.orderlistresponse;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  gridStats(ordersData),
                  const SizedBox(height: 12),
                  balanceCard(ordersData),
                  vericalSpaceMedium,
                  MediumText(title: "Recent Transactions"),
                  const SizedBox(height: 10),
                  // 🔹 FIXED LISTVIEW — NO OVERFLOW
                  if (ordersData.orders != null &&
                      ordersData.orders!.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: ordersData.orders!.length,
                      itemBuilder: (context, index) {
                        final order = ordersData.orders![index];
                        final itemImage = order.items?.isNotEmpty == true
                            ? (order.items!.first.image ??
                                'https://via.placeholder.com/60')
                            : 'https://via.placeholder.com/60';

                        return revenueItem(
                          image: itemImage,
                          title: order.items?.isNotEmpty == true
                              ? (order.items!.first.name ?? 'Order')
                              : 'Order ${order.uniqueId}',
                          date: order.createdAt ?? 'N/A',
                          orderId: order.uniqueId ?? order.id ?? 'N/A',
                          amount: order.totalSellerEarning?.toString() ?? '0',
                          amountColor: Colors.green,
                        );
                      },
                    )
                  else
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          "No transactions yet",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // 🔹 GRID 4 BOXES
  Widget gridStats(RevenueResponseModel? ordersData) {
    final totalOrders = ordersData?.totalOrders ?? 0;
    final totalIncome = ordersData?.totalSellerEarningAllOrders ?? 0;
    final totalProcessingFee = ordersData?.totalProcessingFeeAllOrders ?? 0;
    // Use fixed rows/columns (2x2) with Expanded to avoid layout overflow
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: statBox("Total Orders", totalOrders.toString(),
                    "Today's Orders", "0", Colors.blue.shade100),
              ),
              Expanded(
                child: statBox("Total Income", "₹$totalIncome",
                    "Today's Income", "₹0", Colors.green.shade100),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: statBox("Total Returns", "0", "Today's Returns", "0",
                    Colors.orange.shade100),
              ),
              Expanded(
                child: statBox("Processing Fees", "₹$totalProcessingFee",
                    "Today's Fees", "₹0", Colors.red.shade100),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 🔹 STAT BOX UI
  Widget statBox(
    String title1,
    String value1,
    String title2,
    String value2,
    Color boxColor,
  ) {
    return Container(
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: boxColor,
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
          Text(title1, style: TextStyle(fontSize: 13, color: Colors.black54)),
          Text(value1,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(title2, style: TextStyle(fontSize: 13, color: Colors.black54)),
          Text(value2,
              style:
                  const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // 🔹 BALANCE CARD
  Widget balanceCard(RevenueResponseModel? ordersData) {
    final totalEarning = ordersData?.totalSellerEarningAllOrders ?? 0;

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
                "Total Earnings",
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 6),
              Text(
                "₹${totalEarning.toStringAsFixed(2)}",
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
                    totalBalance: totalEarning.toStringAsFixed(2),
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
          child: SizedBox(
            width: 60,
            height: 60,
            child: Image.network(
              image,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              // show a small loader while loading
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              },
              // fallback when image fails to load
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey.shade200,
                child: Icon(Icons.broken_image, color: Colors.grey, size: 28),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                "Ordered on $date",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                "Order ID  $orderId",
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        SizedBox(
          width: 90,
          child: Text(
            "₹$amount",
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: amountColor),
          ),
        ),
      ],
    ),
  );
}
