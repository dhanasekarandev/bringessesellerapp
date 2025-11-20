class UpdateOrderStatusReqModel {
  String? orderId;
  String? status;
  String? userId;
  String? sellerId;
  String? otp;

  UpdateOrderStatusReqModel({
    this.orderId,
    this.status,
    this.userId,
    this.sellerId,
    this.otp,
  });

  UpdateOrderStatusReqModel.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    status = json['status'];
    userId = json['userId'];
    sellerId = json['sellerId'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (orderId != null) data['orderId'] = orderId;
    if (status != null) data['status'] = status;
    if (userId != null) data['userId'] = userId;
    if (sellerId != null) data['sellerId'] = sellerId;
    if (otp != null) data['otp'] = otp;
    return data;
  }
}
