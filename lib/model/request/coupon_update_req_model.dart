class CouponUpdateReqModel {
  String? name;
  String? code;
  String? type;
  String? sellerId;
  String? storeId;
  String? discountType;
  num? discountValue;
  num? total;
  String? startDate;
  String? endDate;
  List<String>? productIds;

  CouponUpdateReqModel({
    this.name,
    this.code,
    this.type,
    this.sellerId,
    this.storeId,
    this.discountType,
    this.discountValue,
    this.total,
    this.startDate,
    this.endDate,
    this.productIds,
  });

  CouponUpdateReqModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
    type = json['type'];
    sellerId = json['sellerId'];
    storeId = json['storeId'];
    discountType = json['discountType'];
    discountValue = json['discountValue'];
    total = json['total'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    productIds =
        json['productIds'] != null ? List<String>.from(json['productIds']) : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['name'] = name;
    data['code'] = code;
    data['type'] = type;
    data['sellerId'] = sellerId;
    data['storeId'] = storeId;
    data['discountType'] = discountType;
    data['discountValue'] = discountValue;
    data['total'] = total;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['productIds'] = productIds ?? [];
    return data;
  }
}
