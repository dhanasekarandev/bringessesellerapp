import 'package:bringessesellerapp/config/constant/contsant.dart';
import 'package:bringessesellerapp/config/constant/sharedpreference_helper.dart';
import 'package:bringessesellerapp/model/request/change_password_req_model.dart';

import 'package:bringessesellerapp/presentation/screen/profile/bloc/change_password_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/change_password_state.dart';
import 'package:bringessesellerapp/presentation/widget/custom_card.dart';
import 'package:bringessesellerapp/presentation/widget/custome_appbar.dart';
import 'package:bringessesellerapp/presentation/widget/custome_button.dart';
import 'package:bringessesellerapp/presentation/widget/custome_textfeild.dart';
import 'package:bringessesellerapp/presentation/widget/sub_title.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:bringessesellerapp/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePaswordScreen extends StatefulWidget {
  const ChangePaswordScreen({super.key});

  @override
  State<ChangePaswordScreen> createState() => _ChangePaswordScreenState();
}

class _ChangePaswordScreenState extends State<ChangePaswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  late SharedPreferenceHelper sharedPreferenceHelper;

  @override
  void initState() {
    super.initState();
    sharedPreferenceHelper = SharedPreferenceHelper();
    sharedPreferenceHelper.init();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Change Password"),
      body: BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
        listener: (context, state) {
          if (state.networkStatusEnum == NetworkStatusEnum.loaded &&
              state.ChangePassword.status == 'true') {
            context.pop();
            showAppToast(
                message: state.ChangePassword.message ?? "", isError: false);

            _currentPasswordController.clear();
            _newPasswordController.clear();
            _confirmPasswordController.clear();

            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) context.pop();
            });
          } else if (state.networkStatusEnum == NetworkStatusEnum.loaded &&
              state.ChangePassword.status != 'true') {
            showAppToast(
                message: state.ChangePassword.message ?? "", isError: true);
          } else if (state.networkStatusEnum == NetworkStatusEnum.failed) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Network error. Please try again.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(15.w),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomCard(
                    child: Padding(
                      padding: EdgeInsets.all(15.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SubTitleText(title: "Current password"),
                          CustomTextField(
                            controller: _currentPasswordController,
                            hintText: "Current password",
                            isPassword: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Current password is required";
                              }
                              return null;
                            },
                          ),
                          vericalSpaceMedium,
                          const SubTitleText(title: "New password"),
                          CustomTextField(
                            controller: _newPasswordController,
                            hintText: "New password",
                            isPassword: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "New password is required";
                              } else if (value.length < 6) {
                                return "Password must be at least 6 characters";
                              }
                              return null;
                            },
                          ),
                          vericalSpaceMedium,
                          const SubTitleText(title: "Confirm password"),
                          CustomTextField(
                            controller: _confirmPasswordController,
                            hintText: "Confirm password",
                            isPassword: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Confirm password is required";
                              } else if (value != _newPasswordController.text) {
                                return "Passwords do not match";
                              }
                              return null;
                            },
                          ),
                          vericalSpaceMedium,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.w),
          child: CustomButton(
            title: "Save",
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context.read<ChangePasswordCubit>().login(
                      ChangePasswordReqModel(
                        oldPassword: _currentPasswordController.text,
                        sellerId: sharedPreferenceHelper.getSellerId,
                        password: _confirmPasswordController.text,
                      ),
                    );
              }
            },
            icon: Icons.arrow_forward_ios_rounded,
          ),
        ),
      ),
    );
  }
}
