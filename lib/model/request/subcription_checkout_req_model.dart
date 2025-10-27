class SubscriptionCheckoutReqModel {
  double? subscriptionPrice;
  String? subscriptionId;
  String? sellerId;

  SubscriptionCheckoutReqModel({this.subscriptionPrice, this.subscriptionId, this.sellerId});

  SubscriptionCheckoutReqModel.fromJson(Map<String, dynamic> json) {
    subscriptionPrice = json['subscriptionPrice'] != null
        ? (json['subscriptionPrice'] as num).toDouble()
        : null;
    subscriptionId = json['subscriptionId'];
    sellerId = json['sellerId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (subscriptionPrice != null) data['subscriptionPrice'] = subscriptionPrice;
    if (subscriptionId != null) data['subscriptionId'] = subscriptionId;
    if (sellerId != null) data['sellerId'] = sellerId;
    return data;
  }
}
