class TransactionRequestModel {
  String? paymentId;     
  String? orderId;       
  String? signature;     
  String? promotionId;
  String? gatewayName;   

  TransactionRequestModel({
    this.paymentId,
    this.orderId,
    this.signature,
    this.promotionId,
    this.gatewayName,
  });

  TransactionRequestModel.fromJson(Map<String, dynamic> json) {
    paymentId = json['paymentId'];
    orderId = json['orderId'];
    signature = json['signature'];
    promotionId = json['promotionId'];

    // New field for Juspay
    gatewayName = json['gatewayName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (paymentId != null) data['paymentId'] = paymentId;
    if (orderId != null) data['orderId'] = orderId;
    if (signature != null) data['signature'] = signature;
    if (promotionId != null) data['promotionId'] = promotionId;

    // Send only if available
    if (gatewayName != null) data['gatewayName'] = gatewayName;

    return data;
  }
}
