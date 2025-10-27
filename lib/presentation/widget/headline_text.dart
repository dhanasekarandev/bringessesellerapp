import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeadlineText extends StatelessWidget {
  final String title;
  final FontWeight? fontWeight;
  final Color? textColor;
  final double? fontSize;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextOverflow? overflow;

  const HeadlineText({
    Key? key,
    required this.title,
    this.fontWeight,
    this.textColor,
    this.fontSize,
    this.maxLines,
    this.textAlign,
    this.overflow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      title,
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines ?? 2,
      overflow: overflow ?? TextOverflow.ellipsis,
      style: theme.textTheme.bodyLarge?.copyWith(
        fontWeight: fontWeight ?? FontWeight.w800,
        color: textColor ?? theme.colorScheme.onBackground,
        fontSize: fontSize ?? 25.sp,
      ),
    );
  }
}
