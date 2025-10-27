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
  bool? comboOffer;
  List<File>? productImages;

  ProductCreateReqModel({
    this.sellerId,
    this.storeId,
    this.name,
    this.sku,
    this.menuId,
    this.variants,
    this.description,
    this.comboOffer,
    this.productImages,
  });

  /// Normal JSON (for non-file usage)
  Map<String, dynamic> toJson() {
    return {
      'sellerId': sellerId,
      'storeId': storeId,
      'name': name,
      'SKU': sku,
      'menuId': menuId,
      'variants': variants?.map((v) => v.toJson()).toList(),
      'description': description,
      'comboOffer': comboOffer,
    };
  }

  /// Multipart FormData (for file upload)
  Future<FormData> toFormData() async {
    final Map<String, dynamic> formDataMap = {
      'sellerId': sellerId,
      'storeId': storeId,
      'name': name,
      'SKU': sku,
      'menuId': menuId,
      'variants': variants != null
          ? jsonEncode(variants!.map((v) => v.toJson()).toList())
          : null,
      'description': description,
      'comboOffer': comboOffer,
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

  Variant({
    this.name,
    this.price,
    this.offerAvailable,
    this.offerPrice,
    this.unit,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'offer_available': offerAvailable,
      'offer_price': offerPrice,
      'unit': unit,
    };
  }
}
