
import 'package:bringessesellerapp/model/response/coupon_success_rres_model.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:equatable/equatable.dart';

class CouponCreateState extends Equatable {
  final NetworkStatusEnum networkStatusEnum;
  final CouponSuccessRresModel createres;

  const CouponCreateState(
      {required this.networkStatusEnum, required this.createres});

  factory CouponCreateState.initial() => CouponCreateState(
        networkStatusEnum: NetworkStatusEnum.initial,
        createres: CouponSuccessRresModel(),
      );

  @override
  List<Object?> get props => [networkStatusEnum, createres];

  CouponCreateState copyWith(
      {NetworkStatusEnum? networkStatusEnum,
      NetworkStatusEnum? childNetworkStatusEnum,
      int? currentPage,
      CouponSuccessRresModel? createres}) {
    return CouponCreateState(
        createres: createres ?? this.createres,
        networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum);
  }
}
