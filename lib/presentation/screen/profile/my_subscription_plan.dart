import 'package:bringessesellerapp/config/themes.dart';
import 'package:bringessesellerapp/model/request/my_subs_res_model.dart';
import 'package:bringessesellerapp/model/response/subription_defaults_response_model.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/subscription_default_cubit.dart';
import 'package:bringessesellerapp/presentation/widget/custome_appbar.dart';
import 'package:bringessesellerapp/presentation/widget/headline_text.dart';
import 'package:bringessesellerapp/presentation/widget/sub_title.dart';
import 'package:bringessesellerapp/presentation/widget/title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class SubscriptionListScreen extends StatefulWidget {
  final MySubscriptionResult? data;
  const SubscriptionListScreen({super.key, this.data});

  @override
  State<SubscriptionListScreen> createState() => _SubscriptionListScreenState();
}

class _SubscriptionListScreenState extends State<SubscriptionListScreen> {
  List<SubscriptionModel> otherPlans = [];
  Map<String, bool> expandedCard = {}; // Track showMore state per card

  @override
  void initState() {
    super.initState();
    loadPlans();
  }

  loadPlans() {
    final subscriptionState =
        context.read<SubscriptionDefaultCubit>().state.viewProfile;

    otherPlans = subscriptionState.result ?? [];

    // Remove active plan from this list as it is shown above separately
    final activeId = widget.data?.subscriptionPlan!.id;
    if (activeId != null) {
      otherPlans.removeWhere((plan) => plan.id == activeId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

            /// 🔥 Loop API plans dynamically
            ...otherPlans.map((plan) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _subscriptionCard(
                  id: plan.id ?? "",
                  title: plan.name ?? "--",
                  duration: "${plan.durationCount} Days",
                  freeCalls: "${plan.price}",
                  description: plan.description ?? "--",
                  isActive: false,
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

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

  Widget _subscriptionCard({
    required String id,
    required String title,
    required String duration,
    required String freeCalls,
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
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            _detailItem("Duration", duration),
            SizedBox(height: 6),
            _detailItem("Price", "₹$freeCalls"),
            SizedBox(height: 12),

            // Show more toggle
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

            if (isActive) ...[
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.emoji_events, color: Colors.green, size: 18),
                      SizedBox(width: 6),
                      Text("Active ⚡",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ]
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
