import 'dart:io';
import 'package:dio/dio.dart';

class MenuCreateReqModel {
  String? name;
  String? subCategoryId;
  int? status;
  String? storeId;
  File? image;

  MenuCreateReqModel({
    this.name,
    this.subCategoryId,
    this.status,
    this.storeId,
    this.image,
  });

  /// Convert to normal JSON (if no image upload)
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['subCategoryId'] = subCategoryId;
    data['status'] = status;
    data['storeId'] = storeId;
    return data;
  }

  /// ✅ Convert to Multipart FormData (for file upload)
  Future<FormData> toFormData() async {
    final Map<String, dynamic> formDataMap = {
      'name': name,
      'subCategoryId': subCategoryId,
      'status': status,
      'storeId': storeId,
    };

    if (image != null) {
      formDataMap['image'] = await MultipartFile.fromFile(
        image!.path,
        filename: image!.path.split('/').last,
      );
    }

    return FormData.fromMap(formDataMap);
  }
}
