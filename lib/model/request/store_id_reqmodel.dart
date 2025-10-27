class StoreIdReqmodel {
  String? storeId;

  StoreIdReqmodel({this.storeId});

  StoreIdReqmodel.fromJson(Map<String, dynamic> json) {
    storeId = json['storeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (storeId != null) data['storeId'] = storeId;
    return data;
  }
}
