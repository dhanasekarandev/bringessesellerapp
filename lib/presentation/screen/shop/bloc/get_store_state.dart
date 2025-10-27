import 'package:bringessesellerapp/model/response/get_sore_response_model.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:equatable/equatable.dart';

class GetStoreState extends Equatable {
  final NetworkStatusEnum networkStatusEnum;
  final GetStoreModel getStoreModel;

  const GetStoreState(
      {required this.networkStatusEnum, required this.getStoreModel});

  factory GetStoreState.initial() => GetStoreState(
        networkStatusEnum: NetworkStatusEnum.initial,
        getStoreModel: GetStoreModel(),
      );

  @override
  List<Object?> get props => [networkStatusEnum, getStoreModel];

  GetStoreState copyWith(
      {NetworkStatusEnum? networkStatusEnum,
      NetworkStatusEnum? childNetworkStatusEnum,
      int? currentPage,
      GetStoreModel? getStoreModel}) {
    return GetStoreState(
        getStoreModel: getStoreModel ?? this.getStoreModel,
        networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum);
  }
}
