import 'package:bringessesellerapp/presentation/repository/auth_repo.dart';
import 'package:bringessesellerapp/presentation/screen/banner/bloc/promotion_transaction_state.dart';

import 'package:bringessesellerapp/utils/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PromotionTransctionCubit extends Cubit<PromotionTransactionState> {
  AuthRepository authRepository;

  PromotionTransctionCubit({required this.authRepository})
      : super(PromotionTransactionState.initial());

  void login(storeUploadReqModel) async {
    emit(state.copyWith(networkStatusEnum: NetworkStatusEnum.loading));

    (bool, dynamic) response =
        await authRepository.promotionTransaction(storeUploadReqModel);

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
