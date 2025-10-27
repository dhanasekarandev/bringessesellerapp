class TransactionRequestModel {
  String? paymentId;
  String? orderId;
  String? signature;
  String? promotionId;

  TransactionRequestModel({
    this.paymentId,
    this.orderId,
    this.signature,
    this.promotionId,
  });

  TransactionRequestModel.fromJson(Map<String, dynamic> json) {
    paymentId = json['paymentId'];
    orderId = json['orderId'];
    signature = json['signature'];
    promotionId = json['promotionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['paymentId'] = paymentId;
    data['orderId'] = orderId;
    data['signature'] = signature;
    data['promotionId'] = promotionId;
    return data;
  }
}
