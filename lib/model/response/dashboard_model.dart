class DashboardModel {
  String? status;
  int? totalOrders;
  int? totalMenus;
  int? totalItems;
  int? totalReviews;
  int? successfulOrders;
  int? unSuccessfulOrders;
  num? totalRevenue;
  num? spendPromotion;
  num? spendSubscription;
  String? currencySymbol;
  int? sellerStatus;
  String? paymentStatus;
  int? liveStatus;

  DashboardModel({
    this.status,
    this.totalOrders,
    this.totalMenus,
    this.totalItems,
    this.totalReviews,
    this.successfulOrders,
    this.unSuccessfulOrders,
    this.totalRevenue,
    this.spendPromotion,
    this.spendSubscription,
    this.currencySymbol,
    this.sellerStatus,
    this.paymentStatus,
    this.liveStatus,
  });

  DashboardModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalOrders = json['totalOrders'];
    totalMenus = json['totalMenus'];
    totalItems = json['totalItems'];
    totalReviews = json['totalReviews'];
    successfulOrders = json['successfulOrders'];
    unSuccessfulOrders = json['unSuccessfulOrders'];
    totalRevenue = json['totalRevenue'];
    spendPromotion = json['spendPromotion'];
    spendSubscription = json['spendSubscription'];
    currencySymbol = json['currencySymbol'];
    sellerStatus = json['sellerStatus'];
    paymentStatus = json['paymentStatus'];
    liveStatus = json['live_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    data['totalOrders'] = totalOrders;
    data['totalMenus'] = totalMenus;
    data['totalItems'] = totalItems;
    data['totalReviews'] = totalReviews;
    data['successfulOrders'] = successfulOrders;
    data['unSuccessfulOrders'] = unSuccessfulOrders;
    data['totalRevenue'] = totalRevenue;
    data['spendPromotion'] = spendPromotion;
    data['spendSubscription'] = spendSubscription;
    data['currencySymbol'] = currencySymbol;
    data['sellerStatus'] = sellerStatus;
    data['paymentStatus'] = paymentStatus;
    data['live_status'] = liveStatus;
    return data;
  }
}
