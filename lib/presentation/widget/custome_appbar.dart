import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bringessesellerapp/config/themes.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final bool showLeading; // Show/hide back button
  final List<Widget>? actions; // Optional actions (e.g. icons)

  const CustomAppBar({
    Key? key,
    required this.title,
    this.onBack,
    this.showLeading = true,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        height: kToolbarHeight.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        // decoration: BoxDecoration(
        //   color: AppTheme.whiteColor,
        //   boxShadow: [
        //     BoxShadow(
        //       color: Colors.black.withOpacity(0.06),
        //       blurRadius: 6,
        //       offset: const Offset(0, 3),
        //     ),
        //   ],
        // ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ⬅️ Optional Back Button
            if (showLeading)
              GestureDetector(
                onTap: onBack ?? () => Navigator.of(context).maybePop(),
                child: Container(
                  height: 36.h,
                  width: 36.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    CupertinoIcons.back,
                    //   color: AppTheme.textColor,
                    size: 22.sp,
                  ),
                ),
              )
            else
              SizedBox(width: 36.h),

            // 🧭 Center Title
            Expanded(
              child: Center(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 20.sp,
                      ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),

            // ➡️ Optional Actions (like search, notification, etc.)
            if (actions != null && actions!.isNotEmpty)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: actions!
                    .map(
                      (action) => Padding(
                        padding: EdgeInsets.only(left: 8.w),
                        child: action,
                      ),
                    )
                    .toList(),
              )
            else
              SizedBox(width: 36.h),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight.h);
}
