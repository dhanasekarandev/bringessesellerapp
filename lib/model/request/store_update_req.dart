import 'dart:io';
import 'package:dio/dio.dart';

class StoreUpdateReq {
  String? name;
  String? contactNo;
  String? categoryId;
  String? sellerId;
  String? lon;
  String? lat;
  String? storeId;
  File? image; // new image file
  String? storeImage; // existing image name
  List<File>? documents; // new files
  List<String>? storeDocuments; // existing file names
  String? description;
  String? opentime;
  String? closetime;
  String? packingtime;
  String? packingcharge;

  StoreUpdateReq({
    this.name,
    this.contactNo,
    this.categoryId,
    this.sellerId,
    this.lon,
    this.lat,
    this.storeId,
    this.image,
    this.storeImage,
    this.documents,
    this.storeDocuments,
    this.description,
    this.opentime,
    this.closetime,
    this.packingtime,
    this.packingcharge,
  });

  /// ✅ JSON version — used for debugging or raw API
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'contactNo': contactNo,
      'categoryId': categoryId,
      'sellerId': sellerId,
      'storeId': storeId,
      'lon': lon,
      'lat': lat,
      'description': description,
      'openingTime': opentime,
      'closingTime': closetime,
      'packingTime': packingtime,
      'packingCharge': packingcharge,
      'storeImage': storeImage,
      'storeDocuments': storeDocuments, // ✅ stays as List<String>
    };
  }

  /// ✅ Converts to FormData for Dio request
  Future<FormData> toFormData() async {
    final formData = FormData();

    // Helper to add fields safely
    void addField(String key, String? value) {
      if (value != null && value.isNotEmpty) {
        formData.fields.add(MapEntry(key, value));
      }
    }

    // --- Add normal text fields ---
    addField('name', name);
    addField('contactNo', contactNo);
    addField('categoryId', categoryId);
    addField('sellerId', sellerId);
    addField('storeId', storeId);
    addField('lon', lon);
    addField('lat', lat);
    addField('description', description);
    addField('openingTime', opentime);
    addField('closingTime', closetime);
    addField('packingTime', packingtime);
    addField('packingCharge', packingcharge);

    // --- Add image field ---
    if (image != null && await image!.exists()) {
      formData.files.add(
        MapEntry(
          'storeImage',
          await MultipartFile.fromFile(
            image!.path,
            filename: image!.path.split('/').last,
          ),
        ),
      );
    } else if (storeImage != null && storeImage!.isNotEmpty) {
      addField('storeImage', storeImage);
    }

    // --- ✅ Correct storeDocuments format (as JSON array) ---
    if (storeDocuments != null && storeDocuments!.isNotEmpty) {
      formData.fields.add(MapEntry(
        'storeDocuments',
        '[${storeDocuments!.map((e) => '"$e"').join(',')}]',
      ));
    }

    // --- Add new document files ---
    if (documents != null && documents!.isNotEmpty) {
      for (var doc in documents!) {
        if (await doc.exists()) {
          formData.files.add(
            MapEntry(
              'storeDocuments',
              await MultipartFile.fromFile(
                doc.path,
                filename: doc.path.split('/').last,
              ),
            ),
          );
        }
      }
    }

    return formData;
  }
}
