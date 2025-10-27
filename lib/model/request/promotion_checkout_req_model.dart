class PromotionCheckoutReqModel {
  String? promotionId;
  String? bannerPrice;
  

  PromotionCheckoutReqModel({
    this.promotionId,
    this.bannerPrice,
    
  });

  PromotionCheckoutReqModel.fromJson(Map<String, dynamic> json) {
    promotionId = json['promotionId'];
    bannerPrice = json['bannerPrice'];
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['promotionId'] = promotionId;
    data['bannerPrice'] = bannerPrice;

    return data;
  }
}
