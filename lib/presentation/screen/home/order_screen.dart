import 'package:bringessesellerapp/config/constant/sharedpreference_helper.dart';
import 'package:bringessesellerapp/model/request/oder_list_req_model.dart';

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

    // Listen to tab changes
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
        final pendingOrders = state.orderlistresponse.items
                ?.where((e) => e.status == "1")
                .toList() ??
            [];
        final completedOrders = state.orderlistresponse.items
                ?.where((e) => e.status == "0")
                .toList() ??
            [];

        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: const CustomAppBar(
              title: "Orders",
              showLeading: false,
            ),
            body: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: const BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black87,
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
                      // ✅ Pending Orders List
                      pendingOrders.isNotEmpty
                          ? ListView.builder(
                              itemCount: pendingOrders.length,
                              padding: EdgeInsets.all(10.w),
                              itemBuilder: (context, index) {
                                final order = pendingOrders[index];
                                return _buildOrderCard(order, isPending: true);
                              },
                            )
                          : const Center(
                              child: Text("No pending orders"),
                            ),

                      // ✅ Completed Orders List
                      completedOrders.isNotEmpty
                          ? ListView.builder(
                              itemCount: completedOrders.length,
                              padding: EdgeInsets.all(10.w),
                              itemBuilder: (context, index) {
                                final order = completedOrders[index];
                                return _buildOrderCard(order, isPending: false);
                              },
                            )
                          : const Center(
                              child: Text("No completed orders"),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrderCard(dynamic order, {required bool isPending}) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
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
          // Order ID & Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Order #${order.uniqueId ?? ""}",
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

          // Customer Name
          Text(
            "Customer: ${order.userDetails?.name ?? "N/A"}",
            style: TextStyle(fontSize: 14.sp),
          ),
          SizedBox(height: 4.h),

          // Price
          Text(
            "Price: ${order.currencySymbol ?? "₹"}${order.price ?? "0.00"}",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15.sp,
            ),
          ),
          SizedBox(height: 4.h),

          // Date
          Text(
            "Date: ${order.date ?? "--"}",
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
