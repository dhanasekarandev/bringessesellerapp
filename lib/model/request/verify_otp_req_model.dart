class VerifyOtpReqModel {
  String? type; // e.g. "phone" or "email"
  String? otp;
  String? phoneNumber;
  String? email;

  VerifyOtpReqModel({
    this.type,
    this.otp,
    this.phoneNumber,
    this.email,
  });

  // 🔹 fromJson constructor
  VerifyOtpReqModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    otp = json['otp'];
    phoneNumber = json['phonenumber'];
    email = json['email'];
  }

  // 🔹 Convert to JSON (skip nulls)
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (type != null) data['type'] = type;
    if (otp != null) data['otp'] = otp;
    if (phoneNumber != null) data['phonenumber'] = phoneNumber;
    if (email != null) data['email'] = email;
    return data;
  }

  @override
  String toString() {
    return 'VerifyOtpReqModel(type: $type, otp: $otp, phonenumber: $phoneNumber, email: $email)';
  }
}
