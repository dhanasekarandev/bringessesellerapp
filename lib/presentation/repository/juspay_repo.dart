import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hypersdkflutter/hypersdkflutter.dart';

class PaymentPageScreen extends StatefulWidget {
  final HyperSDK hyperSDK;
  final dynamic payload;

  const PaymentPageScreen({
    Key? key,
    required this.hyperSDK,
    required this.payload,
  }) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPageScreen> {
  bool showLoader = true;
  bool processCalled = false;

  @override
  Widget build(BuildContext context) {
    print("Incoming Payload => ${widget.payload.toJson()}");

    if (!processCalled) {
      print("STEP=>0");
      Future.delayed(Duration.zero, () {
        if (mounted) startPayment(widget.payload?.toJson());
      });
    }

    return WillPopScope(
      onWillPop: () async {
        if (Platform.isAndroid) {
          var backResult = await widget.hyperSDK.onBackPress();
          return backResult.toLowerCase() != "true";
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: showLoader
              ? CupertinoActivityIndicator(
                  radius: 30.r,
                )
              : Container(),
        ),
      ),
    );
  }

  /// START PAYMENT
  void startPayment(Map<String, dynamic> payload) async {
    print("STEP=>1");
    processCalled = true;

    try {
      widget.hyperSDK.openPaymentPage(
        payload,
        hyperSDKCallbackHandler,
      );
    } catch (e) {
      print("Payment Page Error: $e");
    }
  }

  /// JUSPAY CALLBACK HANDLER
  void hyperSDKCallbackHandler(MethodCall methodCall) {
    switch (methodCall.method) {
      case "hide_loader":
        setState(() => showLoader = false);
        break;

      case "process_result":
        Map<String, dynamic> args = {};

        try {
          if (methodCall.arguments is String) {
            args = json.decode(methodCall.arguments);
          } else if (methodCall.arguments is Map) {
            args = Map<String, dynamic>.from(methodCall.arguments);
          }
        } catch (e) {
          print("Callback Decode Error: $e");
        }

        final payload = args["payload"] ?? {};
        final String status = payload["status"] ?? "";
        final orderId = args["orderId"] ?? null;
      //  final amount = args['']
        print("Payment Status => $args");
        print("Order ID => $payload");

        if (status == "backpressed" || status == "user_aborted") {
          Navigator.pop(context, {
            "success": false,
            "orderId": orderId,
          });
          break;
        }

        final success = status.toLowerCase() == "charged";

        Navigator.pop(context, {
          "success": success,
          "orderId": orderId,
        });
        break;
    }
  }
}
