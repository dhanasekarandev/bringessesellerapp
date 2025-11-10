import 'package:dio/dio.dart';

class CreateCouponReqModel {
  String? name;
  String? code;
  String? type;
  String? sellerId;
  String? storeId;
  String? discountType;
  String? discountValue;
  String? total;
  String? startDate;
  String? endDate;
  List<String>? productIds;

  CreateCouponReqModel({
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

  /// Convert to simple JSON (for normal API requests)
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
    data['startDate'] = startDate ?? '';
    data['endDate'] = endDate ?? '';
    data['productIds'] = productIds ?? [];
    return data;
  }

  /// ✅ Convert to FormData (for x-www-form-urlencoded or multipart upload)
  Future<FormData> toFormData() async {
    final Map<String, dynamic> formDataMap = {
      'name': name,
      'code': code,
      'type': type,
      'sellerId': sellerId,
      'storeId': storeId,
      'discountType': discountType,
      'discountValue': discountValue,
      'total': total,
      'startDate': startDate ?? '',
      'endDate': endDate ?? '',
      'productIds': productIds ?? [],
    };

    return FormData.fromMap(formDataMap);
  }
}
