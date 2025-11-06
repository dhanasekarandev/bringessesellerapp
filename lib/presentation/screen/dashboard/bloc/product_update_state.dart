import 'package:bringessesellerapp/model/response/common_success_res_model.dart';


import 'package:bringessesellerapp/utils/enums.dart';
import 'package:equatable/equatable.dart';

class ProductUpdateState extends Equatable {
  final NetworkStatusEnum networkStatusEnum;
  final CommonSuccessResModel productupdateres;

  const ProductUpdateState(
      {required this.networkStatusEnum, required this.productupdateres});

  factory ProductUpdateState.initial() => ProductUpdateState(
        networkStatusEnum: NetworkStatusEnum.initial,
        productupdateres: CommonSuccessResModel(),
      );

  @override
  List<Object?> get props => [networkStatusEnum, productupdateres];

  ProductUpdateState copyWith(
      {NetworkStatusEnum? networkStatusEnum,
      NetworkStatusEnum? childNetworkStatusEnum,
      int? currentPage,
      CommonSuccessResModel? productupdateres}) {
    return ProductUpdateState(
        productupdateres: productupdateres ?? this.productupdateres,
        networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum);
  }
}
