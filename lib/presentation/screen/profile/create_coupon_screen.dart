import 'package:bringessesellerapp/config/constant/contsant.dart';
import 'package:bringessesellerapp/config/constant/sharedpreference_helper.dart';
import 'package:bringessesellerapp/model/request/coupon_update_req_model.dart';
import 'package:bringessesellerapp/model/request/create_coupon_req.dart';
import 'package:bringessesellerapp/model/request/productlist_req_model.dart';

import 'package:bringessesellerapp/model/response/get_coupon_res_model.dart';
import 'package:bringessesellerapp/model/response/product_list_response_model.dart';

import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/product_list_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/product_list_state.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/coupon_create_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/coupon_create_state.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/update_coupon_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/update_coupon_state.dart';
import 'package:bringessesellerapp/presentation/widget/custome_appbar.dart';
import 'package:bringessesellerapp/presentation/widget/custome_button.dart';
import 'package:bringessesellerapp/presentation/widget/custome_textfeild.dart';
import 'package:bringessesellerapp/presentation/widget/sub_title.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:bringessesellerapp/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class CreateCoupon extends StatefulWidget {
  final GetCouponData? couponData; // ✅ optional for edit

  const CreateCoupon({super.key, this.couponData});

  @override
  State<CreateCoupon> createState() => _CreateCouponState();
}

class _CreateCouponState extends State<CreateCoupon> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _couponCodeController = TextEditingController();
  final TextEditingController _couponNameController = TextEditingController();
  final TextEditingController _maxCouponsController = TextEditingController();
  final TextEditingController _validFromController = TextEditingController();
  final TextEditingController _validTillController = TextEditingController();
  final TextEditingController _priceValueController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  late SharedPreferenceHelper sharedPreferenceHelper;

  String? selectedCouponType;
  String? selectedDiscountType;

  final List<String> couponTypes = ['store', 'product'];
  final List<String> discountTypes = ['flat', 'percentage'];

  List<ProductItem> productList = [];
  ProductItem? selectedProduct;

  @override
  void initState() {
    sharedPreferenceHelper = SharedPreferenceHelper();
    _initialize();
    super.initState();
  }

  Future<void> _initialize() async {
    await sharedPreferenceHelper.init();
    loadProduct();

    // ✅ Prefill when editing
    if (widget.couponData != null) {
      final coupon = widget.couponData!;
      _couponCodeController.text = coupon.code ?? '';
      _couponNameController.text = coupon.name ?? '';
      _maxCouponsController.text = coupon.total?.toString() ?? '';
      _priceValueController.text = coupon.discountValue?.toString() ?? '';
      _validFromController.text = _formatDateForDisplay(coupon.startDate);
      _validTillController.text = _formatDateForDisplay(coupon.endDate);
      selectedCouponType = coupon.type!.toLowerCase();
      selectedDiscountType = coupon.discountType;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (coupon.productIds != null && coupon.productIds!.isNotEmpty) {
          final productId = coupon.productIds!.first.toString();
          if (productList.isNotEmpty) {
            final match = productList.firstWhere(
              (p) => p.id.toString() == productId,
              orElse: () => ProductItem(),
            );
            setState(() {
              selectedProduct = match;
            });
          }
        }
      });
    }
  }

  void loadProduct() {
    context.read<ProductListCubit>().login(
          ProductListReqModel(
            storeId: sharedPreferenceHelper.getStoreId,
            status: '1',
            pageId: "0",
            searchKey: "",
          ),
        );
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) {
      controller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
    }
  }

  String _formatDateForDisplay(String? date) {
    if (date == null || date.isEmpty) return '';
    try {
      final parsed = DateTime.parse(date);
      return DateFormat('dd/MM/yyyy').format(parsed);
    } catch (e) {
      return date;
    }
  }

  String _formatDateForBackend(String date) {
    try {
      final parsed = DateFormat('dd/MM/yyyy').parse(date);
      return DateFormat('yyyy-MM-dd').format(parsed);
    } catch (_) {
      return date;
    }
  }

  void _save() {
    final model = CreateCouponReqModel(
      code: _couponCodeController.text,
      discountType: selectedDiscountType,
      discountValue: _priceValueController.text,
      productIds:
          selectedProduct != null ? [selectedProduct!.id.toString()] : [],
      endDate: _formatDateForBackend(_validTillController.text),
      name: _couponNameController.text,
      sellerId: sharedPreferenceHelper.getSellerId,
      startDate: _formatDateForBackend(_validFromController.text),
      storeId: sharedPreferenceHelper.getStoreId,
      total: _maxCouponsController.text,
      type: selectedCouponType,
    );

    if (widget.couponData == null) {
      /// ✅ Create New Coupon
      context.read<CouponCreateCubit>().login(model);
    } else {
      /// ✅ Update Existing Coupon
      final updateModel = CouponUpdateReqModel(
        name: _couponNameController.text,
        code: _couponCodeController.text,
        type: selectedCouponType,
        sellerId: sharedPreferenceHelper.getSellerId,
        storeId: sharedPreferenceHelper.getStoreId,
        discountType: selectedDiscountType,
        discountValue: num.tryParse(_priceValueController.text) ?? 0,
        total: num.tryParse(_maxCouponsController.text) ?? 0,
        startDate: _formatDateForBackend(_validFromController.text),
        endDate: _formatDateForBackend(_validTillController.text),
        productIds:
            selectedProduct != null ? [selectedProduct!.id.toString()] : [],
      );

      context
          .read<UpdateCouponCubit>()
          .login(updateModel, widget.couponData!.id);
    }
  }

  @override
  void dispose() {
    _couponCodeController.dispose();
    _maxCouponsController.dispose();
    _validFromController.dispose();
    _validTillController.dispose();
    _priceValueController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.couponData == null ? "Create Coupon" : "Edit Coupon",
      ),
      body: BlocListener<UpdateCouponCubit, UpdateCouponState>(
        listener: (context, state) {
          if (state.networkStatusEnum == NetworkStatusEnum.loaded) {
            showAppToast(message: "Coupon update successfully 🎉");
            Future.delayed(const Duration(seconds: 1), () {
              context.pop();
            });
          }
        },
        child: BlocConsumer<CouponCreateCubit, CouponCreateState>(
          listener: (context, state) {
            if (state.networkStatusEnum == NetworkStatusEnum.loaded) {
              showAppToast(message: "Coupon created successfully 🎉");
              Future.delayed(const Duration(seconds: 1), () {
                context.pop();
              });
            }
          },
          builder: (context, state) {
            if (state.networkStatusEnum == NetworkStatusEnum.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(15.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Coupon Code
                    const SubTitleText(
                      title: "Coupon Code",
                      isMandatory: true,
                    ),
                    CustomTextField(
                      controller: _couponCodeController,
                      hintText: "Enter Coupon Code",
                      onChanged: (value) {
                        _couponCodeController.value =
                            _couponCodeController.value.copyWith(
                          text: value.toUpperCase(),
                          selection:
                              TextSelection.collapsed(offset: value.length),
                        );
                      },
                      // disable in edit mode
                      validator: (v) =>
                          v == null || v.isEmpty ? "Required" : null,
                    ),
                    vericalSpaceMedium,

                    /// Coupon Name
                    const SubTitleText(
                      title: "Coupon Name",
                      isMandatory: true,
                    ),
                    CustomTextField(
                      controller: _couponNameController,
                      hintText: "Enter Coupon Name",
                      validator: (v) =>
                          v == null || v.isEmpty ? "Required" : null,
                    ),
                    vericalSpaceMedium,

                    /// Max Coupons
                    const SubTitleText(
                      title: "Max Coupons",
                      isMandatory: true,
                    ),
                    CustomTextField(
                      controller: _maxCouponsController,
                      hintText: "Enter maximum number",
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          v == null || v.isEmpty ? "Required" : null,
                    ),
                    vericalSpaceMedium,

                    /// Valid From
                    const SubTitleText(
                      title: "Valid From",
                      isMandatory: true,
                    ),
                    GestureDetector(
                      onTap: () => _pickDate(_validFromController),
                      child: AbsorbPointer(
                        child: CustomTextField(
                          controller: _validFromController,
                          hintText: "Select start date",
                          validator: (v) =>
                              v == null || v.isEmpty ? "Required" : null,
                        ),
                      ),
                    ),
                    vericalSpaceMedium,

                    /// Valid Till
                    const SubTitleText(
                      title: "Valid Till",
                      isMandatory: true,
                    ),
                    GestureDetector(
                      onTap: () => _pickDate(_validTillController),
                      child: AbsorbPointer(
                        child: CustomTextField(
                          controller: _validTillController,
                          hintText: "Select end date",
                          validator: (v) =>
                              v == null || v.isEmpty ? "Required" : null,
                        ),
                      ),
                    ),
                    vericalSpaceMedium,

                    /// Coupon Type
                    const SubTitleText(
                      title: "Coupon Type",
                      isMandatory: true,
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedCouponType,
                      hint: const Text("Select coupon type"),
                      items: couponTypes
                          .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (v) {
                        setState(() => selectedCouponType = v);
                      },
                      decoration:
                          const InputDecoration(border: OutlineInputBorder()),
                      validator: (v) =>
                          v == null ? "Please select coupon type" : null,
                    ),
                    vericalSpaceMedium,
                    if (selectedCouponType == 'product') ...[
                      const SubTitleText(
                        title: "Select Product",
                        isMandatory: true,
                      ),
                      vericalSpaceSmall,
                      BlocBuilder<ProductListCubit, ProductListState>(
                        builder: (context, productState) {
                          if (productState.networkStatusEnum ==
                              NetworkStatusEnum.loading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          final list =
                              productState.productListModel.result?.items ?? [];
                          return DropdownButtonFormField<ProductItem>(
                            value: selectedProduct,
                            items: list
                                .map((p) => DropdownMenuItem(
                                    value: p, child: Text(p.name ?? '')))
                                .toList(),
                            onChanged: (v) {
                              setState(() => selectedProduct = v);
                            },
                            decoration: const InputDecoration(
                                border: OutlineInputBorder()),
                            validator: (v) =>
                                selectedCouponType == 'product' && v == null
                                    ? "Select a product"
                                    : null,
                          );
                        },
                      ),
                    ],
                    vericalSpaceSmall,
                    const SubTitleText(
                      title: "Discount Type",
                      isMandatory: true,
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedDiscountType,
                      hint: const Text("Select discount type"),
                      items: discountTypes
                          .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (v) {
                        setState(() => selectedDiscountType = v);
                      },
                      decoration:
                          const InputDecoration(border: OutlineInputBorder()),
                      validator: (v) =>
                          v == null ? "Please select discount type" : null,
                    ),
                    vericalSpaceMedium,

                    /// Discount Value
                    if (selectedDiscountType != null) ...[
                      SubTitleText(
                        title: selectedDiscountType == 'percentage'
                            ? "Percentage (1–100)"
                            : "Flat Amount (₹)",
                        isMandatory: true,
                      ),
                      CustomTextField(
                        controller: _priceValueController,
                        hintText: selectedDiscountType == 'percentage'
                            ? "Enter percentage"
                            : "Enter flat discount",
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.isEmpty) return "Required";
                          final val = num.tryParse(v);
                          if (val == null) return "Invalid number";
                          if (selectedDiscountType == 'percentage' &&
                              (val < 1 || val > 100)) {
                            return "Percentage must be 1–100";
                          }
                          return null;
                        },
                      ),
                      vericalSpaceMedium,
                    ],

                    /// Product List
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.w),
          child: CustomButton(
            title: widget.couponData == null ? "Save" : "Update",
            onPressed: () {
              if (_formKey.currentState!.validate()) _save();
            },
          ),
        ),
      ),
    );
  }
}
