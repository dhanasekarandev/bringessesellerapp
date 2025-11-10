import 'package:bringessesellerapp/presentation/widget/custome_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class WaitingApprovalScreen extends StatelessWidget {
  const WaitingApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('assetslottie/Waiting.json'),
              SizedBox(height: 20.h),

              Text(
                "Waiting for Admin Approval",
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.sp,
                ),
              ),
              SizedBox(height: 10.h),

              Text(
                "Your account is under review. "
                "You will be notified once the admin approves your registration. "
                "Please check back later.",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium!.copyWith(
                  fontSize: 16.sp,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 30.h),

              // Optional: Loading indicator

              SizedBox(height: 20.h),

              // Optional: Retry / Refresh button
              CustomButton(
                onPressed: () {
                  context.go('/login');
                },
                title: "Go to Login",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
