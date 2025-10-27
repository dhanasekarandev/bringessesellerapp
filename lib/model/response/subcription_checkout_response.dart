class SubscriptionCheckoutResponse {
  int? amount;
  String? currency;
  String? key;
  String? message;
  String? orderId;
  int? statusCode;

  SubscriptionCheckoutResponse({
    this.amount,
    this.currency,
    this.key,
    this.message,
    this.orderId,
    this.statusCode,
  });

  SubscriptionCheckoutResponse.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    currency = json['currency'];
    key = json['key'];
    message = json['message'];
    orderId = json['orderId'];
    statusCode = json['status_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (amount != null) data['amount'] = amount;
    if (currency != null) data['currency'] = currency;
    if (key != null) data['key'] = key;
    if (message != null) data['message'] = message;
    if (orderId != null) data['orderId'] = orderId;
    if (statusCode != null) data['status_code'] = statusCode;
    return data;
  }
}
