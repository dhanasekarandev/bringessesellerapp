import 'package:bringessesellerapp/presentation/repository/auth_repo.dart';

import 'package:bringessesellerapp/presentation/screen/profile/bloc/logout_state.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogoutCubit extends Cubit<LogoutState> {
  AuthRepository authRepository;

  LogoutCubit({required this.authRepository}) : super(LogoutState.initial());

  void login(EditProfileRequestModel) async {
    emit(state.copyWith(networkStatusEnum: NetworkStatusEnum.loading));

    (bool, dynamic) response =
        await authRepository.logOut(EditProfileRequestModel);

    if (response.$1 == true) {
      emit(state.copyWith(
        networkStatusEnum: NetworkStatusEnum.loaded,
        logoutResponse: response.$2,
      ));
    } else {
      emit(state.copyWith(
          networkStatusEnum: NetworkStatusEnum.failed,
          logoutResponse: response.$2));
    }
  }
}
