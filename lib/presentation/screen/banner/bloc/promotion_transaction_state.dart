import 'package:bringessesellerapp/model/response/transaction_response_model.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:equatable/equatable.dart';

class PromotionTransactionState extends Equatable {
  final NetworkStatusEnum networkStatusEnum;
  final TransactionResponseModel promotionResponseModel;

  const PromotionTransactionState(
      {required this.networkStatusEnum, required this.promotionResponseModel});

  factory PromotionTransactionState.initial() => PromotionTransactionState(
        networkStatusEnum: NetworkStatusEnum.initial,
        promotionResponseModel: TransactionResponseModel(),
      );

  @override
  List<Object?> get props => [networkStatusEnum, promotionResponseModel];

  PromotionTransactionState copyWith(
      {NetworkStatusEnum? networkStatusEnum,
      NetworkStatusEnum? childNetworkStatusEnum,
      int? currentPage,
      TransactionResponseModel? promotionResponseModel}) {
    return PromotionTransactionState(
        promotionResponseModel: promotionResponseModel ?? this.promotionResponseModel,
        networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum);
  }
}
