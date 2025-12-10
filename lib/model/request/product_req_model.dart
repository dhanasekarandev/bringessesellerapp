import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';

class ProductCreateReqModel {
  String? sellerId;
  String? storeId;
  String? name;
  String? sku;
  String? menuId;
  List<Variant>? variants;
  String? description;
  String? videoUrl;
  String? quantity;
  bool? comboOffer;
  String? type;
  double? processingFeeAmount;
  String? isRefund;
  String? noOfDaysToReturn;
  List<File>? productImages;

  ProductCreateReqModel({
    this.sellerId,
    this.storeId,
    this.name,
    this.type,
    this.processingFeeAmount,
    this.sku,
    this.videoUrl,
    this.quantity,
    this.menuId,
    this.variants,
    this.description,
    this.comboOffer,
    this.noOfDaysToReturn,
    this.productImages,
    this.isRefund,
  });

  /// Normal JSON (for non-file usage)
  Map<String, dynamic> toJson() {
    return {
      'sellerId': sellerId,
      'storeId': storeId,
      'name': name,
      'type': type,
      'SKU': sku,
      'videoUrl': videoUrl,
      'quantity': quantity,
      'menuId': menuId,
      'processingFeeAmount': processingFeeAmount,
      'variants': variants?.map((v) => v.toJson()).toList(),
      'description': description,
      'noOfDaysToReturn': noOfDaysToReturn,
      'comboOffer': comboOffer,
      'isRefund': isRefund,
    };
  }

  /// Multipart FormData (for file upload)
  Future<FormData> toFormData() async {
    final Map<String, dynamic> formDataMap = {
      'sellerId': sellerId,
      'storeId': storeId,
      'name': name,
      'type': type,
      'processingFeeAmount': processingFeeAmount,
      'SKU': sku,
      'videoUrl': videoUrl,
      'quantity': quantity,
      'menuId': menuId,
      'variants': variants != null
          ? jsonEncode(variants!.map((v) => v.toJson()).toList())
          : null,
      'description': description,
      'comboOffer': comboOffer,
      'noOfDaysToReturn': noOfDaysToReturn,
      'isRefund': isRefund
    };

    if (productImages != null && productImages!.isNotEmpty) {
      formDataMap['productImages'] =
          await Future.wait(productImages!.map((img) async {
        return MultipartFile.fromFile(img.path,
            filename: img.path.split('/').last);
      }));
    }

    return FormData.fromMap(formDataMap);
  }
}

class Variant {
  dynamic name;
  double? price;
  String? offerAvailable;
  double? offerPrice;
  String? unit;
  int? weight;
  num? gst;
  num? cGstInPercent;
  num? cGstInAmount;
  num? sGstInAmount;
  num? sGstInPercent;
  num? totalAmount;
  String? sellerEarningAmount;
  String? processingFee;

  Variant(
      {this.name,
      this.price,
      this.offerAvailable,
      this.offerPrice,
      this.unit,
      this.weight,
      this.gst,
      this.cGstInPercent,
      this.cGstInAmount,
      this.sGstInAmount,
      this.sGstInPercent,
      this.sellerEarningAmount,
      this.processingFee,
      this.totalAmount});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'offer_available': offerAvailable,
      'offer_price': offerPrice,
      'unit': unit,
      'weight': weight,
      'gst': gst,
      'cGstInPercent': cGstInPercent,
      'cGstInAmount': cGstInAmount,
      'sGstInAmount': sGstInAmount,
      'sGstInPercent': sGstInPercent,
      'totalAmount': totalAmount,
      'processingFee': processingFee,
      'sellerEarningAmount': sellerEarningAmount,
    };
  }
}
