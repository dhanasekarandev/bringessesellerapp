class CommonSuccessResModel {
  String? status;
  String? message;

  CommonSuccessResModel({
    this.status,
    this.message,
  });

  factory CommonSuccessResModel.fromJson(Map<String, dynamic> json) {
    return CommonSuccessResModel(
      status: json['status'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['status'] = status;
    data['message'] = message;

    return data;
  }
}
