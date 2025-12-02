import 'package:bringessesellerapp/presentation/repository/auth_repo.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/my_subscription_plan_state.dart';

import 'package:bringessesellerapp/utils/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MySubscriptionPlanCubit extends Cubit<MySubscriptionPlanState> {
  AuthRepository authRepository;

  MySubscriptionPlanCubit({required this.authRepository})
      : super(MySubscriptionPlanState.initial());

  void login() async {
    emit(state.copyWith(networkStatusEnum: NetworkStatusEnum.loading));

    (bool, dynamic) response = await authRepository.getMySubsDetails();

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
