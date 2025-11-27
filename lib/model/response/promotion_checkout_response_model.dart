class PromotionCheckoutResponseModel {
  String? status;
  int? statuscode;
  String? gateway;
  String? orderId;
  int? amount;
  String? mode;
  String? key;
  String? currency;
  String? message;
  String? paymentLink;
  SessionData? session;

  PromotionCheckoutResponseModel({
    this.status,
    this.statuscode,
    this.orderId,
    this.currency,
    this.key,
    this.amount,
    this.message,
    this.paymentLink,
    this.session,
    this.gateway,
    this.mode,
  });

  PromotionCheckoutResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statuscode = json['status_code'];
    orderId = json['orderId'];
    currency = json['currency'];
    amount = json['amount'];
    key = json['key'];
    message = json['message'];
    mode = json['mode'];
    gateway = json['gateway'];
    paymentLink = json['paymentLink'];
    session = json['session'] != null ? SessionData.fromJson(json['session']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (status != null) data['status'] = status;
    if (statuscode != null) data['status_code'] = statuscode;
    if (orderId != null) data['orderId'] = orderId;
    if (currency != null) data['currency'] = currency;
    if (amount != null) data['amount'] = amount;
    if (key != null) data['key'] = key;
    if (message != null) data['message'] = message;
    if (mode != null) data['mode'] = mode;
    if (gateway != null) data['gateway'] = gateway;
    if (paymentLink != null) data['paymentLink'] = paymentLink;
    if (session != null) data['session'] = session!.toJson();

    return data;
  }
}

class SessionData {
  String? status;
  String? id;
  String? orderId;
  PaymentLinks? paymentLinks;
  SdkPayload? sdkPayload;

  SessionData({
    this.status,
    this.id,
    this.orderId,
    this.paymentLinks,
    this.sdkPayload,
  });

  factory SessionData.fromJson(Map<String, dynamic> json) {
    return SessionData(
      status: json['status'],
      id: json['id'],
      orderId: json['order_id'],
      paymentLinks: json['payment_links'] != null
          ? PaymentLinks.fromJson(json['payment_links'])
          : null,
      sdkPayload: json['sdk_payload'] != null
          ? SdkPayload.fromJson(json['sdk_payload'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (status != null) data['status'] = status;
    if (id != null) data['id'] = id;
    if (orderId != null) data['order_id'] = orderId;
    if (paymentLinks != null) data['payment_links'] = paymentLinks!.toJson();
    if (sdkPayload != null) data['sdk_payload'] = sdkPayload!.toJson();
    return data;
  }
}

class PaymentLinks {
  String? web;
  dynamic expiry;

  PaymentLinks({this.web, this.expiry});

  factory PaymentLinks.fromJson(Map<String, dynamic> json) {
    return PaymentLinks(
      web: json['web'],
      expiry: json['expiry'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (web != null) data['web'] = web;
    data['expiry'] = expiry;
    return data;
  }
}

class SdkPayload {
  String? requestId;
  String? service;
  JuspayPayload? payload;
  String? currTime;
  String? xRoutingId;

  SdkPayload({this.requestId, this.service, this.payload, this.currTime, this.xRoutingId});

  factory SdkPayload.fromJson(Map<String, dynamic> json) {
    return SdkPayload(
      requestId: json['requestId'],
      service: json['service'],
      payload: json['payload'] != null ? JuspayPayload.fromJson(json['payload']) : null,
      currTime: json['currTime'],
      xRoutingId: json['xRoutingId'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (requestId != null) data['requestId'] = requestId;
    if (service != null) data['service'] = service;
    if (payload != null) data['payload'] = payload!.toJson();
    if (currTime != null) data['currTime'] = currTime;
    if (xRoutingId != null) data['xRoutingId'] = xRoutingId;
    return data;
  }
}

class JuspayPayload {
  String? clientId;
  String? customerId;
  String? orderId;
  String? returnUrl;
  String? currency;
  String? customerPhone;
  String? service;
  String? environment;
  String? merchantId;
  String? amount;
  String? clientAuthTokenExpiry;
  String? clientAuthToken;
  String? action;
  bool? collectAvsInfo;

  JuspayPayload({
    this.clientId,
    this.customerId,
    this.orderId,
    this.returnUrl,
    this.currency,
    this.customerPhone,
    this.service,
    this.environment,
    this.merchantId,
    this.amount,
    this.clientAuthTokenExpiry,
    this.clientAuthToken,
    this.action,
    this.collectAvsInfo,
  });

  factory JuspayPayload.fromJson(Map<String, dynamic> json) {
    return JuspayPayload(
      clientId: json['clientId'],
      customerId: json['customerId'],
      orderId: json['orderId'],
      returnUrl: json['returnUrl'],
      currency: json['currency'],
      customerPhone: json['customerPhone'],
      service: json['service'],
      environment: json['environment'],
      merchantId: json['merchantId'],
      amount: json['amount'],
      clientAuthTokenExpiry: json['clientAuthTokenExpiry'],
      clientAuthToken: json['clientAuthToken'],
      action: json['action'],
      collectAvsInfo: json['collectAvsInfo'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (clientId != null) data['clientId'] = clientId;
    if (customerId != null) data['customerId'] = customerId;
    if (orderId != null) data['orderId'] = orderId;
    if (returnUrl != null) data['returnUrl'] = returnUrl;
    if (currency != null) data['currency'] = currency;
    if (customerPhone != null) data['customerPhone'] = customerPhone;
    if (service != null) data['service'] = service;
    if (environment != null) data['environment'] = environment;
    if (merchantId != null) data['merchantId'] = merchantId;
    if (amount != null) data['amount'] = amount;
    if (clientAuthTokenExpiry != null) data['clientAuthTokenExpiry'] = clientAuthTokenExpiry;
    if (clientAuthToken != null) data['clientAuthToken'] = clientAuthToken;
    if (action != null) data['action'] = action;
    if (collectAvsInfo != null) data['collectAvsInfo'] = collectAvsInfo;
    return data;
  }
}
