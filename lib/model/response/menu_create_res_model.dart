class MenuCreateResModel {
//  int? statusCode;
  String? status;
  String? message;

  MenuCreateResModel({this.status, this.message});

  MenuCreateResModel.fromJson(Map<String, dynamic> json) {
    //   statusCode = json['status_code'];
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    //  data['status_code'] = statusCode;
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}
