class StoreUpdateStatusResponse {
  int? statusCode;
  String? status;
  String? message;
  StoreResult? result;

  StoreUpdateStatusResponse({
    this.statusCode,
    this.status,
    this.message,
    this.result,
  });

  StoreUpdateStatusResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    status = json['status'];
    message = json['message'];
    result = json['result'] != null ? StoreResult.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status_code'] = statusCode;
    data['status'] = status;
    data['message'] = message;
    if (result != null) data['result'] = result!.toJson();
    return data;
  }
}

class StoreResult {
  Location? location;
  String? id;
  String? name;
  int? contactNo;
  String? sellerId;
  String? categoryId;
  List<String>? documents;
  String? image;
  int? status;
  int? featured;
  double? rating;
  String? createdAt;
  String? updatedAt;
  int? v;
  String? closingTime;
  String? description;
  String? openingTime;
  int? packingCharge;
  int? packingTime;
  String? address;
  String? storeType;
  List<String>? paymentOptions;
  String? returnPolicy;
  bool? isFood;
  String? referralCode;
  bool? isActive;

  StoreResult({
    this.location,
    this.id,
    this.name,
    this.contactNo,
    this.sellerId,
    this.categoryId,
    this.documents,
    this.image,
    this.status,
    this.featured,
    this.rating,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.closingTime,
    this.description,
    this.openingTime,
    this.packingCharge,
    this.packingTime,
    this.address,
    this.storeType,
    this.paymentOptions,
    this.returnPolicy,
    this.isFood,
    this.referralCode,
    this.isActive,
  });

  StoreResult.fromJson(Map<String, dynamic> json) {
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    id = json['_id'];
    name = json['name'];
    contactNo = json['contactNo'];
    sellerId = json['sellerId'];
    categoryId = json['categoryId'];

    documents = json['documents'] != null
        ? List<String>.from(json['documents'])
        : [];

    image = json['image'];
    status = json['status'];
    featured = json['featured'];
    rating = (json['rating'] ?? 0).toDouble();

    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
    closingTime = json['closingTime'];
    description = json['description'];
    openingTime = json['openingTime'];
    packingCharge = json['packingCharge'];
    packingTime = json['packingTime'];
    address = json['address'];
    storeType = json['storeType'];

    paymentOptions = json['paymentOptions'] != null
        ? List<String>.from(json['paymentOptions'])
        : [];

    returnPolicy = json['retunPolicy'];

    // Convert "true"/"false" → bool
    isFood = json['isFood'] == "true" || json['isFood'] == true;
    isActive = json['isActive'] == "true" || json['isActive'] == true;

    referralCode = json['referralCode'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (location != null) data['location'] = location!.toJson();

    data['_id'] = id;
    data['name'] = name;
    data['contactNo'] = contactNo;
    data['sellerId'] = sellerId;
    data['categoryId'] = categoryId;
    data['documents'] = documents;
    data['image'] = image;
    data['status'] = status;
    data['featured'] = featured;
    data['rating'] = rating;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = v;
    data['closingTime'] = closingTime;
    data['description'] = description;
    data['openingTime'] = openingTime;
    data['packingCharge'] = packingCharge;
    data['packingTime'] = packingTime;
    data['address'] = address;
    data['storeType'] = storeType;
    data['paymentOptions'] = paymentOptions;
    data['retunPolicy'] = returnPolicy;
    data['isFood'] = isFood;
    data['referralCode'] = referralCode;
    data['isActive'] = isActive;

    return data;
  }
}

class Location {
  String? type;
  List<double>? coordinates;

  Location({this.type, this.coordinates});

  Location.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'] != null
        ? List<double>.from(json['coordinates'].map((x) => x.toDouble()))
        : [];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['type'] = type;
    data['coordinates'] = coordinates;
    return data;
  }
}
