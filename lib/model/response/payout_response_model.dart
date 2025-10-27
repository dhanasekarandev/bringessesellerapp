class RazorpayAccountResponseModel {
  String? status;
  String? message;
  String? accountId;
  String? productId;
  String? paymentStatus;
  String? activationStatus;

  RazorpayAccountResponseModel({
    this.status,
    this.message,
    this.accountId,
    this.productId,
    this.paymentStatus,
    this.activationStatus,
  });

  RazorpayAccountResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    accountId = json['account_id'];
    productId = json['product_id'];
    paymentStatus = json['paymentStatus'];
    activationStatus = json['activationStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['account_id'] = accountId;
    data['product_id'] = productId;
    data['paymentStatus'] = paymentStatus;
    data['activationStatus'] = activationStatus;
    return data;
  }
}
