import 'package:bringessesellerapp/presentation/repository/auth_repo.dart';

import 'package:bringessesellerapp/presentation/screen/order_section/bloc/oder_list_state.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OderListCubit extends Cubit<OderListState> {
  AuthRepository authRepository;

  OderListCubit({required this.authRepository})
      : super(OderListState.initial());

  void login(orderlistreq) async {
    emit(state.copyWith(networkStatusEnum: NetworkStatusEnum.loading));

    (bool, dynamic) response =
        await authRepository.oderList(orderlistreq);

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
