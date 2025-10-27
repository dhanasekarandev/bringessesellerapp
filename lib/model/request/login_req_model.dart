class LoginRequestModel {
  String? email;
  String? password;
  String? deviceId;
  int? deviceType; // 1 for Android, 2 for iOS, etc.
  String? deviceToken; // FCM token

  LoginRequestModel({
    this.email,
    this.password,
    this.deviceId,
    this.deviceType,
    this.deviceToken,
  });

  LoginRequestModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    deviceId = json['device_id'];
    deviceType = json['device_type'];
    deviceToken = json['device_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    data['device_id'] = deviceId;
    data['device_type'] = deviceType;
    data['device_token'] = deviceToken;
    return data;
  }

  @override
  String toString() {
    return 'LoginRequestModel(email: $email, deviceId: $deviceId, deviceType: $deviceType, deviceToken: $deviceToken)';
  }
}
