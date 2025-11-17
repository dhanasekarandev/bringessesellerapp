import 'dart:io';
import 'package:dio/dio.dart';

class StoreReqModel {
  String? name;
  String? contactNo;
  String? categoryId;
  String? sellerId;
  String? lon;
  String? lat;
  String? storeId;
  File? image;
  List<File>? documents;
  String? description;
  String? opentime;
  String? closetime;
  String? packingtime;
  String? storeType;
  String? returnPolicy;
  List<String>? paymentOptions;
  String? packingcharge;

  StoreReqModel(
      {this.name,
      this.contactNo,
      this.categoryId,
      this.sellerId,
      this.lon,
      this.lat,
      this.image,
      this.documents,
      this.description,
      this.closetime,
      this.opentime,
      this.storeId,
      this.storeType,
      this.returnPolicy,
      this.packingcharge,
      this.paymentOptions,
      this.packingtime});

  StoreReqModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    contactNo = json['contactNo'];
    categoryId = json['categoryId'];
    sellerId = json['sellerId'];
    storeId = json['storeId'];
    lon = json['lon'];
    lat = json['lat'];
    description = json['description'];
    opentime = json['openingTime'];
    closetime = json['closingTime'];
    packingcharge = json['packingCharge'];
    packingtime = json['packingTime'];
    storeType = json['storeType'];

    returnPolicy = json['returnPolicy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['contactNo'] = contactNo;
    data['categoryId'] = categoryId;
    data['sellerId'] = sellerId;
    data['storeId'] = storeId;
    data['lon'] = lon;
    data['lat'] = lat;
    data['description'] = description;
    data['openingTime'] = packingtime;
    data['packingCharge'] = packingcharge;
    data['openingTime'] = opentime;
    data['closingTime'] = closetime;
    data['storeType'] = storeType;
    data['returnPolicy'] = returnPolicy;
    // image and documents should be sent via FormData, not JSON
    return data;
  }

  Future<FormData> toFormData() async {
    final formData = FormData();

    // Helper to safely add non-empty fields
    void addField(String key, String? value) {
      if (value != null && value.isNotEmpty) {
        formData.fields.add(MapEntry(key, value));
      }
    }

    // Add text fields (only if not empty)
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
    addField("storeType", storeType);
    addField('packingCharge', packingcharge);
    addField('returnPolicy', returnPolicy);

    if (paymentOptions != null && paymentOptions!.isNotEmpty) {
      for (var option in paymentOptions!) {
        formData.fields.add(MapEntry('paymentOptions[]', option));
      }
    }
    // ✅ Handle image logic
    if (image != null && await image!.exists()) {
      // Send new image file
      formData.files.add(
        MapEntry(
          'image',
          await MultipartFile.fromFile(
            image!.path,
            filename: image!.path.split('/').last,
          ),
        ),
      );
    } else if (image != null && image is! File && image.toString().isNotEmpty) {
      // If you’re using an existing image name (string, not file)
      addField('image', image.toString());
    }

    // ✅ Add documents if available
    if (documents != null && documents!.isNotEmpty) {
      for (var doc in documents!) {
        if (await doc.exists()) {
          formData.files.add(
            MapEntry(
              'documents',
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
