import 'package:bringessesellerapp/presentation/repository/auth_repo.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/product_by_id_state.dart';


import 'package:bringessesellerapp/utils/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductByIdCubit extends Cubit<ProductByIdState> {
  AuthRepository authRepository;

  ProductByIdCubit({required this.authRepository})
      : super(ProductByIdState.initial());

  void login(productId) async {
    emit(state.copyWith(networkStatusEnum: NetworkStatusEnum.loading));

    (bool, dynamic) response = await authRepository.productById(productId);

    if (response.$1 == true) {
      emit(state.copyWith(
        networkStatusEnum: NetworkStatusEnum.loaded,
        productListModel: response.$2,
      ));
    } else {
      emit(state.copyWith(
          networkStatusEnum: NetworkStatusEnum.failed,
          productListModel: response.$2));
    }
  }
}
