class VerifyOtpResponseModel {
  bool? status;
  String? message;

  VerifyOtpResponseModel({
    this.status,
    this.message,
  });

  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponseModel(
      status: json['status'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['status'] = status;
    data['message'] = message;

    return data;
  }
}
