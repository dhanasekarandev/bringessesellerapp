import 'package:bringessesellerapp/presentation/repository/auth_repo.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/send_otp_state.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SendOtpCubit extends Cubit<SendOtpState> {
  AuthRepository authRepository;

  SendOtpCubit({required this.authRepository}) : super(SendOtpState.initial());

  void login(ChangeMpinRequestModel) async {
    emit(state.copyWith(networkStatusEnum: NetworkStatusEnum.loading));

    (bool, dynamic) response =
        await authRepository.sendOTP(ChangeMpinRequestModel);

    if (response.$1 == true) {
      emit(state.copyWith(
        networkStatusEnum: NetworkStatusEnum.loaded,
        ChangePassword: response.$2,
      ));
    } else {
      emit(state.copyWith(
          networkStatusEnum: NetworkStatusEnum.failed,
          ChangePassword: response.$2));
    }
  }
}
