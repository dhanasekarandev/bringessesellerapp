class CategoryIdReqModel {
  String? categoryId;

  CategoryIdReqModel({this.categoryId});

  CategoryIdReqModel.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (categoryId != null) data['categoryId'] = categoryId;
    return data;
  }
}
