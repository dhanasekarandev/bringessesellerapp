
import 'package:bringessesellerapp/model/response/notification_model.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:equatable/equatable.dart';

class NotificationState extends Equatable {
  final NetworkStatusEnum networkStatusEnum;
  final NotificationResponseModel notificationResponseModel;

  const NotificationState(
      {required this.networkStatusEnum,
      required this.notificationResponseModel});

  factory NotificationState.initial() => NotificationState(
        networkStatusEnum: NetworkStatusEnum.initial,
        notificationResponseModel: NotificationResponseModel(),
      );

  @override
  List<Object?> get props => [networkStatusEnum, notificationResponseModel];

  NotificationState copyWith(
      {NetworkStatusEnum? networkStatusEnum,
      NetworkStatusEnum? childNetworkStatusEnum,
      int? currentPage,
      NotificationResponseModel? notificationResponseModel}) {
    return NotificationState(
        notificationResponseModel:
            notificationResponseModel ?? this.notificationResponseModel,
        networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum);
  }
}
