import 'package:bringessesellerapp/config/constant/contsant.dart';
import 'package:bringessesellerapp/config/constant/sharedpreference_helper.dart';
import 'package:bringessesellerapp/model/request/create_coupon_req.dart';
import 'package:bringessesellerapp/model/request/productlist_req_model.dart';
import 'package:bringessesellerapp/model/response/product_list_response_model.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/product_list_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/product_list_state.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/coupon_create_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/coupon_create_state.dart';
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
  const CreateCoupon({super.key});

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
    loadProduct();
    super.initState();
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      setState(() {
        controller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  Future<void> _initialize() async {
    await sharedPreferenceHelper.init();
    loadProduct();
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

  void _save() {
    final model = CreateCouponReqModel(
      code: _couponCodeController.text,
      discountType: selectedDiscountType,
      discountValue: _priceValueController.text,
      productIds:
          selectedProduct != null ? [selectedProduct!.id.toString()] : [],
      endDate: _validTillController.text,
      name: _couponNameController.text,
      sellerId: sharedPreferenceHelper.getSellerId,
      startDate: _validFromController.text,
      storeId: sharedPreferenceHelper.getStoreId,
      total: _maxCouponsController.text,
      type: selectedCouponType,
    );

    context.read<CouponCreateCubit>().login(model);
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
      appBar: const CustomAppBar(title: "Create Coupon"),
      body: BlocConsumer<CouponCreateCubit, CouponCreateState>(
        listener: (context, state) {
          print("ssdfljbns$state");
          if (state.networkStatusEnum == NetworkStatusEnum.loaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Coupon created successfully 🎉"),
                duration: Duration(seconds: 2),
              ),
            );

            Future.delayed(const Duration(seconds: 2), () {
              context.pop(); // go back to previous screen
            });
          } else if (state.createres.status != 'true') {
            showAppToast(message: state.createres.message ?? "");
          }

          /// ❌ Failure
          // else if (state.networkStatusEnum == NetworkStatusEnum.error) {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(
          //       content: Text(state.error ?? "Failed to create coupon"),
          //       backgroundColor: Colors.red,
          //     ),
          //   );
          // }
        },
        builder: (context, state) {
          if (state.networkStatusEnum == NetworkStatusEnum.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(15.w),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(15.w),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Coupon Code
                      const SubTitleText(title: "Coupon Code"),
                      CustomTextField(
                        onChanged: (value) {
                          _couponCodeController.value =
                              _couponCodeController.value.copyWith(
                            text: value.toUpperCase(),
                            selection:
                                TextSelection.collapsed(offset: value.length),
                          );
                        },
                        controller: _couponCodeController,
                        hintText: "Enter Coupon Code",
                        validator: (value) =>
                            value == null || value.isEmpty ? "Required" : null,
                      ),
                      vericalSpaceMedium,

                      /// Coupon Name
                      const SubTitleText(title: "Coupon Name"),
                      CustomTextField(
                        controller: _couponNameController,
                        hintText: "Enter Coupon Name",
                        validator: (value) =>
                            value == null || value.isEmpty ? "Required" : null,
                      ),
                      vericalSpaceMedium,

                      /// Max Coupons
                      const SubTitleText(title: "Max No of Coupons"),
                      CustomTextField(
                        controller: _maxCouponsController,
                        hintText: "Enter maximum number of coupons",
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            value == null || value.isEmpty ? "Required" : null,
                      ),
                      vericalSpaceMedium,

                      /// Valid From
                      const SubTitleText(title: "Coupon Valid From"),
                      GestureDetector(
                        onTap: () => _pickDate(_validFromController),
                        child: AbsorbPointer(
                          child: CustomTextField(
                            controller: _validFromController,
                            hintText: "Select start date",
                            validator: (value) => value == null || value.isEmpty
                                ? "Required"
                                : null,
                          ),
                        ),
                      ),
                      vericalSpaceMedium,

                      /// Valid Till
                      const SubTitleText(title: "Coupon Valid Till"),
                      GestureDetector(
                        onTap: () => _pickDate(_validTillController),
                        child: AbsorbPointer(
                          child: CustomTextField(
                            controller: _validTillController,
                            hintText: "Select end date",
                            validator: (value) => value == null || value.isEmpty
                                ? "Required"
                                : null,
                          ),
                        ),
                      ),
                      vericalSpaceMedium,

                      /// Coupon Type
                      const SubTitleText(title: "Select Coupon Type"),
                      DropdownButtonFormField<String>(
                        hint: const Text("Select coupon type"),
                        value: selectedCouponType,
                        items: couponTypes
                            .map((type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCouponType = value;
                          });
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        validator: (value) =>
                            value == null ? "Please select coupon type" : null,
                      ),
                      vericalSpaceMedium,

                      /// Discount Type
                      const SubTitleText(title: "Discount Type"),
                      DropdownButtonFormField<String>(
                        hint: const Text("Select discount type"),
                        value: selectedDiscountType,
                        items: discountTypes
                            .map((type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedDiscountType = value;
                          });
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        validator: (value) => value == null
                            ? "Please select discount type"
                            : null,
                      ),
                      vericalSpaceMedium,

                      /// Price Value
                      if (selectedDiscountType != null) ...[
                        SubTitleText(
                          title: selectedDiscountType == 'percentage'
                              ? "Percentage Value (1–100)"
                              : "Discount Amount",
                        ),
                        CustomTextField(
                          controller: _priceValueController,
                          hintText: selectedDiscountType == 'percentage'
                              ? "Enter discount percentage"
                              : "Enter discount amount",
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Required";
                            }

                            final num? val = num.tryParse(value);
                            if (val == null) {
                              return "Enter a valid number";
                            }

                            // ✅ Additional validation for percentage type
                            if (selectedDiscountType == 'percentage' &&
                                (val < 1 || val > 100)) {
                              return "Percentage must be between 1 and 100";
                            }

                            return null;
                          },
                        ),
                        vericalSpaceMedium,
                      ],
                      vericalSpaceMedium,

                      /// Product List (Dynamic)
                      if (selectedCouponType == 'product') ...[
                        const SubTitleText(title: "Select Product"),
                        vericalSpaceSmall,
                        BlocBuilder<ProductListCubit, ProductListState>(
                          builder: (context, productState) {
                            if (productState.networkStatusEnum ==
                                NetworkStatusEnum.loading) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (productState.networkStatusEnum ==
                                NetworkStatusEnum.loaded) {
                              productList =
                                  productState.productListModel.result?.items ??
                                      [];

                              return DropdownButtonFormField<ProductItem>(
                                value: selectedProduct,
                                hint: const Text(
                                    "Select product"), // ✅ Added hint
                                items: productList.map((product) {
                                  return DropdownMenuItem(
                                    value: product,
                                    child: Text(product.name ?? ''),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedProduct = value;
                                  });
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                ),
                                validator: (value) =>
                                    selectedCouponType == 'product' &&
                                            value == null
                                        ? "Please select a product"
                                        : null,
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                        vericalSpaceMedium,
                      ]
                    ]),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.w),
          child: CustomButton(
            title: "Save",
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _save();
              }
            },
          ),
        ),
      ),
    );
  }
}
