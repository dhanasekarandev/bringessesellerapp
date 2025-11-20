import 'package:bringessesellerapp/presentation/repository/auth_repo.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/privacy_policy_state.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PrivacyPolicyCubit extends Cubit<PrivacyPolicyState> {
  AuthRepository authRepository;

  PrivacyPolicyCubit({required this.authRepository})
      : super(PrivacyPolicyState.initial());

  void login() async {
    emit(state.copyWith(networkStatusEnum: NetworkStatusEnum.loading));

    (bool, dynamic) response = await authRepository.privacyPolicy();

    if (response.$1 == true) {
      emit(state.copyWith(
        networkStatusEnum: NetworkStatusEnum.loaded,
        termsResponseModel: response.$2,
      ));
    } else {
      emit(state.copyWith(
          networkStatusEnum: NetworkStatusEnum.failed,
          termsResponseModel: response.$2));
    }
  }
}
