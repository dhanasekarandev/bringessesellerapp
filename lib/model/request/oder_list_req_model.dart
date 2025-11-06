class OderListReqModel {
  String? storeId;
  String? pageId;
  String? searchKey;
  String? status;

  OderListReqModel({
    this.storeId,
    this.pageId,
    this.searchKey,
    this.status,
  });

  OderListReqModel.fromJson(Map<String, dynamic> json) {
    storeId = json['storeId'];
    pageId = json['pageId'];
    searchKey = json['searchKey'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['storeId'] = storeId;
    data['pageId'] = pageId;
    data['searchKey'] = searchKey;
    data['status'] = status;
    return data;
  }
}
