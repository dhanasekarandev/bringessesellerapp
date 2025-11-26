import 'package:bringessesellerapp/presentation/repository/auth_repo.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/subscription_transaction_state.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubscriptionTransactionCubit extends Cubit<SubscriptionTransactionState> {
  AuthRepository authRepository;

  SubscriptionTransactionCubit({required this.authRepository})
      : super(SubscriptionTransactionState.initial());

  void login(EditProfileRequestModel) async {
    emit(state.copyWith(networkStatusEnum: NetworkStatusEnum.loading));

    (bool, dynamic) response =
        await authRepository.subscriptionTransaction(EditProfileRequestModel);

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
