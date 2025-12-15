class RevenueResponseModel {
  String? status;
  List<Order>? orders;
  int? totalOrders;
  int? totalSellerEarningAllOrders;
  int? totalProcessingFeeAllOrders;

  RevenueResponseModel({
    this.status,
    this.orders,
    this.totalOrders,
    this.totalSellerEarningAllOrders,
    this.totalProcessingFeeAllOrders,
  });

  RevenueResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['orders'] != null) {
      orders = <Order>[];
      json['orders'].forEach((v) {
        orders!.add(Order.fromJson(v));
      });
    }
    totalOrders = json['totalOrders'];
    totalSellerEarningAllOrders = json['totalSellerEarningAllOrders'];
    totalProcessingFeeAllOrders = json['totalProcessingFeeAllOrders'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    if (orders != null) {
      data['orders'] = orders!.map((v) => v.toJson()).toList();
    }
    data['totalOrders'] = totalOrders;
    data['totalSellerEarningAllOrders'] = totalSellerEarningAllOrders;
    data['totalProcessingFeeAllOrders'] = totalProcessingFeeAllOrders;
    return data;
  }
}

class Order {
  String? id;
  String? userId;
  String? storeId;
  String? uniqueId;
  String? currencyCode;
  String? currencySymbol;
  int? price;
  int? taxAmount;
  int? deliveryCharge;
  int? packingCharge;
  num? total;
  int? itemCount;
  String? walletUsed;
  int? walletAmount;
  List<dynamic>? taxes;
  dynamic adminOffer;
  dynamic categoryOffer;
  List<dynamic>? categoryOfferInfo;
  StoreAddress? storeAddress;
  // DeliveryAddress? deliveryAddress;
  int? deliveryDistance;
  int? sellerSettlement;
  int? driverSettlement;
  String? status;
  int? otp;
  String? deliveryType;
  int? driverAmount;
  bool? notified;
  int? userOtp;
  List<Item>? items;
  List<dynamic>? charges;
  dynamic appliedCoupon;
  num? grandTotal;
  String? acceptance;
  String? createdAt;
  String? updatedAt;
  int? v;
  String? paymentId;
  String? paymentType;
  String? transactionStatus;
  int? totalSellerEarning;
  int? totalProcessingFee;

  Order({
    this.id,
    this.userId,
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
    this.walletUsed,
    this.walletAmount,
    this.taxes,
    this.adminOffer,
    this.categoryOffer,
    this.categoryOfferInfo,
    this.storeAddress,
    // this.deliveryAddress,
    this.deliveryDistance,
    this.sellerSettlement,
    this.driverSettlement,
    this.status,
    this.otp,
    this.deliveryType,
    this.driverAmount,
    this.notified,
    this.userOtp,
    this.items,
    this.charges,
    this.appliedCoupon,
    this.grandTotal,
    this.acceptance,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.paymentId,
    this.paymentType,
    this.transactionStatus,
    this.totalSellerEarning,
    this.totalProcessingFee,
  });

  Order.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    userId = json['userId'];
    storeId = json['storeId'];
    uniqueId = json['uniqueId'];
    currencyCode = json['currencyCode'];
    currencySymbol = json['currencySymbol'];
    price = json['price'];
    taxAmount = json['taxAmount'];
    deliveryCharge = json['deliveryCharge'];
    packingCharge = json['packingCharge'];
    total = json['total'];
    itemCount = json['itemCount'];
    walletUsed = json['walletUsed'];
    walletAmount = json['walletAmount'];
    taxes = json['taxes'];
    adminOffer = json['adminOffer'];
    categoryOffer = json['categoryOffer'];
    categoryOfferInfo = json['categoryOfferInfo'];
    storeAddress = json['storeAddress'] != null
        ? StoreAddress.fromJson(json['storeAddress'])
        : null;
    // deliveryAddress = json['deliveryAddress'] != null
    //     ? DeliveryAddress.fromJson(json['deliveryAddress'])
    //     : null;
    deliveryDistance = json['deliveryDistance'];
    sellerSettlement = json['sellerSettlement'];
    driverSettlement = json['driverSettlement'];
    status = json['status'];
    otp = json['otp'];
    deliveryType = json['delivery_type'];
    driverAmount = json['driverAmount'];
    notified = json['notified'];
    userOtp = json['userOtp'];
    if (json['items'] != null) {
      items = <Item>[];
      json['items'].forEach((v) {
        items!.add(Item.fromJson(v));
      });
    }
    charges = json['charges'];
    appliedCoupon = json['appliedCoupon'];
    grandTotal = json['grand_total'];
    acceptance = json['acceptance'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
    paymentId = json['paymentId'];
    paymentType = json['paymentType'];
    transactionStatus = json['transactionStatus'];
    totalSellerEarning = json['totalSellerEarning'];
    totalProcessingFee = json['totalProcessingFee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = id;
    data['userId'] = userId;
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
    data['walletUsed'] = walletUsed;
    data['walletAmount'] = walletAmount;
    data['taxes'] = taxes;
    data['adminOffer'] = adminOffer;
    data['categoryOffer'] = categoryOffer;
    data['categoryOfferInfo'] = categoryOfferInfo;
    if (storeAddress != null) {
      data['storeAddress'] = storeAddress!.toJson();
    }
    // if (deliveryAddress != null) {
    //   data['deliveryAddress'] = deliveryAddress!.toJson();
    // }
    data['deliveryDistance'] = deliveryDistance;
    data['sellerSettlement'] = sellerSettlement;
    data['driverSettlement'] = driverSettlement;
    data['status'] = status;
    data['otp'] = otp;
    data['delivery_type'] = deliveryType;
    data['driverAmount'] = driverAmount;
    data['notified'] = notified;
    data['userOtp'] = userOtp;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    data['charges'] = charges;
    data['appliedCoupon'] = appliedCoupon;
    data['grand_total'] = grandTotal;
    data['acceptance'] = acceptance;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = v;
    data['paymentId'] = paymentId;
    data['paymentType'] = paymentType;
    data['transactionStatus'] = transactionStatus;
    data['totalSellerEarning'] = totalSellerEarning;
    data['totalProcessingFee'] = totalProcessingFee;
    return data;
  }
}

class StoreAddress {
  Location? location;
  String? address;

  StoreAddress({this.location, this.address});

  StoreAddress.fromJson(Map<String, dynamic> json) {
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['address'] = address;
    return data;
  }
}

class Location {
  String? type;
  List<double>? coordinates;

  Location({this.type, this.coordinates});

  Location.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates']?.cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['type'] = type;
    data['coordinates'] = coordinates;
    return data;
  }
}

// class DeliveryAddress {
//   String? address;
//   double? lat;
//   double? lon;
//   String? location;
//   dynamic addressType;
//   dynamic flatNo;
//   dynamic note;
//   String? isDefault;
//   dynamic id;

//   DeliveryAddress({
//     this.address,
//     this.lat,
//     this.lon,
//     this.location,
//     this.addressType,
//     this.flatNo,
//     this.note,
//     this.isDefault,
//     this.id,
//   });

//   DeliveryAddress.fromJson(Map<String, dynamic> json) {
//     // Handle address - can be string or nested object
//     final addressValue = json['address'];
//     if (addressValue is String) {
//       address = addressValue;
//     } else if (addressValue is Map) {
//       address = addressValue['address']?.toString();
//     }

//     lat = json['lat'] != null ? double.tryParse(json['lat'].toString()) : null;
//     lon = json['lon'] != null ? double.tryParse(json['lon'].toString()) : null;
//     location = json['location']?.toString();
//     addressType = json['address_type'];
//     flatNo = json['flat_no'];
//     note = json['note'];
//     isDefault = json['is_default']?.toString();
//     id = json['id'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     data['address'] = address;
//     data['lat'] = lat;
//     data['lon'] = lon;
//     data['location'] = location;
//     data['address_type'] = addressType;
//     data['flat_no'] = flatNo;
//     data['note'] = note;
//     data['is_default'] = isDefault;
//     data['id'] = id;
//     return data;
//   }
// }

class Item {
  String? itemId;
  String? name;
  String? image;
  int? variantIndex;
  SelectedVariant? selectedVariant;
  int? qty;
  int? price;
  int? subTotal;
  num? totalAmount;
  int? totalProcessingFee;
  int? totalSellerEarning;
  List<ItemCharge>? charges;
  num? processingFee;
  int? sellerEarningAmount;

  Item({
    this.itemId,
    this.name,
    this.image,
    this.variantIndex,
    this.selectedVariant,
    this.qty,
    this.price,
    this.subTotal,
    this.totalAmount,
    this.totalProcessingFee,
    this.totalSellerEarning,
    this.charges,
    this.processingFee,
    this.sellerEarningAmount,
  });

  Item.fromJson(Map<String, dynamic> json) {
    itemId = json['item_id'];
    name = json['name'];
    image = json['image'];
    variantIndex = json['variant_index'];
    selectedVariant = json['selected_variant'] != null
        ? SelectedVariant.fromJson(json['selected_variant'])
        : null;
    qty = json['qty'];
    price = json['price'];
    subTotal = json['sub_total'];
    totalAmount = json['totalAmount'];
    totalProcessingFee = json['totalProcessingFee'];
    totalSellerEarning = json['totalSellerEarning'];
    if (json['charges'] != null) {
      charges = <ItemCharge>[];
      json['charges'].forEach((v) {
        charges!.add(ItemCharge.fromJson(v));
      });
    }
    processingFee = json['processingFee'];
    sellerEarningAmount = json['sellerEarningAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['item_id'] = itemId;
    data['name'] = name;
    data['image'] = image;
    data['variant_index'] = variantIndex;
    if (selectedVariant != null) {
      data['selected_variant'] = selectedVariant!.toJson();
    }
    data['qty'] = qty;
    data['price'] = price;
    data['sub_total'] = subTotal;
    data['totalAmount'] = totalAmount;
    data['totalProcessingFee'] = totalProcessingFee;
    data['totalSellerEarning'] = totalSellerEarning;

    if (charges != null) {
      data['charges'] = charges!.map((v) => v.toJson()).toList();
    }

    data['processingFee'] = processingFee;
    data['sellerEarningAmount'] = sellerEarningAmount;
    return data;
  }
}

class SelectedVariant {
  String? name;
  int? price;
  String? offerAvailable;
  int? offerPrice;
  String? unit;
  int? gst;
  int? cGstInPercent;
  int? cGstInAmount;
  int? sGstInAmount;
  num? totalAmount;
  String? processingFee;
  String? sellerEarningAmount;

  SelectedVariant({
    this.name,
    this.price,
    this.offerAvailable,
    this.offerPrice,
    this.unit,
    this.gst,
    this.cGstInPercent,
    this.cGstInAmount,
    this.sGstInAmount,
    this.totalAmount,
    this.processingFee,
    this.sellerEarningAmount,
  });

  SelectedVariant.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
    offerAvailable = json['offer_available'];
    offerPrice = json['offer_price'];
    unit = json['unit'];
    gst = json['gst'];
    cGstInPercent = json['cGstInPercent'];
    cGstInAmount = json['cGstInAmount'];
    sGstInAmount = json['sGstInAmount'];
    totalAmount = json['totalAmount'];
    processingFee = json['processingFee'];
    sellerEarningAmount = json['sellerEarningAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['price'] = price;
    data['offer_available'] = offerAvailable;
    data['offer_price'] = offerPrice;
    data['unit'] = unit;
    data['gst'] = gst;
    data['cGstInPercent'] = cGstInPercent;
    data['cGstInAmount'] = cGstInAmount;
    data['sGstInAmount'] = sGstInAmount;
    data['totalAmount'] = totalAmount;
    data['processingFee'] = processingFee;
    data['sellerEarningAmount'] = sellerEarningAmount;
    return data;
  }
}

class ItemCharge {
  String? key;
  num? value;

  ItemCharge({this.key, this.value});

  ItemCharge.fromJson(Map<String, dynamic> json) {
    key = json['key'];

    // Convert string to num if needed
    if (json['value'] is String) {
      value = num.tryParse(json['value']);
    } else {
      value = json['value'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['key'] = key;
    data['value'] = value;
    return data;
  }
}
