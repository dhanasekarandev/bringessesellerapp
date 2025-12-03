import 'package:bringessesellerapp/config/constant/contsant.dart';
import 'package:bringessesellerapp/config/constant/sharedpreference_helper.dart';
import 'package:bringessesellerapp/config/constant/themecubit/theme_cubit.dart';
import 'package:bringessesellerapp/config/themes.dart';
import 'package:bringessesellerapp/model/request/edit_profile_req_model.dart';
import 'package:bringessesellerapp/model/request/send_otp_req_model.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/edit_profile_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/my_subscription_plan_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/my_subscription_plan_state.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/send_otp_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/send_otp_state.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/subscription_default_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/view_profile_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/view_profile_state.dart';
import 'package:bringessesellerapp/presentation/screen/profile/my_subscription_plan.dart';
import 'package:bringessesellerapp/presentation/screen/profile/otp_screen.dart';
import 'package:bringessesellerapp/presentation/screen/profile/quick_app_links.dart';
import 'package:bringessesellerapp/presentation/screen/shop/bloc/store_defaults_cubit.dart';
import 'package:bringessesellerapp/presentation/widget/custom_card.dart';
import 'package:bringessesellerapp/presentation/widget/custom_conformation.dart';
import 'package:bringessesellerapp/presentation/widget/custome_appbar.dart';
import 'package:bringessesellerapp/presentation/widget/custome_listile.dart';
import 'package:bringessesellerapp/presentation/widget/custome_textfeild.dart';
import 'package:bringessesellerapp/presentation/widget/reffer_widget.dart';
import 'package:bringessesellerapp/presentation/widget/sub_title.dart';
import 'package:bringessesellerapp/presentation/widget/title_text.dart';

import 'package:bringessesellerapp/utils/enums.dart';
import 'package:bringessesellerapp/utils/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  String? sellerId;
  late SharedPreferenceHelper sharedPreferenceHelper;
  bool loading = false;
  bool phoneloading = false;
  @override
  void initState() {
    super.initState();
    sharedPreferenceHelper = SharedPreferenceHelper();
    sharedPreferenceHelper.init();

    _loadProfile();
  }

  String? currentVersion;
  String? appcount;
  bool reffer = false;
  void _loadProfile() async {
    context.read<ViewProfileCubit>().login();
    context.read<StoreDefaultsCubit>().login();
    context.read<SubscriptionDefaultCubit>().login();
    context.read<MySubscriptionPlanCubit>().login();

    final packageInfo = await PackageInfo.fromPlatform();
    currentVersion = packageInfo.version;
  }

  void _saveProfile() {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String contact = _contactController.text.trim();

// Basic validation
    if (name.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter your name",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    if (email.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter your email",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

// Simple email validation
    if (!RegExp(r"^[\w-.]+@([\w-]+.)+[\w-]{2,4}$").hasMatch(email)) {
      showAppToast(message: "Please enter a valid email", isError: true);
      return;
    }

    if (contact.isEmpty) {
      showAppToast(message: "Please enter your contact number", isError: true);
      return;
    }

// Simple contact number validation (10 digits)
    if (!RegExp(r'^\+91\s?\d{10}$|^\d{10}$').hasMatch(contact)) {
      showAppToast(
        message: "Please enter a valid contact number",
        isError: true,
      );
      return;
    }
// If all validations pass, update the profile
    context.read<EditProfileCubit>().login(EditProfileRequestModel(
          contactNo: contact,
          email: email,
          name: name,
          liveStatus: true,
          sellerId: sellerId ?? sharedPreferenceHelper.getSellerId,
        ));

    Fluttertoast.showToast(
      msg: "Profile data updated",
      textColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  bool phone = false;

  void _sendOtpPhone() {
    setState(() {
      phone = true;
    });

    String number = _contactController.text.trim();

    // Remove +91 if exists
    if (number.startsWith("+91")) {
      number = number.replaceFirst("+91", "");
    }

    context.read<SendOtpCubit>().login(
          SendOtpReqModel(
            phoneNumber: number,
            type: 'phone',
          ),
        );
  }

  void _sendOtpEmail() {
    context.read<SendOtpCubit>().login(SendOtpReqModel(
          email: _emailController.text,
          type: 'email',
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Profile",
        onBack: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/dashboard');
          }
        },
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: const TitleText(title: "Save"),
          ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<SendOtpCubit, SendOtpState>(
            listener: (context, state) {
              if (state.networkStatusEnum == NetworkStatusEnum.loaded &&
                  state.ChangePassword.status != false) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OtpScreen(
                      isPhone: phone,
                      phone: phone ? _contactController.text : null,
                      email: phone ? null : _emailController.text,
                    ),
                  ),
                ).then(
                  (value) {
                    setState(() {
                      phone = false;
                      loading = false;
                      phoneloading = false;
                    });
                  },
                );
                context.read<ViewProfileCubit>().login();
                Fluttertoast.showToast(
                  msg: state.ChangePassword.message ?? '',
                  toastLength: Toast.LENGTH_SHORT,
                );
              }
            },
          ),
          BlocListener<MySubscriptionPlanCubit, MySubscriptionPlanState>(
            listener: (context, state) {
              if (state.networkStatusEnum == NetworkStatusEnum.loaded) {
                setState(() {
                  appcount = state
                      .viewProfile.result!.subscriptionPlan!.noOfDriversAllowed
                      .toString();
                  reffer = state.viewProfile.result!.id == '' ? false : true;
                });
                print("sdlfhs${appcount},${reffer}");
              }
            },
          ),
        ],
        child: BlocConsumer<ViewProfileCubit, ViewProfileState>(
          listener: (context, state) {
            if (state.networkStatusEnum == NetworkStatusEnum.loaded) {
              final data = state.viewProfile.result;

              // Fluttertoast.showToast(
              //   msg: state.viewProfile.message ?? "Profile loaded",
              //   backgroundColor: Colors.green,
              //   textColor: Colors.white,
              //   toastLength: Toast.LENGTH_SHORT,
              // );
              if (state.viewProfile.status == 'true') {
                sellerId = data!.sellerId;
                _nameController.text = data.name ?? "";
                _emailController.text = data.email ?? "";
                _contactController.text = data.contactNo ?? "";
              } else {
                Fluttertoast.showToast(
                  msg: state.viewProfile.message ?? "Something went wrong",
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  toastLength: Toast.LENGTH_SHORT,
                );
              }
            } else if (state.networkStatusEnum == NetworkStatusEnum.failed) {
              // Fluttertoast.showToast(
              //   msg: "Network error",
              //   backgroundColor: Colors.red,
              //   textColor: Colors.white,
              //   toastLength: Toast.LENGTH_SHORT,
              // );
            }
          },
          builder: (context, state) {
            if (state.networkStatusEnum == NetworkStatusEnum.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.networkStatusEnum == NetworkStatusEnum.loaded &&
                state.viewProfile.status == 'true') {
              return SingleChildScrollView(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Info
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SubTitleText(title: "Name"),
                          CustomTextField(
                            controller: _nameController,
                            hintText: "Name",
                          ),
                          vericalSpaceMedium,
                          const SubTitleText(title: "Email ID"),
                          CustomTextField(
                              controller: _emailController,
                              hintText: "Email",
                              suffixWidget: loading
                                  ? const CupertinoActivityIndicator()
                                  : InkWell(
                                      onTap: state.viewProfile.result!
                                                  .emailVerified !=
                                              true
                                          ? () {
                                              setState(() {
                                                loading = true;
                                              });
                                              _sendOtpEmail();
                                            }
                                          : null,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 15),
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: state.viewProfile.result!
                                                      .emailVerified !=
                                                  true
                                              ? BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.r),
                                                  border: Border.all(
                                                      color:
                                                          AppTheme.primaryColor,
                                                      strokeAlign: 2))
                                              : const BoxDecoration(),
                                          child: state.viewProfile.result!
                                                      .emailVerified !=
                                                  true
                                              ? Text(
                                                  "Verify",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall!
                                                      .copyWith(
                                                          color: AppTheme
                                                              .primaryColor),
                                                )
                                              : const Icon(
                                                  Icons.verified,
                                                  color: Colors.green,
                                                ),
                                        ),
                                      ),
                                    )

                              // prefixIcon: ,
                              ),
                          vericalSpaceMedium,
                          const SubTitleText(title: "Mobile number"),
                          CustomTextField(
                            controller: _contactController,
                            hintText: "Mobile number",
                            suffixWidget: state
                                        .viewProfile.result!.phoneVerified ==
                                    true
                                ? const Icon(
                                    Icons.verified,
                                    color: Colors.green,
                                  )
                                : phoneloading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CupertinoActivityIndicator(),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          setState(() {
                                            phoneloading = true;
                                          });
                                          _sendOtpPhone();
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 15,
                                            vertical: 15,
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5.r),
                                              border: Border.all(
                                                color: AppTheme.primaryColor,
                                                strokeAlign: 2,
                                              ),
                                            ),
                                            child: Text(
                                              "Verify",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .copyWith(
                                                      color: AppTheme
                                                          .primaryColor),
                                            ),
                                          ),
                                        ),
                                      ),
                          ),
                        ],
                      ),
                    ),

                    // Settings
                    CustomCard(
                      child: Column(
                        children: [
                          CustomListTile(
                            title: "My Plan",
                            leadingIcon: Icons.workspace_premium_outlined,
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SubscriptionListScreen(
                                      data: context
                                          .read<MySubscriptionPlanCubit>()
                                          .state
                                          .viewProfile
                                          .result,
                                    ),
                                  ));
                              //context.push('/profile/changepassword');
                            },
                          ),
                          CustomListTile(
                            title: "Change password",
                            leadingIcon: Icons.remove_red_eye_outlined,
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              context.push('/profile/changepassword');
                            },
                          ),
                          CustomListTile(
                            title: "Theme",
                            leadingIcon: Icons.brightness_4_outlined,
                            trailing: BlocBuilder<ThemeCubit, ThemeMode>(
                              builder: (context, mode) {
                                return GestureDetector(
                                  onTap: () {
                                    context.read<ThemeCubit>().toggleTheme();
                                  },
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 400),
                                    transitionBuilder: (child, animation) {
                                      return RotationTransition(
                                        turns: Tween(begin: 0.75, end: 1.0)
                                            .animate(
                                          CurvedAnimation(
                                              parent: animation,
                                              curve: Curves.easeInOut),
                                        ),
                                        child: FadeTransition(
                                            opacity: animation, child: child),
                                      );
                                    },
                                    child: Icon(
                                      mode == ThemeMode.dark
                                          ? Icons.dark_mode_rounded
                                          : Icons.light_mode_rounded,
                                      //  key: ValueKey(isDark),
                                      color: mode == ThemeMode.dark
                                          ? AppTheme.primaryColor
                                          : Colors.amber,
                                      size: 28,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          CustomListTile(
                            title: "Coupon",
                            leadingIcon: Icons.countertops_outlined,
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              context.push('/profile/coupon');
                            },
                          ),
                          CustomListTile(
                            title: "Payout preferences",
                            leadingIcon: Icons.adf_scanner_outlined,
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              context.push('/profile/account');
                            },
                          ),
                          if (reffer && (appcount != '0'))
                            CustomListTile(
                              title: "share delivery partner",
                              leadingIcon: Icons.share_outlined,
                              trailing: const Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DriverRefferal(
                                      storeId: state
                                          .viewProfile.result!.storeDetails!.id,
                                    ),
                                  ),
                                );
                              },
                            ),
                          // CustomListTile(
                          //   title: "Subscription Plans",
                          //   leadingIcon: Icons.shield_outlined,
                          //   trailing: const Icon(Icons.arrow_forward_ios),
                          //   onTap: () {
                          //     final subscriptionData = context
                          //         .read<SubscriptionDefaultCubit>()
                          //         .state
                          //         .viewProfile
                          //         .result;
                          //     final razorKey = context
                          //         .read<StoreDefaultsCubit>()
                          //         .state
                          //         .storeDefaultModel
                          //         .appSettings!
                          //         .razorKey;
                          //     context.push('/profile/subs', extra: {
                          //       'subs': subscriptionData,
                          //       'razorKey': razorKey
                          //     });
                          //   },
                          // ),
                          CustomListTile(
                            title: "Quick App links",
                            leadingIcon: Icons.play_for_work_rounded,
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PlayStoreListScreen(),
                                  ));
                            },
                          ),
                          CustomListTile(
                            title: "Privacy Policy",
                            leadingIcon: Icons.policy_outlined,
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              context.push(
                                '/profile/privacy',
                              );
                            },
                          ),
                          CustomListTile(
                            title: "Version",
                            leadingIcon: Icons.info_outline,
                            trailing: Text(
                              "($currentVersion)",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          // const CustomListTile(
                          //   title: "Language",
                          //   leadingIcon: Icons.language_outlined,
                          //   trailing: Icon(Icons.arrow_forward_ios),
                          // ),
                          CustomListTile(
                            onTap: () {
                              showCustomConfirmationDialog(
                                context: context,
                                content: "Are you sure want to logout?",
                                confirmText: "Yes",
                                title: "Logout",
                                cancelText: "Cancel",
                                onConfirm: () {
                                  sharedPreferenceHelper.clearPreferences();
                                  context.go('/login');
                                },
                              );
                            },
                            title: "Logout",
                            leadingIcon: Icons.exit_to_app_outlined,
                            trailing: const Icon(Icons.arrow_forward_ios),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            // Default fallback
            return const Center(
              child: Text("No profile data available"),
            );
          },
        ),
      ),
    );
  }
}
