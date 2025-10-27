import 'package:bringessesellerapp/model/response/payou_error_response_model.dart';
import 'package:bringessesellerapp/model/response/payout_response_model.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:equatable/equatable.dart';

class PayoutAccountState extends Equatable {
  final NetworkStatusEnum networkStatusEnum;
  final RazorpayAccountResponseModel? accountResponse;
  final RazorpayErrorResponseModel? errorResponse;

  const PayoutAccountState({
    required this.networkStatusEnum,
    this.accountResponse,
    this.errorResponse,
  });

  factory PayoutAccountState.initial() => PayoutAccountState(
        networkStatusEnum: NetworkStatusEnum.initial,
        accountResponse: null,
        errorResponse: null,
      );

  @override
  List<Object?> get props =>
      [networkStatusEnum, accountResponse, errorResponse];

  PayoutAccountState copyWith({
    NetworkStatusEnum? networkStatusEnum,
    RazorpayAccountResponseModel? accountResponse,
    RazorpayErrorResponseModel? errorResponse,
  }) {
    return PayoutAccountState(
      networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum,
      accountResponse: accountResponse ?? this.accountResponse,
      errorResponse: errorResponse ?? this.errorResponse,
    );
  }
}
