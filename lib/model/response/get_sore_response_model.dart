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
  String? address;
  String? image;
  int? status;
  String? categoryId;
  String? categoryName;
  List<dynamic>? documents;
  String? createdAt;
  String? openingTime;
  String? closingTime;
  int? packingTime;
  int? packingCharge;
  String? description;
  double? lat;
  double? lon;
  String? storeType;
  String? returnPolicy;
  List<String>? paymentOptions;

  Result({
    this.storeId,
    this.name,
    this.contactNo,
    this.address,
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
    this.lat,
    this.lon,
    this.storeType,
    this.returnPolicy,
    this.paymentOptions,
  });

  Result.fromJson(Map<String, dynamic> json) {
    storeId = json['storeId'];
    name = json['name'];
    contactNo = json['contactNo'];
    address = json['address'];
    image = json['image'];
    status = json['status'];
    categoryId = json['categoryId'];
    categoryName = json['categoryName'];
    documents =
        json['documents'] != null ? List<dynamic>.from(json['documents']) : [];
    createdAt = json['created_at'];
    openingTime = json['openingTime'];
    closingTime = json['closingTime'];
    packingTime = json['packingTime'];
    packingCharge = json['packingCharge'];
    description = json['description'];
    lat = (json['lat'] != null) ? json['lat'].toDouble() : null;
    lon = (json['lon'] != null) ? json['lon'].toDouble() : null;
    storeType = json['storeType'];
    returnPolicy = json['returnPolicy'];
    paymentOptions = json['paymentOptions'] != null
        ? List<String>.from(json['paymentOptions'])
        : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['storeId'] = storeId;
    data['name'] = name;
    data['contactNo'] = contactNo;
    data['address'] = address;
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
    data['lat'] = lat;
    data['lon'] = lon;
    data['storeType'] = storeType;
    data['returnPolicy'] = returnPolicy;
    data['paymentOptions'] = paymentOptions;
    return data;
  }
}
