import 'package:bringessesellerapp/model/response/menu_create_res_model.dart';


import 'package:bringessesellerapp/utils/enums.dart';
import 'package:equatable/equatable.dart';

class ProductCreateState extends Equatable {
  final NetworkStatusEnum networkStatusEnum;
  final MenuCreateResModel menuCreateResModel;

  const ProductCreateState(
      {required this.networkStatusEnum, required this.menuCreateResModel});

  factory ProductCreateState.initial() => ProductCreateState(
        networkStatusEnum: NetworkStatusEnum.initial,
        menuCreateResModel: MenuCreateResModel(),
      );

  @override
  List<Object?> get props => [networkStatusEnum, menuCreateResModel];

  ProductCreateState copyWith(
      {NetworkStatusEnum? networkStatusEnum,
      NetworkStatusEnum? childNetworkStatusEnum,
      int? currentPage,
      MenuCreateResModel? menuCreateResModel}) {
    return ProductCreateState(
        menuCreateResModel: menuCreateResModel ?? this.menuCreateResModel,
        networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum);
  }
}
