class DeleteProductResponseModel {
  int? statusCode;
  DeleteResult? result;

  DeleteProductResponseModel({this.statusCode, this.result});

  DeleteProductResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    result = json['result'] != null ? DeleteResult.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (statusCode != null) data['status_code'] = statusCode;
    if (result != null) data['result'] = result!.toJson();
    return data;
  }
}

class DeleteResult {
  String? message;

  DeleteResult({this.message});

  DeleteResult.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (message != null) data['message'] = message;
    return data;
  }
}
