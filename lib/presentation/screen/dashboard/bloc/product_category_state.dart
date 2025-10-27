
import 'package:bringessesellerapp/model/response/store_default_model.dart';

import 'package:bringessesellerapp/utils/enums.dart';
import 'package:equatable/equatable.dart';

class ProductCategoryState extends Equatable {
  final NetworkStatusEnum networkStatusEnum;
  final StoreDefaultModel categoryResponse;

  const ProductCategoryState(
      {required this.networkStatusEnum, required this.categoryResponse});

  factory ProductCategoryState.initial() => ProductCategoryState(
        networkStatusEnum: NetworkStatusEnum.initial,
        categoryResponse: StoreDefaultModel(),
      );

  @override
  List<Object?> get props => [networkStatusEnum, categoryResponse];

  ProductCategoryState copyWith(
      {NetworkStatusEnum? networkStatusEnum,
      NetworkStatusEnum? childNetworkStatusEnum,
      int? currentPage,
      StoreDefaultModel? categoryResponse}) {
    return ProductCategoryState(
        categoryResponse: categoryResponse ?? this.categoryResponse,
        networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum);
  }
}
