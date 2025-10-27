import 'package:bringessesellerapp/config/constant/contsant.dart';
import 'package:bringessesellerapp/config/constant/sharedpreference_helper.dart';
import 'package:bringessesellerapp/model/request/edit_profile_req_model.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/edit_profile_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/subscription_default_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/view_profile_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/view_profile_state.dart';
import 'package:bringessesellerapp/presentation/widget/custom_card.dart';
import 'package:bringessesellerapp/presentation/widget/custom_conformation.dart';
import 'package:bringessesellerapp/presentation/widget/custome_appbar.dart';
import 'package:bringessesellerapp/presentation/widget/custome_listile.dart';
import 'package:bringessesellerapp/presentation/widget/custome_textfeild.dart';
import 'package:bringessesellerapp/presentation/widget/sub_title.dart';
import 'package:bringessesellerapp/presentation/widget/title_text.dart';

import 'package:bringessesellerapp/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  @override
  void initState() {
    super.initState();
    sharedPreferenceHelper = SharedPreferenceHelper();
    sharedPreferenceHelper.init();

    _loadProfile();
  }

  String? currentVersion;
  void _loadProfile() async {
    context.read<ViewProfileCubit>().login();
    context.read<SubscriptionDefaultCubit>().login();
    final packageInfo = await PackageInfo.fromPlatform();
    currentVersion = packageInfo.version;
  }

  void _saveProfile() {
    context.read<EditProfileCubit>().login(EditProfileRequestModel(
        contactNo: _contactController.text,
        email: _emailController.text,
        name: _nameController.text,
        liveStatus: true,
        sellerId: sellerId ?? sharedPreferenceHelper.getSellerId));
    Fluttertoast.showToast(
      msg: "Profile data updated",
      backgroundColor: Colors.green,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Profile",
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: const TitleText(title: "Save"),
          ),
        ],
      ),
      body: BlocConsumer<ViewProfileCubit, ViewProfileState>(
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
                        ),
                        vericalSpaceMedium,
                        const SubTitleText(title: "Mobile number"),
                        CustomTextField(
                          controller: _contactController,
                          hintText: "Mobilr number",
                        ),
                      ],
                    ),
                  ),

                  // Settings
                  CustomCard(
                    child: Column(
                      children: [
                        CustomListTile(
                          title: "Change password",
                          leadingIcon: Icons.remove_red_eye_outlined,
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            context.push('/profile/changepassword');
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
                        CustomListTile(
                          title: "Subscription Plans",
                          leadingIcon: Icons.shield_outlined,
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            final subscriptionData = context
                                .read<SubscriptionDefaultCubit>()
                                .state
                                .viewProfile
                                .result;
                            context.push('/profile/subs',
                                extra: {'subs': subscriptionData});
                          },
                        ),

                        CustomListTile(
                          title: "Version",
                          leadingIcon: Icons.info_outline,
                          trailing: Text(
                            "(${currentVersion})",
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
                          trailing: Icon(Icons.arrow_forward_ios),
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
    );
  }
}
