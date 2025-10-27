import 'package:bringessesellerapp/presentation/repository/auth_repo.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/dashboard_state.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/get_account_detail_state.dart';

import 'package:bringessesellerapp/utils/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetAccountDetailCubit extends Cubit<GetAccountDetailState> {
  AuthRepository authRepository;

  GetAccountDetailCubit({required this.authRepository})
      : super(GetAccountDetailState.initial());

  void login(getAccountReq) async {
    emit(state.copyWith(networkStatusEnum: NetworkStatusEnum.loading));

    (bool, dynamic) response =
        await authRepository.getAccountDetails(getAccountReq);

    if (response.$1 == true) {
      emit(state.copyWith(
        networkStatusEnum: NetworkStatusEnum.loaded,
        accountDetailModel: response.$2,
      ));
    } else {
      emit(state.copyWith(
          networkStatusEnum: NetworkStatusEnum.failed,
          accountDetailModel: response.$2));
    }
  }
}
