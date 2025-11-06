import 'package:bringessesellerapp/model/response/common_success_res_model.dart';


import 'package:bringessesellerapp/utils/enums.dart';
import 'package:equatable/equatable.dart';

class DeleteMenuState extends Equatable {
  final NetworkStatusEnum networkStatusEnum;
  final CommonSuccessResModel deleteproductres;

  const DeleteMenuState(
      {required this.networkStatusEnum, required this.deleteproductres});

  factory DeleteMenuState.initial() => DeleteMenuState(
        networkStatusEnum: NetworkStatusEnum.initial,
        deleteproductres: CommonSuccessResModel(),
      );

  @override
  List<Object?> get props => [networkStatusEnum, deleteproductres];

  DeleteMenuState copyWith(
      {NetworkStatusEnum? networkStatusEnum,
      NetworkStatusEnum? childNetworkStatusEnum,
      int? currentPage,
      CommonSuccessResModel? deleteproductres}) {
    return DeleteMenuState(
        deleteproductres: deleteproductres ?? this.deleteproductres,
        networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum);
  }
}
