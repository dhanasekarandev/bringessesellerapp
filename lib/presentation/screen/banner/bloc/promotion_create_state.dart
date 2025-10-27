import 'package:bringessesellerapp/model/response/promotion_create_response.dart';

import 'package:bringessesellerapp/utils/enums.dart';
import 'package:equatable/equatable.dart';

class PromotionCreateState extends Equatable {
  final NetworkStatusEnum networkStatusEnum;
  final PromotionResponseModel promotionResponseModel;

  const PromotionCreateState(
      {required this.networkStatusEnum, required this.promotionResponseModel});

  factory PromotionCreateState.initial() => PromotionCreateState(
        networkStatusEnum: NetworkStatusEnum.initial,
        promotionResponseModel: PromotionResponseModel(),
      );

  @override
  List<Object?> get props => [networkStatusEnum, promotionResponseModel];

  PromotionCreateState copyWith(
      {NetworkStatusEnum? networkStatusEnum,
      NetworkStatusEnum? childNetworkStatusEnum,
      int? currentPage,
      PromotionResponseModel? promotionResponseModel}) {
    return PromotionCreateState(
        promotionResponseModel: promotionResponseModel ?? this.promotionResponseModel,
        networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum);
  }
}
