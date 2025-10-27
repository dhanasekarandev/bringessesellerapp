class BannerResponseModel {
  String? status;
  List<BannerItem>? banners;
  int? count;

  BannerResponseModel({this.status, this.banners, this.count});

  BannerResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['banners'] != null) {
      banners = <BannerItem>[];
      json['banners'].forEach((v) {
        banners!.add(BannerItem.fromJson(v));
      });
    }
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    if (banners != null) {
      data['banners'] = banners!.map((v) => v.toJson()).toList();
    }
    data['count'] = count;
    return data;
  }
}

class BannerItem {
  String? id;
  String? storeId;
  List<String>? sectionId;
  List<String>? displaySection;
  String? appImage;
  String? userType;
  String? type;
  String? sourceId;
  String? url;
  DateTime? startDate;
  DateTime? endDate;
  int? status;
  int? paymentStatus;
  double? totalPrice;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? transactionId;
  Location? location;

  BannerItem({
    this.id,
    this.storeId,
    this.sectionId,
    this.displaySection,
    this.appImage,
    this.userType,
    this.type,
    this.sourceId,
    this.url,
    this.startDate,
    this.endDate,
    this.status,
    this.paymentStatus,
    this.totalPrice,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.transactionId,
    this.location,
  });

  BannerItem.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    storeId = json['storeId'];
    sectionId = json['sectionId'] != null ? List<String>.from(json['sectionId']) : [];
    displaySection = json['displaySection'] != null ? List<String>.from(json['displaySection']) : [];
    appImage = json['appImage'];
    userType = json['userType'];
    type = json['type'];
    sourceId = json['sourceId'];
    url = json['url'];
    startDate = json['startDate'] != null ? DateTime.parse(json['startDate']) : null;
    endDate = json['endDate'] != null ? DateTime.parse(json['endDate']) : null;
    status = json['status'];
    paymentStatus = json['paymentStatus'];
    totalPrice = json['totalPrice']?.toDouble();
    createdAt = json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null;
    updatedAt = json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null;
    v = json['__v'];
    transactionId = json['transactionId'];
    location = json['location'] != null ? Location.fromJson(json['location']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = id;
    data['storeId'] = storeId;
    data['sectionId'] = sectionId;
    data['displaySection'] = displaySection;
    data['appImage'] = appImage;
    data['userType'] = userType;
    data['type'] = type;
    data['sourceId'] = sourceId;
    data['url'] = url;
    data['startDate'] = startDate?.toIso8601String();
    data['endDate'] = endDate?.toIso8601String();
    data['status'] = status;
    data['paymentStatus'] = paymentStatus;
    data['totalPrice'] = totalPrice;
    data['createdAt'] = createdAt?.toIso8601String();
    data['updatedAt'] = updatedAt?.toIso8601String();
    data['__v'] = v;
    data['transactionId'] = transactionId;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    return data;
  }
}

class Location {
  String? type;
  List<double>? coordinates;

  Location({this.type, this.coordinates});

  Location.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'] != null ? List<double>.from(json['coordinates'].map((x) => x.toDouble())) : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['type'] = type;
    data['coordinates'] = coordinates;
    return data;
  }
}
