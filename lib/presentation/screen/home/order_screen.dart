import 'package:bringessesellerapp/config/constant/sharedpreference_helper.dart';
import 'package:bringessesellerapp/config/themes.dart';
import 'package:bringessesellerapp/model/request/oder_list_req_model.dart';
import 'package:bringessesellerapp/model/response/oder_list_response.dart';

import 'package:bringessesellerapp/presentation/screen/home/order_detail.dart';
import 'package:bringessesellerapp/presentation/screen/home/success_order_details.dart';
import 'package:bringessesellerapp/presentation/screen/order_section/bloc/oder_list_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/order_section/bloc/oder_list_state.dart';
import 'package:bringessesellerapp/presentation/widget/custome_appbar.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class OrderScreen extends StatefulWidget {
  final String? from;
  final String? status;
  const OrderScreen({super.key, this.from, this.status});

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
    if (widget.status == "complete") {
      _tabController.index = 1;
      _loadOrder(status: "complete");
    } else {
      _tabController.index = 0;
      _loadOrder(status: "pending");
    }
    _loadOrder(status: "pending");

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      final status = _tabController.index == 0 ? "pending" : "complete";
      _loadOrder(status: status);
    });
  }

  void _loadOrder({required String status}) {
    context.read<OderListCubit>().login(
          OderListReqModel(
            storeId: sharedPreferenceHelper.getStoreId,
            status: status,
            pageId: "",
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
        List<OrderDetails> pendingOrders = [];
        List<OrderDetails> completedOrders = [];

        if (state.networkStatusEnum == NetworkStatusEnum.loaded) {
          final orders = state.orderlistresponse.result?.orders ?? [];

          pendingOrders = orders
              .where((e) =>
                  e.status?.toString() == "pending" ||
                  e.status?.toString() == "shipped" ||
                  e.status?.toString() == "processing" ||
                  e.status?.toString() == "ready" ||
                  e.status?.toString() == 'accept')
              .toList()
            ..sort((a, b) => DateTime.parse(b.createdAt!).compareTo(
                  DateTime.parse(a.createdAt!),
                ));

          completedOrders =
              orders.where((e) => e.status?.toString() == "complete").toList()
                ..sort((a, b) => DateTime.parse(b.createdAt!).compareTo(
                      DateTime.parse(a.createdAt!),
                    ));
        }

        return Scaffold(
          appBar: CustomAppBar(
              title: "Orders",
              showLeading: widget.from == 'dash' ? true : false),
          body: Column(
            children: [
              // Tab section
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: TabBar(
                  isScrollable: false,
                  physics: NeverScrollableScrollPhysics(),
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

              // Orders List
              Expanded(
                child: state.networkStatusEnum == NetworkStatusEnum.loading
                    ? const Center(child: CircularProgressIndicator())
                    : TabBarView(
                        controller: _tabController,
                        children: [
                          _buildOrderList(pendingOrders, true),
                          _buildOrderList(completedOrders, false),
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Build ListView for each order category
  Widget _buildOrderList(List<OrderDetails> orders, bool isPending) {
    if (orders.isEmpty) {
      return const Center(child: Text("No orders found"));
    }

    return ListView.builder(
      itemCount: orders.length,
      padding: EdgeInsets.all(10.w),
      itemBuilder: (context, index) {
        final order = orders[index];
        return GestureDetector(
          onTap: isPending
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrderDetailsScreen(order: order),
                    ),
                  );
                }
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SuccessOrderDetailsScreen(
                        order: order,
                      ),
                    ),
                  );
                },
          child: _buildOrderCard(order, isPending: isPending),
        );
      },
    );
  }

  /// Build individual order card
  Widget _buildOrderCard(OrderDetails order, {required bool isPending}) {
    final uniqueId = order.uniqueId ?? "";
    final name = order.userDetails?.name ?? "Unknown";
    final price = order.total?.toStringAsFixed(2) ?? "0.00";
    final symbol = order.currencySymbol ?? "₹";
    final date = order.createdAt ?? "-";

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade900
            : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
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
                  "${order.status == 'accept' ? 'ready' : order.status}",
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
          Text(
            "Customer: $name",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            "Price: $symbol$price",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            "Date: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(date))}",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15.sp,
            ),
          ),
        ],
      ),
    );
  }
}
