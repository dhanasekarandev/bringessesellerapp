class ReviewReqModel {
  String? pageId;
  String? storeId;

  ReviewReqModel({this.pageId, this.storeId});

  ReviewReqModel.fromJson(Map<String, dynamic> json) {
    pageId = json['pageId'];
    storeId = json['storeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['pageId'] = pageId;
    data['storeId'] = storeId;
    return data;
  }
}
