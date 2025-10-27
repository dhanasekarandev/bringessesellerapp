import 'package:bringessesellerapp/presentation/repository/auth_repo.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/subcription_defaults_state.dart';

import 'package:bringessesellerapp/utils/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubscriptionDefaultCubit extends Cubit<SubcriptionDefaultsState> {
  AuthRepository authRepository;

  SubscriptionDefaultCubit({required this.authRepository})
      : super(SubcriptionDefaultsState.initial());

  void login() async {
    emit(state.copyWith(networkStatusEnum: NetworkStatusEnum.loading));

    (bool, dynamic) response = await authRepository.subcriptionDefaults();

    if (response.$1 == true) {
      emit(state.copyWith(
        networkStatusEnum: NetworkStatusEnum.loaded,
        viewProfile: response.$2,
      ));
    } else {
      emit(state.copyWith(
          networkStatusEnum: NetworkStatusEnum.failed,
          viewProfile: response.$2));
    }
  }
}
