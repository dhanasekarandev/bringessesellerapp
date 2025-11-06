import 'package:bringessesellerapp/presentation/repository/auth_repo.dart';

import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/product_update_state.dart';

import 'package:bringessesellerapp/utils/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductUpdateCubit extends Cubit<ProductUpdateState> {
  AuthRepository authRepository;

  ProductUpdateCubit({required this.authRepository})
      : super(ProductUpdateState.initial());

  void login(productupdatereq) async {
    emit(state.copyWith(networkStatusEnum: NetworkStatusEnum.loading));

    (bool, dynamic) response =
        await authRepository.productUpdate(productupdatereq);

    if (response.$1 == true) {
      emit(state.copyWith(
        networkStatusEnum: NetworkStatusEnum.loaded,
        productupdateres: response.$2,
      ));
    } else {
      emit(state.copyWith(
          networkStatusEnum: NetworkStatusEnum.failed,
          productupdateres: response.$2));
    }
  }
}
