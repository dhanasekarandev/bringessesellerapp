import 'package:bringessesellerapp/model/response/promotion_checkout_response_model.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:equatable/equatable.dart';

class PromotionCheckoutState extends Equatable {
  final NetworkStatusEnum networkStatusEnum;
  final PromotionCheckoutResponseModel promotionResponseModel;

  const PromotionCheckoutState(
      {required this.networkStatusEnum, required this.promotionResponseModel});

  factory PromotionCheckoutState.initial() => PromotionCheckoutState(
        networkStatusEnum: NetworkStatusEnum.initial,
        promotionResponseModel: PromotionCheckoutResponseModel(),
      );

  @override
  List<Object?> get props => [networkStatusEnum, promotionResponseModel];

  PromotionCheckoutState copyWith(
      {NetworkStatusEnum? networkStatusEnum,
      NetworkStatusEnum? childNetworkStatusEnum,
      int? currentPage,
      PromotionCheckoutResponseModel? promotionResponseModel}) {
    return PromotionCheckoutState(
        promotionResponseModel: promotionResponseModel ?? this.promotionResponseModel,
        networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum);
  }
}
