class ReviewResponseModel {
  int? statusCode;
  String? status;
  ResultModel? result;

  ReviewResponseModel({this.statusCode, this.status, this.result});

  ReviewResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    status = json['status'];
    result =
        json['result'] != null ? ResultModel.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status_code'] = statusCode;
    data['status'] = status;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class ResultModel {
  int? count;
  List<ReviewModel>? reviews;

  ResultModel({this.count, this.reviews});

  ResultModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['reviews'] != null) {
      reviews = <ReviewModel>[];
      json['reviews'].forEach((v) {
        reviews!.add(ReviewModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['count'] = count;
    if (reviews != null) {
      data['reviews'] = reviews!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReviewModel {
  String? id;
  int? v;
  String? type;
  int? status;
  String? review;
  int? rating;
  UserDetailsModel? userDetails;
  String? orderId;
  String? uniqueId;
  StoreDetailsModel? storeDetails;
  String? createdAt;

  ReviewModel(
      {this.id,
      this.v,
      this.type,
      this.status,
      this.review,
      this.rating,
      this.userDetails,
      this.orderId,
      this.uniqueId,
      this.storeDetails,
      this.createdAt});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    v = json['__v'];
    type = json['type'];
    status = json['status'];
    review = json['review'];
    rating = json['rating'];
    userDetails = json['userDetails'] != null
        ? UserDetailsModel.fromJson(json['userDetails'])
        : null;
    orderId = json['orderId'];
    uniqueId = json['uniqueId'];
    storeDetails = json['storeDetails'] != null
        ? StoreDetailsModel.fromJson(json['storeDetails'])
        : null;
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['__v'] = v;
    data['type'] = type;
    data['status'] = status;
    data['review'] = review;
    data['rating'] = rating;
    if (userDetails != null) {
      data['userDetails'] = userDetails!.toJson();
    }
    data['orderId'] = orderId;
    data['uniqueId'] = uniqueId;
    if (storeDetails != null) {
      data['storeDetails'] = storeDetails!.toJson();
    }
    data['created_at'] = createdAt;
    return data;
  }
}

class UserDetailsModel {
  String? id;
  String? contactNo;
  String? uniqueCode;
  String? referId;
  String? deviceType;
  int? walletAmount;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? v;
  String? deviceId;
  String? deviceToken;
  String? email;
  String? name;
  String? image;
  List<UserAddressModel>? address;

  UserDetailsModel(
      {this.id,
      this.contactNo,
      this.uniqueCode,
      this.referId,
      this.deviceType,
      this.walletAmount,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.v,
      this.deviceId,
      this.deviceToken,
      this.email,
      this.name,
      this.image,
      this.address});

  UserDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    contactNo = json['contactNo'];
    uniqueCode = json['uniqueCode'];
    referId = json['referId'];
    deviceType = json['deviceType'];
    walletAmount = json['walletAmount'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
    deviceId = json['deviceId'];
    deviceToken = json['deviceToken'];
    email = json['email'];
    name = json['name'];
    image = json['image'];

    if (json['address'] != null) {
      address = <UserAddressModel>[];
      json['address'].forEach((v) {
        address!.add(UserAddressModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = id;
    data['contactNo'] = contactNo;
    data['uniqueCode'] = uniqueCode;
    data['referId'] = referId;
    data['deviceType'] = deviceType;
    data['walletAmount'] = walletAmount;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = v;
    data['deviceId'] = deviceId;
    data['deviceToken'] = deviceToken;
    data['email'] = email;
    data['name'] = name;
    data['image'] = image;

    if (address != null) {
      data['address'] = address!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserAddressModel {
  double? lat;
  double? lon;
  String? address;
  String? location;
  String? addressType;
  String? flatNo;
  String? note;
  String? isDefault;

  UserAddressModel(
      {this.lat,
      this.lon,
      this.address,
      this.location,
      this.addressType,
      this.flatNo,
      this.note,
      this.isDefault});

  UserAddressModel.fromJson(Map<String, dynamic> json) {
    lat = json['lat']?.toDouble();
    lon = json['lon']?.toDouble();
    address = json['address'];
    location = json['location'];
    addressType = json['address_type'];
    flatNo = json['flat_no'];
    note = json['note'];
    isDefault = json['is_default'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['lat'] = lat;
    data['lon'] = lon;
    data['address'] = address;
    data['location'] = location;
    data['address_type'] = addressType;
    data['flat_no'] = flatNo;
    data['note'] = note;
    data['is_default'] = isDefault;
    return data;
  }
}

class StoreDetailsModel {
  LocationModel? location;
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

  StoreDetailsModel(
      {this.location,
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
      this.returnPolicy});

  StoreDetailsModel.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? LocationModel.fromJson(json['location'])
        : null;
    id = json['_id'];
    name = json['name'];
    contactNo = json['contactNo'];
    sellerId = json['sellerId'];
    categoryId = json['categoryId'];
    documents =
        json['documents'] != null ? List<String>.from(json['documents']) : null;
    image = json['image'];
    status = json['status'];
    featured = json['featured'];
    rating = json['rating'];
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
        : null;
    returnPolicy = json['retunPolicy'];
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
    return data;
  }
}

class LocationModel {
  String? type;
  List<double>? coordinates;

  LocationModel({this.type, this.coordinates});

  LocationModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'] != null
        ? List<double>.from(json['coordinates'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['type'] = type;
    data['coordinates'] = coordinates;
    return data;
  }
}
