import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastWidget extends StatelessWidget {
  final String? message;
  final Color color;
  final ToastGravity gravity;

  const ToastWidget({
    Key? key,
    this.message,
    this.color = Colors.red,
    this.gravity = ToastGravity.BOTTOM,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (message != null && message!.trim().isNotEmpty) {
        Fluttertoast.showToast(
          msg: message!.replaceAll("Exception:", "").trim(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: gravity,
          backgroundColor: color,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    });

    return const SizedBox.shrink();
  }
}
