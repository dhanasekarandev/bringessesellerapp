import 'package:bringessesellerapp/model/response/revenue_response_model.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:equatable/equatable.dart';

class RevenueState extends Equatable {
  final NetworkStatusEnum networkStatusEnum;
  final RevenueResponseModel orderlistresponse;

  const RevenueState(
      {required this.networkStatusEnum, required this.orderlistresponse});

  factory RevenueState.initial() => RevenueState(
        networkStatusEnum: NetworkStatusEnum.initial,
        orderlistresponse: RevenueResponseModel(),
      );

  @override
  List<Object?> get props => [networkStatusEnum, orderlistresponse];

  RevenueState copyWith(
      {NetworkStatusEnum? networkStatusEnum,
      NetworkStatusEnum? childNetworkStatusEnum,
      int? currentPage,
      RevenueResponseModel? orderlistresponse}) {
    return RevenueState(
        orderlistresponse: orderlistresponse ?? this.orderlistresponse,
        networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum);
  }
}
