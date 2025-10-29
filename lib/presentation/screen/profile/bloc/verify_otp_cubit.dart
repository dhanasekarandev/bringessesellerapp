import 'package:bringessesellerapp/presentation/repository/auth_repo.dart';

import 'package:bringessesellerapp/presentation/screen/profile/bloc/verify_otp_state.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyOtpCubit extends Cubit<VerifyOtpState> {
  AuthRepository authRepository;

  VerifyOtpCubit({required this.authRepository})
      : super(VerifyOtpState.initial());

  void login(ChangeMpinRequestModel) async {
    emit(state.copyWith(networkStatusEnum: NetworkStatusEnum.loading));

    (bool, dynamic) response =
        await authRepository.verifyOTP(ChangeMpinRequestModel);

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
