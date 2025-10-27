import 'package:bringessesellerapp/presentation/repository/auth_repo.dart';

import 'package:bringessesellerapp/presentation/screen/profile/bloc/subscription_checkout_state.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubscriptionCheckoutCubit extends Cubit<SubscriptionCheckoutState> {
  AuthRepository authRepository;

  SubscriptionCheckoutCubit({required this.authRepository})
      : super(SubscriptionCheckoutState.initial());

  void login(EditProfileRequestModel) async {
    emit(state.copyWith(networkStatusEnum: NetworkStatusEnum.loading));

    (bool, dynamic) response =
        await authRepository.subscriptionCheckout(EditProfileRequestModel);

    if (response.$1 == true) {
      emit(state.copyWith(
        networkStatusEnum: NetworkStatusEnum.loaded,
        editProfile: response.$2,
      ));
    } else {
      emit(state.copyWith(
          networkStatusEnum: NetworkStatusEnum.failed,
          editProfile: response.$2));
    }
  }
}
