import 'package:flutter/material.dart';

class MediumText extends StatelessWidget {
  final String title;
  final FontWeight? fontWeight;
  final Color? textColor;
  final double? fontSize;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextOverflow? overflow;

  const MediumText({
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

    return Text(title,
        textAlign: textAlign ?? TextAlign.start,
        maxLines: maxLines ?? 4,
        overflow: overflow ?? TextOverflow.ellipsis,
        style: theme.textTheme.titleMedium);
  }
}
