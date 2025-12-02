class StoreOpenReqModel {
  String? isActive;
  String? storeId;

  StoreOpenReqModel({this.isActive, this.storeId});

  StoreOpenReqModel.fromJson(Map<String, dynamic> json) {
    isActive = json['isActive'];
    storeId = json['storeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['isActive'] = isActive;
    data['storeId'] = storeId;
    return data;
  }
}
