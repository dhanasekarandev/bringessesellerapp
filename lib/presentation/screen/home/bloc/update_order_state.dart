import 'package:bringessesellerapp/model/response/order_update_res_model.dart';


import 'package:bringessesellerapp/utils/enums.dart';
import 'package:equatable/equatable.dart';

class UpdateOrderState extends Equatable {
  final NetworkStatusEnum networkStatusEnum;
  final OrderUpdateResponseModel reviewResponseModel;

  const UpdateOrderState(
      {required this.networkStatusEnum, required this.reviewResponseModel});

  factory UpdateOrderState.initial() => UpdateOrderState(
        networkStatusEnum: NetworkStatusEnum.initial,
        reviewResponseModel: OrderUpdateResponseModel(),
      );

  @override
  List<Object?> get props => [networkStatusEnum, reviewResponseModel];

  UpdateOrderState copyWith(
      {NetworkStatusEnum? networkStatusEnum,
      NetworkStatusEnum? childNetworkStatusEnum,
      int? currentPage,
      OrderUpdateResponseModel? reviewResponseModel}) {
    return UpdateOrderState(
        reviewResponseModel: reviewResponseModel ?? this.reviewResponseModel,
        networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum);
  }
}
