class MySubscriptionResponse {
  int? statusCode;
  MySubscriptionResult? result;

  MySubscriptionResponse({this.statusCode, this.result});

  MySubscriptionResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    result = json['result'] != null
        ? MySubscriptionResult.fromJson(json['result'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status_code'] = statusCode;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class MySubscriptionResult {
  String? id;
  String? storeId;
  String? sellerId;
  String? subscriptionPlanId;
  String? subscriptionName;
  String? subscriptionDuration;
  int? subscriptionPrice;
  String? startDate;
  String? endDate;
  String? createdAt;
  String? updatedAt;
  int? v;

  MySubscriptionResult({
    this.id,
    this.storeId,
    this.sellerId,
    this.subscriptionPlanId,
    this.subscriptionName,
    this.subscriptionDuration,
    this.subscriptionPrice,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  MySubscriptionResult.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    storeId = json['storeId'];
    sellerId = json['sellerId'];
    subscriptionPlanId = json['subscriptionPlanId'];
    subscriptionName = json['subscriptionName'];
    subscriptionDuration = json['subscriptionDuration'];
    subscriptionPrice = json['subscriptionPrice'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = id;
    data['storeId'] = storeId;
    data['sellerId'] = sellerId;
    data['subscriptionPlanId'] = subscriptionPlanId;
    data['subscriptionName'] = subscriptionName;
    data['subscriptionDuration'] = subscriptionDuration;
    data['subscriptionPrice'] = subscriptionPrice;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = v;
    return data;
  }
}
