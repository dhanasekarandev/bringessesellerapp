import 'dart:io';
import 'dart:convert'; // ✅ needed for jsonEncode
import 'package:dio/dio.dart';

class PromotionRequestModel {
  File? appImage; // file object
  String? storeId;
  List<String>? sectionId;
  List<String>? sections;
  String? startDate;
  String? endDate;
  String? type;
  String? url;

  PromotionRequestModel({
    this.appImage,
    this.storeId,
    this.sectionId,
    this.sections,
    this.startDate,
    this.endDate,
    this.type,
    this.url,
  });

  /// ✅ Convert to FormData for multipart request
  Future<FormData> toFormData() async {
    final formData = FormData();


    if (appImage != null) {
      final fileName = appImage!.path.split('/').last;
      formData.files.add(
        MapEntry(
          'appImage',
          await MultipartFile.fromFile(
            appImage!.path,
            filename: fileName,
          ),
        ),
      );
    }

  
    if (storeId != null) formData.fields.add(MapEntry('storeId', storeId!));

    
    if (sectionId != null) {
      formData.fields.add(MapEntry('sectionId', jsonEncode(sectionId)));
    }

    if (sections != null) {
      formData.fields.add(MapEntry('sections', jsonEncode(sections)));
    }

    if (startDate != null) {
      formData.fields.add(MapEntry('startDate', startDate!));
    }

    if (endDate != null) {
      formData.fields.add(MapEntry('endDate', endDate!));
    }

    if (type != null) formData.fields.add(MapEntry('type', type!));
    if (url != null) formData.fields.add(MapEntry('url', url!));

    return formData;
  }
}
