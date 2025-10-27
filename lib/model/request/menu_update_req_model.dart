import 'dart:io';

import 'package:dio/dio.dart';

class MenuUpdateReqModel {
  String? name;
  String? menuId;
  String? subCategoryId;
  int? status;
  String? storeId;
  File? menuImage;
  String? existingImage;

  MenuUpdateReqModel({
    this.name,
    this.menuId,
    this.subCategoryId,
    this.status,
    this.storeId,
    this.menuImage,
    this.existingImage,
  });

  Future<FormData> toFormData() async {
    final Map<String, dynamic> formDataMap = {
      'name': name,
      'menuId': menuId,
      'subCategoryId': subCategoryId,
      'status': status,
      'storeId': storeId,
    };

    if (menuImage != null && File(menuImage!.path).existsSync()) {
      // New file picked
      formDataMap['menuImage'] = await MultipartFile.fromFile(
        menuImage!.path,
        filename: menuImage!.path.split('/').last,
      );
    } else if (existingImage != null && existingImage!.isNotEmpty) {
      // Keep old image
      formDataMap['menuImage'] = existingImage;
    }

    return FormData.fromMap(formDataMap);
  }
}
