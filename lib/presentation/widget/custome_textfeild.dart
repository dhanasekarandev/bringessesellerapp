import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bringessesellerapp/config/themes.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final String? labelText;
  final TextEditingController? controller;
  final bool isPassword;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Widget? suffixWidget; // ✅ New
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final int maxLines;
  final double borderRadius;
  final Color? fillColor;
  final TextInputAction? textInputAction;

  const CustomTextField({
    Key? key,
    required this.hintText,
    this.labelText,
    this.controller,
    this.isPassword = false,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixWidget, // ✅ New
    this.validator,
    this.onChanged,
    this.readOnly = false,
    this.maxLines = 1,
    this.borderRadius = 12,
    this.fillColor,
    this.textInputAction,
    this.onTap,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  void _validate(String? value) {
    if (widget.validator != null) {
      final error = widget.validator!(value);
      setState(() => _errorText = error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 6.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius.r),
          ),
          child: TextFormField(
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            onTap: widget.onTap,
            controller: widget.controller,
            obscureText: _obscureText,
            keyboardType: widget.keyboardType,
            readOnly: widget.readOnly,
            maxLines: widget.maxLines,
            validator: widget.validator,
            onChanged: (value) {
              widget.onChanged?.call(value);
              _validate(value);
            },
            textInputAction: widget.textInputAction ?? TextInputAction.next,
            decoration: InputDecoration(
              filled: true,
              fillColor: widget.fillColor ?? Theme.of(context).cardTheme.color,
              hintText: widget.hintText,
              labelText: widget.labelText,
              hintStyle: TextStyle(
                color: AppTheme.textColor.withOpacity(0.5),
                fontSize: 14.sp,
              ),
              labelStyle: TextStyle(
                color: AppTheme.textColor.withOpacity(0.7),
                fontSize: 15.sp,
              ),
              prefixIcon: widget.prefixIcon != null
                  ? Icon(widget.prefixIcon, size: 20.sp)
                  : null,
              suffixIcon: widget.suffixWidget ??
                  (widget.isPassword
                      ? IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppTheme.textColor.withOpacity(0.6),
                            size: 20.sp,
                          ),
                          onPressed: () =>
                              setState(() => _obscureText = !_obscureText),
                        )
                      : (widget.suffixIcon != null
                          ? Icon(widget.suffixIcon,
                              color: AppTheme.textColor.withOpacity(0.6),
                              size: 20.sp)
                          : null)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius.r),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 15.w,
                vertical: 10.h,
              ),
            ),
          ),
        ),
        if (_errorText != null)
          Padding(
            padding: EdgeInsets.only(left: 12.w, top: 2.h),
            child: Text(
              _errorText!,
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 12.sp,
              ),
            ),
          ),
      ],
    );
  }
}
