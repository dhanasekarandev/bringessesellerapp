import 'package:bringessesellerapp/model/response/dashboard_model.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:equatable/equatable.dart';

class DashboardState extends Equatable {
  final NetworkStatusEnum networkStatusEnum;
  final DashboardModel dashboardModel;

  const DashboardState(
      {required this.networkStatusEnum, required this.dashboardModel});

  factory DashboardState.initial() => DashboardState(
        networkStatusEnum: NetworkStatusEnum.initial,
        dashboardModel: DashboardModel(),
      );

  @override
  List<Object?> get props => [networkStatusEnum, dashboardModel];

  DashboardState copyWith(
      {NetworkStatusEnum? networkStatusEnum,
      NetworkStatusEnum? childNetworkStatusEnum,
      int? currentPage,
      DashboardModel? dashboardModel}) {
    return DashboardState(
        dashboardModel: dashboardModel ?? this.dashboardModel,
        networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum);
  }
}
