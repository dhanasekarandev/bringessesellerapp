import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:bringessesellerapp/config/themes.dart';

class CustomGooglePlacesField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final double borderRadius;
  final String googleApiKey;
  final ValueChanged<Prediction>? onPlaceSelected;

  const CustomGooglePlacesField({
    Key? key,
    required this.controller,
    required this.googleApiKey,
    this.hintText = 'Search place',
    this.prefixIcon,
    this.borderRadius = 12,
    this.onPlaceSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(borderRadius.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 4,
            spreadRadius: 0.5,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.transparent, // can change on error
          width: 1,
        ),
      ),
      child: GooglePlaceAutoCompleteTextField(
        textEditingController: controller,
        googleAPIKey: googleApiKey,
        inputDecoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: AppTheme.textColor.withOpacity(0.5),
            fontSize: 14.sp,
          ),
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: AppTheme.textColor, size: 20.sp)
              : null,
          filled: true,
          fillColor: Colors.transparent, // container color handles it
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius.r),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 15.w,
            vertical: 10.h,
          ),
        ),
        debounceTime: 800,
        itemClick: (Prediction prediction) {
          controller.text = prediction.description??"";
          controller.selection = TextSelection.fromPosition(
              TextPosition(offset: prediction.description!.length));
          if (onPlaceSelected != null) {
            onPlaceSelected!(prediction);
          }
        },
      ),
    );
  }
}
