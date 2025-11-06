import 'package:bringessesellerapp/presentation/screen/banner/add_banner.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/add_menu.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/add_product.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/menu_screen.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/product_details.dart';
import 'package:bringessesellerapp/presentation/screen/home/bottom_layout.dart';
import 'package:bringessesellerapp/presentation/screen/home/notfication_screen.dart';
import 'package:bringessesellerapp/presentation/screen/home/promotion.dart';
import 'package:bringessesellerapp/presentation/screen/home/shop_screen.dart';
import 'package:bringessesellerapp/presentation/screen/login/login_screen.dart';
import 'package:bringessesellerapp/presentation/screen/onboarding/onboarding.dart';
import 'package:bringessesellerapp/presentation/screen/onboarding/welcome.dart';
import 'package:bringessesellerapp/presentation/screen/profile/change_pasword_screen.dart';
import 'package:bringessesellerapp/presentation/screen/profile/payout_prefs.dart';
import 'package:bringessesellerapp/presentation/screen/profile/profile_screen.dart';
import 'package:bringessesellerapp/presentation/screen/profile/subcription_screen.dart';
import 'package:bringessesellerapp/presentation/screen/register/approval_screen.dart';
import 'package:bringessesellerapp/presentation/screen/register/register_screen.dart';
import 'package:bringessesellerapp/presentation/screen/onboarding/splash.dart';
import 'package:bringessesellerapp/presentation/screen/home/dashboard_screen.dart';

import 'package:bringessesellerapp/presentation/screen/home/order_screen.dart';
import 'package:bringessesellerapp/presentation/widget/map_widget.dart';

import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnBordingScreen(),
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/approve',
      builder: (context, state) => const WaitingApprovalScreen(),
    ),
    GoRoute(
      path: '/map',
      builder: (context, state) => const FullMapScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => BottomNavBar(child: child),
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
            path: '/promotion',
            builder: (context, state) => const PromotionScreen(),
            routes: [
              GoRoute(
                path: 'addbanner',
                builder: (context, state) => const AddBannerScreen(),
              ),
            ]),
        GoRoute(
          path: '/orders',
          builder: (context, state) => const OrderScreen(),
        ),
        GoRoute(
          path: '/notification',
          builder: (context, state) => const NotficationScreen(),
        ),
        GoRoute(
          path: '/store',
          builder: (context, state) => const ShopScreen(),
        ),
      ],
    ),
    GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
        routes: [
          GoRoute(
            path: '/changepassword',
            builder: (context, state) => const ChangePaswordScreen(),
          ),
          GoRoute(
            path: '/account',
            builder: (context, state) => const PayoutPrefsScreen(),
          ),
          GoRoute(
            path: '/subs',
            builder: (context, state) {
              var args = state.extra as Map;
              return SubcriptionScreen(
                data: args['subs'],
              );
            },
          ),
        ]),
    GoRoute(
        path: '/menu',
        builder: (context, state) => const MenuScreen(),
        routes: [
          GoRoute(
            path: 'addmenu',
            builder: (context, state) {
              var args = state.extra as Map;
              return AddMenuScreen(
                catogery: args['category'],
                storeId: args['storeId'],
              );
            },
          ),
        ]),
    GoRoute(
        path: '/products',
        builder: (context, state) => const MenuScreen(),
        routes: [
          GoRoute(
            path: 'add',
            builder: (context, state) {
              var args = state.extra as Map;
              return AddProductScreen(
                catname: args['catname'],
                menuList: args['menu'],
                units: args['units'],
                storeId: args['storeId'],
                sellerId: args['sellerId'],
                editProduct : args['edit'],
                subcat:  args['subcat'],
              );
            },
          ),
          GoRoute(
            path: 'details',
            builder: (context, state) {
              var args = state.extra as Map;
              return ProductDetailsScreen(product: args['product']);
            },
          )
        ]),
  ],
);
