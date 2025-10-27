class EditProfileRequestModel {
  String? sellerId;
  String? name;
  String? email;
  String? contactNo;
  bool? liveStatus;

  EditProfileRequestModel({
    this.sellerId,
    this.name,
    this.email,
    this.contactNo,
    this.liveStatus,
  });

  EditProfileRequestModel.fromJson(Map<String, dynamic> json) {
    sellerId = json['sellerId'];
    name = json['name'];
    email = json['email'];
    contactNo = json['contactNo'];
    liveStatus = json['live_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sellerId'] = sellerId;
    data['name'] = name;
    data['email'] = email;
    data['contactNo'] = contactNo;
    data['live_status'] = liveStatus;
    return data;
  }
}
