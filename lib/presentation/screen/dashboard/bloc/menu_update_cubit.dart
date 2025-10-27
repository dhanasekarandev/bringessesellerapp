import 'package:bringessesellerapp/presentation/repository/auth_repo.dart';

import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/menu_update_state.dart';

import 'package:bringessesellerapp/utils/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MenuUpdateCubit extends Cubit<MenuUpdateState> {
  AuthRepository authRepository;

  MenuUpdateCubit({required this.authRepository})
      : super(MenuUpdateState.initial());

  void login(storeUploadReqModel) async {
    emit(state.copyWith(networkStatusEnum: NetworkStatusEnum.loading));

    (bool, dynamic) response =
        await authRepository.menuUpdate(storeUploadReqModel);

    if (response.$1 == true) {
      emit(state.copyWith(
        networkStatusEnum: NetworkStatusEnum.loaded,
        menuCreateResModel: response.$2,
      ));
    } else {
      emit(state.copyWith(
          networkStatusEnum: NetworkStatusEnum.failed,
          menuCreateResModel: response.$2));
    }
  }
}
