class AccountReqModel {
  String? sellerId;

  AccountReqModel({this.sellerId});

  AccountReqModel.fromJson(Map<String, dynamic> json) {
    sellerId = json['sellerId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (sellerId != null) data['sellerId'] = sellerId;
    return data;
  }
}