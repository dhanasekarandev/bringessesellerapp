class GetStoreModel {
  int? statusCode;
  String? status;
  Result? result;

  GetStoreModel({this.statusCode, this.status, this.result});

  GetStoreModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    status = json['status'];
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status_code'] = statusCode;
    data['status'] = status;
    if (result != null) data['result'] = result!.toJson();
    return data;
  }
}

class Result {
  String? storeId;
  String? name;
  int? contactNo;
  String? image;
  int? status;
  String? categoryId;
  String? categoryName;
  List<dynamic>? documents;
  String? createdAt;
  String? openingTime; // new
  String? closingTime; // new
  int? packingTime; // new
  int? packingCharge; // new
  String? description; // new

  Result({
    this.storeId,
    this.name,
    this.contactNo,
    this.image,
    this.status,
    this.categoryId,
    this.categoryName,
    this.documents,
    this.createdAt,
    this.openingTime,
    this.closingTime,
    this.packingTime,
    this.packingCharge,
    this.description,
  });

  Result.fromJson(Map<String, dynamic> json) {
    storeId = json['storeId'];
    name = json['name'];
    contactNo = json['contactNo'];
    image = json['image'];
    status = json['status'];
    categoryId = json['categoryId'];
    categoryName = json['categoryName'];
    documents = json['documents'] ?? [];
    createdAt = json['created_at'];
    openingTime = json['openingTime'];
    closingTime = json['closingTime'];
    packingTime = json['packingTime'];
    packingCharge = json['packingCharge'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['storeId'] = storeId;
    data['name'] = name;
    data['contactNo'] = contactNo;
    data['image'] = image;
    data['status'] = status;
    data['categoryId'] = categoryId;
    data['categoryName'] = categoryName;
    data['documents'] = documents;
    data['created_at'] = createdAt;
    data['openingTime'] = openingTime;
    data['closingTime'] = closingTime;
    data['packingTime'] = packingTime;
    data['packingCharge'] = packingCharge;
    data['description'] = description;
    return data;
  }
}
