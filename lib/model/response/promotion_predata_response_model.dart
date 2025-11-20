class PromotionPredataResponseModel {
  String? status;
  List<Store>? stores;
  List<Section>? sections;
  AppData? appData;

  PromotionPredataResponseModel(
      {this.status, this.stores, this.sections, this.appData});

  PromotionPredataResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['stores'] != null) {
      stores = <Store>[];
      json['stores'].forEach((v) {
        stores!.add(Store.fromJson(v));
      });
    }
    if (json['sections'] != null) {
      sections = <Section>[];
      json['sections'].forEach((v) {
        sections!.add(Section.fromJson(v));
      });
    }
    appData =
        json['appData'] != null ? AppData.fromJson(json['appData']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    if (stores != null) {
      data['stores'] = stores!.map((v) => v.toJson()).toList();
    }
    if (sections != null) {
      data['sections'] = sections!.map((v) => v.toJson()).toList();
    }
    if (appData != null) {
      data['appData'] = appData!.toJson();
    }
    return data;
  }
}

class Store {
  Location? location;
  String? id;
  String? name;
  dynamic contactNo;
  String? sellerId;
  String? categoryId;
  String? address;
  List<String>? documents;
  String? image;
  String? description;
  String? openingTime;
  String? closingTime;
  int? packingTime;
  int? packingCharge;
  int? status;
  int? featured;
  // double? rating;
  String? createdAt;
  String? updatedAt;
  int? v;

  Store(
      {this.location,
      this.id,
      this.name,
      this.contactNo,
      this.sellerId,
      this.categoryId,
      this.address,
      this.documents,
      this.image,
      this.description,
      this.openingTime,
      this.closingTime,
      this.packingTime,
      this.packingCharge,
      this.status,
      this.featured,
      // this.rating,
      this.createdAt,
      this.updatedAt,
      this.v});

  Store.fromJson(Map<String, dynamic> json) {
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    id = json['_id'];
    name = json['name'];
    contactNo = json['contactNo'];
    sellerId = json['sellerId'];
    categoryId = json['categoryId'];
    address = json['address'];
    documents =
        json['documents'] != null ? List<String>.from(json['documents']) : [];
    image = json['image'];
    description = json['description'];
    openingTime = json['openingTime'];
    closingTime = json['closingTime'];
    packingTime = json['packingTime'];
    packingCharge = json['packingCharge'];
    status = json['status'];
    featured = json['featured'];
    // rating = json['rating'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['_id'] = id;
    data['name'] = name;
    data['contactNo'] = contactNo;
    data['sellerId'] = sellerId;
    data['categoryId'] = categoryId;
    data['address'] = address;
    data['documents'] = documents;
    data['image'] = image;
    data['description'] = description;
    data['openingTime'] = openingTime;
    data['closingTime'] = closingTime;
    data['packingTime'] = packingTime;
    data['packingCharge'] = packingCharge;
    data['status'] = status;
    data['featured'] = featured;
    // data['rating'] = rating;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = v;
    return data;
  }
}

class Location {
  String? type;
  List<double>? coordinates;

  Location({this.type, this.coordinates});

  Location.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'] != null
        ? List<double>.from(json['coordinates'].map((x) => x.toDouble()))
        : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['type'] = type;
    data['coordinates'] = coordinates;
    return data;
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
    final Map<String, dynamic> data = {};
    data['_id'] = id;
    data['type'] = type;
    data['price'] = price;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = v;
    return data;
  }
}

class AppData {
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
  String? smtpPort;
  String? smtpHost;
  String? smtpEmail;
  String? smtpPassword;
  String? smtpEncryption;
  String? logo;
  String? darkLogo;
  String? defaultUser;
  String? defaultProduct;
  String? favicon;
  String? facebookLink;
  String? whatsappLink;
  String? twitterLink;
  String? linkedInLink;
  String? youtubeLink;
  String? pinterestLink;
  String? instagramLink;
  String? androidStatus;
  String? iosStatus;
  String? androidLink;
  String? iosLink;
  String? copyRightsDetails;
  String? updatedAt;
  String? currencyCode;
  String? currencySymbol;
  int? minDistance;
  int? minDistanceAmount;
  int? extraDistance;
  int? extraDistanceAmount;
  String? isoCountryCode;
  String? menuBanner;
  int? itemAutoApprovalStatus;
  int? storeAutoApprovalStatus;
  int? sellerBannerLimit;
  int? driverFileLimit;
  String? driverFileText;
  int? driverMaxFileSize;
  int? walletMinAmount;
  int? sellerStoreDocumentLimit;
  String? sellerStoreDocumentText;
  int? storeDistance;
  int? maximumImageSize;
  int? baseDeliveryPrice;
  int? baseKm;
  int? eachKmPrice;
  int? eachKm;
  int? algorithmMaxSearchCount;
  int? algorithmMaxIncreasedKm;
  int? driverMaxReachedTime;
  String? subscriptionModule;
  int? freeSubscriptionDuration;
  String? sellerDocContent;
  String? sellerDocLimit;
  int? orderMergeKm;
  String? sellerSubcriptionStatus;
  int? settlementMinAmount;

  AppData({
    this.id,
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
    this.smtpPort,
    this.smtpHost,
    this.smtpEmail,
    this.smtpPassword,
    this.smtpEncryption,
    this.logo,
    this.darkLogo,
    this.defaultUser,
    this.defaultProduct,
    this.favicon,
    this.facebookLink,
    this.whatsappLink,
    this.twitterLink,
    this.linkedInLink,
    this.youtubeLink,
    this.pinterestLink,
    this.instagramLink,
    this.androidStatus,
    this.iosStatus,
    this.androidLink,
    this.iosLink,
    this.copyRightsDetails,
    this.updatedAt,
    this.currencyCode,
    this.currencySymbol,
    this.minDistance,
    this.minDistanceAmount,
    this.extraDistance,
    this.extraDistanceAmount,
    this.isoCountryCode,
    this.menuBanner,
    this.itemAutoApprovalStatus,
    this.storeAutoApprovalStatus,
    this.sellerBannerLimit,
    this.driverFileLimit,
    this.driverFileText,
    this.driverMaxFileSize,
    this.walletMinAmount,
    this.sellerStoreDocumentLimit,
    this.sellerStoreDocumentText,
    this.storeDistance,
    this.maximumImageSize,
    this.baseDeliveryPrice,
    this.baseKm,
    this.eachKmPrice,
    this.eachKm,
    this.algorithmMaxSearchCount,
    this.algorithmMaxIncreasedKm,
    this.driverMaxReachedTime,
    this.subscriptionModule,
    this.freeSubscriptionDuration,
    this.sellerDocContent,
    this.sellerDocLimit,
    this.orderMergeKm,
    this.sellerSubcriptionStatus,
    this.settlementMinAmount,
  });

  AppData.fromJson(Map<String, dynamic> json) {
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
    stripeClientId = json['stripeClientId'];
    smtpPort = json['smtpPort'];
    smtpHost = json['smtpHost'];
    smtpEmail = json['smtpEmail'];
    smtpPassword = json['smtpPassword'];
    smtpEncryption = json['smtpEncryption'];
    logo = json['logo'];
    darkLogo = json['darkLogo'];
    defaultUser = json['defaultUser'];
    defaultProduct = json['defaultProduct'];
    favicon = json['favicon'];
    facebookLink = json['facebookLink'];
    whatsappLink = json['whatsappLink'];
    twitterLink = json['twitterLink'];
    linkedInLink = json['linkedInLink'];
    youtubeLink = json['youtubeLink'];
    pinterestLink = json['pinterestLink'];
    instagramLink = json['instagramLink'];
    androidStatus = json['androidStatus'];
    iosStatus = json['iosStatus'];
    androidLink = json['androidLink'];
    iosLink = json['iosLink'];
    copyRightsDetails = json['copyRightsDetails'];
    updatedAt = json['updatedAt'];
    currencyCode = json['currencyCode'];
    currencySymbol = json['currencySymbol'];
    minDistance = json['minDistance'];
    minDistanceAmount = json['minDistanceAmount'];
    extraDistance = json['extraDistance'];
    extraDistanceAmount = json['extraDistanceAmount'];
    isoCountryCode = json['isoCountryCode'];
    menuBanner = json['menuBanner'];
    itemAutoApprovalStatus = json['itemAutoApprovalStatus'];
    storeAutoApprovalStatus = json['storeAutoApprovalStatus'];
    sellerBannerLimit = json['sellerBannerLimit'];
    driverFileLimit = json['driverFileLimit'];
    driverFileText = json['driverFileText'];
    driverMaxFileSize = json['driverMaxFileSize'];
    walletMinAmount = json['walletMinAmount'];
    sellerStoreDocumentLimit = json['sellerStoreDocumentLimit'];
    sellerStoreDocumentText = json['sellerStoreDocumentText'];
    storeDistance = json['storeDistance'];
    maximumImageSize = json['maximumImageSize'];
    baseDeliveryPrice = json['baseDeliveryPrice'];
    baseKm = json['baseKm'];
    eachKmPrice = json['eachKmPrice'];
    eachKm = json['eachKm'];
    algorithmMaxSearchCount = json['algorithmMaxSearchCount'];
    algorithmMaxIncreasedKm = json['algorithmMaxIncreasedKm'];
    driverMaxReachedTime = json['driverMaxReachedTime'];
    subscriptionModule = json['subscriptionModule'];
    freeSubscriptionDuration = json['FreeSubscriptionDuration'];
    sellerDocContent = json['sellerDocContent'];
    sellerDocLimit = json['sellerDocLimit'];
    orderMergeKm = json['orderMergeKm'];
    sellerSubcriptionStatus = json['sellerSubcriptionStatus'];
    settlementMinAmount = json['settlementMinAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = id;
    data['siteName'] = siteName;
    data['freeDeliveryForAllOrder'] = freeDeliveryForAllOrder;
    data['freeDeliveryForMinimumAmt'] = freeDeliveryForMinimumAmt;
    data['freeDeliveryForParentCategory'] = freeDeliveryForParentCategory;
    data['sellerDeliveryOption'] = sellerDeliveryOption;
    data['referralAmount'] = referralAmount;
    data['maxSearchDistance'] = maxSearchDistance;
    data['minSearchDistance'] = minSearchDistance;
    data['pickupOrderCount'] = pickupOrderCount;
    data['googleMapKey'] = googleMapKey;
    data['firebaseFCMKey'] = firebaseFCMKey;
    data['firebaseAPIKey'] = firebaseAPIKey;
    data['stripePrivateKey'] = stripePrivateKey;
    data['stripePublicKey'] = stripePublicKey;
    data['razorKey'] = razorKey;
    data['razorSecret'] = razorSecret;
    data['stripeClientId'] = stripeClientId;
    data['smtpPort'] = smtpPort;
    data['smtpHost'] = smtpHost;
    data['smtpEmail'] = smtpEmail;
    data['smtpPassword'] = smtpPassword;
    data['smtpEncryption'] = smtpEncryption;
    data['logo'] = logo;
    data['darkLogo'] = darkLogo;
    data['defaultUser'] = defaultUser;
    data['defaultProduct'] = defaultProduct;
    data['favicon'] = favicon;
    data['facebookLink'] = facebookLink;
    data['whatsappLink'] = whatsappLink;
    data['twitterLink'] = twitterLink;
    data['linkedInLink'] = linkedInLink;
    data['youtubeLink'] = youtubeLink;
    data['pinterestLink'] = pinterestLink;
    data['instagramLink'] = instagramLink;
    data['androidStatus'] = androidStatus;
    data['iosStatus'] = iosStatus;
    data['androidLink'] = androidLink;
    data['iosLink'] = iosLink;
    data['copyRightsDetails'] = copyRightsDetails;
    data['updatedAt'] = updatedAt;
    data['currencyCode'] = currencyCode;
    data['currencySymbol'] = currencySymbol;
    data['minDistance'] = minDistance;
    data['minDistanceAmount'] = minDistanceAmount;
    data['extraDistance'] = extraDistance;
    data['extraDistanceAmount'] = extraDistanceAmount;
    data['isoCountryCode'] = isoCountryCode;
    data['menuBanner'] = menuBanner;
    data['itemAutoApprovalStatus'] = itemAutoApprovalStatus;
    data['storeAutoApprovalStatus'] = storeAutoApprovalStatus;
    data['sellerBannerLimit'] = sellerBannerLimit;
    data['driverFileLimit'] = driverFileLimit;
    data['driverFileText'] = driverFileText;
    data['driverMaxFileSize'] = driverMaxFileSize;
    data['walletMinAmount'] = walletMinAmount;
    data['sellerStoreDocumentLimit'] = sellerStoreDocumentLimit;
    data['sellerStoreDocumentText'] = sellerStoreDocumentText;
    data['storeDistance'] = storeDistance;
    data['maximumImageSize'] = maximumImageSize;
    data['baseDeliveryPrice'] = baseDeliveryPrice;
    data['baseKm'] = baseKm;
    data['eachKmPrice'] = eachKmPrice;
    data['eachKm'] = eachKm;
    data['algorithmMaxSearchCount'] = algorithmMaxSearchCount;
    data['algorithmMaxIncreasedKm'] = algorithmMaxIncreasedKm;
    data['driverMaxReachedTime'] = driverMaxReachedTime;
    data['subscriptionModule'] = subscriptionModule;
    data['FreeSubscriptionDuration'] = freeSubscriptionDuration;
    data['sellerDocContent'] = sellerDocContent;
    data['sellerDocLimit'] = sellerDocLimit;
    data['orderMergeKm'] = orderMergeKm;
    data['sellerSubcriptionStatus'] = sellerSubcriptionStatus;
    data['settlementMinAmount'] = settlementMinAmount;
    return data;
  }
}
