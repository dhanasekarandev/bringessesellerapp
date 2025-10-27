class PromotionCheckoutResponseModel {
  String? status;
  int? statuscode;
  String? orderId;
  int? amount;
  String? key;
  String? currency;
  String? message;

  PromotionCheckoutResponseModel({
    this.status,
    this.statuscode,
    this.orderId,
    this.currency,
    this.key,
    this.amount,
    this.message,
  });

  PromotionCheckoutResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    status = json['status_code'];
    orderId = json['orderId'];
    currency = json['currency'];
    amount = json['amount'];
    key = json['key'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['orderId'] = orderId;
    data['currency'] = currency;
    data['amount'] = amount;
    data['key'] = key;
    data['message'] = message;
    return data;
  }
}
