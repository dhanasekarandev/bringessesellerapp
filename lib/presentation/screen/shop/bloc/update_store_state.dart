
import 'package:bringessesellerapp/model/response/store_upload_model.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:equatable/equatable.dart';

class UpdateStoreState extends Equatable {
  final NetworkStatusEnum networkStatusEnum;
  final StoreResponseModel editStore;

  const UpdateStoreState(
      {required this.networkStatusEnum, required this.editStore});

  factory UpdateStoreState.initial() => UpdateStoreState(
        networkStatusEnum: NetworkStatusEnum.initial,
        editStore: StoreResponseModel(),
      );

  @override
  List<Object?> get props => [networkStatusEnum, editStore];

  UpdateStoreState copyWith(
      {NetworkStatusEnum? networkStatusEnum,
      NetworkStatusEnum? childNetworkStatusEnum,
      int? currentPage,
      StoreResponseModel? editStore}) {
    return UpdateStoreState(
        editStore: editStore ?? this.editStore,
        networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum);
  }
}
