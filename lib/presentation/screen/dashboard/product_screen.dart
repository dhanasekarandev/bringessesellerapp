import 'package:bringessesellerapp/config/constant/api_constant.dart';
import 'package:bringessesellerapp/config/constant/sharedpreference_helper.dart';
import 'package:bringessesellerapp/model/request/store_id_reqmodel.dart';
import 'package:bringessesellerapp/model/request/productlist_req_model.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/product_category_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/product_list_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/product_list_state.dart';
import 'package:bringessesellerapp/presentation/widget/custome_appbar.dart';
import 'package:bringessesellerapp/presentation/widget/custome_button.dart';
import 'package:bringessesellerapp/presentation/widget/custome_image_listtile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen>
    with SingleTickerProviderStateMixin {
  late SharedPreferenceHelper sharedPreferenceHelper;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    sharedPreferenceHelper = SharedPreferenceHelper();
    _tabController = TabController(length: 2, vsync: this);
    initializeData();
  }

  Future<void> initializeData() async {
    await sharedPreferenceHelper.init(); // ✅ Wait for SharedPref ready

    if (!mounted) return;

    loadProduct(status: "1");

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      final status = _tabController.index == 0 ? "1" : "0";
      loadProduct(status: status);
    });
  }

  void loadProduct({required String status}) {
    final storeId = sharedPreferenceHelper.getStoreId;

    if (storeId == null || storeId.isEmpty) {
      Fluttertoast.showToast(msg: "Please create a store first");
      return;
    }

    // Load category/menu
    context.read<ProductCategoryCubit>().login(
          StoreIdReqmodel(storeId: storeId),
        );

    // Load product list
    context.read<ProductListCubit>().login(
          ProductListReqModel(
            storeId: storeId,
            status: status,
            pageId: "0",
            searchKey: "",
          ),
        );
  }

  Future<void> refreshProducts() async {
    final storeId = sharedPreferenceHelper.getStoreId;
    if (storeId == null || storeId.isEmpty) return;

    final productCubit = context.read<ProductListCubit>();

    await Future.delayed(
        const Duration(milliseconds: 100)); // stabilize rebuild

    productCubit.login(ProductListReqModel(
      storeId: storeId,
      status: "1",
      pageId: "0",
      searchKey: "",
    ));

    productCubit.login(ProductListReqModel(
      storeId: storeId,
      status: "0",
      pageId: "0",
      searchKey: "",
    ));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductListCubit, ProductListState>(
      listener: (context, state) {},
      builder: (context, state) {
        final approvedProducts = state.productListModel.result?.items
                ?.where((e) => e.status == 1)
                .toList() ??
            [];
        final unapprovedProducts = state.productListModel.result?.items
                ?.where((e) => e.status == 0)
                .toList() ??
            [];

        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: const CustomAppBar(title: "Products"),
            body: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: const BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black87,
                    tabs: const [
                      Tab(text: "Approved"),
                      Tab(text: "Unapproved"),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      approvedProducts.isNotEmpty
                          ? ListView.builder(
                              itemCount: approvedProducts.length,
                              itemBuilder: (context, index) {
                                final product = approvedProducts[index];
                                return GestureDetector(
                                  onTap: () {
                                    context.push('/products/details',
                                        extra: {'product': product}).then((_) {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        refreshProducts(); // ✅ stable reload
                                      });
                                    });
                                  },
                                  child: CustomImageListTile(
                                    imageUrl:
                                        "${ApiConstant.imageUrl}/public/media/items/${product.images?.first ?? ''}",
                                    status: "Approved",
                                    subtitle: product.outOfStock == 0
                                        ? "Available"
                                        : "Out of Stock",
                                    subtitle1: product.createdAt ?? "",
                                    title: product.name ?? "",
                                  ),
                                );
                              },
                            )
                          : const Center(
                              child: Text("No approved products"),
                            ),
                      unapprovedProducts.isNotEmpty
                          ? ListView.builder(
                              itemCount: unapprovedProducts.length,
                              itemBuilder: (context, index) {
                                final product = unapprovedProducts[index];
                                return GestureDetector(
                                  onTap: () {
                                    context.push('/products/details',
                                        extra: {'product': product}).then((_) {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        refreshProducts(); // ✅ stable reload
                                      });
                                    });
                                  },
                                  child: CustomImageListTile(
                                    imageUrl:
                                        "${ApiConstant.imageUrl}/public/media/items/${product.images?.first ?? ''}",
                                    status: "Pending",
                                    subtitle: "Awaiting approval",
                                    subtitle1: product.createdAt ?? "",
                                    title: product.name ?? "",
                                  ),
                                );
                              },
                            )
                          : const Center(
                              child: Text("No unapproved products"),
                            ),
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: SafeArea(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.w),
                child: CustomButton(
                  title: "Add Product",
                  onPressed: () async {
                    final storeId = sharedPreferenceHelper.getStoreId;

                    if (storeId == null || storeId.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Please create a store first");
                      return;
                    }

                    final menus = context
                        .read<ProductCategoryCubit>()
                        .state
                        .categoryResponse
                        .result
                        ?.menus;
                    final units = context
                        .read<ProductCategoryCubit>()
                        .state
                        .categoryResponse
                        .result
                        ?.units;

                    if (menus == null || menus.isEmpty) {
                      Fluttertoast.showToast(msg: "Please create a menu first");
                      return;
                    }

                    await context.push('/products/add', extra: {
                      "catname": sharedPreferenceHelper.getcatName,
                      "menu": menus,
                      "units": units,
                      "storeId": storeId,
                      "sellerId": sharedPreferenceHelper.getSellerId
                    });

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      refreshProducts(); // ✅ reload after coming back
                    });
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
