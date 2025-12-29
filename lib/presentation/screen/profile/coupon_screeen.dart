import 'package:bringessesellerapp/config/themes.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/delete_coupon_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/profile/create_coupon_screen.dart';
import 'package:bringessesellerapp/presentation/widget/custom_card.dart';
import 'package:bringessesellerapp/presentation/widget/custom_conformation.dart';
import 'package:bringessesellerapp/presentation/widget/custome_appbar.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // ✅ For date formatting

import 'bloc/get_coupon_cubit.dart';
import 'bloc/get_coupon_state.dart';

class CouponScreeen extends StatefulWidget {
  const CouponScreeen({super.key});

  @override
  State<CouponScreeen> createState() => _CouponScreeenState();
}

class _CouponScreeenState extends State<CouponScreeen> {
  @override
  void initState() {
    super.initState();
    context.read<GetCouponCubit>().login(); // ✅ Load data on init
  }

  void _deleteCoupon(String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Coupon"),
        content: const Text("Are you sure you want to delete this coupon?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              //  context.read<GetCouponCubit>().deleteCoupon(id);
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleStatus(String id, bool currentStatus) {
    // context.read<GetCouponCubit>().updateCouponStatus(id, !currentStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Coupon List"),
      body: BlocConsumer<GetCouponCubit, GetCouponState>(
        listener: (context, state) {
          if (state.networkStatusEnum == NetworkStatusEnum.loaded) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(
            //     content: Text(state.message!),
            //     backgroundColor: Colors.green,
            //   ),
            // );
          }
        },
        builder: (context, state) {
          if (state.networkStatusEnum == NetworkStatusEnum.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.networkStatusEnum == NetworkStatusEnum.loaded &&
              state.getcouponresponse.data != null &&
              state.getcouponresponse.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: state.getcouponresponse.data!.length,
              itemBuilder: (context, index) {
                final promo = state.getcouponresponse.data![index];

                // ✅ Date formatting
                String formattedDate = '';
                if (promo.endDate != null && promo.endDate!.isNotEmpty) {
                  try {
                    final date = DateTime.parse(promo.endDate!);
                    formattedDate = DateFormat('MMM dd, yyyy').format(date);
                  } catch (e) {
                    formattedDate = promo.endDate!;
                  }
                }

                // ✅ Handle discount text
                String discountDisplay = '';
                if (promo.discountType?.toLowerCase() == 'percentage') {
                  discountDisplay = '${promo.discountValue}% OFF';
                } else if (promo.discountType?.toLowerCase() == 'flat') {
                  discountDisplay = '₹${promo.discountValue} OFF';
                } else {
                  discountDisplay = promo.discountValue.toString();
                }

                // ✅ Coupon status
                bool isActive = false;

                return CustomCard(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: Container(
                      padding: const EdgeInsets.all(5),
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: AppTheme.primaryColor.withOpacity(0.2),
                      ),
                      child: Image.asset(
                        'assets/icons/coupon.png',
                        height: 30.h,
                        width: 30.w,
                      ),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          discountDisplay,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          children: [
                            // ✅ Edit icon
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                context.push('/profile/coupon/add',
                                    extra: {'coupons': promo}).then(
                                  (value) {
                                    context.read<GetCouponCubit>().login();
                                  },
                                );
                              },
                            ),
                            // ✅ Delete icon
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                showCustomConfirmationDialog(
                                    content:
                                        'Are you sure you want delete this coupon',
                                    context: context,
                                    onConfirm: () {
                                      context
                                          .read<DeleteCouponCubit>()
                                          .login(promo.id);
                                      Fluttertoast.showToast(
                                        msg: "Coupon deleted successfully",
                                      ).then(
                                        (value) {
                                          context
                                              .read<GetCouponCubit>()
                                              .login();
                                        },
                                      );
                                    },
                                    title: "Delete",
                                    cancelText: "Cancel",
                                    confirmText: "Yes");
                                // _deleteCoupon(promo.id ?? '');
                              },
                            ),
                            // ✅ Toggle Active/Inactive
                            // IconButton(
                            //   icon: Icon(
                            //     isActive
                            //         ? Icons.toggle_on_rounded
                            //         : Icons.toggle_off_rounded,
                            //     color: isActive ? Colors.green : Colors.grey,
                            //     size: 32,
                            //   ),
                            //   onPressed: () =>
                            //       _toggleStatus(promo.id ?? '', isActive),
                            // ),
                          ],
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          promo.discountType?.toString().toUpperCase() ?? '',
                          style: const TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Valid till $formattedDate",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          if (state.networkStatusEnum == NetworkStatusEnum.loaded &&
              (state.getcouponresponse.data == null ||
                  state.getcouponresponse.data!.isEmpty)) {
            return const Center(
              child: Text(
                'No coupons found.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateCoupon(),
              )).then(
            (value) {
              context.read<GetCouponCubit>().login();
            },
          );
        },
      ),
    );
  }
}
