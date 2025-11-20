import 'package:bringessesellerapp/model/response/privacy_policy_res_model.dart';

import 'package:bringessesellerapp/utils/enums.dart';
import 'package:equatable/equatable.dart';

class PrivacyPolicyState extends Equatable {
  final NetworkStatusEnum networkStatusEnum;
  final TermsResponseModel termsResponseModel;

  const PrivacyPolicyState(
      {required this.networkStatusEnum, required this.termsResponseModel});

  factory PrivacyPolicyState.initial() => PrivacyPolicyState(
        networkStatusEnum: NetworkStatusEnum.initial,
        termsResponseModel: TermsResponseModel(),
      );

  @override
  List<Object?> get props => [networkStatusEnum, termsResponseModel];

  PrivacyPolicyState copyWith(
      {NetworkStatusEnum? networkStatusEnum,
      NetworkStatusEnum? childNetworkStatusEnum,
      int? currentPage,
      TermsResponseModel? termsResponseModel}) {
    return PrivacyPolicyState(
        termsResponseModel: termsResponseModel ?? this.termsResponseModel,
        networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum);
  }
}
