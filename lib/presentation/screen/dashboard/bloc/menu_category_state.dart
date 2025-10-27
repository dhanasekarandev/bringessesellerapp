
import 'package:bringessesellerapp/model/response/store_default_model.dart';

import 'package:bringessesellerapp/utils/enums.dart';
import 'package:equatable/equatable.dart';

class MenuCategoryState extends Equatable {
  final NetworkStatusEnum networkStatusEnum;
  final StoreDefaultModel categoryResponse;

  const MenuCategoryState(
      {required this.networkStatusEnum, required this.categoryResponse});

  factory MenuCategoryState.initial() => MenuCategoryState(
        networkStatusEnum: NetworkStatusEnum.initial,
        categoryResponse: StoreDefaultModel(),
      );

  @override
  List<Object?> get props => [networkStatusEnum, categoryResponse];

  MenuCategoryState copyWith(
      {NetworkStatusEnum? networkStatusEnum,
      NetworkStatusEnum? childNetworkStatusEnum,
      int? currentPage,
      StoreDefaultModel? categoryResponse}) {
    return MenuCategoryState(
        categoryResponse: categoryResponse ?? this.categoryResponse,
        networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum);
  }
}
