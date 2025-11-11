class CouponUpdateResponse {
  int? statusCode;
  bool? status;
  String? message;
  CouponResult? result;

  CouponUpdateResponse({
    this.statusCode,
    this.status,
    this.message,
    this.result,
  });

  CouponUpdateResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    status = json['status'];
    message = json['message'];
    result =
        json['result'] != null ? CouponResult.fromJson(json['result']) : null;
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

class CouponResult {
  String? id;
  String? name;
  String? code;
  String? type;
  String? sellerId;
  String? storeId;
  List<dynamic>? productIds;
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

  CouponResult({
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

  CouponResult.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    code = json['code'];
    type = json['type'];
    sellerId = json['sellerId'];
    storeId = json['storeId'];
    productIds = json['productIds'] != null
        ? List<dynamic>.from(json['productIds'])
        : [];
    discountType = json['discountType'];
    discountValue = json['discountValue'];
    total = json['total'];
    couponUsed = json['couponUsed'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    status = json['status'] == true ||
        json['status'].toString().toLowerCase() == 'true';
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
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
