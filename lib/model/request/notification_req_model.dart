class NotificationReqModel {
  String? pageId;
  String? sellerId;
  String? offset;

  NotificationReqModel({
    this.pageId,
    this.sellerId,
    this.offset,
  });

  NotificationReqModel.fromJson(Map<String, dynamic> json) {
    pageId = json['pageId'];
    sellerId = json['sellerId'];
    offset = json['offset'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['pageId'] = pageId;
    data['sellerId'] = sellerId;
    data['offset'] = offset;
    return data;
  }
}
