
import 'package:bringessesellerapp/model/response/subcription_checkout_response.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:equatable/equatable.dart';

class SubscriptionCheckoutState extends Equatable {
  final NetworkStatusEnum networkStatusEnum;
  final SubscriptionCheckoutResponse editProfile;

  const SubscriptionCheckoutState(
      {required this.networkStatusEnum, required this.editProfile});

  factory SubscriptionCheckoutState.initial() => SubscriptionCheckoutState(
        networkStatusEnum: NetworkStatusEnum.initial,
        editProfile: SubscriptionCheckoutResponse(),
      );

  @override
  List<Object?> get props => [networkStatusEnum, editProfile];

  SubscriptionCheckoutState copyWith(
      {NetworkStatusEnum? networkStatusEnum,
      NetworkStatusEnum? childNetworkStatusEnum,
      int? currentPage,
      SubscriptionCheckoutResponse? editProfile}) {
    return SubscriptionCheckoutState(
        editProfile: editProfile ?? this.editProfile,
        networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum);
  }
}
