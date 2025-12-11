import 'package:bringessesellerapp/presentation/repository/auth_repo.dart';
import 'package:bringessesellerapp/presentation/screen/onboarding/bloc/revenue_state.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RevenueCubit extends Cubit<RevenueState> {
  AuthRepository authRepository;

  RevenueCubit({required this.authRepository}) : super(RevenueState.initial());

  void login(orderlistreq) async {
    emit(state.copyWith(networkStatusEnum: NetworkStatusEnum.loading));

    (bool, dynamic) response = await authRepository.getRevenue(orderlistreq);

    if (response.$1 == true) {
      emit(state.copyWith(
        networkStatusEnum: NetworkStatusEnum.loaded,
        orderlistresponse: response.$2,
      ));
    } else {
      print("NetWorkEnum Faild");
      emit(state.copyWith(
          networkStatusEnum: NetworkStatusEnum.failed,
          orderlistresponse: response.$2));
    }
  }
}
