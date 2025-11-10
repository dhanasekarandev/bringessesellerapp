import 'package:bringessesellerapp/config/constant/sharedpreference_helper.dart';
import 'package:bringessesellerapp/config/themes.dart';
import 'package:bringessesellerapp/model/request/oder_list_req_model.dart';
import 'package:bringessesellerapp/presentation/screen/home/order_detail.dart';
import 'package:bringessesellerapp/presentation/screen/order_section/bloc/oder_list_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/order_section/bloc/oder_list_state.dart';

import 'package:bringessesellerapp/presentation/widget/custome_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with SingleTickerProviderStateMixin {
  late SharedPreferenceHelper sharedPreferenceHelper;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    sharedPreferenceHelper = SharedPreferenceHelper();
    sharedPreferenceHelper.init();

    _tabController = TabController(length: 2, vsync: this);

    // Load initial tab (Pending Orders)
    loadOrder(status: "1");

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      final status = _tabController.index == 0 ? "1" : "0";
      loadOrder(status: status);
    });
  }

  void loadOrder({required String status}) {
    context.read<OderListCubit>().login(
          OderListReqModel(
            storeId: sharedPreferenceHelper.getStoreId,
            status: status,
            pageId: "0",
            searchKey: "",
          ),
        );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OderListCubit, OderListState>(
      listener: (context, state) {},
      builder: (context, state) {
        final dummyOrders = [
          {
            "uniqueId": "ORD1001",
            "status": "1",
            "userDetails": {"name": "John Doe"},
            "currencySymbol": "₹",
            "price": "299.00",
            "date": "2025-11-08",
          },
          {
            "uniqueId": "ORD1002",
            "status": "0",
            "userDetails": {"name": "Priya Sharma"},
            "currencySymbol": "₹",
            "price": "499.00",
            "date": "2025-11-07",
          },
        ];

        final items = state.orderlistresponse.items?.isNotEmpty == true
            ? state.orderlistresponse.items
            : dummyOrders;

        final pendingOrders = items!.where((e) => e["status"] == "1").toList();
        final completedOrders = items.where((e) => e["status"] == "0").toList();

        return Scaffold(
          appBar: const CustomAppBar(title: "Orders", showLeading: false),
          body: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: const BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor:
                      Theme.of(context).tabBarTheme.indicatorColor,
                  tabs: const [
                    Tab(text: "Pending"),
                    Tab(text: "Completed"),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildOrderList(pendingOrders, true, true),
                    _buildOrderList(completedOrders, false, false),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOrderList(
      List<dynamic> orders, bool isPending, bool navigation) {
    return orders.isNotEmpty
        ? ListView.builder(
            itemCount: orders.length,
            padding: EdgeInsets.all(10.w),
            itemBuilder: (context, index) {
              final order = orders[index];
              return GestureDetector(
                onTap: navigation
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OrderDetailsScreen(order: order),
                          ),
                        );
                      }
                    : null,
                child: _buildOrderCard(order, isPending: isPending),
              );
            },
          )
        : const Center(child: Text("No orders found"));
  }

  Widget _buildOrderCard(dynamic order, {required bool isPending}) {
    final uniqueId = order["uniqueId"];
    final name = order["userDetails"]["name"];
    final price = order["price"];
    final symbol = order["currencySymbol"];
    final date = order["date"];

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade900
            : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Order #$uniqueId",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isPending
                      ? Colors.orange.shade100
                      : Colors.green.shade100,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  isPending ? "Pending" : "Completed",
                  style: TextStyle(
                    color: isPending
                        ? Colors.orange.shade800
                        : Colors.green.shade800,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text("Customer: $name", style: TextStyle(fontSize: 14.sp)),
          SizedBox(height: 4.h),
          Text(
            "Price: $symbol$price",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text("Date: $date",
              style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade600)),
        ],
      ),
    );
  }
}
