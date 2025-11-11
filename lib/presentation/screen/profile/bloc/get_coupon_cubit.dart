import 'package:bringessesellerapp/presentation/repository/auth_repo.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/get_coupon_state.dart';

import 'package:bringessesellerapp/utils/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetCouponCubit extends Cubit<GetCouponState> {
  AuthRepository authRepository;

  GetCouponCubit({required this.authRepository})
      : super(GetCouponState.initial());

  void login({int? limit, int? page}) async {
    emit(state.copyWith(networkStatusEnum: NetworkStatusEnum.loading));

    (bool, dynamic) response =
        await authRepository.getCouponList(limit: limit, page: page);

    if (response.$1 == true) {
      emit(state.copyWith(
        networkStatusEnum: NetworkStatusEnum.loaded,
        getcouponresponse: response.$2,
      ));
    } else {
      emit(state.copyWith(
          networkStatusEnum: NetworkStatusEnum.failed,
          getcouponresponse: response.$2));
    }
  }
}
