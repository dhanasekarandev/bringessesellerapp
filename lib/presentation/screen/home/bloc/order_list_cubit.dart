// import 'package:bringessesellerapp/presentation/repository/auth_repo.dart';

// import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/product_list_state.dart';
// import 'package:bringessesellerapp/presentation/screen/home/bloc/order_list_state.dart';

// import 'package:bringessesellerapp/utils/enums.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class OrderListCubit extends Cubit<OrderListState> {
//   AuthRepository authRepository;

//   OrderListCubit({required this.authRepository})
//       : super(OrderListState.initial());

//   void login(storeId) async {
//     emit(state.copyWith(networkStatusEnum: NetworkStatusEnum.loading));

//     (bool, dynamic) response = await authRepository.productList(storeId);

//     if (response.$1 == true) {
//       emit(state.copyWith(
//         networkStatusEnum: NetworkStatusEnum.loaded,
//         productListModel: response.$2,
//       ));
//     } else {
//       emit(state.copyWith(
//           networkStatusEnum: NetworkStatusEnum.failed,
//           productListModel: response.$2));
//     }
//   }
// }
