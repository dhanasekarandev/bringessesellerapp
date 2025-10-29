class SendOtpReqModel {
  String? type; // e.g. "phone" or "email"
 
  String? phoneNumber;
  String? email;

  SendOtpReqModel({
    this.type,
 
    this.phoneNumber,
    this.email,
  });

  // 🔹 fromJson constructor
  SendOtpReqModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
   
    phoneNumber = json['phonenumber'];
    email = json['email'];
  }

  // 🔹 Convert to JSON (skip nulls)
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (type != null) data['type'] = type;
 
    if (phoneNumber != null) data['phonenumber'] = phoneNumber;
    if (email != null) data['email'] = email;
    return data;
  }

  @override
  String toString() {
    return 'SendOtpReqModel(type: $type, phonenumber: $phoneNumber, email: $email)';
  }
}
