import 'package:bringessesellerapp/model/request/send_otp_req_model.dart';
import 'package:bringessesellerapp/model/request/verify_otp_req_model.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/send_otp_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/send_otp_state.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/verify_otp_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/verify_otp_state.dart';
import 'package:bringessesellerapp/presentation/widget/custome_appbar.dart';
import 'package:bringessesellerapp/presentation/widget/custome_button.dart';
import 'package:bringessesellerapp/presentation/widget/toast_widget.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:bringessesellerapp/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class OtpScreen extends StatefulWidget {
  final bool isPhone;

  final String? phone;
  final String? email;
  const OtpScreen({
    super.key,
    required this.isPhone,
    this.phone,
    this.email,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _verifyOtp() {
    String otp = _controllers.map((c) => c.text).join();

    // Validate OTP length
    if (otp.length != 4) {
      showAppToast(message: "Please enter the full 4-digit OTP");
      return;
    }

    context.read<VerifyOtpCubit>().login(VerifyOtpReqModel(
          phoneNumber: widget.phone,
          otp: otp,
          email: widget.email,
          type: widget.isPhone == true ? 'phone' : 'email',
        ));
  }

  void _resendOtp() {
    context.read<SendOtpCubit>().login(SendOtpReqModel(
          email: widget.email,
          phoneNumber: widget.phone,
          type: widget.isPhone ? 'phone' : 'email',
        ));
  }

  Widget _buildOtpBox(int index) {
    return SizedBox(
      width: 60.w,
      height: 60.w,
      child: TextField(
        controller: _controllers[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade300,
          counterText: "",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 3) {
            FocusScope.of(context).nextFocus();
          } else if (value.isEmpty && index > 0) {
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("sdkgfbshk${widget.isPhone}");
    final message = widget.isPhone
        ? "We’ve sent a 4-digit code to your phone number"
        : "We’ve sent a 4-digit code to your email address";

    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: CustomAppBar(title: ''),
      body: MultiBlocListener(
        listeners: [
          BlocListener<VerifyOtpCubit, VerifyOtpState>(
            listener: (context, state) {
              if (NetworkStatusEnum.loaded == state.networkStatusEnum &&
                  state.ChangePassword.status != false) {
                context.pop(true);
                showAppToast(message: state.ChangePassword.message ?? '');
              }
            },
          ),
          BlocListener<SendOtpCubit, SendOtpState>(
            listener: (context, state) {
              if (state.networkStatusEnum == NetworkStatusEnum.loaded &&
                  state.ChangePassword.status != false) {
                showAppToast(message: state.ChangePassword.message ?? '');
              }
            },
          ),
        ],
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 60.h),
                Text(
                  "Enter OTP",
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "$message",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(height: 40.h),

                // 🔢 OTP Boxes
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(4, (index) => _buildOtpBox(index)),
                ),

                SizedBox(height: 30.h),

                // 🔁 Resend OTP
                TextButton(
                  onPressed: () {
                    _resendOtp();
                    //
                  },
                  child: Text(
                    "Resend OTP",
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                SizedBox(height: 40.h),

                // ✅ Verify Button
                CustomButton(
                  title: "Verify",
                  onPressed: _verifyOtp,
                )
                // SizedBox(
                //   width: double.infinity,
                //   height: 50.h,
                //   child: ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: Colors.blueAccent,
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(12.r),
                //       ),
                //     ),
                //     onPressed: _verifyOtp,
                //     child: Text(
                //       "Verify",
                //       style: TextStyle(
                //         fontSize: 18.sp,
                //         fontWeight: FontWeight.w600,
                //         color: Colors.white,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
