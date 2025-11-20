class TermsResponseModel {
  int? statusCode;
  List<TermItem>? result;

  TermsResponseModel({this.statusCode, this.result});

  TermsResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    if (json['result'] != null) {
      result = <TermItem>[];
      json['result'].forEach((v) {
        result!.add(TermItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status_code'] = statusCode;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TermItem {
  String? id;
  String? title;
  String? description;
  int? status;
  String? type;
  String? createdAt;
  String? updatedAt;
  int? v;

  TermItem({
    this.id,
    this.title,
    this.description,
    this.status,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  TermItem.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    title = json['title'];
    description = json['description'];
    status = json['status'];
    type = json['type'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['status'] = status;
    data['type'] = type;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = v;
    return data;
  }
}
