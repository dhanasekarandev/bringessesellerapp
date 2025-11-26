import 'package:play_install_referrer/play_install_referrer.dart';

class ReferrerService {
  /// STEP 1: Get raw referrer from Play Store
  static Future<String?> getRawReferrer() async {
    try {
      final ReferrerDetails details = await PlayInstallReferrer.installReferrer;

      final ref = details.installReferrer;
      print("DEBUG: Raw Referrer → $ref");

      return ref;
    } catch (e) {
      print("Referrer Error: $e");
      return null;
    }
  }

  /// STEP 2: Extract referral_code=XXXX from referrer string
  static String? extractReferralCode(String? referrer) {
    if (referrer == null || referrer.isEmpty) return null;

    try {
      if (referrer.contains("referral_code=")) {
        final part = referrer.split("referral_code=").last;
        return part.contains("&") ? part.split("&").first : part;
      }
    } catch (e) {
      print("Parse Error: $e");
    }

    return null;
  }

  /// STEP 3: Directly get referral code
  static Future<String?> getReferralCode() async {
    final raw = await getRawReferrer();
    final code = extractReferralCode(raw);

    print("DEBUG: Final Referral Code → $code");
    return code;
  }
}
