class LoginModel {
  int? statusCode;
  String? status;
  Result? result;
  String? message;

  LoginModel({
    this.statusCode,
    this.status,
    this.result,
    this.message,
  });

  LoginModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    status = json['status'];
    message = json['message'];
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status_code'] = statusCode;
    data['status'] = status;
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class Result {
  String? accessToken;
  String? refreshToken;
  String? storeId;
  String? categoryId;
  String? sellerId;
  String? accountId;
  String? paymentStatus;
  int? subscriptionStatus;
  String? subscriptionExpiryAt;
  String? message;
  int? liveStatus;

  Result({
    this.accessToken,
    this.refreshToken,
    this.storeId,
    this.categoryId,
    this.sellerId,
    this.accountId,
    this.paymentStatus,
    this.subscriptionStatus,
    this.subscriptionExpiryAt,
    this.message,
    this.liveStatus,
  });

  Result.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
    storeId = json['storeId'];
    categoryId = json['categoryId'];
    sellerId = json['sellerId'];
    accountId = json['accountId'];
    paymentStatus = json['paymentStatus'];
    subscriptionStatus = json['subscriptionStatus'];
    subscriptionExpiryAt = json['subscriptionExpiryAt'];
    message = json['message'];
    liveStatus = json['live_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['accessToken'] = accessToken;
    data['refreshToken'] = refreshToken;
    data['storeId'] = storeId;
    data['categoryId'] = categoryId;
    data['sellerId'] = sellerId;
    data['accountId'] = accountId;
    data['paymentStatus'] = paymentStatus;
    data['subscriptionStatus'] = subscriptionStatus;
    data['subscriptionExpiryAt'] = subscriptionExpiryAt;
    data['message'] = message;
    data['live_status'] = liveStatus;
    return data;
  }
}
