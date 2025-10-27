import 'package:bringessesellerapp/model/response/subription_defaults_response_model.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:equatable/equatable.dart';

class SubcriptionDefaultsState extends Equatable {
  final NetworkStatusEnum networkStatusEnum;
  final SubscriptionResponseModel viewProfile;

  const SubcriptionDefaultsState(
      {required this.networkStatusEnum, required this.viewProfile});

  factory SubcriptionDefaultsState.initial() => SubcriptionDefaultsState(
        networkStatusEnum: NetworkStatusEnum.initial,
        viewProfile: SubscriptionResponseModel(),
      );

  @override
  List<Object?> get props => [networkStatusEnum, viewProfile];

  SubcriptionDefaultsState copyWith(
      {NetworkStatusEnum? networkStatusEnum,
      NetworkStatusEnum? childNetworkStatusEnum,
      int? currentPage,
      SubscriptionResponseModel? viewProfile}) {
    return SubcriptionDefaultsState(
        viewProfile: viewProfile ?? this.viewProfile,
        networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum);
  }
}
