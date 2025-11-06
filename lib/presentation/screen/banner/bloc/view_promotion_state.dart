
import 'package:bringessesellerapp/model/response/view_transaction_response_model.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:equatable/equatable.dart';

class ViewPromotionState extends Equatable {
  final NetworkStatusEnum networkStatusEnum;
  final BannerResponseModel promotionpreRes;

  const ViewPromotionState(
      {required this.networkStatusEnum, required this.promotionpreRes});

  factory ViewPromotionState.initial() => ViewPromotionState(
        networkStatusEnum: NetworkStatusEnum.initial,
        promotionpreRes: BannerResponseModel(),
      );

  @override
  List<Object?> get props => [networkStatusEnum, promotionpreRes];

  ViewPromotionState copyWith(
      {NetworkStatusEnum? networkStatusEnum,
      NetworkStatusEnum? childNetworkStatusEnum,
      int? currentPage,
      BannerResponseModel? promotionpreRes}) {
    return ViewPromotionState(
        promotionpreRes: promotionpreRes ?? this.promotionpreRes,
        networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum);
  }
}
