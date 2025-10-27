class TransactionResponseModel {
  int? statusCode;
  String? status;
  String? message;

  TransactionResponseModel({
    this.statusCode,
    this.status,
    this.message,
  });

  factory TransactionResponseModel.fromJson(Map<String, dynamic> json) {
    return TransactionResponseModel(
      statusCode: json['status_code'],
      status: json['status'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status_code'] = statusCode;
    data['status'] = status;
    data['message'] = message;

    return data;
  }
}
