import 'package:bringessesellerapp/presentation/repository/auth_repo.dart';

import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/product_create_state.dart';

import 'package:bringessesellerapp/utils/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductCreateCubit extends Cubit<ProductCreateState> {
  AuthRepository authRepository;

  ProductCreateCubit({required this.authRepository})
      : super(ProductCreateState.initial());

  void login(storeUploadReqModel) async {
    emit(state.copyWith(networkStatusEnum: NetworkStatusEnum.loading));

    (bool, dynamic) response =
        await authRepository.productCreate(storeUploadReqModel);

    if (response.$1 == true) {
      emit(state.copyWith(
        networkStatusEnum: NetworkStatusEnum.loaded,
        menuCreateResModel: response.$2,
      ));
    } else {
      emit(state.copyWith(
          networkStatusEnum: NetworkStatusEnum.failed,
          menuCreateResModel: response.$2));
    }
  }
}
