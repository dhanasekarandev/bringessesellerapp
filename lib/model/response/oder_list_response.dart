class OderListResponse {
  int? statusCode;
  String? status;
  OrderDetails? orderDetails;
  List<dynamic>? items;

  OderListResponse({
    this.statusCode,
    this.status,
    this.orderDetails,
    this.items,
  });

  OderListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    status = json['status'];
    orderDetails = json['orderDetails'] != null
        ? OrderDetails.fromJson(json['orderDetails'])
        : null;
    items = json['items'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status_code'] = statusCode;
    data['status'] = status;
    if (orderDetails != null) {
      data['orderDetails'] = orderDetails!.toJson();
    }
    data['items'] = items;
    return data;
  }
}

class OrderDetails {
  String? orderId;
  dynamic userDetails;
  String? storeId;
  String? uniqueId;
  String? currencyCode;
  String? currencySymbol;
  double? price;
  double? taxAmount;
  double? deliveryCharge;
  double? packingCharge;
  double? total;
  int? itemCount;
  dynamic taxes;
  String? deliveryType;
  dynamic adminOffer;
  dynamic categoryOffer;
  dynamic categoryOfferInfo;
  dynamic storeAddress;
  dynamic deliveryAddress;
  String? status;
  String? createdAt;
  String? updatedAt;
  List<dynamic>? vehicles;
  String? vehicleId;

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
    this.packingCharge,
    this.total,
    this.itemCount,
    this.taxes,
    this.deliveryType,
    this.adminOffer,
    this.categoryOffer,
    this.categoryOfferInfo,
    this.storeAddress,
    this.deliveryAddress,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.vehicles,
    this.vehicleId,
  });

  OrderDetails.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    userDetails = json['userDetails'];
    storeId = json['storeId'];
    uniqueId = json['uniqueId'];
    currencyCode = json['currencyCode'];
    currencySymbol = json['currencySymbol'];
    price = (json['price'] != null) ? json['price'].toDouble() : null;
    taxAmount = (json['taxAmount'] != null) ? json['taxAmount'].toDouble() : null;
    deliveryCharge =
        (json['deliveryCharge'] != null) ? json['deliveryCharge'].toDouble() : null;
    packingCharge =
        (json['packingCharge'] != null) ? json['packingCharge'].toDouble() : null;
    total = (json['total'] != null) ? json['total'].toDouble() : null;
    itemCount = json['itemCount'];
    taxes = json['taxes'];
    deliveryType = json['delivery_type'];
    adminOffer = json['adminOffer'];
    categoryOffer = json['categoryOffer'];
    categoryOfferInfo = json['categoryOfferInfo'];
    storeAddress = json['storeAddress'];
    deliveryAddress = json['deliveryAddress'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    vehicles = json['vehicles'];
    vehicleId = json['vehicleId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['orderId'] = orderId;
    data['userDetails'] = userDetails;
    data['storeId'] = storeId;
    data['uniqueId'] = uniqueId;
    data['currencyCode'] = currencyCode;
    data['currencySymbol'] = currencySymbol;
    data['price'] = price;
    data['taxAmount'] = taxAmount;
    data['deliveryCharge'] = deliveryCharge;
    data['packingCharge'] = packingCharge;
    data['total'] = total;
    data['itemCount'] = itemCount;
    data['taxes'] = taxes;
    data['delivery_type'] = deliveryType;
    data['adminOffer'] = adminOffer;
    data['categoryOffer'] = categoryOffer;
    data['categoryOfferInfo'] = categoryOfferInfo;
    data['storeAddress'] = storeAddress;
    data['deliveryAddress'] = deliveryAddress;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['vehicles'] = vehicles;
    data['vehicleId'] = vehicleId;
    return data;
  }
}
