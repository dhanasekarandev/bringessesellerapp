class CouponSuccessRresModel {
  bool? status;
  String? message;

  CouponSuccessRresModel({
    this.status,
    this.message,
  });

  factory CouponSuccessRresModel.fromJson(Map<String, dynamic> json) {
    return CouponSuccessRresModel(
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
