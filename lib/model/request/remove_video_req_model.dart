class RemoveVideoReqModel {
  String? videoUrl;

  RemoveVideoReqModel({this.videoUrl});

  RemoveVideoReqModel.fromJson(Map<String, dynamic> json) {
    videoUrl = json['videoUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (videoUrl != null) data['videoUrl'] = videoUrl;
    return data;
  }
}
