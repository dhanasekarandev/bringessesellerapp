import 'package:bringessesellerapp/model/response/change_password_model.dart';


import 'package:bringessesellerapp/utils/enums.dart';
import 'package:equatable/equatable.dart';

class DeleteBannerState extends Equatable {
  final NetworkStatusEnum networkStatusEnum;
  final ChangePasswordModel promotionResponseModel;

  const DeleteBannerState(
      {required this.networkStatusEnum, required this.promotionResponseModel});

  factory DeleteBannerState.initial() => DeleteBannerState(
        networkStatusEnum: NetworkStatusEnum.initial,
        promotionResponseModel: ChangePasswordModel(),
      );

  @override
  List<Object?> get props => [networkStatusEnum, promotionResponseModel];

  DeleteBannerState copyWith(
      {NetworkStatusEnum? networkStatusEnum,
      NetworkStatusEnum? childNetworkStatusEnum,
      int? currentPage,
      ChangePasswordModel? promotionResponseModel}) {
    return DeleteBannerState(
        promotionResponseModel: promotionResponseModel ?? this.promotionResponseModel,
        networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum);
  }
}
