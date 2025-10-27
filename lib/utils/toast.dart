import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showAppToast({
  required String message,
  bool isError = false,
}) {
  Fluttertoast.showToast(
    msg: message,
    backgroundColor: isError ? Colors.red : null,
    textColor: isError ? Colors.white : null,
    toastLength: Toast.LENGTH_SHORT,
  );
}
