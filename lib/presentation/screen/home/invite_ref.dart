import 'package:bringessesellerapp/config/constant/contsant.dart';
import 'package:bringessesellerapp/presentation/widget/custome_appbar.dart';
import 'package:bringessesellerapp/presentation/widget/custome_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class InviteReferre extends StatefulWidget {
  final String? refId;
  InviteReferre({super.key, this.refId});

  @override
  State<InviteReferre> createState() => _InviteReferreState();
}

class _InviteReferreState extends State<InviteReferre> {
  Widget _buildBenefitText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 16,
          //  color: Colors.black,
        ),
      ),
    );
  }

  String? referralLink;
  @override
  void initState() {
    generateReferralLink(widget.refId!);
    super.initState();
  }

  String reffUri = '';
  String generateReferralLink(String referralCode) {
    final baseUrl = 'https://play.google.com/store/apps/details';
    final packageName = 'com.app.bringessesellerapp';

    final Uri uri = Uri.parse(baseUrl).replace(
      queryParameters: {
        'id': packageName,
        'referrer': 'referral_code=${referralCode}',
      },
    );
    setState(() {
      reffUri = uri.toString();
    });
    return uri.toString();
  }

  void showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      // backgroundColor: Colors.black87,
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  // SHARE FUNCTION
  void shareReferral() {
    Share.share("Download the app & use my referral!\n$reffUri");
  }

  // COPY FUNCTION
  Future<void> copyReferral() async {
    await Clipboard.setData(ClipboardData(text: reffUri));
    Fluttertoast.showToast(
      msg: "Referral link copied!",
      backgroundColor: Colors.black87,
      textColor: Colors.white,
    );
  }

  // DOWNLOAD FUNCTION
  Future<void> openPlayStore() async {
    final url = Uri.parse(reffUri);

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      Fluttertoast.showToast(msg: "Cannot open link");
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryRed = Color(0xFFC73D3D);

    return Scaffold(
      appBar: CustomAppBar(title: ''),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Invite Friends & Earn Rewards!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryRed,
                ),
              ),

              const SizedBox(height: 16),

              _buildBenefitText(
                  'Invite friends and earn exciting rewards instantly!'),
              _buildBenefitText(
                  'Grow your network and earn more with each referral'),
              _buildBenefitText(
                  'Track your referral rewards easily in the app'),
              _buildBenefitText(
                  'Enjoy exclusive offers for you and your friends'),

              vericalSpaceMedium,

              // SHARE + COPY BUTTONS
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 45.h,
                      child: CustomButton(
                        icon: Icons.share_outlined,
                        title: "Share",
                        onPressed: shareReferral,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 45.h,
                      child: CustomButton(
                        icon: Icons.copy_outlined,
                        title: "Copy",
                        onPressed: copyReferral,
                      ),
                    ),
                  ),
                ],
              ),

              verticalSpaceDynamic(30.h),

              // QR + DOWNLOAD BUTTON
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  QrImageView(
                    data: reffUri,
                    version: QrVersions.auto,
                    backgroundColor: Colors.grey.shade200,
                    size: 120,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'To download, Referral link\nQR, click here',
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 40.h,
                          child: CustomButton(
                            onPressed: openPlayStore,
                            title: 'Download',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
