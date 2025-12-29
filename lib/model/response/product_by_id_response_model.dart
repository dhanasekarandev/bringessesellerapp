class ProductByIdResponse {
  int? statusCode;
  String? status;
  ProductResult? result;
  Menu? menu;

  ProductByIdResponse({
    this.statusCode,
    this.status,
    this.result,
    this.menu,
  });

  ProductByIdResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    status = json['status']?.toString();
    result =
        json['result'] != null ? ProductResult.fromJson(json['result']) : null;
    menu = json['menu'] != null ? Menu.fromJson(json['menu']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status_code'] = statusCode;
    data['status'] = status;
    if (result != null) data['result'] = result!.toJson();
    if (menu != null) data['menu'] = menu!.toJson();
    return data;
  }
}

class ProductResult {
  String? id;
  String? name;
  List<ProductVariant>? variants;
  String? videoUrl;
  int? imageposition;
  int? status;
  String? sku;
  String? isFood;
  String? type;
  String? description;
  String? menuId;
  String? quantity;
  String? menuName;
  int? outOfStock;
  int? comboOffer;
  List<String>? images;
  String? createdAt;

  ProductResult({
    this.id,
    this.name,
    this.variants,
    this.videoUrl,
    this.imageposition,
    this.status,
    this.isFood,
    this.type,
    this.quantity,
    this.sku,
    this.description,
    this.menuId,
    this.menuName,
    this.outOfStock,
    this.comboOffer,
    this.images,
    this.createdAt,
  });

  ProductResult.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    name = json['name'];
    if (json['variants'] != null) {
      variants = (json['variants'] as List)
          .map((v) => ProductVariant.fromJson(v))
          .toList();
    }
    videoUrl = json['videoUrl'];
    imageposition = json['imageposition'];
    status = json['status'];
    quantity = json['quantity'];
    sku = json['SKU'];
    isFood = json['isFood'];
    type = json['type'];
    description = json['description'];
    menuId = json['menuId'];
    menuName = json['menuName'];
    outOfStock = json['outOfStock'];
    comboOffer = json['comboOffer'];
    images = json['images'] != null ? List<String>.from(json['images']) : [];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (variants != null) {
      data['variants'] = variants!.map((v) => v.toJson()).toList();
    }
    data['videoUrl'] = videoUrl;
    data['imageposition'] = imageposition;
    data['status'] = status;
    data['SKU'] = sku;
    data['isFood'] = isFood;
    data['type'] = type;
    data['quantity'] = quantity;
    data['description'] = description;
    data['menuId'] = menuId;
    data['menuName'] = menuName;
    data['outOfStock'] = outOfStock;
    data['comboOffer'] = comboOffer;
    data['images'] = images;
    data['created_at'] = createdAt;
    return data;
  }
}

class ProductVariant {
  String? name;
  num? price;
  num? itemQuantity;
  num? weight;
  String? itemWarranty;
  String? itemoutOfStock;
  num? gst;
  String? offerAvailable;
  num? offerPrice;
  String? unit;

  ProductVariant({
    this.name,
    this.price,
    this.weight,
    this.itemWarranty,
    this.itemQuantity,
    this.gst,
    this.offerAvailable,
    this.offerPrice,
    this.unit,
  });

  ProductVariant.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? "";
    price = json['price'];
    gst = json['gst'];

    itemWarranty =
        json['itemWarranty']?.toString() ?? json['itemWarranty ']?.toString();
    itemQuantity = json['itemquantity'];
    itemoutOfStock = json['itemOutofStock']?.toString() ??
        json['itemOutofStock ']?.toString();
    weight = json['weight'];
    offerAvailable = json['offer_available']?.toString();
    offerPrice = json['offer_price'];
    unit = json['unit']?.trim(); // ✅ handles spaces like " kg"
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['price'] = price;
    data['gst'] = gst;
    data['weight'] = weight;
    data['itemquantity'] = itemQuantity;
    data['itemWarranty '] = itemWarranty;
    data['itemOutofStock '] = itemoutOfStock;
    data['offer_available'] = offerAvailable;
    data['offer_price'] = offerPrice;
    data['unit'] = unit;
    return data;
  }
}

class Menu {
  String? id;
  String? name;
  String? storeId;
  SubCategoryId? subCategoryId;
  String? image;
  int? status;
  String? createdAt;
  String? updatedAt;

  Menu({
    this.id,
    this.name,
    this.storeId,
    this.subCategoryId,
    this.image,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  Menu.fromJson(Map<String, dynamic> json) {
    id = json['_id']?.toString();
    name = json['name'];
    storeId = json['storeId'];
    subCategoryId = json['subCategoryId'] != null
        ? SubCategoryId.fromJson(json['subCategoryId'])
        : null;
    image = json['image'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['storeId'] = storeId;
    if (subCategoryId != null) {
      data['subCategoryId'] = subCategoryId!.toJson();
    }
    data['image'] = image;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class SubCategoryId {
  String? id;
  String? name;
  String? image;
  String? categoryId;
  int? offerPercentage;
  int? offerAvailable;
  String? offerDetails;
  int? offerMinRange;
  int? status;
  String? createdAt;

  SubCategoryId({
    this.id,
    this.name,
    this.image,
    this.categoryId,
    this.offerPercentage,
    this.offerAvailable,
    this.offerDetails,
    this.offerMinRange,
    this.status,
    this.createdAt,
  });

  SubCategoryId.fromJson(Map<String, dynamic> json) {
    id = json['_id']?.toString();
    name = json['name'];
    image = json['image'];
    categoryId = json['categoryId'];
    offerPercentage = json['offerPercentage'];
    offerAvailable = json['offerAvailable'];
    offerDetails = json['offerDetails'];
    offerMinRange = json['offerMinRange'];
    status = json['status'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['categoryId'] = categoryId;
    data['offerPercentage'] = offerPercentage;
    data['offerAvailable'] = offerAvailable;
    data['offerDetails'] = offerDetails;
    data['offerMinRange'] = offerMinRange;
    data['status'] = status;
    data['createdAt'] = createdAt;
    return data;
  }
}
