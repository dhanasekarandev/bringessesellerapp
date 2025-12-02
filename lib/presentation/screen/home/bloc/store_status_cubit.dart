import 'package:bringessesellerapp/presentation/repository/auth_repo.dart';
import 'package:bringessesellerapp/presentation/screen/home/bloc/store_status_state.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StoreStatusCubit extends Cubit<StoreStatusState> {
  AuthRepository authRepository;

  StoreStatusCubit({required this.authRepository})
      : super(StoreStatusState.initial());

  void login(notificationReq) async {
    emit(state.copyWith(networkStatusEnum: NetworkStatusEnum.loading));

    (bool, dynamic) response =
        await authRepository.storeStatusUpdate(notificationReq);

    if (response.$1 == true) {
      emit(state.copyWith(
        networkStatusEnum: NetworkStatusEnum.loaded,
        notificationResponseModel: response.$2,
      ));
    } else {
      emit(state.copyWith(
          networkStatusEnum: NetworkStatusEnum.failed,
          notificationResponseModel: response.$2));
    }
  }
}
