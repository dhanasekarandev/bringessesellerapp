class SubscriptionTransactionReq {
  String? gateway; // razorpay / juspay
  String? paymentId;
  String? orderId;
  String? signature;

  // New Juspay format fields
  String? gatewayName;
  String? subscriptionPlanId;
  String? storeId;
  String? sellerId;
  String? status;

  SubscriptionTransactionReq({
    this.gateway = "razorpay",
    this.paymentId,
    this.orderId,
    this.signature,
    this.gatewayName,
    this.subscriptionPlanId,
    this.storeId,
    this.sellerId,
    this.status,
  });

  SubscriptionTransactionReq.fromJson(Map<String, dynamic> json) {
    // Razorpay keys
    paymentId = json['paymentId'] ?? json['payment_id'];
    orderId = json['orderId'] ?? json['order_id'];
    signature = json['signature'];

    // Juspay keys (NEW FORMAT)
    gatewayName = json['gatewayName'];
    subscriptionPlanId = json['subscriptionPlanId'];
    storeId = json['storeId'];
    sellerId = json['sellerId'];
    status = json['status'];

    // Auto detect gateway
    if (gatewayName != null) {
      gateway = gatewayName!.toLowerCase();
    }
  }

  Map<String, dynamic> toJson() {
    // ✔ Razorpay request format
    if (gateway?.toLowerCase() == "razorpay") {
      return {
        "gateway": "razorpay",
        if (paymentId != null) "paymentId": paymentId,
        if (orderId != null) "orderId": orderId,
        if (signature != null) "signature": signature,
      };
    }

    // ✔ Juspay request format (NEW API)
    if (gateway?.toLowerCase() == "juspay") {
      return {
        "gatewayName": "Juspay",
        if (storeId != null) "storeId": storeId,
        if (sellerId != null) "sellerId": sellerId,
        if (subscriptionPlanId != null)
          "subscriptionPlanId": subscriptionPlanId,
        if (orderId != null) "orderId": orderId,
        if (paymentId != null) "paymentId": paymentId,
        if (status != null) "status": status,
      };
    }

    return {};
  }
}
