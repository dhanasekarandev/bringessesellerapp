class StoreResponseModel {
  int? statusCode;
  bool? status;
  String? message;
  StoreResult? result;

  StoreResponseModel({
    this.statusCode,
    this.status,
    this.message,
    this.result,
  });

  StoreResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    status = json['status'] == true || json['status'] == 'true';
    message = json['message'];
    result =
        json['result'] != null ? StoreResult.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status_code'] = statusCode;
    data['status'] = status;
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class StoreResult {
  String? storeId;
  String? categoryId;
  List<String>? images; // list of image URLs or paths
  List<String>? documents; // list of document URLs or paths

  StoreResult({
    this.storeId,
    this.categoryId,
    this.images,
    this.documents,
  });

  StoreResult.fromJson(Map<String, dynamic> json) {
    storeId = json['storeId'];
    categoryId = json['categoryId'];
    // If images/documents exist in API, parse them; otherwise, initialize empty lists
    images = json['images'] != null
        ? List<String>.from(json['images'])
        : <String>[];
    documents = json['documents'] != null
        ? List<String>.from(json['documents'])
        : <String>[];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['storeId'] = storeId;
    data['categoryId'] = categoryId;
    data['images'] = images ?? [];
    data['documents'] = documents ?? [];
    return data;
  }
}
