import 'package:bringessesellerapp/model/response/store_upload_model.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:equatable/equatable.dart';

class StoreUploadState extends Equatable {
  final NetworkStatusEnum networkStatusEnum;
  final StoreResponseModel storeResponseModel;

  const StoreUploadState(
      {required this.networkStatusEnum, required this.storeResponseModel});

  factory StoreUploadState.initial() => StoreUploadState(
        networkStatusEnum: NetworkStatusEnum.initial,
        storeResponseModel: StoreResponseModel(),
      );

  @override
  List<Object?> get props => [networkStatusEnum, storeResponseModel];

  StoreUploadState copyWith(
      {NetworkStatusEnum? networkStatusEnum,
      NetworkStatusEnum? childNetworkStatusEnum,
      int? currentPage,
      StoreResponseModel? storeResponseModel}) {
    return StoreUploadState(
        storeResponseModel: storeResponseModel ?? this.storeResponseModel,
        networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum);
  }
}
