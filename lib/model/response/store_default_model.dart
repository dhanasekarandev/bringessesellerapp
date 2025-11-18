class StoreDefaultModel {
  int? statusCode;
  String? status;
  Result? result;
  AppSettings? appSettings;
  StoreType? storeType;

  StoreDefaultModel(
      {this.statusCode,
      this.status,
      this.result,
      this.appSettings,
      this.storeType});

  StoreDefaultModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    status = json['status'];
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
    appSettings = json['appSettings'] != null
        ? AppSettings.fromJson(json['appSettings'])
        : null;
    storeType =
        json['stores'] != null ? StoreType.fromJson(json['stores']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status_code'] = statusCode;
    data['status'] = status;
    if (result != null) data['result'] = result!.toJson();
    if (appSettings != null) data['appSettings'] = appSettings!.toJson();
    if (storeType != null) data['stores'] = storeType!.toJson();
    return data;
  }
}

class Result {
  List<Category>? categories;
  List<Subcategory>? subcategories;
  Map<String, dynamic>? seller;
  List<Unit>? units;
  List<Menu>? menus;
  String? stripePayoutUrl;
  String? subscriptionUrl;
  String? mediaUrl;
  List<Section>? sections;

  Result(
      {this.categories,
      this.subcategories,
      this.seller,
      this.units,
      this.menus,
      this.stripePayoutUrl,
      this.subscriptionUrl,
      this.mediaUrl,
      this.sections});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      categories = <Category>[];
      json['categories'].forEach((v) {
        categories!.add(Category.fromJson(v));
      });
    }
    if (json['subcategories'] != null) {
      subcategories = <Subcategory>[];
      json['subcategories'].forEach((v) {
        subcategories!.add(Subcategory.fromJson(v));
      });
    }
    seller = json['seller'] ?? {};
    if (json['units'] != null) {
      units = <Unit>[];
      json['units'].forEach((v) {
        units!.add(Unit.fromJson(v));
      });
    }
    menus = json['menus'] != null
        ? List<Menu>.from(json['menus'].map((v) => Menu.fromJson(v)))
        : [];

    stripePayoutUrl = json['stripePayoutUrl'];
    subscriptionUrl = json['subscriptionUrl'];
    mediaUrl = json['mediaUrl'];
    if (json['sections'] != null) {
      sections = <Section>[];
      json['sections'].forEach((v) {
        sections!.add(Section.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (categories != null)
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    data['subcategories'] = subcategories;
    data['seller'] = seller;
    if (units != null) data['units'] = units!.map((v) => v.toJson()).toList();
    data['menus'] = menus;
    data['stripePayoutUrl'] = stripePayoutUrl;
    data['subscriptionUrl'] = subscriptionUrl;
    data['mediaUrl'] = mediaUrl;
    if (sections != null)
      data['sections'] = sections!.map((v) => v.toJson()).toList();
    return data;
  }
}

class Menu {
  String? id;
  String? name;
  String? subCategoryId;
  String? subCategoryName;

  Menu({this.id, this.name, this.subCategoryId, this.subCategoryName});

  Menu.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    subCategoryId = json['subCategoryId'];
    subCategoryName = json['subCategoryName'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subCategoryId': subCategoryId,
      'subCategoryName': subCategoryName,
    };
  }
}

class Category {
  String? id;
  String? name;

  Category({this.id, this.name});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

class Subcategory {
  String? id;
  String? name;

  Subcategory({this.id, this.name});

  Subcategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Unit {
  String? id;
  String? name;

  Unit({this.id, this.name});

  Unit.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

class Section {
  String? id;
  String? type;
  String? price;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? v;

  Section(
      {this.id,
      this.type,
      this.price,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.v});

  Section.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    type = json['type'];
    price = json['price'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'type': type,
      'price': price,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}

class AppSettings {
  String? id;
  String? siteName;
  String? freeDeliveryForAllOrder;
  int? freeDeliveryForMinimumAmt;
  String? freeDeliveryForParentCategory;
  String? sellerDeliveryOption;
  int? referralAmount;
  int? maxSearchDistance;
  int? minSearchDistance;
  int? pickupOrderCount;
  String? googleMapKey;
  String? firebaseFCMKey;
  String? firebaseAPIKey;
  String? stripePrivateKey;
  String? stripePublicKey;
  String? razorKey;
  String? razorSecret;
  String? stripeClientId;
  int? processingFee;
  // ... add remaining fields similarly

  AppSettings(
      {this.id,
      this.siteName,
      this.freeDeliveryForAllOrder,
      this.freeDeliveryForMinimumAmt,
      this.freeDeliveryForParentCategory,
      this.sellerDeliveryOption,
      this.referralAmount,
      this.maxSearchDistance,
      this.minSearchDistance,
      this.pickupOrderCount,
      this.googleMapKey,
      this.firebaseFCMKey,
      this.firebaseAPIKey,
      this.stripePrivateKey,
      this.stripePublicKey,
      this.razorKey,
      this.razorSecret,
      this.stripeClientId,
      this.processingFee});

  AppSettings.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    siteName = json['siteName'];
    freeDeliveryForAllOrder = json['freeDeliveryForAllOrder'];
    freeDeliveryForMinimumAmt = json['freeDeliveryForMinimumAmt'];
    freeDeliveryForParentCategory = json['freeDeliveryForParentCategory'];
    sellerDeliveryOption = json['sellerDeliveryOption'];
    referralAmount = json['referralAmount'];
    maxSearchDistance = json['maxSearchDistance'];
    minSearchDistance = json['minSearchDistance'];
    pickupOrderCount = json['pickupOrderCount'];
    googleMapKey = json['googleMapKey'];
    firebaseFCMKey = json['firebaseFCMKey'];
    firebaseAPIKey = json['firebaseAPIKey'];
    stripePrivateKey = json['stripePrivateKey'];
    stripePublicKey = json['stripePublicKey'];
    razorKey = json['razorKey'];
    razorSecret = json['razorSecret'];
    processingFee = json['processingFee'];
    stripeClientId = json['stripeClientId'];
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'siteName': siteName,
      'freeDeliveryForAllOrder': freeDeliveryForAllOrder,
      'freeDeliveryForMinimumAmt': freeDeliveryForMinimumAmt,
      'freeDeliveryForParentCategory': freeDeliveryForParentCategory,
      'sellerDeliveryOption': sellerDeliveryOption,
      'referralAmount': referralAmount,
      'maxSearchDistance': maxSearchDistance,
      'minSearchDistance': minSearchDistance,
      'pickupOrderCount': pickupOrderCount,
      'googleMapKey': googleMapKey,
      'firebaseFCMKey': firebaseFCMKey,
      'firebaseAPIKey': firebaseAPIKey,
      'stripePrivateKey': stripePrivateKey,
      'stripePublicKey': stripePublicKey,
      'razorKey': razorKey,
      'razorSecret': razorSecret,
      'processingFee': processingFee,
      'stripeClientId': stripeClientId,
    };
  }
}

class StoreType {
  int? small;
  int? medium;
  int? large;
  StoreType({required this.small, required this.medium, required this.large});

  StoreType.fromJson(Map<String, dynamic> json) {
    small = json['small'];
    medium = json['medium'];
    large = json['large'];
  }

  Map<String, dynamic> toJson() {
    return {'small': small, 'medium': medium, 'large': large};
  }
}
