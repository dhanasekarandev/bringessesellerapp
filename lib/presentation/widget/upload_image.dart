
import 'package:bringessesellerapp/config/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool isBottomSheetVisible = false; 
  String? _imagePath;
  final picker = ImagePicker();

  Future<void> getImage(ImageSource source) async {
    final image = await picker.pickImage(source: source);
    if (image == null) return;

    setState(() {
      _imagePath = image.path;
    });
  }

  Future<void> showImagePickerOptions(BuildContext context) async {
    setState(() {
      isBottomSheetVisible = !isBottomSheetVisible; 
    });

    if (isBottomSheetVisible) {
     
    } else {
      Navigator.pop(context); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            showImagePickerOptions(context);
          },
          child: CircleAvatar(
            radius: 60.r,
            child: Icon(
              Icons.person_2_outlined,
              color: AppTheme.graycolor,
              size: 40.sp,
            ),
          ),
        ),
      ],
    )
        // You can show a loading indicator while capturing the photo
        );
  }
}
