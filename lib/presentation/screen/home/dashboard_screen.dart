import 'package:bringessesellerapp/config/constant/sharedpreference_helper.dart';
import 'package:bringessesellerapp/config/themes.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/dashboard_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/dashboard_state.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/menu_screen.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/product_screen.dart';

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
    context.read<GetStoreCubit>().login();

    context.read<DashboardCubit>().login();

    context.read<ViewProfileCubit>().login();
  }

  void _startPaymentStatusCheck() {
    _paymentStatusTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (mounted) {
        context.read<ViewProfileCubit>().login();
      }
    });
  }

  int? totalOrder;
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<GetStoreCubit, GetStoreState>(
          listener: (context, state) {
            if (state.networkStatusEnum == NetworkStatusEnum.loaded) {
              if (state.getStoreModel.status == 'true') {
                final data = state.getStoreModel.result;
                sharedPreferenceHelper
                    .saveStoreId(state.getStoreModel.result?.storeId);
                sharedPreferenceHelper
                    .saveCategoryId(state.getStoreModel.result?.categoryId);
                sharedPreferenceHelper
                    .saveCategoryName(state.getStoreModel.result?.categoryName);
              }
            }
          },
        ),
        BlocListener<DashboardCubit, DashboardState>(
          listener: (context, state) {
            if (state.networkStatusEnum == NetworkStatusEnum.loaded) {
              if (state.dashboardModel.status == 'true') {
                totalOrder = state.dashboardModel.totalOrders;

                // ToastWidget(
                //   message: "Data Retrieved",
                //   color: Colors.green,
                // ).build(context);
              } else {
                ToastWidget(
                  message: "Something went wrong",
                  color: Colors.red,
                ).build(context);
              }
            }
            // else if (state.networkStatusEnum == NetworkStatusEnum.failed) {
            //   ToastWidget(
            //     message: "Network error",
            //     color: Colors.red,
            //   ).build(context);
            // }
          },
        ),
        BlocListener<ViewProfileCubit, ViewProfileState>(
          listener: (context, state) {},
        ),
      ],
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Dashboard",
          showLeading: false,
          actions: [
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
                    color: AppTheme.whiteColor,
                  ),
                  child: const Icon(Icons.person_2_outlined),
                ),
              ),
            ),
          ],
        ),
        body: BlocBuilder<ViewProfileCubit, ViewProfileState>(
          builder: (context, viewProfileState) {
            bool shouldShowPaymentCard = false;

            if (viewProfileState.networkStatusEnum ==
                NetworkStatusEnum.loading) {
              // Optional: show loader instead of card while refreshing
              return const Center(child: CircularProgressIndicator());
            }

            if (viewProfileState.networkStatusEnum ==
                    NetworkStatusEnum.loaded &&
                viewProfileState.viewProfile.status == 'true' &&
                viewProfileState.viewProfile.result != null) {
              final paymentStatus = viewProfileState
                      .viewProfile.result!.paymentStatus
                      ?.toString()
                      .toLowerCase() ??
                  'false';

              // ✅ Show card only if paymentStatus is not true
              shouldShowPaymentCard = paymentStatus != 'true';
            } else if (viewProfileState.networkStatusEnum ==
                NetworkStatusEnum.failed) {
              shouldShowPaymentCard = true; // show card on error
            }

            if (shouldShowPaymentCard) {
              return const Center(
                child: PaymentDetailsCard(),
              );
            }

            return BlocBuilder<DashboardCubit, DashboardState>(
              builder: (context, state) {
                if (state.networkStatusEnum == NetworkStatusEnum.loaded &&
                    state.dashboardModel.status == 'true') {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomCard(
                          margin: EdgeInsets.all(5.w),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SubTitleText(title: "Shop Status"),
                                  TitleText(
                                    title: _storeSwitch ? "Open" : "Closed",
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Switch(
                                value: _storeSwitch,
                                onChanged: (value) {
                                  setState(() {
                                    _storeSwitch = value;
                                  });

                                  context.read<ViewProfileCubit>().login();
                                },
                              ),
                            ],
                          ),
                        ),

                        /// Orders card
                        CustomCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SubTitleText(title: "Total orders"),
                              TitleText(
                                  title:
                                      "${state.dashboardModel.totalOrders ?? "0"}"),
                              CustomListTile(
                                leadingIcon: Icons.bookmark_border_outlined,
                                title:
                                    "${state.dashboardModel.successfulOrders ?? '0'}",
                                subtitle: "Successful orders",
                              ),
                              CustomListTile(
                                leadingIcon: Icons.bookmark_border_outlined,
                                title:
                                    "${state.dashboardModel.unSuccessfulOrders ?? '0'}",
                                subtitle: "Pending orders",
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          width: double.infinity,
                          child: CustomCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SubTitleText(title: "Total Revenue"),
                                TitleText(
                                    title:
                                        "${state.dashboardModel.totalRevenue ?? ''}"),
                              ],
                            ),
                          ),
                        ),

                        const CustomCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SubTitleText(title: "Revenue graph"),
                              TitleText(title: "\$ 0.0"),
                              SalesGraph(),
                            ],
                          ),
                        ),

                        const CustomCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SubTitleText(title: "Total graph"),
                              TitleText(title: "\$ 0.0"),
                              SalesGraph(),
                            ],
                          ),
                        ),

                        CustomCard(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MenuScreen()),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SubTitleText(title: "Menu section"),
                              CustomListTile(
                                leadingIcon: Icons.bookmark_border_outlined,
                                title: "Menu",
                                subtitle: "${state.dashboardModel.totalMenus}",
                              ),
                            ],
                          ),
                        ),

                        CustomCard(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ProductScreen()),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SubTitleText(title: "Product section"),
                              CustomListTile(
                                leadingIcon: Icons.bookmark_border_outlined,
                                title: "Product",
                                subtitle: "${state.dashboardModel.totalItems}",
                              ),
                            ],
                          ),
                        ),

                        CustomCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SubTitleText(title: "Review section"),
                              CustomListTile(
                                leadingIcon: Icons.bookmark_border_outlined,
                                title: "Review",
                                subtitle:
                                    "${state.dashboardModel.totalReviews}",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  CircularProgressIndicator();
                }
                if (state.dashboardModel.paymentStatus != "false") {
                  return PaymentDetailsCard();
                }
                return CircularProgressIndicator();
              },
            );
          },
        ),
      ),
    );
  }
}
