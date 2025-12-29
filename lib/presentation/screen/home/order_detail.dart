import 'dart:io';

import 'package:bringessesellerapp/config/constant/api_constant.dart';
import 'package:bringessesellerapp/config/constant/sharedpreference_helper.dart';
import 'package:bringessesellerapp/model/request/update_order_req_model.dart';
import 'package:bringessesellerapp/model/response/oder_list_response.dart';
import 'package:bringessesellerapp/presentation/screen/home/bloc/oder_status_update_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/home/bloc/update_order_state.dart';
import 'package:bringessesellerapp/presentation/widget/custom_conformation.dart';

import 'package:bringessesellerapp/presentation/widget/custome_appbar.dart';
import 'package:bringessesellerapp/presentation/widget/custome_button.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:bringessesellerapp/utils/toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

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
  // Scroll controller to programmatically scroll when keyboard opens
  final ScrollController _scrollController = ScrollController();
  // Focus node for OTP field so we can ensure it's visible
  final FocusNode _otpFocusNode = FocusNode();
  // Key to locate the OTP field in the widget tree
  final GlobalKey _otpFieldKey = GlobalKey();

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
    super.initState();
    sharedPreferenceHelper = SharedPreferenceHelper();
    sharedPreferenceHelper.init();

    currentStatus = widget.order.status == 'accept'
        ? 'ready'
        : widget.order.status ?? "pending";

    // When OTP field gets focus, ensure it's visible inside the scrollable
    _otpFocusNode.addListener(() {
      if (_otpFocusNode.hasFocus) {
        // Guard: context might be null if widget not laid out yet
        if (_otpFieldKey.currentContext != null) {
          Scrollable.ensureVisible(
            _otpFieldKey.currentContext!,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeIn,
            alignment: 0.3,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _otpFocusNode.dispose();
    otpController.dispose();
    super.dispose();
  }

  String? tempStatus;
  String? localOTP;

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
  Future<void> downloadInvoice(String orderId) async {
    try {
      final url = "https://bringesse.com:3002/order/download/$orderId";

      final response = await http.post(Uri.parse(url));

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;

        final dir = await getTemporaryDirectory();
        final filePath = "${dir.path}/invoice_$orderId.pdf";
        final file = File(filePath);

        await file.writeAsBytes(bytes);

        print("Invoice saved at $filePath");

        await OpenFilex.open(filePath); // Opens PDF
      } else {
        print("Download failed: ${response.statusCode}");
      }
    } catch (e) {
      print("Error downloading invoice: $e");
    }
  }

  Future<void> printInvoice(String orderId) async {
    final url = "https://your_api/invoice/print/$orderId";

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not open print invoice");
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;

    /// Prevent -1 index issue
    final currentStep = orderStages.indexOf(currentStatus) == -1
        ? 0
        : orderStages.indexOf(currentStatus);

    return BlocConsumer<OderStatusUpdateCubit, UpdateOrderState>(
      listener: (context, state) {
        if (state.networkStatusEnum == NetworkStatusEnum.loaded &&
            state.reviewResponseModel.status == 'true') {
          //
          if (state.reviewResponseModel.data!.status == 'processing') {
            final otp = state.reviewResponseModel.data!.otp.toString();
            final orderId = widget.order.orderId.toString();

            sharedPreferenceHelper.saveOrderOtp(orderId, otp);

            localOTP = otp;

            print("Local OTP: $localOTP");
          }

          showAppToast(
              message:
                  "Status changed to ${state.reviewResponseModel.message}");
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
        final bottomInset = MediaQuery.of(context).viewInsets.bottom;
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: CustomAppBar(
            title: "Order #${order.uniqueId}",
            actions: [
              PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'download') {
                    downloadInvoice(order.orderId.toString());
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'download',
                    child: Row(
                      children: const [
                        Icon(Icons.file_download_rounded, size: 20),
                        SizedBox(width: 10),
                        Text("Download Invoice"),
                      ],
                    ),
                  ),
                  // PopupMenuItem(
                  //   value: 'download',
                  //   child: Row(
                  //     children: const [
                  //       Icon(Icons.file_download, size: 20),
                  //       SizedBox(width: 10),
                  //       Text("Download Invoice"),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
          body: SingleChildScrollView(
            controller: _scrollController,
            padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 16.h + bottomInset),
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
                    padding: EdgeInsets.all(10.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// CUSTOMER + IMAGE
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                "Customer: ${order.userDetails?.name ?? ''}",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 8.h),

                        /// PRODUCT DETAILS
                        ...order.orderItems!.map((item) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 6.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// PRODUCT IMAGE
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6.r),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        "${ApiConstant.imageUrl}/public/media/items/${item.imageUrl}",
                                    height: 40.h,
                                    width: 40.w,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 10.w),

                                /// PRODUCT INFO
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name ?? '',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        "Qty: ${item.count}",
                                        style: TextStyle(fontSize: 12.sp),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),

                        Divider(height: 15.h),

                        /// ORDER INFO
                        Text("Total: ${order.currencySymbol}${order.total}"),
                        Text(
                          "Date: ${DateFormat('dd-MM-yyyy').format(
                            DateTime.parse(order.createdAt.toString()),
                          )}",
                        ),
                        Text(
                            "Address: ${order.deliveryAddress?.location ?? ''}"),

                        SizedBox(height: 10.h),

                        /// STATUS
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Current Status:",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 4.h,
                              ),
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
                if (currentStatus != "pending" &&
                    currentStatus != 'cancel') ...[
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
                    physics: NeverScrollableScrollPhysics(),
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
                            if (index == currentStep) SizedBox(height: 10.h),
                            if (index == currentStep &&
                                currentStatus == "ready") ...[
                              Text(
                                "Enter Delivery OTP",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              TextField(
                                key: _otpFieldKey,
                                focusNode: _otpFocusNode,
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
                                onPressed: () async {
                                  final orderId =
                                      widget.order.orderId.toString();

                                  final savedOtp = await sharedPreferenceHelper
                                      .getOrderOtp(orderId);

                                  print("Stored OTP for $orderId = $savedOtp");

                                  if (otpController.text == savedOtp) {
                                    updateStatus("shipped",
                                        otp: otpController.text);
                                    showAppToast(message: "OTP Verified");
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
          // resizeToAvoidBottomInset: false,
          bottomSheet: currentStatus == "pending"
              ? SafeArea(
                  child: AnimatedPadding(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.only(bottom: bottomInset + 12.h),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 20.h),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, -2),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                                backgroundColor: Colors.green,
                                title: "Accept",
                                onPressed: () {
                                  showCustomConfirmationDialog(
                                    context: context,
                                    content:
                                        "Are you sure want to accept this order",
                                    confirmText: "Yes",
                                    title: "Accept Order",
                                    cancelText: "Back",
                                    onConfirm: acceptOrder,
                                  );
                                }),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: CustomButton(
                              title: "Decline",
                              backgroundColor: Colors.red,
                              onPressed: () {
                                showCustomConfirmationDialog(
                                  context: context,
                                  content:
                                      "Are you sure want to cancel this order",
                                  confirmText: "Yes",
                                  title: "Cancel Order",
                                  cancelText: "Cancel",
                                  onConfirm: declineOrder,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        );
      },
    );
  }
}
