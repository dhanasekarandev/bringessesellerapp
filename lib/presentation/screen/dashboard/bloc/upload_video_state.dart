
import 'package:bringessesellerapp/model/response/video_upload_response_model.dart';

import 'package:bringessesellerapp/utils/enums.dart';
import 'package:equatable/equatable.dart';

class UploadVideoState extends Equatable {
  final NetworkStatusEnum networkStatusEnum;
  final UploadVideoResModel videoResModel;

  const UploadVideoState(
      {required this.networkStatusEnum, required this.videoResModel});

  factory UploadVideoState.initial() => UploadVideoState(
        networkStatusEnum: NetworkStatusEnum.initial,
        videoResModel: UploadVideoResModel(),
      );

  @override
  List<Object?> get props => [networkStatusEnum, videoResModel];

  UploadVideoState copyWith(
      {NetworkStatusEnum? networkStatusEnum,
      NetworkStatusEnum? childNetworkStatusEnum,
      int? currentPage,
      UploadVideoResModel? productupdateres}) {
    return UploadVideoState(
        videoResModel: productupdateres ?? this.videoResModel,
        networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum);
  }
}
