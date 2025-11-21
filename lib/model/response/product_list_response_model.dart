class ProductListResponseModel {
  String? status;
  int? statusCode;
  ProductListResult? result;

  ProductListResponseModel({this.status, this.statusCode, this.result});

  ProductListResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    status = json['status'];
    result = json['result'] != null
        ? ProductListResult.fromJson(json['result'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status_code'] = statusCode;
    data['status'] = status;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class ProductListResult {
  int? count;
  List<ProductItem>? items;

  ProductListResult({this.count, this.items});

  ProductListResult.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['items'] != null) {
      items = <ProductItem>[];
      json['items'].forEach((v) {
        items!.add(ProductItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['count'] = count;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductItem {
  String? id;
  int? v;
  String? name;
  int? status;
  int? outOfStock;
  int? comboOffer;
  String? quantity;
  List<String>? images;
  List<ProductVariant>? variants;
  String? createdAt;

  ProductItem(
      {this.id,
      this.v,
      this.name,
      this.status,
      this.outOfStock,
      this.comboOffer,
      this.quantity,
      this.images,
      this.variants,
      this.createdAt});

  ProductItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    v = json['__v'];
    name = json['name'];
    status = json['status'];
    outOfStock = json['outOfStock'];
    comboOffer = json['comboOffer'];
    quantity = json['quantity'];

    images = json['images'] != null ? List<String>.from(json['images']) : [];

    // variants
    if (json['variants'] != null) {
      variants = <ProductVariant>[];
      json['variants'].forEach((v) {
        variants!.add(ProductVariant.fromJson(v));
      });
    }

    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['__v'] = v;
    data['name'] = name;
    data['status'] = status;
    data['outOfStock'] = outOfStock;
    data['comboOffer'] = comboOffer;
    data['quantity'] = quantity;
    data['images'] = images;
    if (variants != null) {
      data['variants'] = variants!.map((e) => e.toJson()).toList();
    }
    data['created_at'] = createdAt;
    return data;
  }
}

class ProductVariant {
  String? name;
  int? price;
  String? offerAvailable;
  int? offerPrice;
  String? unit;
  double? gst;
  double? cGstInPercent;
  double? cGstInAmount;
  double? sGstInPercent;
  double? sGstInAmount;
  double? totalAmount;

  ProductVariant(
      {this.name,
      this.price,
      this.offerAvailable,
      this.offerPrice,
      this.unit,
      this.gst,
      this.cGstInPercent,
      this.cGstInAmount,
      this.sGstInPercent,
      this.sGstInAmount,
      this.totalAmount});

  ProductVariant.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
    offerAvailable = json['offer_available'];
    offerPrice = json['offer_price'];
    unit = json['unit'];
    gst = (json['gst'] ?? 0).toDouble();
    cGstInPercent = (json['cGstInPercent'] ?? 0).toDouble();
    cGstInAmount = (json['cGstInAmount'] ?? 0).toDouble();
    sGstInPercent = (json['sGstInPercent'] ?? 0).toDouble();
    sGstInAmount = (json['sGstInAmount'] ?? 0).toDouble();
    totalAmount = (json['totalAmount'] ?? 0).toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['price'] = price;
    data['offer_available'] = offerAvailable;
    data['offer_price'] = offerPrice;
    data['unit'] = unit;
    data['gst'] = gst;
    data['cGstInPercent'] = cGstInPercent;
    data['cGstInAmount'] = cGstInAmount;
    data['sGstInPercent'] = sGstInPercent;
    data['sGstInAmount'] = sGstInAmount;
    data['totalAmount'] = totalAmount;
    return data;
  }
}
