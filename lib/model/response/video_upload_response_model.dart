class UploadVideoResModel {
  String? status;
  String? videoUrl;

  UploadVideoResModel({this.status, this.videoUrl});

  UploadVideoResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    videoUrl = json['videoUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (status != null) data['status'] = status;
    if (videoUrl != null) data['videoUrl'] = videoUrl;
    return data;
  }
}
