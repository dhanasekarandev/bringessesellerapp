class ViewProfileModel {
  int? statusCode;
  String? status;
  Result? result;
  String? message;

  ViewProfileModel({
    this.statusCode,
    this.status,
    this.result,
    this.message,
  });

  ViewProfileModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    status = json['status'];
    message = json['message'];
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
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

class Result {
  String? sellerId;
  String? name;
  String? email;
  String? contactNo;
  String? paymentStatus;
  // StoreDetails? storeDetails;
  int? subscriptionStatus;
  String? subscriptionExpiryAt;

  Result({
    this.sellerId,
    this.name,
    this.email,
    this.contactNo,
    this.paymentStatus,
    //  this.storeDetails,
    this.subscriptionStatus,
    this.subscriptionExpiryAt,
  });

  Result.fromJson(Map<String, dynamic> json) {
    sellerId = json['sellerId'];
    name = json['name'];
    email = json['email'];
    contactNo = json['contactNo'];
    paymentStatus = json['paymentStatus'];
    subscriptionStatus = json['subscriptionStatus'];
    subscriptionExpiryAt = json['subscriptionExpiryAt'];
    //  storeDetails = json['storeDetails'] != null
    //     ? StoreDetails.fromJson(json['storeDetails'])
    //     : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['sellerId'] = sellerId;
    data['name'] = name;
    data['email'] = email;
    data['contactNo'] = contactNo;
    data['paymentStatus'] = paymentStatus;
    // if (storeDetails != null) {
    //   data['storeDetails'] = storeDetails!.toJson();
    // }
    data['subscriptionStatus'] = subscriptionStatus;
    data['subscriptionExpiryAt'] = subscriptionExpiryAt;
    return data;
  }
}

class StoreDetails {
  Location? location;
  String? id;
  String? name;
  String? contactNo;
  String? sellerId;
  String? categoryId;
  List<String>? documents;
  String? image;
  int? status;
  int? featured;
  double? rating;
  String? createdAt;
  String? updatedAt;
  String? closingTime;
  String? description;
  String? openingTime;
  int? packingCharge;
  int? packingTime;

  StoreDetails({
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
    this.closingTime,
    this.description,
    this.openingTime,
    this.packingCharge,
    this.packingTime,
  });

  StoreDetails.fromJson(Map<String, dynamic> json) {
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    id = json['_id'];
    name = json['name'];
    contactNo = json['contactNo'];
    sellerId = json['sellerId'];
    categoryId = json['categoryId'];
    documents =
        json['documents'] != null ? List<String>.from(json['documents']) : [];
    image = json['image'];
    status = json['status'];
    featured = json['featured'];
    rating = (json['rating'] is int)
        ? (json['rating'] as int).toDouble()
        : json['rating']?.toDouble();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    closingTime = json['closingTime'];
    description = json['description'];
    openingTime = json['openingTime'];
    packingCharge = json['packingCharge'];
    packingTime = json['packingTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (location != null) {
      data['location'] = location!.toJson();
    }
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
    data['closingTime'] = closingTime;
    data['description'] = description;
    data['openingTime'] = openingTime;
    data['packingCharge'] = packingCharge;
    data['packingTime'] = packingTime;
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
    final Map<String, dynamic> data = {};
    data['type'] = type;
    data['coordinates'] = coordinates;
    return data;
  }
}
