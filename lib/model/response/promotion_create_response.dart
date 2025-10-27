class PromotionResponseModel {
  String? status;
  String? promotionId;
  int? promotionPrice;
  String? message;

  PromotionResponseModel({
    this.status,
    this.promotionId,
    this.promotionPrice,
    this.message,
  });

  PromotionResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    promotionId = json['promotionId'];
    promotionPrice = json['promotionPrice'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['promotionId'] = promotionId;
    data['promotionPrice'] = promotionPrice;
    data['message'] = message;
    return data;
  }
}
