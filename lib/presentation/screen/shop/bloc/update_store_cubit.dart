import 'package:bringessesellerapp/presentation/repository/auth_repo.dart';

import 'package:bringessesellerapp/presentation/screen/shop/bloc/update_store_state.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateStoreCubit extends Cubit<UpdateStoreState> {
  AuthRepository authRepository;

  UpdateStoreCubit({required this.authRepository})
      : super(UpdateStoreState.initial());

  void login(EditProfileRequestModel) async {
    emit(state.copyWith(networkStatusEnum: NetworkStatusEnum.loading));

    (bool, dynamic) response =
        await authRepository.storeUpdate(EditProfileRequestModel);

    if (response.$1 == true) {
      emit(state.copyWith(
        networkStatusEnum: NetworkStatusEnum.loaded,
        editStore: response.$2,
      ));
    } else {
      emit(state.copyWith(
          networkStatusEnum: NetworkStatusEnum.failed, editStore: response.$2));
    }
  }
}
