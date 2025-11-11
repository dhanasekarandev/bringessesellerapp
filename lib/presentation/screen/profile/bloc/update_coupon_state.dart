import 'package:bringessesellerapp/model/response/coupon_update_response.dart';

import 'package:bringessesellerapp/utils/enums.dart';
import 'package:equatable/equatable.dart';

class UpdateCouponState extends Equatable {
  final NetworkStatusEnum networkStatusEnum;
  final CouponUpdateResponse editProfile;

  const UpdateCouponState(
      {required this.networkStatusEnum, required this.editProfile});

  factory UpdateCouponState.initial() => UpdateCouponState(
        networkStatusEnum: NetworkStatusEnum.initial,
        editProfile: CouponUpdateResponse(),
      );

  @override
  List<Object?> get props => [networkStatusEnum, editProfile];

  UpdateCouponState copyWith(
      {NetworkStatusEnum? networkStatusEnum,
      NetworkStatusEnum? childNetworkStatusEnum,
      int? currentPage,
      CouponUpdateResponse? editProfile}) {
    return UpdateCouponState(
        editProfile: editProfile ?? this.editProfile,
        networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum);
  }
}
