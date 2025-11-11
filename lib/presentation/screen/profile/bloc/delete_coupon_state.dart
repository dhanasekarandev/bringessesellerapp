import 'package:bringessesellerapp/model/response/common_success_res_model.dart';

import 'package:bringessesellerapp/utils/enums.dart';
import 'package:equatable/equatable.dart';

class DeleteCouponState extends Equatable {
  final NetworkStatusEnum networkStatusEnum;
  final CommonSuccessResModel deleteproductres;

  const DeleteCouponState(
      {required this.networkStatusEnum, required this.deleteproductres});

  factory DeleteCouponState.initial() => DeleteCouponState(
        networkStatusEnum: NetworkStatusEnum.initial,
        deleteproductres: CommonSuccessResModel(),
      );

  @override
  List<Object?> get props => [networkStatusEnum, deleteproductres];

  DeleteCouponState copyWith(
      {NetworkStatusEnum? networkStatusEnum,
      NetworkStatusEnum? childNetworkStatusEnum,
      int? currentPage,
      CommonSuccessResModel? deleteproductres}) {
    return DeleteCouponState(
        deleteproductres: deleteproductres ?? this.deleteproductres,
        networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum);
  }
}
