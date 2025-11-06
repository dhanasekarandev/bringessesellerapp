class ProductDeleteReqModel {
  String? itemId;
  int? status;

  ProductDeleteReqModel({this.itemId, this.status});

  ProductDeleteReqModel.fromJson(Map<String, dynamic> json) {
    itemId = json['itemId'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (itemId != null) data['itemId'] = itemId;
    if (status != null) data['status'] = status;
    return data;
  }
}
