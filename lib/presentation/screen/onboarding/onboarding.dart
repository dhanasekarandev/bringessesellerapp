import 'package:bringessesellerapp/config/constant/contsant.dart';
import 'package:bringessesellerapp/config/themes.dart';
import 'package:bringessesellerapp/presentation/widget/custome_button.dart';
import 'package:bringessesellerapp/presentation/widget/headline_text.dart';
import 'package:bringessesellerapp/presentation/widget/sub_title.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBordingScreen extends StatelessWidget {
  const OnBordingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        body: Padding(
          padding: EdgeInsets.only(top: 20.w),
          child: Column(
            children: [
              Image.asset(
                'assets/images/landing_logo.png',
                height: 260.h,
                fit: BoxFit.cover,
              ),
              verticalSpaceDynamic(),
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
                      color: Colors.black.withOpacity(0.06),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const HeadlineText(
                        title: 'Take Your Business to  next level'),
                    vericalSpaceMedium,
                    const SubTitleText(
                        title:
                            "LoreLorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque euismod, nibh eu facilisis suscipit, urna quam hendrerit justo, on csequat velit libero nec nulla"),
                    vericalSpaceMedium,
                    CustomButton(
                      width: 250.w,
                      title: "Next",
                      icon: Icons.arrow_forward_ios_sharp,
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('onboard_seen', true);
                        context.push('/welcome');
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
