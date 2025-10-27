import 'package:bringessesellerapp/model/response/menu_create_res_model.dart';
import 'package:bringessesellerapp/model/response/promotion_create_response.dart';

import 'package:bringessesellerapp/utils/enums.dart';
import 'package:equatable/equatable.dart';

class MenuCreateState extends Equatable {
  final NetworkStatusEnum networkStatusEnum;
  final MenuCreateResModel menuCreateResModel;

  const MenuCreateState(
      {required this.networkStatusEnum, required this.menuCreateResModel});

  factory MenuCreateState.initial() => MenuCreateState(
        networkStatusEnum: NetworkStatusEnum.initial,
        menuCreateResModel: MenuCreateResModel(),
      );

  @override
  List<Object?> get props => [networkStatusEnum, menuCreateResModel];

  MenuCreateState copyWith(
      {NetworkStatusEnum? networkStatusEnum,
      NetworkStatusEnum? childNetworkStatusEnum,
      int? currentPage,
      MenuCreateResModel? menuCreateResModel}) {
    return MenuCreateState(
        menuCreateResModel: menuCreateResModel ?? this.menuCreateResModel,
        networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum);
  }
}
