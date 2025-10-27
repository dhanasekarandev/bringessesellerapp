import 'package:bringessesellerapp/presentation/repository/auth_repo.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/menu_category_state.dart';

import 'package:bringessesellerapp/utils/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetMenuCategoryCubit extends Cubit<MenuCategoryState> {
  AuthRepository authRepository;

  GetMenuCategoryCubit({required this.authRepository})
      : super(MenuCategoryState.initial());

  void login(categoryReqId) async {
    emit(state.copyWith(networkStatusEnum: NetworkStatusEnum.loading));

    (bool, dynamic) response = await authRepository.getCategory(categoryReqId);

    if (response.$1 == true) {
      emit(state.copyWith(
        networkStatusEnum: NetworkStatusEnum.loaded,
        categoryResponse: response.$2,
      ));
    } else {
      emit(state.copyWith(
          networkStatusEnum: NetworkStatusEnum.failed,
          categoryResponse: response.$2));
    }
  }
}
