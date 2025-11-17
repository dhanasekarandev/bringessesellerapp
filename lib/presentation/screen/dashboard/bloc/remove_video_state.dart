import 'package:bringessesellerapp/model/response/common_success_res_model.dart';


import 'package:bringessesellerapp/utils/enums.dart';
import 'package:equatable/equatable.dart';

class RemoveVideoState extends Equatable {
  final NetworkStatusEnum networkStatusEnum;
  final CommonSuccessResModel videoResModel;

  const RemoveVideoState(
      {required this.networkStatusEnum, required this.videoResModel});

  factory RemoveVideoState.initial() => RemoveVideoState(
        networkStatusEnum: NetworkStatusEnum.initial,
        videoResModel: CommonSuccessResModel(),
      );

  @override
  List<Object?> get props => [networkStatusEnum, videoResModel];

  RemoveVideoState copyWith(
      {NetworkStatusEnum? networkStatusEnum,
      NetworkStatusEnum? childNetworkStatusEnum,
      int? currentPage,
      CommonSuccessResModel? productupdateres}) {
    return RemoveVideoState(
        videoResModel: productupdateres ?? this.videoResModel,
        networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum);
  }
}
