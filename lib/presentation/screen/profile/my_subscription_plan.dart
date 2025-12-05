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
import 'package:bringessesellerapp/presentation/widget/title_text.dart';

import 'package:bringessesellerapp/utils/enums.dart';
import 'package:bringessesellerapp/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hypersdkflutter/hypersdkflutter.dart';
import 'package:intl/intl.dart';

import '../../../model/response/subcription_checkout_response.dart';

class SubscriptionListScreen extends StatefulWidget {
  final String? contact;
  final MySubscriptionResult? data;
  const SubscriptionListScreen({super.key, this.data, this.contact});

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
              } else {
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
                print("dkgfjhu${widget.contact}");
                paymentRepo.openCheckout(
                  contact: widget.contact,
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

  Widget _activeCard() {
    final plan = widget.data;
    print('plandetail:$plan');
    if (plan == null) return noActivePlanCard();

    return activePlanCard(plan: plan);
  }

  Widget activePlanCard({MySubscriptionResult? plan}) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF6A4FFC),
            Color(0xFF7B4DF0),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current Plan Chip
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "CURRENT PLAN",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
          SizedBox(height: 12),

          // Title show plan name
          Text(
            plan!.subscriptionPlan!.name ?? "Your Plan",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 6),

          // Subtitle - expiry or description
          Text(
            "Active until ${DateFormat('dd MMM yyyy').format(DateTime.parse(plan.endDate.toString()))}", // or your field
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),

          SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Price
              Text(
                "₹${plan.subscriptionPrice}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.white,
              //     foregroundColor: Color(0xFF6A4FFC),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(30),
              //     ),
              //   ),
              //   onPressed: () {
              //     // open plan management
              //   },
              //   child: Text("Manage"),
              // )
            ],
          ),
        ],
      ),
    );
  }

  Widget noActivePlanCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF6A4FFC),
            Color(0xFF7B4DF0),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current Plan Chip
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "CURRENT PLAN",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
          SizedBox(height: 12),

          // Title
          Text(
            "No plan active",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 6),

          // Subtitle
          Text(
            "You don't have an active subscription.",
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),

          SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Price
              Text(
                "₹0/month",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // See Plans Button
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  // Open your plan screen
                },
                child: Text(
                  "See pricing plans",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
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
