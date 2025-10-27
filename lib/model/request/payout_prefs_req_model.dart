class PayoutRequestModel {
  String? sellerId;
  String? pancard;
  String? accountNumber;
  String? ifsc;
  String? accountName;
  String? postalCode;
  String? street2;
  String? street1;
  String? city;
  String? state;

  PayoutRequestModel({
    this.sellerId,
    this.pancard,
    this.accountNumber,
    this.ifsc,
    this.accountName,
    this.postalCode,
    this.street2,
    this.street1,
    this.city,
    this.state,
  });

  PayoutRequestModel.fromJson(Map<String, dynamic> json) {
    sellerId = json['sellerId'];
    pancard = json['pancard'];
    accountNumber = json['account_number'];
    ifsc = json['ifsc'];
    accountName = json['account_name'];
    postalCode = json['postal_code'];
    street2 = json['street2'];
    street1 = json['street1'];
    city = json['city'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sellerId'] = sellerId;
    data['pancard'] = pancard;
    data['account_number'] = accountNumber;
    data['ifsc'] = ifsc;
    data['account_name'] = accountName;
    data['postal_code'] = postalCode;
    data['street2'] = street2;
    data['street1'] = street1;
    data['city'] = city;
    data['state'] = state;

    return data;
  }
}
