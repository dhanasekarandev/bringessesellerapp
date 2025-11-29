class SubscriptionTransactionReq {
  String? paymentId;
  String? orderId;
  String? signature;
  String? gateway = "razorpay";
  // For Juspay extra fields
  String? sessionStatus;
  String? sessionId;
  String? subscriptionId;
  String? sellerId;
  double? subscriptionPrice;
  int? price;
  String? currency;

  SubscriptionTransactionReq({
    this.gateway,
    this.paymentId,
    this.orderId,
    this.price,
    this.signature,
    this.sessionStatus,
    this.sessionId,
    this.subscriptionId,
    this.sellerId,
    this.subscriptionPrice,
    this.currency,
  });

  SubscriptionTransactionReq.fromJson(Map<String, dynamic> json) {
    paymentId = json['paymentId'] ?? json['payment_id'];
    orderId = json['orderId'] ?? json['order_id'];
    signature = json['signature'];

    // Juspay keys
    if (json['session'] != null) {
      var session = json['session'];
      sessionStatus = session['status'];
      sessionId = session['id'];
      orderId = session['order_id']; // override if needed
      currency = session['sdk_payload']?['payload']?['currency'];
    }
    subscriptionId = json['subscriptionId'];
    sellerId = json['sellerId'];
    price = json['subscriptionPrice'] != null ? json['subscriptionPrice'] : 0;
  }

  Map<String, dynamic> toJson() {
    if (gateway?.toLowerCase() == "razorpay") {
      return {
        if (paymentId != null) 'paymentId': paymentId,
        if (orderId != null) 'orderId': orderId,
        if (signature != null) 'signature': signature,
      };
    } else if (gateway?.toLowerCase() == "juspay") {
      return {
        'session': {
          'status': sessionStatus ?? "SUCCESS",
          'id': sessionId ?? orderId,
          'order_id': orderId,
          'sdk_payload': {
            'payload': {
              'amount': subscriptionPrice ?? 0, // send as number
              'currency': currency ?? "INR",
            }
          }
        },
        if (subscriptionId != null) 'subscriptionId': subscriptionId,
        if (sellerId != null) 'sellerId': sellerId,
        if (price != null) 'subscriptionPrice': price
      };
    }
    return {};
  }
}
