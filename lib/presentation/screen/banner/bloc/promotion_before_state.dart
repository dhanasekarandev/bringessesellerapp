import 'package:bringessesellerapp/model/response/promotion_predata_response_model.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:equatable/equatable.dart';

class PromotionBeforeState extends Equatable {
  final NetworkStatusEnum networkStatusEnum;
  final PromotionPredataResponseModel promotionpreRes;

  const PromotionBeforeState(
      {required this.networkStatusEnum, required this.promotionpreRes});

  factory PromotionBeforeState.initial() => PromotionBeforeState(
        networkStatusEnum: NetworkStatusEnum.initial,
        promotionpreRes: PromotionPredataResponseModel(),
      );

  @override
  List<Object?> get props => [networkStatusEnum, promotionpreRes];

  PromotionBeforeState copyWith(
      {NetworkStatusEnum? networkStatusEnum,
      NetworkStatusEnum? childNetworkStatusEnum,
      int? currentPage,
      PromotionPredataResponseModel? promotionpreRes}) {
    return PromotionBeforeState(
        promotionpreRes: promotionpreRes ?? this.promotionpreRes,
        networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum);
  }
}
