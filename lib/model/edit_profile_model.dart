class EditProfileModel {
  int? statusCode;
  String? status;
  String? message;
  bool? liveStatus;

  EditProfileModel({
    this.statusCode,
    this.status,
    this.message,
    this.liveStatus,
  });

  EditProfileModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    status = json['status'];
    message = json['message'];
    liveStatus = json['live_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status_code'] = statusCode;
    data['status'] = status;
    data['message'] = message;
    data['live_status'] = liveStatus;
    return data;
  }
}
