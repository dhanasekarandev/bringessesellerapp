
import 'package:bringessesellerapp/model/request/subs_transaction_req_model.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:equatable/equatable.dart';

class SubscriptionTransactionState extends Equatable {
  final NetworkStatusEnum networkStatusEnum;
  final SubscriptionTransactionReq editProfile;

  const SubscriptionTransactionState(
      {required this.networkStatusEnum, required this.editProfile});

  factory SubscriptionTransactionState.initial() => SubscriptionTransactionState(
        networkStatusEnum: NetworkStatusEnum.initial,
        editProfile: SubscriptionTransactionReq(),
      );

  @override
  List<Object?> get props => [networkStatusEnum, editProfile];

  SubscriptionTransactionState copyWith(
      {NetworkStatusEnum? networkStatusEnum,
      NetworkStatusEnum? childNetworkStatusEnum,
      int? currentPage,
      SubscriptionTransactionReq? editProfile}) {
    return SubscriptionTransactionState(
        editProfile: editProfile ?? this.editProfile,
        networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum);
  }
}
