import 'package:bringessesellerapp/model/response/menu_list_response_model.dart';


import 'package:bringessesellerapp/utils/enums.dart';
import 'package:equatable/equatable.dart';

class MenuListState extends Equatable {
  final NetworkStatusEnum networkStatusEnum;
  final MenuListModel menuListModel;

  const MenuListState(
      {required this.networkStatusEnum, required this.menuListModel});

  factory MenuListState.initial() => MenuListState(
        networkStatusEnum: NetworkStatusEnum.initial,
        menuListModel: MenuListModel(),
      );

  @override
  List<Object?> get props => [networkStatusEnum, menuListModel];

  MenuListState copyWith(
      {NetworkStatusEnum? networkStatusEnum,
      NetworkStatusEnum? childNetworkStatusEnum,
      int? currentPage,
      MenuListModel? menuListModel}) {
    return MenuListState(
        menuListModel: menuListModel ?? this.menuListModel,
        networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum);
  }
}
