import 'package:bringessesellerapp/model/response/change_password_model.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:equatable/equatable.dart';

class ChangePasswordState extends Equatable {
  final NetworkStatusEnum networkStatusEnum;
  final ChangePasswordModel ChangePassword;

  const ChangePasswordState(
      {required this.networkStatusEnum, required this.ChangePassword});

  factory ChangePasswordState.initial() => ChangePasswordState(
        networkStatusEnum: NetworkStatusEnum.initial,
        ChangePassword: ChangePasswordModel(),
      );

  @override
  List<Object?> get props => [networkStatusEnum, ChangePassword];

  ChangePasswordState copyWith(
      {NetworkStatusEnum? networkStatusEnum,
      NetworkStatusEnum? childNetworkStatusEnum,
      int? currentPage,
      ChangePasswordModel? ChangePassword}) {
    return ChangePasswordState(
        ChangePassword: ChangePassword ?? this.ChangePassword,
        networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum);
  }
}
