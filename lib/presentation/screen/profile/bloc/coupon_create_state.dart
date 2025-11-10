import 'package:bringessesellerapp/model/response/common_success_res_model.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:equatable/equatable.dart';

class CouponCreateState extends Equatable {
  final NetworkStatusEnum networkStatusEnum;
  final CommonSuccessResModel createres;

  const CouponCreateState(
      {required this.networkStatusEnum, required this.createres});

  factory CouponCreateState.initial() => CouponCreateState(
        networkStatusEnum: NetworkStatusEnum.initial,
        createres: CommonSuccessResModel(),
      );

  @override
  List<Object?> get props => [networkStatusEnum, createres];

  CouponCreateState copyWith(
      {NetworkStatusEnum? networkStatusEnum,
      NetworkStatusEnum? childNetworkStatusEnum,
      int? currentPage,
      CommonSuccessResModel? createres}) {
    return CouponCreateState(
        createres: createres ?? this.createres,
        networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum);
  }
}
