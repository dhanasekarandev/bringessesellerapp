import 'dart:developer';

import 'package:bringessesellerapp/config/constant/sharedpreference_helper.dart';

import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/dashboard_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/dashboard_state.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/menu_screen.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/product_screen.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/review_screen.dart';
import 'package:bringessesellerapp/presentation/screen/home/invite_ref.dart';
import 'package:bringessesellerapp/presentation/screen/home/order_screen.dart';
import 'package:bringessesellerapp/presentation/screen/onboarding/revenue_list.dart';

import 'package:bringessesellerapp/presentation/screen/profile/bloc/view_profile_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/view_profile_state.dart';
import 'package:bringessesellerapp/presentation/screen/shop/bloc/get_store_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/shop/bloc/get_store_state.dart';
import 'package:bringessesellerapp/presentation/widget/custom_card.dart';
import 'package:bringessesellerapp/presentation/widget/custome_appbar.dart';
import 'package:bringessesellerapp/presentation/widget/custome_listile.dart';
import 'package:bringessesellerapp/presentation/widget/graph_widget.dart';

import 'package:bringessesellerapp/presentation/widget/payment_detail_card.dart';
import 'package:bringessesellerapp/presentation/widget/sub_title.dart';
import 'package:bringessesellerapp/presentation/widget/title_text.dart';
import 'package:bringessesellerapp/presentation/widget/toast_widget.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _storeSwitch = true;
  Timer? _paymentStatusTimer;
  late SharedPreferenceHelper sharedPreferenceHelper;

  @override
  void initState() {
    super.initState();
    sharedPreferenceHelper = SharedPreferenceHelper();
    sharedPreferenceHelper.init();
    _loadDashboard();
    _startPaymentStatusCheck();
  }

  @override
  void dispose() {
    _paymentStatusTimer?.cancel();
    super.dispose();
  }

  void _loadDashboard() {
    // if()

    context.read<ViewProfileCubit>().login();
    loadStore();
  }

  loadStore() {
    if (sharedPreferenceHelper.getStoreId != 'err') {
      context.read<GetStoreCubit>().login();
      context.read<DashboardCubit>().login();
    }
  }

  void _startPaymentStatusCheck() {
    _paymentStatusTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) {
        context.read<ViewProfileCubit>().login();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final token = sharedPreferenceHelper.getRefreshToken;
    log("sdjfbs$token");
    return MultiBlocListener(
      listeners: [
        // ✅ GetStoreCubit Listener
        BlocListener<GetStoreCubit, GetStoreState>(
          listener: (context, state) {
            if (state.networkStatusEnum == NetworkStatusEnum.loaded &&
                state.getStoreModel.status == 'true') {
              final data = state.getStoreModel.result;
              sharedPreferenceHelper.saveStoreId(data?.storeId);
              sharedPreferenceHelper.saveCategoryId(data?.categoryId);
              sharedPreferenceHelper.saveCategoryName(data?.categoryName);
            }
          },
        ),

        // ✅ DashboardCubit Listener
        BlocListener<DashboardCubit, DashboardState>(
          listener: (context, state) {
            if (state.networkStatusEnum == NetworkStatusEnum.failed) {
              ToastWidget(
                message: "Failed to load dashboard",
                color: Colors.red,
              ).build(context);
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Dashboard",
          showLeading: false,
          actions: [
            InkWell(
                onTap: () {
                  print(
                      'sjkldghbslj${context.read<ViewProfileCubit>().state.viewProfile.result!.referralCode}');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InviteReferre(
                          refId: context
                              .read<ViewProfileCubit>()
                              .state
                              .viewProfile
                              .result!
                              .referralCode,
                        ),
                      ));
                },
                child: Icon(Icons.ios_share_outlined)),
            InkWell(
              onTap: () => context.push("/profile"),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  height: 30.h,
                  width: 30.h,
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    //  color: AppTheme.whiteColor,
                  ),
                  child: const Icon(Icons.person_2_outlined),
                ),
              ),
            ),
          ],
        ),

        /// 🔹 Main Body
        body: BlocBuilder<ViewProfileCubit, ViewProfileState>(
          builder: (context, viewProfileState) {
            if (NetworkStatusEnum.failed ==
                viewProfileState.networkStatusEnum) {
              print("sfjbs");
            }
            print("sdkfhbsk${viewProfileState}");
            final isPaymentDone = viewProfileState
                    .viewProfile.result?.paymentStatus
                    ?.toString()
                    .toLowerCase() ==
                'true';

            // 🔸 Only show loader for very first time
            if (viewProfileState.networkStatusEnum ==
                    NetworkStatusEnum.loading &&
                viewProfileState.viewProfile.result == null) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!isPaymentDone) {
              return const Center(child: PaymentDetailsCard());
            }

            // 🔸 Build dashboard only after payment verified
            return BlocBuilder<DashboardCubit, DashboardState>(
              builder: (context, dashboardState) {
                if (dashboardState.networkStatusEnum ==
                        NetworkStatusEnum.loading &&
                    dashboardState.dashboardModel.status == "false") {
                  return const Center(child: CircularProgressIndicator());
                }

                if (dashboardState.networkStatusEnum ==
                    NetworkStatusEnum.failed) {
                  return const Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [Text("We are under maintanance")],
                  ));
                }

                final model = dashboardState.dashboardModel;
                if (model.status != 'true') {
                  return const Center(child: Text("No data found"));
                }

                return SingleChildScrollView(
                  padding: EdgeInsets.all(8.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Shop Status
                      CustomCard(
                        margin: EdgeInsets.all(5.w),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SubTitleText(title: "Shop Status"),
                                TitleText(
                                    title: _storeSwitch ? "Open" : "Closed"),
                              ],
                            ),
                            const Spacer(),
                            Switch(
                              value: _storeSwitch,
                              onChanged: (value) {
                                setState(() => _storeSwitch = value);
                              },
                            ),
                          ],
                        ),
                      ),

                      CustomCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SubTitleText(title: "Total orders"),
                            TitleText(title: "${model.totalOrders ?? '0'}"),
                            CustomListTile(
                              leadingIcon: Icons.check_circle_outline,
                              title: "${model.successfulOrders ?? '0'}",
                              subtitle: "Successful orders",
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const OrderScreen(
                                        from: 'dash',
                                      ),
                                    ));
                              },
                              child: CustomListTile(
                                leadingIcon: Icons.pending_actions_outlined,
                                title: "${model.unSuccessfulOrders ?? '0'}",
                                subtitle: "Pending orders",
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Revenue
                      SizedBox(
                        width: double.infinity,
                        child: CustomCard(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RevenueScreen(),
                                ));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SubTitleText(title: "Total Revenue"),
                              TitleText(title: "${model.totalRevenue ?? '0'}"),
                            ],
                          ),
                        ),
                      ),

                      const CustomCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SubTitleText(title: "Revenue Graph"),
                            TitleText(title: " 0.0"),
                            SalesGraph(),
                          ],
                        ),
                      ),

                      CustomCard(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const MenuScreen()),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SubTitleText(title: "Menu Section"),
                            CustomListTile(
                              leadingIcon: Icons.restaurant_menu,
                              title: "Menu",
                              subtitle: "${model.totalMenus ?? '0'}",
                            ),
                          ],
                        ),
                      ),

                      CustomCard(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ProductScreen()),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SubTitleText(title: "Product Section"),
                            CustomListTile(
                              leadingIcon: Icons.shopping_bag_outlined,
                              title: "Product",
                              subtitle: "${model.totalItems ?? '0'}",
                            ),
                          ],
                        ),
                      ),

                      CustomCard(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ShopCustomerReviewsScreen(),
                              ));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SubTitleText(title: "Review Section"),
                            CustomListTile(
                              leadingIcon: Icons.reviews_outlined,
                              title: "Review",
                              subtitle: "${model.totalReviews ?? '0'}",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
