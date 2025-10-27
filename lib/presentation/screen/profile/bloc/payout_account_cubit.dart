import 'package:bringessesellerapp/model/request/payout_prefs_req_model.dart';
import 'package:bringessesellerapp/model/response/payou_error_response_model.dart';

import 'package:bringessesellerapp/model/response/payout_response_model.dart';
import 'package:bringessesellerapp/presentation/repository/auth_repo.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'payout_account_state.dart';

class PayoutAccountCubit extends Cubit<PayoutAccountState> {
  final AuthRepository authRepository;

  PayoutAccountCubit({required this.authRepository})
      : super(PayoutAccountState.initial());


  void registerAccount(PayoutRequestModel payoutReqModel) async {
    emit(state.copyWith(networkStatusEnum: NetworkStatusEnum.loading));


    (bool, dynamic) response =
        await authRepository.payoutAccountRegister(payoutReqModel);

    if (response.$1 == true && response.$2 is RazorpayAccountResponseModel) {
   
      emit(state.copyWith(
        networkStatusEnum: NetworkStatusEnum.loaded,
        accountResponse: response.$2,
        errorResponse: null,
      ));
    } else if (response.$2 is RazorpayErrorResponseModel) {
      print("djlfbsd${response.$2}");

      emit(state.copyWith(
        networkStatusEnum: NetworkStatusEnum.failed,
        accountResponse: null,
        errorResponse: response.$2,
      ));
    } else {
      emit(state.copyWith(
          networkStatusEnum: NetworkStatusEnum.failed,
          accountResponse: null,
          errorResponse: response.$2));
    }
  }
}
