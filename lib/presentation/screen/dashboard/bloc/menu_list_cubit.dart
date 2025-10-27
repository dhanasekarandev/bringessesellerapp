import 'package:bringessesellerapp/presentation/repository/auth_repo.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/menu_category_state.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/menu_list_state.dart';

import 'package:bringessesellerapp/utils/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MenuListCubit extends Cubit<MenuListState> {
  AuthRepository authRepository;

  MenuListCubit({required this.authRepository})
      : super(MenuListState.initial());

  void login(storeId) async {
    emit(state.copyWith(networkStatusEnum: NetworkStatusEnum.loading));

    (bool, dynamic) response = await authRepository.menuList(storeId);

    if (response.$1 == true) {
      emit(state.copyWith(
        networkStatusEnum: NetworkStatusEnum.loaded,
        menuListModel: response.$2,
      ));
    } else {
      emit(state.copyWith(
          networkStatusEnum: NetworkStatusEnum.failed,
          menuListModel: response.$2));
    }
  }
}
