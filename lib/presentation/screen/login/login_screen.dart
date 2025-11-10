import 'dart:developer';
import 'dart:io';

import 'package:bringessesellerapp/config/constant/contsant.dart';
import 'package:bringessesellerapp/config/constant/sharedpreference_helper.dart';
import 'package:bringessesellerapp/config/themes.dart';
import 'package:bringessesellerapp/model/request/login_req_model.dart';
import 'package:bringessesellerapp/presentation/screen/login/bloc/login_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/login/bloc/login_state.dart';
import 'package:bringessesellerapp/presentation/widget/custome_appbar.dart';
import 'package:bringessesellerapp/presentation/widget/custome_button.dart';
import 'package:bringessesellerapp/presentation/widget/custome_textfeild.dart';
import 'package:bringessesellerapp/presentation/widget/sub_title.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late SharedPreferenceHelper sharedPreferenceHelper;
  @override
  void initState() {
    super.initState();
    sharedPreferenceHelper = SharedPreferenceHelper();
    sharedPreferenceHelper.init();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> _getDeviceDetails() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String? deviceId;
    int deviceType = Platform.isAndroid ? 1 : 0;

    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor;
      }
    } catch (e) {
      deviceId = "unknown_device";
    }

    String? fcmToken = await FirebaseMessaging.instance.getToken();

    return {
      "deviceId": deviceId,
      "deviceType": deviceType,
      "deviceToken": fcmToken,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        appBar: const CustomAppBar(title: "Login"),
        body: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) async {
            print("${state}");

            if (state.networkStatusEnum == NetworkStatusEnum.loaded &&
                state.login.status == 'true') {
              ///  log("sdkfnsj${state.login.result.}");
              sharedPreferenceHelper.saveSellerId(state.login.result?.sellerId);
              sharedPreferenceHelper.saveToken(state.login.result!.accessToken);
              sharedPreferenceHelper
                  .saveRefreshToken(state.login.result!.refreshToken);
              sharedPreferenceHelper.saveStoreId(state.login.result!.storeId);
              sharedPreferenceHelper
                  .saveCategoryId(state.login.result!.categoryId);
              String sellerId = sharedPreferenceHelper.getSellerId;

              print('user id----${sellerId}');
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('login_seen', true);
              await prefs.setBool('onboard_seen', true);
              Fluttertoast.showToast(
                msg: state.login.message ?? "Successfully login",
                toastLength: Toast.LENGTH_SHORT,
              );

              context.go('/dashboard');
            } else if (state.networkStatusEnum == NetworkStatusEnum.loaded &&
                state.login.status != 'true') {
              print("aldn");
              SnackBar(content: Text("${state.login.message}"));
            } else if (state.networkStatusEnum == NetworkStatusEnum.failed &&
                state.login.status == 'true') {
              print("daflhnjldf");
            } else if (state.networkStatusEnum == NetworkStatusEnum.failed &&
                state.login.status == "false") {
              Fluttertoast.showToast(
                msg: state.login.message ?? "",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
              );
            } else if (state.networkStatusEnum == NetworkStatusEnum.loading) {
              log("${state.login}");
              // Fluttertoast.showToast(
              //   msg: "ConnectionTimeout",
              //   backgroundColor: Colors.green,
              //   textColor: Colors.white,
              //   toastLength: Toast.LENGTH_SHORT,
              // );
            }
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(15.r),
                    margin: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: theme.cardColor,
                      boxShadow: [
                        BoxShadow(
                          color: theme.highlightColor,
                          blurRadius: 1,
                          spreadRadius: 0,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SubTitleText(title: "Email"),
                        CustomTextField(
                          controller: _emailController,
                          hintText: "Enter your Email",
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email_outlined,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email is required";
                            } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return "Enter a valid email address";
                            }
                            return null;
                          },
                        ),
                        vericalSpaceSmall,
                        const SubTitleText(title: "Password"),
                        CustomTextField(
                          controller: _passwordController,
                          hintText: "Enter your Password",
                          // labelText: "Password",
                          isPassword: true,
                          prefixIcon: Icons.lock_outline,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password is required";
                            } else if (value.length < 6) {
                              return "Password must be at least 6 characters";
                            }
                            return null;
                          },
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SubTitleText(
                              title: "Forgot password?",
                              textColor: AppTheme.primaryColor,
                            ),
                          ],
                        ),
                        verticalSpaceDynamic(180.w),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: "Haven't an account? ",
                                    style: theme.textTheme.titleMedium!
                                        .copyWith(fontSize: 16.sp)),
                                TextSpan(
                                  text: 'Signup',
                                  style: theme.textTheme.titleMedium!.copyWith(
                                    fontSize: 16.sp,
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      context.push('/register');
                                    },
                                )
                              ]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: SafeArea(
          bottom: true,
          maintainBottomViewPadding: true,
          minimum: EdgeInsets.symmetric(horizontal: 10.w, vertical: 50.w),
          child: Container(
            child: CustomButton(
              title: "Login",
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final deviceData = await _getDeviceDetails();

                  context.read<LoginCubit>().login(LoginRequestModel(
                        email: _emailController.text,
                        password: _passwordController.text,
                        deviceId: deviceData["deviceId"],
                        deviceType: deviceData["deviceType"],
                        deviceToken: deviceData["deviceToken"],
                      ));
                }
              },
              icon: Icons.arrow_forward_ios_rounded,
            ),
          ),
        ));
  }
}
