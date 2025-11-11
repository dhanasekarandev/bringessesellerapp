import 'package:bringessesellerapp/model/response/get_coupon_res_model.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:equatable/equatable.dart';

class GetCouponState extends Equatable {
  final NetworkStatusEnum networkStatusEnum;
  final CouponListResponse getcouponresponse;

  const GetCouponState(
      {required this.networkStatusEnum, required this.getcouponresponse});

  factory GetCouponState.initial() => GetCouponState(
        networkStatusEnum: NetworkStatusEnum.initial,
        getcouponresponse: CouponListResponse(),
      );

  @override
  List<Object?> get props => [networkStatusEnum, getcouponresponse];

  GetCouponState copyWith(
      {NetworkStatusEnum? networkStatusEnum,
      NetworkStatusEnum? childNetworkStatusEnum,
      int? currentPage,
      CouponListResponse? getcouponresponse}) {
    return GetCouponState(
        getcouponresponse: getcouponresponse ?? this.getcouponresponse,
        networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum);
  }
}
