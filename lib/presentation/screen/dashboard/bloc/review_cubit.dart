import 'package:bringessesellerapp/presentation/repository/auth_repo.dart';

import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/review_state.dart';

import 'package:bringessesellerapp/utils/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReviewCubit extends Cubit<ReviewState> {
  AuthRepository authRepository;

  ReviewCubit({required this.authRepository}) : super(ReviewState.initial());

  void login(storeId) async {
    print("sadlfnjs$storeId");
    emit(state.copyWith(networkStatusEnum: NetworkStatusEnum.loading));

    (bool, dynamic) response = await authRepository.reviewList(storeId);

    if (response.$1 == true) {
      emit(state.copyWith(
        networkStatusEnum: NetworkStatusEnum.loaded,
        reviewResponseModel: response.$2,
      ));
    } else {
      emit(state.copyWith(
          networkStatusEnum: NetworkStatusEnum.failed,
          reviewResponseModel: response.$2));
    }
  }
}
