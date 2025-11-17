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
  String? storeType;
  String? packingtime;
  List<String>? paymentOptions; // new ones
  List<String>? storePaymentOptions; // ✅ existing ones
  String? returnPolicy;
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
    this.storeType,
    this.paymentOptions,
    this.storePaymentOptions,
    this.returnPolicy,
    this.packingcharge,
  });

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
      'storeType': storeType,
      "paymentOptions": paymentOptions,
      "storePaymentOptions": storePaymentOptions, // ✅ added
      "returnPolicy": returnPolicy,
      'storeDocuments': storeDocuments,
    };
  }

  Future<FormData> toFormData() async {
    final formData = FormData();

    void addField(String key, String? value) {
      if (value != null && value.isNotEmpty) {
        formData.fields.add(MapEntry(key, value));
      }
    }

    // --- Normal text fields ---
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
    addField('storeType', storeType);
    addField('returnPolicy', returnPolicy);
    addField('packingCharge', packingcharge);

    // --- Image ---
    if (image != null && await image!.exists()) {
      formData.files.add(MapEntry(
        'storeImage',
        await MultipartFile.fromFile(image!.path,
            filename: image!.path.split('/').last),
      ));
    } else if (storeImage != null && storeImage!.isNotEmpty) {
      addField('storeImage', storeImage);
    }

    // --- Store documents (existing) ---
    if (storeDocuments != null && storeDocuments!.isNotEmpty) {
      formData.fields.add(MapEntry(
        'storeDocuments',
        '[${storeDocuments!.map((e) => '"$e"').join(',')}]',
      ));
    }

    // --- Payment Options (merge existing + new) ---
    final allPayments = <String>{
      ...?storePaymentOptions, // existing ones
      ...?paymentOptions, // new ones
    }.toList();

    if (allPayments.isNotEmpty) {
      for (var option in allPayments) {
        formData.fields.add(MapEntry('paymentOptions[]', option));
      }
    }

    // --- New document files ---
    if (documents != null && documents!.isNotEmpty) {
      for (var doc in documents!) {
        if (await doc.exists()) {
          formData.files.add(MapEntry(
            'storeDocuments',
            await MultipartFile.fromFile(doc.path,
                filename: doc.path.split('/').last),
          ));
        }
      }
    }

    return formData;
  }
}
