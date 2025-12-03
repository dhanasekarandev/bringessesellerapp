import 'package:bringessesellerapp/config/constant/api_constant.dart';
import 'package:bringessesellerapp/config/constant/sharedpreference_helper.dart';
import 'package:bringessesellerapp/model/request/category_id_req_model.dart';

import 'package:bringessesellerapp/model/request/store_id_reqmodel.dart';
import 'package:bringessesellerapp/model/response/store_default_model.dart';

import 'package:bringessesellerapp/presentation/screen/dashboard/add_menu.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/delete_menu_cubit.dart';

import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/menu_category_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/menu_category_state.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/menu_list_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/menu_list_state.dart';
import 'package:bringessesellerapp/presentation/widget/custom_conformation.dart';
import 'package:bringessesellerapp/presentation/widget/custome_appbar.dart';
import 'package:bringessesellerapp/presentation/widget/custome_button.dart';

import 'package:bringessesellerapp/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late SharedPreferenceHelper sharedPreferenceHelper;

  @override
  void initState() {
    super.initState();
    sharedPreferenceHelper = SharedPreferenceHelper();
    sharedPreferenceHelper.init();
    loadData();
  }

  void loadData() {
    context
        .read<GetMenuCategoryCubit>()
        .login(CategoryIdReqModel(categoryId: sharedPreferenceHelper.getCatId));

    context
        .read<MenuListCubit>()
        .login(StoreIdReqmodel(storeId: sharedPreferenceHelper.getStoreId));
  }

  List<Subcategory>? categories;
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<GetMenuCategoryCubit, MenuCategoryState>(
          listener: (context, state) {
            if (state.networkStatusEnum == NetworkStatusEnum.loaded) {
              categories = state.categoryResponse.result?.subcategories;
            }
            if (state.networkStatusEnum == NetworkStatusEnum.failed) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Failed to load categories")),
              );
            }
          },
        ),
        BlocListener<MenuListCubit, MenuListState>(
          listener: (context, state) {
            if (state.networkStatusEnum == NetworkStatusEnum.failed) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Failed to load menu list")),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: const CustomAppBar(title: "Menu"),
        body: BlocBuilder<MenuListCubit, MenuListState>(
          builder: (context, state) {
            if (state.networkStatusEnum == NetworkStatusEnum.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.networkStatusEnum == NetworkStatusEnum.loaded) {
              final menus = state.menuListModel.result!.menus!;
              return ListView.builder(
                padding: EdgeInsets.all(10.w),
                itemCount: menus.length,
                itemBuilder: (context, index) {
                  final menu = menus[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 10.h),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r)),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(10.w),
                      leading: CircleAvatar(
                        radius: 25.r,
                        backgroundImage: NetworkImage(
                          menu.image?.isNotEmpty == true
                              ? '${ApiConstant.imageUrl}/public/media/menus/${menu.image!}'
                              : "https://www.olivepower.in/wp-content/uploads/2018/10/exidestarcombo.webp",
                        ),
                      ),
                      title: Text(menu.name ?? ""),
                      subtitle: Text(menu.subCategoryName ?? ""),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // ✏️ Edit button
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () async {
                              var res = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddMenuScreen(
                                    storeId: sharedPreferenceHelper.getStoreId,
                                    catogery: categories,
                                    menu: menu,
                                    from: "edit",
                                  ),
                                ),
                              );
                              if (res == true) {
                                context.read<MenuListCubit>().login(
                                      StoreIdReqmodel(
                                          storeId: sharedPreferenceHelper
                                              .getStoreId),
                                    );
                              }
                            },
                          ),

                          // 🗑️ Delete button
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              showCustomConfirmationDialog(
                                context: context,
                                content:
                                    "This action will permanently delete the menu. Continue?",
                                confirmText: "Yes",
                                title: "Delete Menu",
                                cancelText: "Cancel",
                                onConfirm: () {
                                  context
                                      .read<DeleteMenuCubit>()
                                      .login(menu.id);
                                  Fluttertoast.showToast(
                                    msg: "Menu deleted successfully",
                                  );
                                },
                              );

                              // if (confirm == true) {
                              //   // Call your delete cubit here
                              //   context
                              //       .read<DeleteBannerCubit>()
                              //       .deleteBanner(menu.id.toString())
                              //       .then((value) {
                              //     Fluttertoast.showToast(
                              //       msg: "Menu deleted successfully",
                              //       backgroundColor: Colors.green,
                              //     );
                              //     context.read<MenuListCubit>().login(
                              //           StoreIdReqmodel(
                              //               storeId: sharedPreferenceHelper.getStoreId),
                              //         );
                              //   }).catchError((error) {
                              //     Fluttertoast.showToast(
                              //       msg: "Failed to delete menu",
                              //       backgroundColor: Colors.red,
                              //     );
                              //   });
                              // }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text("No menus available"));
            }
          },
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.w),
            child: BlocBuilder<GetMenuCategoryCubit, MenuCategoryState>(
              builder: (context, state) {
                final categories = state.categoryResponse.result?.subcategories;
                return CustomButton(
                    title: "Add Menu",
                    onPressed: sharedPreferenceHelper.getStoreId != "err"
                        ? () {
                            context.push(
                              '/menu/addmenu',
                              extra: {
                                'category': categories,
                                'storeId': sharedPreferenceHelper.getStoreId,
                              },
                            ).then((res) {
                              if (res == true) {
                                context.read<MenuListCubit>().login(
                                      StoreIdReqmodel(
                                          storeId: sharedPreferenceHelper
                                              .getStoreId),
                                    );
                              }
                            });
                          }
                        : () {
                            Fluttertoast.showToast(
                              msg: "First, you need to create a store",
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              toastLength: Toast.LENGTH_SHORT,
                            );
                          });
              },
            ),
          ),
        ),
      ),
    );
  }
}
