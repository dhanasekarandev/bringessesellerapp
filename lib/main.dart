import 'package:bringessesellerapp/config/constant/api_constant.dart';
import 'package:bringessesellerapp/config/constant/sharedpreference_helper.dart';
import 'package:bringessesellerapp/config/constant/themecubit/theme_cubit.dart';
import 'package:bringessesellerapp/config/themes.dart';
import 'package:bringessesellerapp/presentation/repository/auth_repo.dart';
import 'package:bringessesellerapp/presentation/screen/banner/bloc/delete_banner_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/banner/bloc/promotion_before_data_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/banner/bloc/promotion_checkout_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/banner/bloc/promotion_create_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/banner/bloc/promotion_transction_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/banner/bloc/view_promotion_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/dashboard_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/delete_menu_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/delete_product_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/menu_category_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/menu_create_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/menu_list_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/menu_update_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/product_by_id_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/product_category_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/product_create_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/product_list_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/product_update_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/home/bloc/notification_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/home/bloc/order_list_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/login/bloc/login_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/order_section/bloc/oder_list_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/change_password_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/coupon_create_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/edit_profile_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/get_account_detail_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/logout_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/payout_account_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/send_otp_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/subscription_checkout_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/subscription_default_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/verify_otp_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/view_profile_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/shop/bloc/get_store_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/shop/bloc/store_defaults_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/shop/bloc/store_upload_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/shop/bloc/update_store_cubit.dart';
import 'package:bringessesellerapp/presentation/service/api_service.dart';
import 'package:bringessesellerapp/presentation/service/notification_service.dart';

import 'package:bringessesellerapp/router/app_router.dart';
import 'package:bringessesellerapp/utils/app_lifecyle.dart';
import 'package:bringessesellerapp/utils/location_permission_helper.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAebIczLvdHI1zy2Vz11oMoed6Zme2pg7Y",
      appId: "1:989733009995:android:6a8a68c52af08bcb996bce",
      messagingSenderId: "989733009995",
      projectId: "bringessedeliverypartner",
      storageBucket: "bringessedeliverypartner.firebasestorage.app",
    ),
  );
  print("🔔 Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAebIczLvdHI1zy2Vz11oMoed6Zme2pg7Y",
      appId: "1:989733009995:android:6a8a68c52af08bcb996bce",
      messagingSenderId: "989733009995",
      projectId: "bringessedeliverypartner",
      storageBucket: "bringessedeliverypartner.firebasestorage.app",
    ),
  );

  WidgetsBinding.instance.addObserver(AppLifecycleObserver());
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await NotificationService().init();

  final RemoteConfigService remoteConfigService = RemoteConfigService();
  bool granted = await LocationPermissionHelper.isLocationGranted();
  if (!granted) {
    await LocationPermissionHelper.requestLocationPermission();
  }
  await remoteConfigService.init();

  runApp(MyApp(remoteConfigService: remoteConfigService));
}

class MyApp extends StatelessWidget {
  final RemoteConfigService remoteConfigService;

  MyApp({super.key, required this.remoteConfigService});

  @override
  Widget build(BuildContext context) {
    final SharedPreferenceHelper sharedPreferenceHelper =
        SharedPreferenceHelper();

    final Dio dio = Dio(BaseOptions(
      baseUrl: ApiConstant.baseUrl,
      responseType: ResponseType.json,
      receiveDataWhenStatusError: true,
      validateStatus: (_) => true,
      headers: {
        "Accept": "application/json",
      },
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));

    dio.interceptors.add(LoggerInterceptor());

    final ApiService apiService = ApiService(dio, sharedPreferenceHelper);
    final AuthRepository authRepository = AuthRepository(apiService);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => authRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LoginCubit>(
              create: (repoContext) =>
                  LoginCubit(authRepository: AuthRepository(apiService))),
          BlocProvider<ViewProfileCubit>(
              create: (repoContext) =>
                  ViewProfileCubit(authRepository: AuthRepository(apiService))),
          BlocProvider<EditProfileCubit>(
              create: (repoContext) =>
                  EditProfileCubit(authRepository: AuthRepository(apiService))),
          BlocProvider<DashboardCubit>(
              create: (repoContext) =>
                  DashboardCubit(authRepository: AuthRepository(apiService))),
          BlocProvider<ChangePasswordCubit>(
              create: (repoContext) => ChangePasswordCubit(
                  authRepository: AuthRepository(apiService))),
          BlocProvider<StoreDefaultsCubit>(
              create: (repoContext) => StoreDefaultsCubit(
                  authRepository: AuthRepository(apiService))),
          BlocProvider<NotificationCubit>(
              create: (repoContext) => NotificationCubit(
                  authRepository: AuthRepository(apiService))),
          BlocProvider<StoreUploadCubit>(
              create: (repoContext) =>
                  StoreUploadCubit(authRepository: AuthRepository(apiService))),
          BlocProvider<PayoutAccountCubit>(
              create: (repoContext) => PayoutAccountCubit(
                  authRepository: AuthRepository(apiService))),
          BlocProvider<GetStoreCubit>(
              create: (repoContext) =>
                  GetStoreCubit(authRepository: AuthRepository(apiService))),
          BlocProvider<UpdateStoreCubit>(
              create: (repoContext) =>
                  UpdateStoreCubit(authRepository: AuthRepository(apiService))),
          BlocProvider<GetAccountDetailCubit>(
              create: (repoContext) => GetAccountDetailCubit(
                  authRepository: AuthRepository(apiService))),
          BlocProvider<PromotionBeforeDataCubit>(
              create: (repoContext) => PromotionBeforeDataCubit(
                  authRepository: AuthRepository(apiService))),
          BlocProvider<GetMenuCategoryCubit>(
              create: (repoContext) => GetMenuCategoryCubit(
                  authRepository: AuthRepository(apiService))),
          BlocProvider<MenuCreateCubit>(
              create: (repoContext) =>
                  MenuCreateCubit(authRepository: AuthRepository(apiService))),
          BlocProvider<MenuListCubit>(
              create: (repoContext) =>
                  MenuListCubit(authRepository: AuthRepository(apiService))),
          BlocProvider<ProductCategoryCubit>(
              create: (repoContext) => ProductCategoryCubit(
                  authRepository: AuthRepository(apiService))),
          BlocProvider<ProductCreateCubit>(
              create: (repoContext) => ProductCreateCubit(
                  authRepository: AuthRepository(apiService))),
          BlocProvider<ProductListCubit>(
              create: (repoContext) =>
                  ProductListCubit(authRepository: AuthRepository(apiService))),
          BlocProvider<LogoutCubit>(
              create: (repoContext) =>
                  LogoutCubit(authRepository: AuthRepository(apiService))),
          BlocProvider<PromotionCreateCubit>(
              create: (repoContext) => PromotionCreateCubit(
                  authRepository: AuthRepository(apiService))),
          BlocProvider<PromotionCheckoutCubit>(
              create: (repoContext) => PromotionCheckoutCubit(
                  authRepository: AuthRepository(apiService))),
          BlocProvider<PromotionTransctionCubit>(
              create: (repoContext) => PromotionTransctionCubit(
                  authRepository: AuthRepository(apiService))),
          BlocProvider<ViewPromotionCubit>(
              create: (repoContext) => ViewPromotionCubit(
                  authRepository: AuthRepository(apiService))),
          BlocProvider<MenuUpdateCubit>(
              create: (repoContext) =>
                  MenuUpdateCubit(authRepository: AuthRepository(apiService))),
          BlocProvider<SubscriptionDefaultCubit>(
              create: (repoContext) => SubscriptionDefaultCubit(
                  authRepository: AuthRepository(apiService))),
          BlocProvider<PromotionDelete>(
              create: (repoContext) =>
                  PromotionDelete(authRepository: AuthRepository(apiService))),
          BlocProvider<SubscriptionCheckoutCubit>(
              create: (repoContext) => SubscriptionCheckoutCubit(
                  authRepository: AuthRepository(apiService))),
          BlocProvider<SendOtpCubit>(
              create: (repoContext) =>
                  SendOtpCubit(authRepository: AuthRepository(apiService))),
          BlocProvider<VerifyOtpCubit>(
              create: (repoContext) =>
                  VerifyOtpCubit(authRepository: AuthRepository(apiService))),
          BlocProvider<OderListCubit>(
              create: (repoContext) =>
                  OderListCubit(authRepository: AuthRepository(apiService))),
          BlocProvider<ProductByIdCubit>(
              create: (repoContext) =>
                  ProductByIdCubit(authRepository: AuthRepository(apiService))),
          BlocProvider<ProductUpdateCubit>(
              create: (repoContext) => ProductUpdateCubit(
                  authRepository: AuthRepository(apiService))),
          BlocProvider<DeleteProductCubit>(
              create: (repoContext) => DeleteProductCubit(
                  authRepository: AuthRepository(apiService))),
          BlocProvider<DeleteMenuCubit>(
              create: (repoContext) =>
                  DeleteMenuCubit(authRepository: AuthRepository(apiService))),
          BlocProvider<CouponCreateCubit>(
              create: (repoContext) => CouponCreateCubit(
                  authRepository: AuthRepository(apiService))),
          BlocProvider<ThemeCubit>(create: (repoContext) => ThemeCubit()),
        ],
        child: ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, themeMode) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: MaterialApp.router(
                    routerConfig: appRouter,
                    debugShowCheckedModeBanner: false,
                    theme: AppTheme.lightTheme,
                    darkTheme: AppTheme.darkTheme,
                    themeMode: themeMode,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  locationPermission() async {
    bool granted = await LocationPermissionHelper.isLocationGranted();
    if (!granted) {
      await LocationPermissionHelper.requestLocationPermission();
    }
  }
}

// ---------- Logger Interceptor ----------
class LoggerInterceptor extends Interceptor {
  Logger logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 75,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    final options = err.requestOptions;
    final requestPath = '${options.baseUrl}${options.path}';
    logger.e('${options.method} request => $requestPath');
    logger.d('Error: ${err.error}, Message: ${err.message}');
    return super.onError(err, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final requestPath = '${options.baseUrl}${options.path}';
    logger.i('${options.method} request => $requestPath');

    if (options.data is FormData) {
      final formData = options.data as FormData;
      for (final entry in formData.fields) {
        logger.d('Form field: ${entry.key} = ${entry.value}');
      }
    }
    logger.d('data request data', error: options.data);

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.d('StatusCode: ${response.statusCode}, Data: ${response.data}');
    return super.onResponse(response, handler);
  }
}

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> init() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    await _remoteConfig.fetchAndActivate();
  }

  bool isUpdateRequired(String currentVersion) {
    final latestVersion = _remoteConfig.getString('latest_version');
    final updateRequired = _remoteConfig.getBool('update_required');

    if (!updateRequired) return false;
    return _isVersionNewer(latestVersion, currentVersion);
  }

  String get updateMessage => _remoteConfig.getString('update_message');
  String get updateUrl => _remoteConfig.getString('update_url');

  bool _isVersionNewer(String remote, String local) {
    List<int> r = remote.split('.').map(int.parse).toList();
    List<int> l = local.split('.').map(int.parse).toList();
    for (int i = 0; i < r.length; i++) {
      if (i >= l.length || r[i] > l[i]) return true;
      if (r[i] < l[i]) return false;
    }
    return false;
  }
}
