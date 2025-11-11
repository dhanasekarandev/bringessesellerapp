import 'package:bringessesellerapp/presentation/repository/auth_repo.dart';

import 'package:bringessesellerapp/presentation/screen/profile/bloc/delete_coupon_state.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteCouponCubit extends Cubit<DeleteCouponState> {
  AuthRepository authRepository;

  DeleteCouponCubit({required this.authRepository})
      : super(DeleteCouponState.initial());

  void login(productdeletereq) async {
    emit(state.copyWith(networkStatusEnum: NetworkStatusEnum.loading));

    (bool, dynamic) response =
        await authRepository.deleteCoupon(productdeletereq);

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
