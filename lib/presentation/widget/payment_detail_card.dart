import 'package:bringessesellerapp/config/constant/contsant.dart';
import 'package:bringessesellerapp/presentation/widget/custome_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:bringessesellerapp/presentation/widget/sub_title.dart';
import 'package:bringessesellerapp/presentation/widget/title_text.dart';

class PaymentDetailsCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String route;
  final Color? backgroundColor;

  const PaymentDetailsCard({
    super.key,
    this.title = "Payment details",
    this.subtitle = "Add payment to activate your account",
    this.route = '/profile/account',
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(10.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TitleText(title: title),
          vericalSpaceSmall,
          SubTitleText(title: subtitle),
          vericalSpaceSmall,
          CustomButton(
            title: "Click Here",
            onPressed: () => context.push(route),
          ),
          // TextButton(
          //   onPressed: () => context.push(route),
          //   child: TitleText(
          //     title: "Click Here",
          //     fontSize: 12.sp,
          //   ),
          // ),
        ],
      ),
    );
  }
}
