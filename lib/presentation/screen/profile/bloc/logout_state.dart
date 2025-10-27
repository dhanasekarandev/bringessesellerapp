
import 'package:bringessesellerapp/model/response/logout_response_model.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:equatable/equatable.dart';

class LogoutState extends Equatable {
  final NetworkStatusEnum networkStatusEnum;
  final LogoutResponseModel logoutResponse;

  const LogoutState(
      {required this.networkStatusEnum, required this.logoutResponse});

  factory LogoutState.initial() => LogoutState(
        networkStatusEnum: NetworkStatusEnum.initial,
        logoutResponse: LogoutResponseModel(),
      );

  @override
  List<Object?> get props => [networkStatusEnum, logoutResponse];

  LogoutState copyWith(
      {NetworkStatusEnum? networkStatusEnum,
      NetworkStatusEnum? childNetworkStatusEnum,
      int? currentPage,
      LogoutResponseModel? logoutResponse}) {
    return LogoutState(
        logoutResponse: logoutResponse ?? this.logoutResponse,
        networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum);
  }
}
