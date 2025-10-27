import 'package:bringessesellerapp/presentation/repository/auth_repo.dart';
import 'package:bringessesellerapp/presentation/screen/home/bloc/notification_state.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/edit_profile_state.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationCubit extends Cubit<NotificationState> {
  AuthRepository authRepository;

  NotificationCubit({required this.authRepository})
      : super(NotificationState.initial());

  void login(notificationReq) async {
    emit(state.copyWith(networkStatusEnum: NetworkStatusEnum.loading));

    (bool, dynamic) response =
        await authRepository.notificationList(notificationReq);

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
