import 'dart:io';
import 'package:dio/dio.dart';

class UploadVideoReqModel {
  File? video;

  UploadVideoReqModel({this.video});

  UploadVideoReqModel.fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    return data;
  }

  /// Convert to FormData for Dio upload
  Future<FormData> toFormData() async {
    final formData = FormData();

    if (video != null) {
      formData.files.add(
        MapEntry(
          'video',
          await MultipartFile.fromFile(
            video!.path,
            filename: video!.path.split('/').last,
          ),
        ),
      );
    }

    return formData;
  }
}
