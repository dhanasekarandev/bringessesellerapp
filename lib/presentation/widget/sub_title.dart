import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // if you are using .sp
import 'package:bringessesellerapp/config/themes.dart'; // adjust as per your project

class SubTitleText extends StatelessWidget {
  final String title;
  final FontWeight? fontWeight;
  final Color? textColor;
  final double? fontSize;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final bool isMandatory; // 🔹 new flag

  const SubTitleText({
    super.key,
    required this.title,
    this.fontWeight,
    this.textColor,
    this.fontSize,
    this.maxLines,
    this.textAlign,
    this.overflow,
    this.isMandatory = false, // default false
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RichText(
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines ?? 4,
      text: TextSpan(
        text: title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: fontWeight ?? FontWeight.w800,
          color: textColor ?? AppTheme.graycolor,
          fontSize: fontSize ?? 15.sp,
          overflow: overflow ?? TextOverflow.ellipsis,
        ),
        children: isMandatory
            ? [
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                    fontSize: fontSize ?? 15.sp,
                  ),
                ),
              ]
            : null,
      ),
    );
  }
}
