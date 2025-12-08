import 'dart:io';
import 'dart:convert';
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
  String? deliveryCharge;
  bool? isfood;
  String? deliveryType;
  String? returnPolicy;
  List<String>? paymentOptions;
  String? packingcharge;

  StoreReqModel({
    this.name,
    this.contactNo,
    this.categoryId,
    this.sellerId,
    this.lon,
    this.lat,
    this.storeId,
    this.image,
    this.documents,
    this.description,
    this.opentime,
    this.closetime,
    this.packingtime,
    this.storeType,
    this.deliveryCharge,
    this.isfood,
    this.deliveryType,
    this.returnPolicy,
    this.paymentOptions,
    this.packingcharge,
  });

  StoreReqModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    contactNo = json['contactNo'];
    categoryId = json['categoryId'];
    sellerId = json['sellerId'];
    storeId = json['storeId'];
    isfood = json['isfood'];
    deliveryCharge = json['deliveryCharge'];
    lon = json['lon'];
    lat = json['lat'];
    deliveryType = json['deliveryType'];
    description = json['description'];
    opentime = json['openingTime'];
    closetime = json['closingTime'];
    packingtime = json['packingTime'];
    storeType = json['storeType'];
    returnPolicy = json['returnPolicy'];
    packingcharge = json['packingCharge'];
    paymentOptions = json['paymentOptions'] != null
        ? List<String>.from(json['paymentOptions'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['contactNo'] = contactNo;
    data['categoryId'] = categoryId;
    data['sellerId'] = sellerId;
    data['storeId'] = storeId;
    data['isfood'] = isfood;
    data['deliveryCharge'] = deliveryCharge;
    data['deliveryType'] = deliveryType;
    data['lon'] = lon;
    data['lat'] = lat;
    data['description'] = description;
    data['openingTime'] = opentime;
    data['closingTime'] = closetime;
    data['packingTime'] = packingtime;
    data['storeType'] = storeType;
    data['returnPolicy'] = returnPolicy;
    data['packingCharge'] = packingcharge;
    data['paymentOptions'] = paymentOptions;
    return data;
  }

  Future<FormData> toFormData() async {
    final formData = FormData();

    void addField(String key, dynamic value) {
      if (value != null) {
        formData.fields.add(MapEntry(key, value.toString()));
      }
    }

    // Add text/boolean fields
    addField('name', name);
    addField('contactNo', contactNo);
    addField('categoryId', categoryId);
    addField('sellerId', sellerId);
    addField('storeId', storeId);
    addField('isfood', isfood);
    addField('lon', lon);
    addField('lat', lat);
    addField('deliveryType', deliveryType);
    addField('deliveryCharge', deliveryCharge);
    addField('description', description);
    addField('openingTime', opentime);
    addField('closingTime', closetime);
    addField('packingTime', packingtime);
    addField('storeType', storeType);
    addField('returnPolicy', returnPolicy);
    addField('packingCharge', packingcharge);

    // Add payment options as JSON array
    if (paymentOptions != null && paymentOptions!.isNotEmpty) {
      addField('paymentOptions', jsonEncode(paymentOptions));
    }

    // Add image
    if (image != null && await image!.exists()) {
      formData.files.add(MapEntry(
        'image',
        await MultipartFile.fromFile(
          image!.path,
          filename: image!.path.split('/').last,
        ),
      ));
    }

    // Add multiple documents
    if (documents != null && documents!.isNotEmpty) {
      for (var doc in documents!) {
        if (await doc.exists()) {
          formData.files.add(MapEntry(
            'documents', // note the []
            await MultipartFile.fromFile(
              doc.path,
              filename: doc.path.split('/').last,
            ),
          ));
        }
      }
    }

    return formData;
  }
}
