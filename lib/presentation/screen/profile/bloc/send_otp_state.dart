
import 'package:bringessesellerapp/model/response/send_otp_response_model.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:equatable/equatable.dart';

class SendOtpState extends Equatable {
  final NetworkStatusEnum networkStatusEnum;
  final SendOtpResModel ChangePassword;

  const SendOtpState(
      {required this.networkStatusEnum, required this.ChangePassword});

  factory SendOtpState.initial() => SendOtpState(
        networkStatusEnum: NetworkStatusEnum.initial,
        ChangePassword: SendOtpResModel(),
      );

  @override
  List<Object?> get props => [networkStatusEnum, ChangePassword];

  SendOtpState copyWith(
      {NetworkStatusEnum? networkStatusEnum,
      NetworkStatusEnum? childNetworkStatusEnum,
      int? currentPage,
      SendOtpResModel? ChangePassword}) {
    return SendOtpState(
        ChangePassword: ChangePassword ?? this.ChangePassword,
        networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum);
  }
}
