import 'package:bringessesellerapp/presentation/repository/auth_repo.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/delete_menu_state.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteMenuCubit extends Cubit<DeleteMenuState> {
  AuthRepository authRepository;

  DeleteMenuCubit({required this.authRepository})
      : super(DeleteMenuState.initial());

  void login(productdeletereq) async {
    emit(state.copyWith(networkStatusEnum: NetworkStatusEnum.loading));

    (bool, dynamic) response =
        await authRepository.deleteMenu(productdeletereq);

    if (response.$1 == true) {
      emit(state.copyWith(
        networkStatusEnum: NetworkStatusEnum.loaded,
        deleteproductres: response.$2,
      ));
    } else {
      emit(state.copyWith(
          networkStatusEnum: NetworkStatusEnum.failed,
          deleteproductres: response.$2));
    }
  }
}
