import 'dart:developer';

import 'package:bringessesellerapp/config/constant/contsant.dart';
import 'package:bringessesellerapp/config/constant/sharedpreference_helper.dart';
import 'package:bringessesellerapp/config/themes.dart';
import 'package:bringessesellerapp/model/request/my_subs_res_model.dart';
import 'package:bringessesellerapp/model/request/subcription_checkout_req_model.dart';
import 'package:bringessesellerapp/model/request/subs_transaction_req_model.dart';
import 'package:bringessesellerapp/model/response/subription_defaults_response_model.dart';
import 'package:bringessesellerapp/presentation/repository/juspay_repo.dart';
import 'package:bringessesellerapp/presentation/repository/razorpay_repo.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/subscription_checkout_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/subscription_checkout_state.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/subscription_default_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/subscription_transaction_cubit.dart';
import 'package:bringessesellerapp/presentation/widget/custome_appbar.dart';
import 'package:bringessesellerapp/presentation/widget/custome_outline_button.dart';
import 'package:bringessesellerapp/presentation/widget/headline_text.dart';
import 'package:bringessesellerapp/presentation/widget/sub_title.dart';

import 'package:bringessesellerapp/utils/enums.dart';
import 'package:bringessesellerapp/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hypersdkflutter/hypersdkflutter.dart';
import 'package:intl/intl.dart';


import '../../../model/response/subcription_checkout_response.dart';

class SubscriptionListScreen extends StatefulWidget {
  final MySubscriptionResult? data;
  const SubscriptionListScreen({super.key, this.data});

  @override
  State<SubscriptionListScreen> createState() => _SubscriptionListScreenState();
}

class _SubscriptionListScreenState extends State<SubscriptionListScreen> {
  List<SubscriptionModel> otherPlans = [];
  Map<String, bool> expandedCard = {};
  late SharedPreferenceHelper sharedPreferenceHelper;

  final hyperSDKInstance = HyperSDK();

  /// Missing variables fixed 👇
  String? selectedplanId;
  double? selectedplanPrice;
  bool isLoading = false;

  @override
  void initState() {
    sharedPreferenceHelper = SharedPreferenceHelper();
    sharedPreferenceHelper.init();
    super.initState();
    loadPlans();
  }

  loadPlans() {
    final subscriptionState =
        context.read<SubscriptionDefaultCubit>().state.viewProfile;

    otherPlans = subscriptionState.result ?? [];

    final activeId = widget.data?.subscriptionPlan?.id;
    if (activeId != null) {
      otherPlans.removeWhere((plan) => plan.id == activeId);
    }
  }

  /// Juspay Success API Trigger
  void _juspaymentSuccess({
    String? storeId,
    String? orderId,
    String? subscriptionId,
    String? sellerId,
  }) {
    context.read<SubscriptionTransactionCubit>().login(
          SubscriptionTransactionReq(
            gateway: 'juspay',
            orderId: orderId,
            sellerId: sellerId,
            paymentId: orderId,
            subscriptionPlanId: subscriptionId,
            storeId: storeId,
            status: 'CHARGED',
            gatewayName: 'Juspay',
          ),
        );
  }

  /// Juspay Payment Launch & Result Handler
  Future<void> jusPayment(
    BuildContext context,
    SdkPayload? payload,
  ) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentPageScreen(
          hyperSDK: hyperSDKInstance,
          payload: payload,
        ),
      ),
    );

    if (result != null && result['status'] == "CHARGED") {
      showAppToast(message: 'Payment Successful');

      _juspaymentSuccess(
        orderId: result['orderId'],
        sellerId: sharedPreferenceHelper.getSellerId,
        storeId: sharedPreferenceHelper.getStoreId,
        subscriptionId: selectedplanId,
      );
    } else {
      showAppToast(message: 'Payment Failed');
    }

    if (Navigator.canPop(context)) Navigator.pop(context);
  }

  /// Razorpay Success Handler
  void _paymentSuccess(
      {String? orderId, String? paymentId, String? signature}) {
    context.read<SubscriptionTransactionCubit>().login(
          SubscriptionTransactionReq(
            orderId: orderId,
            paymentId: paymentId,
            signature: signature,
          ),
        );
  }

  bool loading = false;

  
  void _checkout({String? subsId, double? subsPrice}) {
    setState(() {
      loading = true;
    });
    selectedplanId = subsId;
    selectedplanPrice = subsPrice;

    context.read<SubscriptionCheckoutCubit>().login(
          SubscriptionCheckoutReqModel(
              subscriptionId: subsId,
              subscriptionPrice: subsPrice,
              sellerId: sharedPreferenceHelper.getSellerId),
        );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SubscriptionCheckoutCubit, SubscriptionCheckoutState>(
          listener: (context, state) async {
            if (state.networkStatusEnum == NetworkStatusEnum.loaded &&
                state.editProfile.statusCode == 200) {
           
              if (state.editProfile.gateway == 'Juspay') {
                final payload = state.editProfile.session?.sdkPayload;
                await jusPayment(context, payload);
              }

              
              else {
                final paymentRepo = PaymentRepository();

                paymentRepo.init(
                  onExternalWallet: (ExternalWalletResponse) {},
                  onSuccess: (paymentId) {
                    _paymentSuccess(
                      orderId: paymentId.orderId,
                      paymentId: paymentId.paymentId,
                      signature: paymentId.signature,
                    );
                    showAppToast(message: "Payment Success");
                  },
                  onError: (response) {
                    setState(() {
                      loading = false;
                    });
                    setState(() => isLoading = false);
                    showAppToast(message: "Payment Failed");
                  },
                );

                paymentRepo.openCheckout(
                  key: state.editProfile.key ?? '',
                  amount: ((selectedplanPrice ?? 0) * 100)
                      .toInt(), // Razorpay format
                  name: "Subscription Payment",
                  description: "Subscription purchase",
                  orderId: state.editProfile.orderId,
                  email: "seller@example.com",
                );
              }
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: CustomAppBar(title: "Subscription"),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SubTitleText(title: "Active Plan"),
              SizedBox(height: 20),
              _activeCard(),
              SizedBox(height: 20),
              SubTitleText(title: "Available Subscriptions"),
              SizedBox(height: 12),
              ...otherPlans.map((plan) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _subscriptionCard(
                    id: plan.id ?? "",
                    title: plan.name ?? "--",
                    duration: "${plan.durationCount} Days",
                    price: "${plan.price}",
                    description: plan.description ?? "--",
                    isActive: false,
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  /// ---------------- ACTIVE PLAN CARD -----------
  Widget _activeCard() {
    final plan = widget.data;

    if (plan == null) return SizedBox();

    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(12),
      shadowColor: Colors.black.withOpacity(0.2),
      child: Container(
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.workspace_premium_outlined,
                      color: Colors.white,
                      size: 30.sp,
                    ),
                    SizedBox(width: 8),
                    HeadlineText(
                      title: plan.subscriptionName ?? "—",
                      textColor: Colors.white,
                    ),
                  ],
                ),
                HeadlineText(
                  title: "₹${plan.subscriptionPrice ?? '--'}",
                  textColor: Colors.white,
                ),
              ],
            ),
            SizedBox(height: 6),
            Text(
              "Duration : ${plan.subscriptionDuration ?? '--'}",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 6),
            Text(
              "Start : ${DateFormat('dd MMM yyyy').format(DateTime.parse('${plan.startDate}'))}",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600),
            ),
            Text(
              "End : ${DateFormat('dd MMM yyyy').format(DateTime.parse('${plan.endDate}'))}",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  /// ---------------- SUBSCRIPTION CARDS -----------------
  Widget _subscriptionCard({
    required String id,
    required String title,
    required String duration,
    required String price,
    required String description,
    required bool isActive,
  }) {
    final isExpanded = expandedCard[id] ?? false;

    return Material(
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.2),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.article, color: Colors.green),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title.toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            _detailItem("Duration", duration),
            SizedBox(height: 6),
            _detailItem("Price", "₹$price"),
            SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                setState(() {
                  expandedCard[id] = !isExpanded;
                });
              },
              child: Text(
                isExpanded ? "Show Less" : "Show More",
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
            if (isExpanded)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(description),
              ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: CustomOutlineButton(
                title: 'Activate',
                onPressed: () {
                  _checkout(subsId: id, subsPrice: double.tryParse(price));
                },
                icon: Icons.workspace_premium_outlined,
                iconSize: 22.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailItem(String title, String value) {
    return Row(
      children: [
        Text("$title : ", style: TextStyle(fontWeight: FontWeight.w500)),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
