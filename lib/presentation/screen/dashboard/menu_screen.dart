import 'package:bringessesellerapp/config/constant/api_constant.dart';
import 'package:bringessesellerapp/config/constant/sharedpreference_helper.dart';
import 'package:bringessesellerapp/model/request/category_id_req_model.dart';
import 'package:bringessesellerapp/model/request/store_id_reqmodel.dart';
import 'package:bringessesellerapp/model/response/store_default_model.dart';
import 'package:bringessesellerapp/presentation/screen/banner/bloc/delete_banner_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/add_menu.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/menu_category_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/menu_category_state.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/menu_list_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/menu_list_state.dart';
import 'package:bringessesellerapp/presentation/widget/custome_appbar.dart';
import 'package:bringessesellerapp/presentation/widget/custome_button.dart';
import 'package:bringessesellerapp/presentation/widget/custome_image_listtile.dart';
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
                  return InkWell(
                    onTap: () async {
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
                                  storeId: sharedPreferenceHelper.getStoreId),
                            );
                      }
                    },
                    child: CustomImageListTile(
                      imageUrl: menu.image?.isNotEmpty == true
                          ? '${ApiConstant.imageUrl}/public/media/menus/${menu.image!}'
                          : "https://www.olivepower.in/wp-content/uploads/2018/10/exidestarcombo.webp",
                      status: menu.status == 1 ? "Active" : "Inactive",
                      title: menu.name ?? "",
                      subtitle: menu.subCategoryName ?? "",
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text("No menus available"));
            }
          },
        ),
        bottomNavigationBar: Container(
          margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.w),
          child: BlocBuilder<GetMenuCategoryCubit, MenuCategoryState>(
            builder: (context, state) {
              final categories = state.categoryResponse.result?.subcategories;
              return CustomButton(
                  title: "Add Menu",
                  onPressed: sharedPreferenceHelper.getStoreId != ""
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
                                        storeId:
                                            sharedPreferenceHelper.getStoreId),
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
    );
  }
}
