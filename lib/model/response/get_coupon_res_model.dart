class CouponListResponse {
  bool? status;
  String? message;
  List<GetCouponData>? data;
  Pagination? pagination;

  CouponListResponse({
    this.status,
    this.message,
    this.data,
    this.pagination,
  });

  factory CouponListResponse.fromJson(Map<String, dynamic> json) {
    return CouponListResponse(
      status: json['status'] == true ||
          json['status'].toString().toLowerCase() == 'true',
      message: json['message'],
      data: json['data'] != null
          ? List<GetCouponData>.from(
              json['data'].map((x) => GetCouponData.fromJson(x)))
          : [],
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "message": message,
      "data": data?.map((x) => x.toJson()).toList(),
      "pagination": pagination?.toJson(),
    };
  }
}

class GetCouponData {
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
  num? remaining;
  String? statusLabel;

  GetCouponData({
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
    this.remaining,
    this.statusLabel,
  });

  factory GetCouponData.fromJson(Map<String, dynamic> json) {
    return GetCouponData(
      id: json['_id'],
      name: json['name'],
      code: json['code'],
      type: json['type'],
      sellerId: json['sellerId'],
      storeId: json['storeId'],
      productIds: json['productIds'] != null
          ? List<dynamic>.from(json['productIds'])
          : [],
      discountType: json['discountType'],
      discountValue: json['discountValue'],
      total: json['total'],
      couponUsed: json['couponUsed'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      status: json['status'] == true ||
          json['status'].toString().toLowerCase() == 'true',
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
      remaining: json['remaining'],
      statusLabel: json['statusLabel'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
      "code": code,
      "type": type,
      "sellerId": sellerId,
      "storeId": storeId,
      "productIds": productIds,
      "discountType": discountType,
      "discountValue": discountValue,
      "total": total,
      "couponUsed": couponUsed,
      "startDate": startDate,
      "endDate": endDate,
      "status": status,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "__v": v,
      "remaining": remaining,
      "statusLabel": statusLabel,
    };
  }
}

class Pagination {
  int? total;
  int? page;
  int? limit;

  Pagination({this.total, this.page, this.limit});

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      total: json['total'],
      page: json['page'],
      limit: json['limit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "total": total,
      "page": page,
      "limit": limit,
    };
  }
}
