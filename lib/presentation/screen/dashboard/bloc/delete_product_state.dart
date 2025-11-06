import 'package:bringessesellerapp/model/response/delete_product_res_model.dart';

import 'package:bringessesellerapp/utils/enums.dart';
import 'package:equatable/equatable.dart';

class DeleteProductState extends Equatable {
  final NetworkStatusEnum networkStatusEnum;
  final DeleteProductResponseModel deleteproductres;

  const DeleteProductState(
      {required this.networkStatusEnum, required this.deleteproductres});

  factory DeleteProductState.initial() => DeleteProductState(
        networkStatusEnum: NetworkStatusEnum.initial,
        deleteproductres: DeleteProductResponseModel(),
      );

  @override
  List<Object?> get props => [networkStatusEnum, deleteproductres];

  DeleteProductState copyWith(
      {NetworkStatusEnum? networkStatusEnum,
      NetworkStatusEnum? childNetworkStatusEnum,
      int? currentPage,
      DeleteProductResponseModel? deleteproductres}) {
    return DeleteProductState(
        deleteproductres: deleteproductres ?? this.deleteproductres,
        networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum);
  }
}
