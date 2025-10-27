class SignupRequestModel {
  String? name;
  String? contactNo;
  String? email;
  String? password;

  SignupRequestModel({
    this.name,
    this.contactNo,
    this.email,
    this.password,
  });

  SignupRequestModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    contactNo = json['contactNo'];
    email = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['contactNo'] = contactNo;
    data['email'] = email;
    data['password'] = password;
    return data;
  }
}
