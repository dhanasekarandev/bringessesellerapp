import 'package:bringessesellerapp/model/response/change_password_model.dart';
import 'package:bringessesellerapp/model/response/verify_otp_response_model.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:equatable/equatable.dart';

class VerifyOtpState extends Equatable {
  final NetworkStatusEnum networkStatusEnum;
  final VerifyOtpResponseModel ChangePassword;

  const VerifyOtpState(
      {required this.networkStatusEnum, required this.ChangePassword});

  factory VerifyOtpState.initial() => VerifyOtpState(
        networkStatusEnum: NetworkStatusEnum.initial,
        ChangePassword: VerifyOtpResponseModel(),
      );

  @override
  List<Object?> get props => [networkStatusEnum, ChangePassword];

  VerifyOtpState copyWith(
      {NetworkStatusEnum? networkStatusEnum,
      NetworkStatusEnum? childNetworkStatusEnum,
      int? currentPage,
      VerifyOtpResponseModel? ChangePassword}) {
    return VerifyOtpState(
        ChangePassword: ChangePassword ?? this.ChangePassword,
        networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum);
  }
}
