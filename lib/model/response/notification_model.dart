class NotificationResponseModel {
  String? status;
  int? statusCode;
  List<NotificationResult>? result;
  int? count;

  NotificationResponseModel({
    this.status,
    this.statusCode,
    this.result,
    this.count,
  });

  NotificationResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    if (json['result'] != null) {
      result = <NotificationResult>[];
      json['result'].forEach((v) {
        result!.add(NotificationResult.fromJson(v));
      });
    }
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    data['status_code'] = statusCode;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    data['count'] = count;
    return data;
  }
}

class NotificationResult {
  String? id;
  String? type;
  String? message;
  String? sellerId;
  String? receiverId;
  String? sourceId;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? v;

  NotificationResult({
    this.id,
    this.type,
    this.message,
    this.sellerId,
    this.receiverId,
    this.sourceId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  NotificationResult.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    type = json['type'];
    message = json['message'];
    sellerId = json['sellerId'];
    receiverId = json['receiverId'];
    sourceId = json['sourceId'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = id;
    data['type'] = type;
    data['message'] = message;
    data['sellerId'] = sellerId;
    data['receiverId'] = receiverId;
    data['sourceId'] = sourceId;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = v;
    return data;
  }
}
