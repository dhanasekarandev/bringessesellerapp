import 'package:bringessesellerapp/model/response/oder_list_response.dart';
import 'package:bringessesellerapp/presentation/widget/custom_conformation.dart';
import 'package:bringessesellerapp/presentation/widget/custome_appbar.dart';
import 'package:bringessesellerapp/presentation/widget/custome_button.dart';
import 'package:bringessesellerapp/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrderDetails order;
  const OrderDetailsScreen({super.key, required this.order});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late String currentStatus;

  final List<String> orderStages = [
    "pending",
    "Confirmed",
    "Packed",
    "Shipped",
    "Out for Delivery",
    "Delivered",
    "Cancelled",
  ];

  @override
  void initState() {

    super.initState();
    currentStatus = widget.order.status ?? "pending";
  }

  void updateStatus(String newStatus) {
    setState(() {
      currentStatus = newStatus;
    });
    showAppToast(message: 'Status changed to $newStatus');
  }

  void moveToNextStage() {
    final currentIndex = orderStages.indexOf(currentStatus);

    if (currentStatus == "Delivered" || currentStatus == "Cancelled") {
      return;
    }

    if (currentIndex < orderStages.length - 2) {
      updateStatus(orderStages[currentIndex + 1]);
    } else {
      updateStatus("Delivered");
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;

    final currentStep = orderStages.indexOf(currentStatus);

    return Scaffold(
      appBar: CustomAppBar(
        title: "Order #${order.uniqueId}",
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🧾 Order Info
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Customer: ${order.userDetails!.name}",
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.w600)),
                    SizedBox(height: 5.h),
                    Text("Price: ${order.currencySymbol}${order.price}"),
                    Text(
                        "Date: ${DateFormat().format(DateTime.parse(order.createdAt.toString()))}"),
                    Text("Address: ${order.deliveryAddress!.address}"),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Current Status:",
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            currentStatus,
                            style: const TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // 🛍 Product List
            Text("Items Ordered",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 8.h),
            // ...products.((item) {
            //   return ListTile(
            //     title: Text(item["name"]),
            //     subtitle: Text("Qty: ${item["qty"]}"),
            //     trailing: Text("₹${item["price"]}"),
            //   );
            // }).toList(),

            SizedBox(height: 20.h),

            // 🚀 Stepper Section
            Text("Order Progress",
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
            SizedBox(height: 10.h),

            Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Colors.blueAccent,
                ),
              ),
              child: Stepper(
                currentStep: currentStep,
                type: StepperType.vertical,
                steps: orderStages
                    .where((stage) => stage != "Cancelled")
                    .map((stage) {
                  final index = orderStages.indexOf(stage);
                  final isLastStep = stage == "Delivered";

                  return Step(
                    title: Text(
                      stage,
                      style: TextStyle(
                        color: index <= currentStep
                            ? Colors.green
                            : Colors.grey.shade700,
                      ),
                    ),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (index == currentStep)
                          Text(
                            "Currently in $stage stage.",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        SizedBox(
                          height: 10.h,
                        ),
                        if (index == currentStep && !isLastStep)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomButton(
                                title: 'Move to Next Step',
                                onPressed: moveToNextStage,
                              ),
                              if (currentStatus == "pending") ...[
                                SizedBox(height: 10.h),
                                CustomButton(
                                  title: 'Cancel Order',
                                  backgroundColor: Colors.redAccent,
                                  onPressed: () {
                                    showCustomConfirmationDialog(
                                      title: 'Cancel Order',
                                      content:
                                          'Are you sure you want to cancel this order?',
                                      context: context,
                                      onConfirm: () {
                                        Navigator.pop(context);
                                        updateStatus("Cancelled");
                                      },
                                    );
                                  },
                                ),
                              ],
                            ],
                          ),
                      ],
                    ),
                    isActive: index <= currentStep,
                    state: index < currentStep
                        ? StepState.complete
                        : (index == currentStep
                            ? StepState.editing
                            : StepState.indexed),
                  );
                }).toList(),
                controlsBuilder: (context, details) => const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
