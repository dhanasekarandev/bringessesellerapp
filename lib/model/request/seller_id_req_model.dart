class CategoryIdReqModel {
  String? sellerId;

  CategoryIdReqModel({this.sellerId});

  CategoryIdReqModel.fromJson(Map<String, dynamic> json) {
    sellerId = json['seller_Id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (sellerId != null) data['seller_Id'] = sellerId;
    return data;
  }
}
