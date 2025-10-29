class SendOtpResModel {
  bool? status;
  String? message;
  String? otp;
  String? expiresIn;

  SendOtpResModel({
    this.status,
    this.message,
    this.otp,
    this.expiresIn,
  });

  SendOtpResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    otp = json['otp'];
    expiresIn = json['expiresIn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (status != null) data['status'] = status;
    if (message != null) data['message'] = message;
    if (otp != null) data['otp'] = otp;
    if (expiresIn != null) data['expiresIn'] = expiresIn;
    return data;
  }

  @override
  String toString() {
    return 'SendOtpResModel(status: $status, message: $message, otp: $otp, expiresIn: $expiresIn)';
  }
}
