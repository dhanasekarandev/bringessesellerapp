import 'package:bringessesellerapp/model/response/notification_model.dart';
import 'package:bringessesellerapp/model/response/store_update_status_res_model.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:equatable/equatable.dart';

class StoreStatusState extends Equatable {
  final NetworkStatusEnum networkStatusEnum;
  final StoreUpdateStatusResponse notificationResponseModel;

  const StoreStatusState(
      {required this.networkStatusEnum,
      required this.notificationResponseModel});

  factory StoreStatusState.initial() => StoreStatusState(
        networkStatusEnum: NetworkStatusEnum.initial,
        notificationResponseModel: StoreUpdateStatusResponse(),
      );

  @override
  List<Object?> get props => [networkStatusEnum, notificationResponseModel];

  StoreStatusState copyWith(
      {NetworkStatusEnum? networkStatusEnum,
      NetworkStatusEnum? childNetworkStatusEnum,
      int? currentPage,
      StoreUpdateStatusResponse? notificationResponseModel}) {
    return StoreStatusState(
        notificationResponseModel:
            notificationResponseModel ?? this.notificationResponseModel,
        networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum);
  }
}
