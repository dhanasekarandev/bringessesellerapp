import 'package:bringessesellerapp/model/response/store_default_model.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:equatable/equatable.dart';

class StoreDefaultState extends Equatable {
  final NetworkStatusEnum networkStatusEnum;
  final StoreDefaultModel storeDefaultModel;

  const StoreDefaultState(
      {required this.networkStatusEnum, required this.storeDefaultModel});

  factory StoreDefaultState.initial() => StoreDefaultState(
        networkStatusEnum: NetworkStatusEnum.initial,
        storeDefaultModel: StoreDefaultModel(),
      );

  @override
  List<Object?> get props => [networkStatusEnum, storeDefaultModel];

  StoreDefaultState copyWith(
      {NetworkStatusEnum? networkStatusEnum,
      NetworkStatusEnum? childNetworkStatusEnum,
      int? currentPage,
      StoreDefaultModel? storeDefaultModel}) {
    return StoreDefaultState(
        storeDefaultModel: storeDefaultModel ?? this.storeDefaultModel,
        networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum);
  }
}
