class CreateCouponResponseModel {
  bool? status;
  String? message;
  CouponData? data;

  CreateCouponResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory CreateCouponResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateCouponResponseModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? CouponData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class CouponData {
  String? id;
  String? name;
  String? code;
  String? type;
  String? sellerId;
  String? storeId;
  List<String>? productIds;
  String? discountType;
  num? discountValue;
  num? total;
  num? couponUsed;
  String? startDate;
  String? endDate;
  bool? status;
  String? createdAt;
  String? updatedAt;
  int? v;

  CouponData({
    this.id,
    this.name,
    this.code,
    this.type,
    this.sellerId,
    this.storeId,
    this.productIds,
    this.discountType,
    this.discountValue,
    this.total,
    this.couponUsed,
    this.startDate,
    this.endDate,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory CouponData.fromJson(Map<String, dynamic> json) {
    return CouponData(
      id: json['_id'],
      name: json['name'],
      code: json['code'],
      type: json['type'],
      sellerId: json['sellerId'],
      storeId: json['storeId'],
      productIds: json['productIds'] != null
          ? List<String>.from(json['productIds'])
          : [],
      discountType: json['discountType'],
      discountValue: json['discountValue'],
      total: json['total'],
      couponUsed: json['couponUsed'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      status: json['status'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['type'] = type;
    data['sellerId'] = sellerId;
    data['storeId'] = storeId;
    data['productIds'] = productIds;
    data['discountType'] = discountType;
    data['discountValue'] = discountValue;
    data['total'] = total;
    data['couponUsed'] = couponUsed;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = v;
    return data;
  }
}
