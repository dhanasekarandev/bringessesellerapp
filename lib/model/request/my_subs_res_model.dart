class MySubscriptionResponse {
  int? statusCode;
  MySubscriptionResult? result;

  MySubscriptionResponse({
    this.statusCode,
    this.result,
  });

  MySubscriptionResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    result = json['result'] != null
        ? MySubscriptionResult.fromJson(json['result'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status_code'] = statusCode;
    if (result != null) data['result'] = result!.toJson();
    return data;
  }
}

// ------------------------- RESULT MODEL -------------------------

class MySubscriptionResult {
  String? id;
  String? storeId;
  String? sellerId;
  String? subscriptionName;
  String? subscriptionDuration;
  int? subscriptionPrice;
  String? startDate;
  String? endDate;
  SubscriptionPlan? subscriptionPlan; // NEW FIELD

  MySubscriptionResult({
    this.id,
    this.storeId,
    this.sellerId,
    this.subscriptionName,
    this.subscriptionDuration,
    this.subscriptionPrice,
    this.startDate,
    this.endDate,
    this.subscriptionPlan,
  });

  MySubscriptionResult.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    storeId = json['storeId'];
    sellerId = json['sellerId'];
    subscriptionName = json['subscriptionName'];
    subscriptionDuration = json['subscriptionDuration'];
    subscriptionPrice = json['subscriptionPrice'];
    startDate = json['startDate'];
    endDate = json['endDate'];

    subscriptionPlan = json['subscriptionPlan'] != null
        ? SubscriptionPlan.fromJson(json['subscriptionPlan'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = id;
    data['storeId'] = storeId;
    data['sellerId'] = sellerId;
    data['subscriptionName'] = subscriptionName;
    data['subscriptionDuration'] = subscriptionDuration;
    data['subscriptionPrice'] = subscriptionPrice;
    data['startDate'] = startDate;
    data['endDate'] = endDate;

    if (subscriptionPlan != null) {
      data['subscriptionPlan'] = subscriptionPlan!.toJson();
    }

    return data;
  }
}

// ------------------------- SUBSCRIPTION PLAN MODEL -------------------------

class SubscriptionPlan {
  String? id;
  String? name;
  String? duration;
  int? price;
  int? durationCount;
  String? description;
  int? status;
  int? noOfDriversAllowed;
  String? createdAt;
  String? updatedAt;
  int? v;

  SubscriptionPlan({
    this.id,
    this.name,
    this.duration,
    this.price,
    this.durationCount,
    this.description,
    this.status,
    this.noOfDriversAllowed,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    duration = json['duration'];
    price = json['price'];
    durationCount = json['durationCount'];
    description = json['description'];
    status = json['status'];
    noOfDriversAllowed = json['noOfDriversAlowed']; // match API spelling
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['duration'] = duration;
    data['price'] = price;
    data['durationCount'] = durationCount;
    data['description'] = description;
    data['status'] = status;
    data['noOfDriversAlowed'] = noOfDriversAllowed;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = v;
    return data;
  }
}
