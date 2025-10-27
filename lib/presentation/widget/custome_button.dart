import 'package:bringessesellerapp/config/constant/contsant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bringessesellerapp/config/themes.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final double? height;
  final double? width;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool isLoading;
  final IconData? icon;
  final double borderRadius;
  final BorderSide? border;

  const CustomButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.height,
    this.width,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.isLoading = false,
    this.icon,
    this.borderRadius = 12,
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 50.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppTheme.primaryColor,
          foregroundColor: textColor ?? AppTheme.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius.r),
            side: border ?? BorderSide.none,
          ),
          elevation: 2,
        ),
        child: isLoading
            ? SizedBox(
                height: 20.h,
                width: 20.h,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) SizedBox(width: 8.w),
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: textColor ?? AppTheme.whiteColor,
                      fontWeight: fontWeight ?? FontWeight.w600,
                      fontSize: fontSize ?? 16.sp,
                    ),
                  ),
                  horizontalSpaceMedium,
                  if (icon != null)
                    Icon(
                      icon,
                      size: 20.sp,
                      color: textColor ?? AppTheme.whiteColor,
                    ),
                ],
              ),
      ),
    );
  }
}
