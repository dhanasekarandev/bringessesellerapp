class RegisterModel {
  int? statusCode;
  bool? status; // 👈 should be bool, not String
  String? message;

  RegisterModel({this.statusCode, this.status, this.message});

  RegisterModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    // Convert string "true"/"false" → bool
    status = json['status'].toString().toLowerCase() == 'true';
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status_code'] = statusCode;
    data['status'] = status.toString(); // returns "true"/"false"
    data['message'] = message;
    return data;
  }
}
