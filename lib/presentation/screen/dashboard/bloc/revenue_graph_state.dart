import 'package:bringessesellerapp/model/response/revenue_graph_res_model.dart';


import 'package:bringessesellerapp/utils/enums.dart';
import 'package:equatable/equatable.dart';

class RevenueGraphState extends Equatable {
  final NetworkStatusEnum networkStatusEnum;
  final RevenueGraphResModel revenueGraphResModel;

  const RevenueGraphState(
      {required this.networkStatusEnum, required this.revenueGraphResModel});

  factory RevenueGraphState.initial() => RevenueGraphState(
        networkStatusEnum: NetworkStatusEnum.initial,
        revenueGraphResModel: RevenueGraphResModel(),
      );

  @override
  List<Object?> get props => [networkStatusEnum, revenueGraphResModel];

  RevenueGraphState copyWith(
      {NetworkStatusEnum? networkStatusEnum,
      NetworkStatusEnum? childNetworkStatusEnum,
      int? currentPage,
      RevenueGraphResModel? revenueGraphResModel}) {
    return RevenueGraphState(
        revenueGraphResModel: revenueGraphResModel ?? this.revenueGraphResModel,
        networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum);
  }
}
