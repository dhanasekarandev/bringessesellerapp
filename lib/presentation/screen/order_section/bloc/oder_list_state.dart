
import 'package:bringessesellerapp/model/response/oder_list_response.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:equatable/equatable.dart';

class OderListState extends Equatable {
  final NetworkStatusEnum networkStatusEnum;
  final OrderListResponse orderlistresponse;

  const OderListState(
      {required this.networkStatusEnum, required this.orderlistresponse});

  factory OderListState.initial() => OderListState(
        networkStatusEnum: NetworkStatusEnum.initial,
        orderlistresponse: OrderListResponse(),
      );

  @override
  List<Object?> get props => [networkStatusEnum, orderlistresponse];

  OderListState copyWith(
      {NetworkStatusEnum? networkStatusEnum,
      NetworkStatusEnum? childNetworkStatusEnum,
      int? currentPage,
      OrderListResponse? orderlistresponse}) {
    return OderListState(
        orderlistresponse: orderlistresponse ?? this.orderlistresponse,
        networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum);
  }
}
