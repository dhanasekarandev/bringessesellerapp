import 'package:bringessesellerapp/presentation/repository/auth_repo.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/update_coupon_state.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateCouponCubit extends Cubit<UpdateCouponState> {
  AuthRepository authRepository;

  UpdateCouponCubit({required this.authRepository})
      : super(UpdateCouponState.initial());

  void login(couponupdate, couponId) async {
    emit(state.copyWith(networkStatusEnum: NetworkStatusEnum.loading));

    (bool, dynamic) response = await authRepository.updateCoupon(
        couponId: couponId, couponupdatereq: couponupdate);

    if (response.$1 == true) {
      emit(state.copyWith(
        networkStatusEnum: NetworkStatusEnum.loaded,
        editProfile: response.$2,
      ));
    } else {
      emit(state.copyWith(
          networkStatusEnum: NetworkStatusEnum.failed,
          editProfile: response.$2));
    }
  }
}
