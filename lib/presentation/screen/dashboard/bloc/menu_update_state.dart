import 'package:bringessesellerapp/model/response/change_password_model.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:equatable/equatable.dart';

class MenuUpdateState extends Equatable {
  final NetworkStatusEnum networkStatusEnum;
  final ChangePasswordModel menuCreateResModel;

  const MenuUpdateState(
      {required this.networkStatusEnum, required this.menuCreateResModel});

  factory MenuUpdateState.initial() => MenuUpdateState(
        networkStatusEnum: NetworkStatusEnum.initial,
        menuCreateResModel: ChangePasswordModel(),
      );

  @override
  List<Object?> get props => [networkStatusEnum, menuCreateResModel];

  MenuUpdateState copyWith(
      {NetworkStatusEnum? networkStatusEnum,
      NetworkStatusEnum? childNetworkStatusEnum,
      int? currentPage,
      ChangePasswordModel? menuCreateResModel}) {
    return MenuUpdateState(
        menuCreateResModel: menuCreateResModel ?? this.menuCreateResModel,
        networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum);
  }
}
