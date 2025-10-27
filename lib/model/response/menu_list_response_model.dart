class MenuListModel {
  String? status;
  int? statusCode;
  MenuResult? result;

  MenuListModel({this.status, this.statusCode, this.result});

  MenuListModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    status = json['status'];
    result = json['result'] != null ? MenuResult.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status_code'] = statusCode;
    data['status'] = status;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class MenuResult {
  int? count;
  int? menuCount;
  List<Menu>? menus;

  MenuResult({this.count, this.menuCount, this.menus});

  MenuResult.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    menuCount = json['menuCount'];
    if (json['menus'] != null) {
      menus = <Menu>[];
      json['menus'].forEach((v) {
        menus!.add(Menu.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['count'] = count;
    data['menuCount'] = menuCount;
    if (menus != null) {
      data['menus'] = menus!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Menu {
  String? id;
  String? name;
  String? image;
  String? subCategoryId;
  String? subCategoryName;
  int? status;
  String? createdAt;

  Menu({
    this.id,
    this.name,
    this.image,
    this.subCategoryId,
    this.subCategoryName,
    this.status,
    this.createdAt,
  });

  Menu.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    subCategoryId = json['subCategoryId'];
    subCategoryName = json['subCategoryName'];
    status = json['status'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['subCategoryId'] = subCategoryId;
    data['subCategoryName'] = subCategoryName;
    data['status'] = status;
    data['created_at'] = createdAt;
    return data;
  }
}
