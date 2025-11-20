import 'package:bringessesellerapp/presentation/repository/auth_repo.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/revenue_graph_state.dart';

import 'package:bringessesellerapp/utils/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RevenueGraphCubit extends Cubit<RevenueGraphState> {
  AuthRepository authRepository;

  RevenueGraphCubit({required this.authRepository})
      : super(RevenueGraphState.initial());

  void login() async {
    emit(state.copyWith(networkStatusEnum: NetworkStatusEnum.loading));

    (bool, dynamic) response = await authRepository.revenueGraph();

    if (response.$1 == true) {
      emit(state.copyWith(
        networkStatusEnum: NetworkStatusEnum.loaded,
        revenueGraphResModel: response.$2,
      ));
    } else {
      emit(state.copyWith(
          networkStatusEnum: NetworkStatusEnum.failed,
          revenueGraphResModel: response.$2));
    }
  }
}
