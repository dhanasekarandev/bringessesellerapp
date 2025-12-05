import 'package:bringessesellerapp/config/constant/api_constant.dart';
import 'package:bringessesellerapp/config/constant/sharedpreference_helper.dart';
import 'package:bringessesellerapp/model/request/product_delete_req_model.dart';
import 'package:bringessesellerapp/model/response/product_list_response_model.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/delete_product_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/product_by_id_state.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/product_category_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/shop/bloc/store_defaults_cubit.dart';
import 'package:bringessesellerapp/presentation/widget/custom_conformation.dart';
import 'package:bringessesellerapp/presentation/widget/custome_appbar.dart';
import 'package:bringessesellerapp/presentation/widget/video_player_widget.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import 'bloc/product_by_id_cubit.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductItem product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late SharedPreferenceHelper sharedPreferenceHelper;
  @override
  void initState() {
    sharedPreferenceHelper = SharedPreferenceHelper();
    sharedPreferenceHelper.init();
    super.initState();
    context.read<ProductByIdCubit>().login(widget.product.id ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Product Details",
        actions: [
          BlocBuilder<ProductByIdCubit, ProductByIdState>(
            builder: (context, state) {
              final product = state.productListModel.result;
              final menu = state.productListModel.menu;
              return PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) async {
                  if (value == 'edit') {
                    final menus = context
                        .read<ProductCategoryCubit>()
                        .state
                        .categoryResponse
                        .result!
                        .menus;
                    final units = context
                        .read<ProductCategoryCubit>()
                        .state
                        .categoryResponse
                        .result!
                        .units;
                    final processing = context
                        .read<StoreDefaultsCubit>()
                        .state
                        .storeDefaultModel
                        .storeType!
                        .processingFee
                        .toString();
                    if (product != null) {
                      await context.push('/products/add', extra: {
                        'edit': product,
                        "catname": sharedPreferenceHelper.getcatName,
                        "subcat": menu!.subCategoryId!.name,
                        "menu": menus,
                        "units": units,
                        "storeId": sharedPreferenceHelper.getStoreId,
                        "sellerId": sharedPreferenceHelper.getSellerId,
                        'processingfee': processing
                      }).then(
                        (value) {
                          context
                              .read<ProductByIdCubit>()
                              .login(widget.product.id ?? "");
                        },
                      );
                    } else {
                      Fluttertoast.showToast(
                          msg: "Product data not loaded yet");
                    }
                  } else if (value == 'delete') {
                    showCustomConfirmationDialog(
                      context: context,
                      content:
                          "This action will permanently delete the product. Continue?",
                      confirmText: "Yes",
                      title: "Delete Product",
                      cancelText: "Cancel",
                      onConfirm: () {
                        context.read<DeleteProductCubit>().login(
                            ProductDeleteReqModel(
                                itemId: widget.product.id, status: 2));
                        context.pop(context);
                      },
                    );
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 20),
                        SizedBox(width: 10),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red, size: 20),
                        SizedBox(width: 10),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<ProductByIdCubit, ProductByIdState>(
        listener: (context, state) {
          // if (state.networkStatusEnum == NetworkStatusEnum.error) {
          //   Fluttertoast.showToast(
          //     msg: state.message ?? "Failed to load product",
          //   );
          // }
        },
        builder: (context, state) {
          if (state.networkStatusEnum == NetworkStatusEnum.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.networkStatusEnum == NetworkStatusEnum.loaded) {
            final product = state.productListModel.result;

            if (product == null) {
              return const Center(child: Text("No product found"));
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (product.images != null && product.images!.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Image.network(
                        "${ApiConstant.imageUrl}/public/media/items/${product.images!.first}",
                        width: double.infinity,
                        height: 220.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                  SizedBox(height: 10.h),
                  if (product.videoUrl != null && product.videoUrl != '')
                    Row(
                      children: [
                        SizedBox(
                          width: 100, // moderate width
                          height: 200, // moderate height, adjust to your taste
                          child: VideoPlayerWidget(
                            playButtonSize: 20,
                            videoUrl: product.videoUrl,
                          ),
                        ),
                      ],
                    ),
                  Text(
                    product.name ?? "",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Status: ${product.status == 1 ? "Approved" : "Pending"}",
                    style: TextStyle(
                      color: product.status == 1 ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Availability: ${product.outOfStock == 0 ? "In Stock" : "Out of Stock"}",
                    style: TextStyle(
                      color:
                          product.outOfStock == 0 ? Colors.green : Colors.red,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text("SKU: ${product.sku ?? "N/A"}"),
                  SizedBox(height: 8.h),
                  Text("Created: ${product.createdAt ?? "N/A"}"),
                  SizedBox(height: 16.h),
                  Text(
                    "Description",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                  ),
                  SizedBox(height: 4.h),
                  Text(product.description ?? ""),
                  SizedBox(height: 16.h),
                  if (product.variants != null && product.variants!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Variants",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.sp),
                        ),
                        ...product.variants!.map((variant) => Card(
                              margin: EdgeInsets.symmetric(vertical: 6.h),
                              child: Padding(
                                padding: EdgeInsets.all(10.w),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        "${variant.name ?? ''} ${variant.unit ?? ""}"),
                                    Text(
                                      variant.offerAvailable == "true"
                                          ? "₹${variant.offerPrice} (Offer)"
                                          : "₹${variant.price}",
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ))
                      ],
                    )
                ],
              ),
            );
          }

          return const Center(child: Text("Something went wrong"));
        },
      ),
    );
  }
}
