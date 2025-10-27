class AccountDetailModel {
  String? status;
  SellerDetails? sellerDetails;

  AccountDetailModel({this.status, this.sellerDetails});

  AccountDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    sellerDetails = json['sellerDetails'] != null
        ? SellerDetails.fromJson(json['sellerDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    if (sellerDetails != null) {
      data['sellerDetails'] = sellerDetails!.toJson();
    }
    return data;
  }
}

class SellerDetails {
  String? accountName;
  String? ifsc;
  int? accountNumber;
  String? pancard;
  String? street1;
  String? street2;
  String? city;
  String? state;
  String? country;
  int? postalCode;
  String? paymentStatus;

  SellerDetails({
    this.accountName,
    this.ifsc,
    this.accountNumber,
    this.pancard,
    this.street1,
    this.street2,
    this.city,
    this.state,
    this.country,
    this.postalCode,
    this.paymentStatus,
  });

  SellerDetails.fromJson(Map<String, dynamic> json) {
    accountName = json['account_name'];
    ifsc = json['ifsc'];
    accountNumber = json['account_number'];
    pancard = json['pancard'];
    street1 = json['street1'];
    street2 = json['street2'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    postalCode = json['postal_code'];
    paymentStatus = json['paymentStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['account_name'] = accountName;
    data['ifsc'] = ifsc;
    data['account_number'] = accountNumber;
    data['pancard'] = pancard;
    data['street1'] = street1;
    data['street2'] = street2;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['postal_code'] = postalCode;
    data['paymentStatus'] = paymentStatus;
    return data;
  }
}
