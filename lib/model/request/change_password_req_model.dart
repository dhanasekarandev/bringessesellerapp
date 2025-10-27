class ChangePasswordReqModel {
  String? sellerId;
  String? oldPassword;
  String? password;


  ChangePasswordReqModel(
      {this.sellerId, this.oldPassword, this.password});

  ChangePasswordReqModel.fromJson(Map<String, dynamic> json) {
    sellerId = json['sellerId'];
    oldPassword = json['oldpassword'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sellerId'] = this.sellerId;
    data['oldpassword'] = this.oldPassword;
    data['password'] = this.password;
    return data;
  }

  String toString() {
    return 'ChangePasswordReqModel(sellerId: $sellerId, password: $password, oldpassword: $oldPassword)';
  }
}
