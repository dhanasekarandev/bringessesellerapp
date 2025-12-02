import 'package:bringessesellerapp/model/request/my_subs_res_model.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:equatable/equatable.dart';

class MySubscriptionPlanState extends Equatable {
  final NetworkStatusEnum networkStatusEnum;
  final MySubscriptionResponse viewProfile;

  const MySubscriptionPlanState(
      {required this.networkStatusEnum, required this.viewProfile});

  factory MySubscriptionPlanState.initial() => MySubscriptionPlanState(
        networkStatusEnum: NetworkStatusEnum.initial,
        viewProfile: MySubscriptionResponse(),
      );

  @override
  List<Object?> get props => [networkStatusEnum, viewProfile];

  MySubscriptionPlanState copyWith(
      {NetworkStatusEnum? networkStatusEnum,
      NetworkStatusEnum? childNetworkStatusEnum,
      int? currentPage,
      MySubscriptionResponse? viewProfile}) {
    return MySubscriptionPlanState(
        viewProfile: viewProfile ?? this.viewProfile,
        networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum);
  }
}
