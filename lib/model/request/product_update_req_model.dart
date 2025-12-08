import 'dart:io';
import 'dart:convert';
import 'package:bringessesellerapp/model/request/product_req_model.dart';
import 'package:dio/dio.dart';

class ProductUpdateReqModel {
  String? itemId;
  String? sellerId;
  String? storeId;
  String? name;
  String? sku;
  String? menuId;
  String? quantity;
  bool? outOfStock;
  bool? comboOffer;
  double? processingFeeAmount;
  String? description;
  String? isRefund;
  String? noOfDaysToReturn;
  List<Variant>? variants;

  /// New images from gallery
  List<File>? productImages;

  /// Already existing image filenames (for keeping on server)
  List<String>? existingImages;

  /// Optional: images to delete from server
  List<String>? deletedImages;

  ProductUpdateReqModel({
    this.itemId,
    this.sellerId,
    this.storeId,
    this.name,
    this.quantity,
    this.processingFeeAmount,
    this.sku,
    this.menuId,
    this.outOfStock,
    this.comboOffer,
    this.description,
    this.variants,
    this.productImages,
    this.existingImages,
    this.deletedImages,
    this.noOfDaysToReturn,
    this.isRefund,
  });

  /// Normal JSON (useful for debugging)
  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'sellerId': sellerId,
      'storeId': storeId,
      'quantity': quantity,
      'name': name,
      'SKU': sku,
      'menuId': menuId,
      'processingFeeAmount': processingFeeAmount,
      'outOfStock': outOfStock,
      'comboOffer': comboOffer,
      'description': description,
      'variants': variants?.map((v) => v.toJson()).toList(),
      'existingImages': existingImages,
      'deletedImages': deletedImages,
      'isRefund': isRefund,
      'noOfDaysToReturn': noOfDaysToReturn,
    };
  }

  /// Multipart form data (for image upload)
  Future<FormData> toFormData() async {
    final Map<String, dynamic> map = {
      'itemId': itemId,
      'sellerId': sellerId,
      'storeId': storeId,
      'quantity': quantity,
      'name': name,
      'SKU': sku,
      'processingFeeAmount': processingFeeAmount,
      'menuId': menuId,
      'outOfStock': outOfStock,
      'comboOffer': comboOffer,
      'description': description,
      'noOfDaysToReturn': noOfDaysToReturn,
      'isRefund': isRefund,
      'variants': variants != null
          ? jsonEncode(variants!.map((v) => v.toJson()).toList())
          : null,
      'existingImages':
          existingImages != null ? jsonEncode(existingImages) : null,
      'deletedImages': deletedImages != null ? jsonEncode(deletedImages) : null,
    };

    // Attach new images (files)
    if (productImages != null && productImages!.isNotEmpty) {
      map['productImages'] = await Future.wait(productImages!.map((file) async {
        return await MultipartFile.fromFile(file.path,
            filename: file.path.split('/').last);
      }));
    }

    return FormData.fromMap(map);
  }
}
