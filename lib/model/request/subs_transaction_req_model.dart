class SubscriptionTransactionReq {
  String? paymentId;
  String? orderId;
  String? signature;

  SubscriptionTransactionReq({this.paymentId, this.orderId, this.signature});

  SubscriptionTransactionReq.fromJson(Map<String, dynamic> json) {
    paymentId = json['paymentId'];
    orderId = json['orderId'];
    signature = json['signature'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (paymentId != null) data['paymentId'] = paymentId;
    if (orderId != null) data['orderId'] = orderId;
    if (signature != null) data['signature'] = signature;
    return data;
  }
}
