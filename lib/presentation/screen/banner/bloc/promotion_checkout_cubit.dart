import 'package:bringessesellerapp/presentation/repository/auth_repo.dart';
import 'package:bringessesellerapp/presentation/screen/banner/bloc/promotion_checkout_state.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PromotionCheckoutCubit extends Cubit<PromotionCheckoutState> {
  AuthRepository authRepository;

  PromotionCheckoutCubit({required this.authRepository})
      : super(PromotionCheckoutState.initial());

  void login(storeUploadReqModel) async {
    emit(state.copyWith(networkStatusEnum: NetworkStatusEnum.loading));

    (bool, dynamic) response =
        await authRepository.promotionCheckout(storeUploadReqModel);

    if (response.$1 == true) {
      emit(state.copyWith(
        networkStatusEnum: NetworkStatusEnum.loaded,
        promotionResponseModel: response.$2,
      ));
    } else {
      emit(state.copyWith(
          networkStatusEnum: NetworkStatusEnum.failed,
          promotionResponseModel: response.$2));
    }
  }
}
