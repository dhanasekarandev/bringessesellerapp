class OrderUpdateResponseModel {
  String? status;
  String? message;
  OrderUpdateData? data;

  OrderUpdateResponseModel({this.status, this.message, this.data});

  OrderUpdateResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? OrderUpdateData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (data != null) map['data'] = data!.toJson();
    return map;
  }
}

class OrderUpdateData {
  String? id;
  String? userId;
  String? storeId;
  String? uniqueId;
  String? currencyCode;
  String? currencySymbol;
  int? total;
  int? itemCount;
  String? status;
  int? otp;
  String? createdAt;
  String? updatedAt;

  OrderUpdateData({
    this.id,
    this.userId,
    this.storeId,
    this.uniqueId,
    this.currencyCode,
    this.currencySymbol,
    this.total,
    this.itemCount,
    this.status,
    this.otp,
    this.createdAt,
    this.updatedAt,
  });

  OrderUpdateData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    userId = json['userId'];
    storeId = json['storeId'];
    uniqueId = json['uniqueId'];
    currencyCode = json['currencyCode'];
    currencySymbol = json['currencySymbol'];
    total = (json['total'] as num?)?.toInt();
    itemCount = json['itemCount'];
    status = json['status'];
    otp = json['otp'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['_id'] = id;
    map['userId'] = userId;
    map['storeId'] = storeId;
    map['uniqueId'] = uniqueId;
    map['currencyCode'] = currencyCode;
    map['currencySymbol'] = currencySymbol;
    map['total'] = total;
    map['itemCount'] = itemCount;
    map['status'] = status;
    map['otp'] = otp;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;

    return map;
  }
}
