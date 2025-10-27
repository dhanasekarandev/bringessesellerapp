class SubscriptionResponseModel {
  int? statusCode;
  List<SubscriptionModel>? result;
  String? currency;

  SubscriptionResponseModel({this.statusCode, this.result, this.currency});

  SubscriptionResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    if (json['result'] != null) {
      result = <SubscriptionModel>[];
      json['result'].forEach((v) {
        result!.add(SubscriptionModel.fromJson(v));
      });
    }
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status_code'] = statusCode;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    data['currency'] = currency;
    return data;
  }

  /// Helper to get default subscription ID (first item)
  String? get defaultSubscriptionId {
    return result != null && result!.isNotEmpty ? result!.first.id : null;
  }
}

class SubscriptionModel {
  String? id;
  String? name;
  String? duration;
  int? price;
  int? durationCount;
  String? description;
  int? status;
  String? createdAt;
  String? updatedAt;

  SubscriptionModel({
    this.id,
    this.name,
    this.duration,
    this.price,
    this.durationCount,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  SubscriptionModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    duration = json['duration'];
    price = json['price'];
    durationCount = json['durationCount'];
    description = json['description'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['duration'] = duration;
    data['price'] = price;
    data['durationCount'] = durationCount;
    data['description'] = description;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
