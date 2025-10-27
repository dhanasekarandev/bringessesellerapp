class ProductListResponseModel {
  String? status;
  int? statusCode;
  ProductListResult? result;

  ProductListResponseModel({this.status, this.statusCode, this.result});

  ProductListResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    status = json['status'];
    result =
        json['result'] != null ? ProductListResult.fromJson(json['result']) : null;
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
  List<String>? images;
  String? createdAt;

  ProductItem({
    this.id,
    this.v,
    this.name,
    this.status,
    this.outOfStock,
    this.comboOffer,
    this.images,
    this.createdAt,
  });

  ProductItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    v = json['__v'];
    name = json['name'];
    status = json['status'];
    outOfStock = json['outOfStock'];
    comboOffer = json['comboOffer'];
    images = json['images'] != null ? List<String>.from(json['images']) : [];
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
    data['images'] = images;
    data['created_at'] = createdAt;
    return data;
  }
}
