class LogoutResponseModel {
  bool? status;
  String? message;

  LogoutResponseModel({this.status, this.message});

  LogoutResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString().toLowerCase() == 'true';
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status.toString();
    data['message'] = message;
    return data;
  }
}
