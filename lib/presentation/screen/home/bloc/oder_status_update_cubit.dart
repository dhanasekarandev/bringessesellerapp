import 'package:bringessesellerapp/presentation/repository/auth_repo.dart';

import 'package:bringessesellerapp/presentation/screen/home/bloc/update_order_state.dart';

import 'package:bringessesellerapp/utils/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OderStatusUpdateCubit extends Cubit<UpdateOrderState> {
  AuthRepository authRepository;

  OderStatusUpdateCubit({required this.authRepository})
      : super(UpdateOrderState.initial());

  void login(productupdatereq) async {
    emit(state.copyWith(networkStatusEnum: NetworkStatusEnum.loading));

    (bool, dynamic) response =
        await authRepository.orderUpdateStatus(productupdatereq);

    if (response.$1 == true) {
      emit(state.copyWith(
        networkStatusEnum: NetworkStatusEnum.loaded,
        reviewResponseModel: response.$2,
      ));
    } else {
      emit(state.copyWith(
          networkStatusEnum: NetworkStatusEnum.failed,
          reviewResponseModel: response.$2));
    }
  }
}
