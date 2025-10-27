import 'package:bringessesellerapp/model/response/menu_list_response_model.dart';
import 'package:bringessesellerapp/model/response/product_list_response_model.dart';


import 'package:bringessesellerapp/utils/enums.dart';
import 'package:equatable/equatable.dart';

class ProductListState extends Equatable {
  final NetworkStatusEnum networkStatusEnum;
  final ProductListResponseModel productListModel;

  const ProductListState(
      {required this.networkStatusEnum, required this.productListModel});

  factory ProductListState.initial() => ProductListState(
        networkStatusEnum: NetworkStatusEnum.initial,
        productListModel: ProductListResponseModel(),
      );

  @override
  List<Object?> get props => [networkStatusEnum, productListModel];

  ProductListState copyWith(
      {NetworkStatusEnum? networkStatusEnum,
      NetworkStatusEnum? childNetworkStatusEnum,
      int? currentPage,
      ProductListResponseModel? productListModel}) {
    return ProductListState(
        productListModel: productListModel ?? this.productListModel,
        networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum);
  }
}
