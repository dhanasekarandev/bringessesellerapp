class OrderListResponse {
  int? statusCode;
  String? status;
  OrderResult? result;

  OrderListResponse({this.statusCode, this.status, this.result});

  OrderListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    status = json['status'];
    result =
        json['result'] != null ? OrderResult.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status_code'] = statusCode;
    data['status'] = status;
    if (result != null) data['result'] = result!.toJson();
    return data;
  }
}

class OrderResult {
  int? count;
  List<OrderDetails>? orders;

  OrderResult({this.count, this.orders});

  OrderResult.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['orders'] != null) {
      orders = (json['orders'] as List)
          .map((v) => OrderDetails.fromJson(v))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['count'] = count;
    if (orders != null) {
      data['orders'] = orders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderDetails {
  String? orderId;
  UserDetails? userDetails;
  String? storeId;
  String? uniqueId;
  String? currencyCode;
  String? currencySymbol;
  double? price;
  double? taxAmount;
  double? deliveryCharge;
  double? total;
  int? itemCount;
  List<Tax>? taxes;
  double? adminOffer;
  double? categoryOffer;
  List<dynamic>? categoryOfferInfo;
  StoreAddress? storeAddress;
  DeliveryAddress? deliveryAddress;
  String? status;
  String? deliveryType;
  String? createdAt;
  String? updatedAt;
  List<Vehicle>? vehicles;

  OrderDetails({
    this.orderId,
    this.userDetails,
    this.storeId,
    this.uniqueId,
    this.currencyCode,
    this.currencySymbol,
    this.price,
    this.taxAmount,
    this.deliveryCharge,
    this.total,
    this.itemCount,
    this.taxes,
    this.adminOffer,
    this.categoryOffer,
    this.categoryOfferInfo,
    this.storeAddress,
    this.deliveryAddress,
    this.status,
    this.deliveryType,
    this.createdAt,
    this.updatedAt,
    this.vehicles,
  });

  OrderDetails.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    userDetails = json['userDetails'] != null
        ? UserDetails.fromJson(json['userDetails'])
        : null;
    storeId = json['storeId'];
    uniqueId = json['uniqueId'];
    currencyCode = json['currencyCode'];
    currencySymbol = json['currencySymbol'];
    price = (json['price'] as num?)?.toDouble();
    taxAmount = (json['taxAmount'] as num?)?.toDouble();
    deliveryCharge = (json['deliveryCharge'] as num?)?.toDouble();
    total = (json['total'] as num?)?.toDouble();
    itemCount = json['itemCount'];
    if (json['taxes'] != null) {
      taxes = (json['taxes'] as List).map((v) => Tax.fromJson(v)).toList();
    }
    adminOffer = (json['adminOffer'] as num?)?.toDouble();
    categoryOffer = (json['categoryOffer'] as num?)?.toDouble();
    categoryOfferInfo = json['categoryOfferInfo'];
    storeAddress = json['storeAddress'] != null
        ? StoreAddress.fromJson(json['storeAddress'])
        : null;
    deliveryAddress = json['deliveryAddress'] != null
        ? DeliveryAddress.fromJson(json['deliveryAddress'])
        : null;
    status = json['status'];
    deliveryType = json['delivery_type'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['vehicles'] != null) {
      vehicles =
          (json['vehicles'] as List).map((v) => Vehicle.fromJson(v)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['orderId'] = orderId;
    if (userDetails != null) data['userDetails'] = userDetails!.toJson();
    data['storeId'] = storeId;
    data['uniqueId'] = uniqueId;
    data['currencyCode'] = currencyCode;
    data['currencySymbol'] = currencySymbol;
    data['price'] = price;
    data['taxAmount'] = taxAmount;
    data['deliveryCharge'] = deliveryCharge;
    data['total'] = total;
    data['itemCount'] = itemCount;
    if (taxes != null) data['taxes'] = taxes!.map((v) => v.toJson()).toList();
    data['adminOffer'] = adminOffer;
    data['categoryOffer'] = categoryOffer;
    data['categoryOfferInfo'] = categoryOfferInfo;
    if (storeAddress != null) data['storeAddress'] = storeAddress!.toJson();
    if (deliveryAddress != null)
      data['deliveryAddress'] = deliveryAddress!.toJson();
    data['status'] = status;
    data['delivery_type'] = deliveryType;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (vehicles != null)
      data['vehicles'] = vehicles!.map((v) => v.toJson()).toList();
    return data;
  }
}

class UserDetails {
  String? id;
  String? contactNo;
  String? email;
  String? name;
  String? image;
  List<Address>? address;

  UserDetails(
      {this.id,
      this.contactNo,
      this.email,
      this.name,
      this.image,
      this.address});

  UserDetails.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    contactNo = json['contactNo'];
    email = json['email'];
    name = json['name'];
    image = json['image'];
    if (json['address'] != null) {
      address =
          (json['address'] as List).map((v) => Address.fromJson(v)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = id;
    data['contactNo'] = contactNo;
    data['email'] = email;
    data['name'] = name;
    data['image'] = image;
    if (address != null) {
      data['address'] = address!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Address {
  double? lat;
  double? lon;
  String? address;
  String? location;
  String? addressType;
  String? isDefault;

  Address({
    this.lat,
    this.lon,
    this.address,
    this.location,
    this.addressType,
    this.isDefault,
  });

  Address.fromJson(Map<String, dynamic> json) {
    lat = (json['lat'] as num?)?.toDouble();
    lon = (json['lon'] as num?)?.toDouble();
    address = json['address'];
    location = json['location'];
    addressType = json['address_type'];
    isDefault = json['is_default'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['lat'] = lat;
    data['lon'] = lon;
    data['address'] = address;
    data['location'] = location;
    data['address_type'] = addressType;
    data['is_default'] = isDefault;
    return data;
  }
}

class Tax {
  String? name;
  double? percentage;
  double? amount;

  Tax({this.name, this.percentage, this.amount});

  Tax.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    percentage = (json['percentage'] as num?)?.toDouble();
    amount = (json['amount'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['percentage'] = percentage;
    data['amount'] = amount;
    return data;
  }
}

class StoreAddress {
  StoreLocation? location;
  String? address;

  StoreAddress({this.location, this.address});

  StoreAddress.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? StoreLocation.fromJson(json['location'])
        : null;
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (location != null) data['location'] = location!.toJson();
    data['address'] = address;
    return data;
  }
}

class StoreLocation {
  String? type;
  List<double>? coordinates;

  StoreLocation({this.type, this.coordinates});

  StoreLocation.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    if (json['coordinates'] != null) {
      coordinates = (json['coordinates'] as List)
          .map((e) => (e as num).toDouble())
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['type'] = type;
    data['coordinates'] = coordinates;
    return data;
  }
}

class DeliveryAddress {
  double? lat;
  double? lon;
  String? address;
  String? location;
  String? addressType;
  String? flatNo;
  String? note;
  String? isDefault;
  int? id;

  DeliveryAddress({
    this.lat,
    this.lon,
    this.address,
    this.location,
    this.addressType,
    this.flatNo,
    this.note,
    this.isDefault,
    this.id,
  });

  DeliveryAddress.fromJson(Map<String, dynamic> json) {
    // CASE 1 → full object
    if (json['address'] is Map) {
      final addr = json['address'];
      lat = (addr['lat'] as num?)?.toDouble();
      lon = (addr['lon'] as num?)?.toDouble();
      address = addr['address'];
      location = addr['location'];
      addressType = addr['address_type'];
      flatNo = addr['flat_no'];
      note = addr['note'];
      isDefault = addr['is_default'];
      id = addr['id'];
    }
    // CASE 2 → just a string
    else if (json['address'] is String) {
      address = json['address'];
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['lat'] = lat;
    data['lon'] = lon;
    data['address'] = address;
    data['location'] = location;
    data['address_type'] = addressType;
    data['flat_no'] = flatNo;
    data['note'] = note;
    data['is_default'] = isDefault;
    data['id'] = id;
    return data;
  }
}

class Vehicle {
  String? id;
  String? name;
  String? image;
  String? category;
  int? status;

  Vehicle({this.id, this.name, this.image, this.category, this.status});

  Vehicle.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    image = json['image'];
    category = json['category'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['category'] = category;
    data['status'] = status;
    return data;
  }
}
