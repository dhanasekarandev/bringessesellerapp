import 'package:bringessesellerapp/config/constant/contsant.dart';
import 'package:bringessesellerapp/config/themes.dart';

import 'package:bringessesellerapp/presentation/repository/api_class.dart';

import 'package:bringessesellerapp/presentation/widget/custome_appbar.dart';
import 'package:bringessesellerapp/presentation/widget/custome_button.dart';
import 'package:bringessesellerapp/presentation/widget/custome_textfeild.dart';
import 'package:bringessesellerapp/presentation/widget/sub_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatefulWidget {
  final String? referCode;
  const RegisterScreen({super.key, this.referCode});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _couponController = TextEditingController();
  final TextEditingController _refferController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Show loading indicator

        // Call the API
        var res = await ApiClass().register(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _confirmPasswordController.text.trim(),
          contactNo: _mobileController.text.trim(),
          referedBy: _refferController.text.trim()
        );

        if (res['status'] == true) {
          context.push('/approve');
        } else {
          Fluttertoast.showToast(
            msg: ' ${res['message']}',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      } catch (e) {
        Navigator.of(context).pop();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('⚠️ Please correct the errors in the form.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: const CustomAppBar(title: "SignUp"),
      body: SingleChildScrollView(
        child: Form(
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
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SubTitleText(title: "Name"),
                    CustomTextField(
                      controller: _nameController,
                      hintText: "Enter your Name",
                      prefixIcon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Name is required";
                        }
                        return null;
                      },
                    ),
                    const SubTitleText(title: "Email"),
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
                    const SubTitleText(title: "Mobile Number"),
                    CustomTextField(
                      controller: _mobileController,
                      hintText: "Enter your Mobile Number",
                      keyboardType: TextInputType.phone,
                      prefixIcon: Icons.phone_outlined,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Mobile number is required";
                        } else if (value.length < 10) {
                          return "Enter a valid mobile number";
                        }
                        return null;
                      },
                    ),
                    const SubTitleText(title: "Coupon"),
                    CustomTextField(
                      controller: _couponController,
                      hintText: "Enter your Coupon",
                      prefixIcon: Icons.apps_sharp,
                    ),
                    const SubTitleText(title: "Reffer"),
                    CustomTextField(
                      controller: _refferController,
                      hintText: "Enter your refferer",
                      prefixIcon: Icons.link_sharp,
                    ),
                    const SubTitleText(title: "Password"),
                    CustomTextField(
                      controller: _passwordController,
                      hintText: "Enter your Password",
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
                    const SubTitleText(title: "Password"),
                    CustomTextField(
                      controller: _confirmPasswordController,
                      hintText: "Confirm your Password",
                      isPassword: true,
                      prefixIcon: Icons.lock_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please confirm your password";
                        } else if (value != _passwordController.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                    ),
                    verticalSpaceDynamic(40.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: 'Already having account? ',
                                style: theme.textTheme.titleMedium!
                                    .copyWith(fontSize: 16.sp)),
                            TextSpan(
                              text: 'Login',
                              style: theme.textTheme.titleMedium!.copyWith(
                                fontSize: 16.sp,
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  context.push('/login');
                                },
                            )
                          ]),
                        ),
                      ],
                    ),
                    //vericalSpaceMedium,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 10.w, vertical: 50.w),
        child: CustomButton(
          title: "Confirm",
          onPressed: () => _submitForm(),
          icon: Icons.arrow_forward_ios_rounded,
        ),
      ),
    );
  }
}
