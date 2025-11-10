import 'package:bringessesellerapp/config/constant/sharedpreference_helper.dart';
import 'package:bringessesellerapp/presentation/screen/home/dashboard_screen.dart';
import 'package:bringessesellerapp/presentation/screen/home/notfication_screen.dart';
import 'package:bringessesellerapp/presentation/screen/home/order_screen.dart';
import 'package:bringessesellerapp/presentation/screen/home/promotion.dart';
import 'package:bringessesellerapp/presentation/screen/home/shop_screen.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/view_profile_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/view_profile_state.dart';
import 'package:bringessesellerapp/presentation/widget/toast_widget.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bringessesellerapp/config/themes.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatefulWidget {
  final Widget child;
  const BottomNavBar({super.key, required this.child});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  late SharedPreferenceHelper sharedPreferenceHelper;
  @override
  void initState() {
    sharedPreferenceHelper = SharedPreferenceHelper();
    sharedPreferenceHelper.init();
    context.read<ViewProfileCubit>().login();
    super.initState();
  }

  final List<String> _routes = [
    '/dashboard',
    '/promotion',
    '/orders',
    '/notification',
    '/store',
  ];

  void _onItemTapped(int index, BuildContext context) {
    // Check if payment status is not 'true' and user is trying to access restricted pages
    if (paymentStatus != 'true') {
      // Restrict access to Orders (index 2) and Shop/Store (index 4) when payment is not verified
      if (index == 2 || index == 4) {
        Fluttertoast.showToast(
          msg: "Add payment to activate your account",
          backgroundColor: Colors.white,
          textColor: Colors.black,
          toastLength: Toast.LENGTH_SHORT,
        );
        return;
      }
    }

    setState(() => _selectedIndex = index);
    context.go(_routes[index]);
  }

  String? paymentStatus;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ViewProfileCubit, ViewProfileState>(
        listener: (context, state) {
          if (state.networkStatusEnum == NetworkStatusEnum.loaded) {
            if (state.viewProfile.status == 'true') {
              paymentStatus = state.viewProfile.result!.paymentStatus;
            } else {}
          } else if (state.networkStatusEnum == NetworkStatusEnum.failed) {
            // ToastWidget(
            //   message: "Network error while updating profile",
            //   color: Colors.red,
            // ).build(context);
          }
        },
        builder: (context, state) {
          return _getBody();
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 6.h),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).focusColor,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => _onItemTapped(index, context),
          backgroundColor: Theme.of(context).cardColor,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: AppTheme.primaryColor,
          unselectedItemColor: AppTheme.graycolor,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/dashboards.png',
                height: 20.h,
                color: AppTheme.graycolor,
              ),
              activeIcon: Image.asset(
                'assets/icons/dashboards (1).png',
                height: 20.h,
                color: AppTheme.primaryColor,
              ),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/promotion.png',
                height: 22.h,
                color: AppTheme.graycolor,
              ),
              activeIcon: Image.asset(
                'assets/icons/marketing (1).png',
                height: 22.h,
                color: AppTheme.primaryColor,
              ),
              label: 'Promotion',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/box.png',
                height: 22.h,
                color: paymentStatus != 'true'
                    ? AppTheme.graycolor.withOpacity(0.5)
                    : AppTheme.graycolor,
              ),
              activeIcon: Image.asset(
                height: 18.h,
                'assets/icons/box (1).png',
                color: paymentStatus != 'true'
                    ? AppTheme.graycolor.withOpacity(0.5)
                    : AppTheme.primaryColor,
              ),
              label: 'Order',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.notifications_none,
                size: 25.sp,
              ),
              activeIcon: Icon(
                Icons.notifications,
                size: 25.sp,
              ),
              label: 'Notification',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.store_outlined,
                color: paymentStatus != 'true'
                    ? AppTheme.graycolor.withOpacity(0.5)
                    : null,
              ),
              activeIcon: Icon(
                Icons.store,
                color: paymentStatus != 'true'
                    ? AppTheme.graycolor.withOpacity(0.5)
                    : null,
              ),
              label: 'Store',
            ),
          ],
        ),
      ),
    );
  }

  Widget _getBody() {
    // Check if current page is restricted and payment status is not verified
    if (paymentStatus != 'true' &&
        (_selectedIndex == 2 || _selectedIndex == 4)) {
      // Show dashboard instead of restricted pages (Orders and Shop/Store)
      return const DashboardScreen();
    }

    switch (_selectedIndex) {
      case 0:
        return const DashboardScreen();
      case 1:
        return const PromotionScreen();
      case 2:
        return const OrderScreen();
      case 3:
        return const NotficationScreen();
      case 4:
        return const ShopScreen();
      default:
        return const DashboardScreen();
    }
  }
}
