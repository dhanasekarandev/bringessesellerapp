import 'package:bringessesellerapp/model/response/product_by_id_response_model.dart';


import 'package:bringessesellerapp/utils/enums.dart';
import 'package:equatable/equatable.dart';

class ProductByIdState extends Equatable {
  final NetworkStatusEnum networkStatusEnum;
  final ProductByIdResponse productListModel;

  const ProductByIdState(
      {required this.networkStatusEnum, required this.productListModel});

  factory ProductByIdState.initial() => ProductByIdState(
        networkStatusEnum: NetworkStatusEnum.initial,
        productListModel: ProductByIdResponse(),
      );

  @override
  List<Object?> get props => [networkStatusEnum, productListModel];

  ProductByIdState copyWith(
      {NetworkStatusEnum? networkStatusEnum,
      NetworkStatusEnum? childNetworkStatusEnum,
      int? currentPage,
      ProductByIdResponse? productListModel}) {
    return ProductByIdState(
        productListModel: productListModel ?? this.productListModel,
        networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum);
  }
}
