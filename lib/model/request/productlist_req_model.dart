class ProductListReqModel {
  String? pageId;
  String? searchKey;
  String? status;
  String? storeId;

  ProductListReqModel({this.pageId, this.searchKey, this.status, this.storeId});

  ProductListReqModel.fromJson(Map<String, dynamic> json) {
    pageId = json['pageId'];
    searchKey = json['searchKey'];
    status = json['status'];
    storeId = json['storeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['pageId'] = pageId;
    data['searchKey'] = searchKey;
    data['status'] = status;
    data['storeId'] = storeId;
    return data;
  }
}
