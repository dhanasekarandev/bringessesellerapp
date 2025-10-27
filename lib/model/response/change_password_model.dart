class ChangePasswordModel {
   int? statusCode;
  String? status;
  String? message;

  ChangePasswordModel({
    this.statusCode,
    this.status,
    this.message,
   
  });

  factory ChangePasswordModel.fromJson(Map<String, dynamic> json) {
    return ChangePasswordModel(
      statusCode: json['status_code'],
      status: json['status'],
      message: json['message'],
   
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status_code'] = statusCode;
    data['status'] = status;
    data['message'] = message;
   
    return data;
  }
}
