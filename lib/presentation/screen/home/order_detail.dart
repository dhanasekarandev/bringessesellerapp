import 'package:bringessesellerapp/config/constant/sharedpreference_helper.dart';
import 'package:bringessesellerapp/model/request/update_order_req_model.dart';
import 'package:bringessesellerapp/model/response/oder_list_response.dart';
import 'package:bringessesellerapp/presentation/screen/home/bloc/oder_status_update_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/home/bloc/update_order_state.dart';
import 'package:bringessesellerapp/presentation/widget/custome_appbar.dart';
import 'package:bringessesellerapp/presentation/widget/custome_button.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:bringessesellerapp/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  late SharedPreferenceHelper sharedPreferenceHelper;
  TextEditingController otpController = TextEditingController();

  /// Order Stages (API values)
  final List<String> orderStages = [
    "pending",
    "processing",
    "ready",
    "shipped"
  ];

  final Map<String, String> stageLabels = {
    "pending": "Pending",
    "processing": "Processing",
    "ready": "Ready to Ship",
    "shipped": "Shipped",
  };

  @override
  void initState() {
    print("sljdfbhskdj${widget.order.status}");
    super.initState();
    sharedPreferenceHelper = SharedPreferenceHelper();
    sharedPreferenceHelper.init();

    currentStatus = widget.order.status ?? "pending";
  }

  String? tempStatus;
  String? otp;

  /// =========================
  /// UPDATE STATUS (API CALL)
  /// =========================
  void updateStatus(String newStatus, {String? otp}) {
    tempStatus = newStatus;
    context.read<OderStatusUpdateCubit>().login(
          UpdateOrderStatusReqModel(
              sellerId: widget.order.storeId,
              orderId: widget.order.orderId,
              status: newStatus, 
              userId: widget.order.userDetails!.id,
              otp: otp),
        );
  }

  /// Move to next stage
  void moveToNextStage() {
    final currentIndex = orderStages.indexOf(currentStatus);
    if (currentIndex != -1 && currentIndex < orderStages.length - 1) {
      updateStatus(orderStages[currentIndex + 1]);
    }
  }

  /// Accept Order
  void acceptOrder() => updateStatus("processing");

  /// Cancel Order
  void declineOrder() => updateStatus("cancel");

  @override
  Widget build(BuildContext context) {
    final order = widget.order;

    /// Prevent -1 index issue
    final currentStep = orderStages.indexOf(currentStatus) == -1
        ? 0
        : orderStages.indexOf(currentStatus);

    return BlocConsumer<OderStatusUpdateCubit, UpdateOrderState>(
      listener: (context, state) {
        print("slkdhfn${state.reviewResponseModel.status}");
        if (state.networkStatusEnum == NetworkStatusEnum.loaded &&
            state.reviewResponseModel.status == 'true') {
          otp = state.reviewResponseModel.data!.otp.toString();
          showAppToast(
              message: "Status changed to ${state.reviewResponseModel.status}");
          setState(() {
            currentStatus = tempStatus!;
          });
        } else if (state.reviewResponseModel.status == 'false') {
          showAppToast(message: "${state.reviewResponseModel.message}");
          setState(() {
            currentStatus = tempStatus!;
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(title: "Order #${order.uniqueId}"),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ===================
                /// ORDER INFO CARD
                /// ===================
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
                        Text(
                          "Customer: ${order.userDetails?.name ?? ''}",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 5.h),

                        Text("Price: ${order.currencySymbol}${order.total}"),

                        Text(
                          "Date: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(order.createdAt.toString()))}",
                        ),

                        Text(
                            "Address: ${order.deliveryAddress?.address ?? ''}"),
                        SizedBox(height: 10.h),

                        /// STATUS LABEL
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Current Status:",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: Colors.blueAccent.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Text(
                                stageLabels[currentStatus] ?? currentStatus,
                                style: const TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                /// ================================
                /// Show Stepper only after pending
                /// ================================
                if (currentStatus != "pending") ...[
                  Text(
                    "Order Progress",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Stepper(
                    currentStep: currentStep,
                    type: StepperType.vertical,
                    controlsBuilder: (context, _) => const SizedBox.shrink(),
                    steps: orderStages.map((stage) {
                      final index = orderStages.indexOf(stage);

                      return Step(
                        title: Text(
                          stageLabels[stage] ?? stage, // UI label
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
                              // Text(
                              //   "Currently in ${stageLabels[stage]}.",
                              //   style: Theme.of(context).textTheme.titleMedium,
                              // ),

                              SizedBox(height: 10.h),

                            // ⭐ OTP UI when status = shipped
                            if (index == currentStep &&
                                currentStatus == "shipped") ...[
                              Text(
                                "Enter Delivery OTP",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              TextField(
                                controller: otpController,
                                maxLength: 4,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  counterText: "",
                                  hintText: "Enter 4-digit OTP",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              CustomButton(
                                title: "Verify OTP & Shipped",
                                onPressed: () {
                                  if (otpController.text == otp) {
                                    updateStatus("shipped",
                                        otp: otpController.text);
                                    showAppToast(
                                        message:
                                            "OTP Verified: ${otpController.text}");
                                  } else {
                                    showAppToast(
                                        message:
                                            "Please enter valid 4-digit OTP");
                                  }
                                },
                              ),
                            ]

                            // ⭐ Show Move to Next Step except shipped
                            else if (index == currentStep &&
                                currentStatus != "shipped")
                              CustomButton(
                                title: "Move to Next Step",
                                onPressed: moveToNextStage,
                              ),
                          ],
                        ),
                        isActive: index <= currentStep,
                        state: index < currentStep
                            ? StepState.complete
                            : index == currentStep
                                ? StepState.editing
                                : StepState.indexed,
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
          bottomSheet: currentStatus == "pending"
              ? Container(
                  color: Colors.white,
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          backgroundColor: Colors.green,
                          title: "Accept",
                          onPressed: acceptOrder,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: CustomButton(
                          title: "Decline",
                          backgroundColor: Colors.red,
                          onPressed: declineOrder,
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        );
      },
    );
  }
}
