import 'package:bringessesellerapp/config/constant/contsant.dart';
import 'package:bringessesellerapp/config/themes.dart';
import 'package:bringessesellerapp/presentation/widget/custome_button.dart';
import 'package:bringessesellerapp/presentation/widget/custome_appbar.dart';
import 'package:bringessesellerapp/presentation/widget/headline_text.dart';
import 'package:bringessesellerapp/presentation/widget/sub_title.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatefulWidget {
 final String? referCode;
  const WelcomeScreen({super.key, this.referCode=''});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: Column(
        children: [
          CustomAppBar(
            title: 'Welcome',
            onBack: () {
              Navigator.pop(context);
            },
          ),
          Image.asset(
            'assets/images/welcome_logo.png',
            height: 280.h,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            margin: EdgeInsets.all(10.r),
            padding: EdgeInsets.all(15.r),
            //  height: 300.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).cardColor,
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const HeadlineText(
                  title: 'Welcome',
                  textAlign: TextAlign.center,
                ),
                vericalSpaceMedium,
                const SubTitleText(
                    title:
                        "LoreLorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque euismod, nibh eu facilisis suscipit, urna quam hendrerit justo, on csequat velit libero nec nulla"),
                vericalSpaceMedium,
                CustomButton(
                  width: 250.w,
                  title: "Signup",
                  icon: Icons.arrow_forward_ios_sharp,
                  onPressed: () {
                    context.push('/register',extra: {
                                        'refcode': '',
                                      });
                  },
                ),
                vericalSpaceMedium,
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
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
