
// import 'package:bringessesellerapp/model/response/product_list_response_model.dart';


// import 'package:bringessesellerapp/utils/enums.dart';
// import 'package:equatable/equatable.dart';

// class OrderListState extends Equatable {
//   final NetworkStatusEnum networkStatusEnum;
//   final ListO productListModel;

//   const OrderListState(
//       {required this.networkStatusEnum, required this.productListModel});

//   factory OrderListState.initial() => OrderListState(
//         networkStatusEnum: NetworkStatusEnum.initial,
//         productListModel: ListO(),
//       );

//   @override
//   List<Object?> get props => [networkStatusEnum, productListModel];

//  OrderListState copyWith(
//       {NetworkStatusEnum? networkStatusEnum,
//       NetworkStatusEnum? childNetworkStatusEnum,
//       int? currentPage,
//       ListO? productListModel}) {
//     return OrderListState(
//         productListModel: productListModel ?? this.productListModel,
//         networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum);
//   }
// }
