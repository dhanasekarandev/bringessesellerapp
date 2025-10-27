class BankAccountRequestModel {
  String? sellerId;
  String? pancard;
  String? accountNumber;
  String? ifsc;
  String? accountName;
  String? postalCode;
  String? street1;
  String? street2;
  String? city;
  String? state;
  String? country;

  BankAccountRequestModel({
    this.sellerId,
    this.pancard,
    this.accountNumber,
    this.ifsc,
    this.accountName,
    this.postalCode,
    this.street1,
    this.street2,
    this.city,
    this.state,
    this.country,
  });

  BankAccountRequestModel.fromJson(Map<String, dynamic> json) {
    sellerId = json['sellerId'];
    pancard = json['pancard'];
    accountNumber = json['account_number'];
    ifsc = json['ifsc'];
    accountName = json['account_name'];
    postalCode = json['postal_code'];
    street1 = json['street1'];
    street2 = json['street2'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sellerId'] = sellerId;
    data['pancard'] = pancard;
    data['account_number'] = accountNumber;
    data['ifsc'] = ifsc;
    data['account_name'] = accountName;
    data['postal_code'] = postalCode;
    data['street1'] = street1;
    data['street2'] = street2;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    return data;
  }
}
