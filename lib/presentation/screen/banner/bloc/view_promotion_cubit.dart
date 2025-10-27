import 'package:bringessesellerapp/presentation/repository/auth_repo.dart';
import 'package:bringessesellerapp/presentation/screen/banner/bloc/view_promotion_state.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewPromotionCubit extends Cubit<ViewPromotionState> {
  AuthRepository authRepository;

  ViewPromotionCubit({required this.authRepository})
      : super(ViewPromotionState.initial());

  void login(viewPromotion) async {
    emit(state.copyWith(networkStatusEnum: NetworkStatusEnum.loading));

    (bool, dynamic) response = await authRepository.viewPromotion(viewPromotion);

    if (response.$1 == true) {
      emit(state.copyWith(
        networkStatusEnum: NetworkStatusEnum.loaded,
        promotionpreRes: response.$2,
      ));
    } else {
      emit(state.copyWith(
          networkStatusEnum: NetworkStatusEnum.failed,
          promotionpreRes: response.$2));
    }
  }
}
