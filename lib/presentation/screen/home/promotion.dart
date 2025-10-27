import 'package:bringessesellerapp/config/constant/api_constant.dart';
import 'package:bringessesellerapp/config/constant/contsant.dart';
import 'package:bringessesellerapp/config/constant/sharedpreference_helper.dart';
import 'package:bringessesellerapp/model/request/store_id_reqmodel.dart';
import 'package:bringessesellerapp/presentation/screen/banner/add_banner.dart';
import 'package:bringessesellerapp/presentation/screen/banner/bloc/delete_banner_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/banner/bloc/promotion_before_data_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/banner/bloc/promotion_before_state.dart';
import 'package:bringessesellerapp/presentation/screen/banner/bloc/view_promotion_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/banner/bloc/view_promotion_state.dart';
import 'package:bringessesellerapp/presentation/widget/custom_conformation.dart';
import 'package:bringessesellerapp/presentation/widget/custome_appbar.dart';
import 'package:bringessesellerapp/presentation/widget/custome_button.dart';
import 'package:bringessesellerapp/presentation/widget/title_text.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PromotionScreen extends StatefulWidget {
  const PromotionScreen({super.key});

  @override
  State<PromotionScreen> createState() => _PromotionScreenState();
}

class _PromotionScreenState extends State<PromotionScreen> {
  late SharedPreferenceHelper sharedPreferenceHelper;
  @override
  void initState() {
    super.initState();
    sharedPreferenceHelper = SharedPreferenceHelper();
    sharedPreferenceHelper.init();
    _loadPredate();
  }

  void _loadPredate() {
    context.read<PromotionBeforeDataCubit>().login();
    context
        .read<ViewPromotionCubit>()
        .login(StoreIdReqmodel(storeId: sharedPreferenceHelper.getStoreId));
  }

  String? storeId;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PromotionBeforeDataCubit, PromotionBeforeState>(
      listener: (context, state) {
        storeId = sharedPreferenceHelper.getStoreId;
      },
      builder: (context, state) {
        return Scaffold(
            appBar: const CustomAppBar(
              title: "Promotion",
              showLeading: false,
            ),
            body: Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                children: [
                  const Row(
                    children: [
                      TitleText(title: "Banner history"),
                    ],
                  ),
                  vericalSpaceMedium,
                  Expanded(
                    child: BlocBuilder<ViewPromotionCubit, ViewPromotionState>(
                      builder: (context, state) {
                        if (state.networkStatusEnum ==
                            NetworkStatusEnum.loading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state.networkStatusEnum ==
                                NetworkStatusEnum.loaded &&
                            state.promotionpreRes.status == "true") {
                          final promotions = state.promotionpreRes.banners;
                          if (promotions == null || promotions.isEmpty) {
                            return const Center(
                              child: Text("No promotions found"),
                            );
                          }

                          return ListView.builder(
                            itemCount: promotions.length,
                            itemBuilder: (context, index) {
                              final promo = promotions[index];
                              return Card(
                                margin: EdgeInsets.symmetric(vertical: 6.h),
                                child: Padding(
                                  padding: EdgeInsets.all(8.w),
                                  child: Row(
                                    children: [
                                      // App Banner Image
                                      CachedNetworkImage(
                                        imageUrl:
                                            "${ApiConstant.imageUrl}/public/media/promotions/${promo.appImage}",
                                        height: 100.h,
                                        width: 100.w,
                                      ),

                                      SizedBox(width: 10.w),
                                      // Details Column
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Sections: ${promo.displaySection?.join(', ') ?? '-'}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              "Type: ${promo.type ?? '-'}",
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  width: 10.w,
                                                  height: 10.h,
                                                  decoration: BoxDecoration(
                                                    color: promo.status == 3
                                                        ? Colors.orange
                                                        : Colors.green,
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                                SizedBox(width: 5.w),
                                                Text(promo.status == 3
                                                    ? "Pending"
                                                    : 'Active'),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Status & Actions
                                      Column(
                                        children: [
                                          SizedBox(height: 5.h),
                                          Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  showCustomConfirmationDialog(
                                                    content:
                                                        "Are you sure, you want to delete this banner ?",
                                                    context: context,
                                                    title: "Delete",
                                                    onConfirm: () {
                                                      _delete(promo.id);
                                                      Fluttertoast.showToast(
                                                        msg:
                                                            "Banner deleted successfully",
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                      );

                                                      final storeId =
                                                          sharedPreferenceHelper
                                                              .getStoreId;
                                                      if (storeId != null &&
                                                          storeId.isNotEmpty) {
                                                        context
                                                            .read<
                                                                ViewPromotionCubit>()
                                                            .login(
                                                                StoreIdReqmodel(
                                                                    storeId:
                                                                        storeId));
                                                      }
                                                    },
                                                    cancelText: "No",
                                                    confirmText: "Yes",
                                                  );
                                                },
                                                icon: const Icon(Icons.delete),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return Center(
                            child: Text("Something went wrong"),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Container(
              margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.w),
              child: CustomButton(
                title: "Add Banner",
                onPressed: storeId != null && storeId != ""
                    ? () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddBannerScreen(
                                sections: state.promotionpreRes.sections,
                                currency: state
                                    .promotionpreRes.appData!.currencySymbol,
                                storeId: storeId,
                                appData: state.promotionpreRes.appData,
                              ),
                            ));
                      }
                    : () {
                        Fluttertoast.showToast(
                          msg: "First, you need to create a store",
                          toastLength: Toast.LENGTH_SHORT,
                        );
                      },
                icon: Icons.arrow_forward_ios_rounded,
              ),
            ));
      },
    );
  }

  void _delete(String? id) {
    context.read<PromotionDelete>().login(id);
  }
}
