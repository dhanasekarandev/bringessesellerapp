import 'dart:io';

import 'package:bringessesellerapp/config/constant/contsant.dart';
import 'package:bringessesellerapp/model/request/product_req_model.dart';
import 'package:bringessesellerapp/model/response/store_default_model.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/product_create_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/product_create_state.dart';
import 'package:bringessesellerapp/presentation/widget/custom_card.dart';
import 'package:bringessesellerapp/presentation/widget/custome_appbar.dart';
import 'package:bringessesellerapp/presentation/widget/custome_button.dart';
import 'package:bringessesellerapp/presentation/widget/custome_outline_button.dart';
import 'package:bringessesellerapp/presentation/widget/custome_textfeild.dart';
import 'package:bringessesellerapp/presentation/widget/dotted_container.dart';
import 'package:bringessesellerapp/presentation/widget/sub_title.dart';
import 'package:bringessesellerapp/presentation/widget/title_text.dart';
import 'package:bringessesellerapp/utils/enums.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class AddProductScreen extends StatefulWidget {
  final String? catname;
  final List<Menu>? menuList;
  final List<Unit>? units;
  final String? storeId;
  final String? sellerId;
  const AddProductScreen(
      {super.key,
      this.catname,
      this.menuList,
      this.units,
      this.storeId,
      this.sellerId});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  String? selectedMenu;
  String? selectedUnit;
  String? selectedMenuId;
  String? selectedOffer;
  bool isCombo = false;
  final TextEditingController _name = TextEditingController();
  final TextEditingController _sku = TextEditingController();
  final TextEditingController _des = TextEditingController();
  final TextEditingController _cat = TextEditingController();
  final TextEditingController _sub = TextEditingController();
  final TextEditingController _count = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _offerprice = TextEditingController();
  List<Map<String, dynamic>> variantList = [];
  final List<String> offerOptions = [
    'Yes',
    'No',
  ];
  File? _productImage; // store picked image

  final ImagePicker _picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    addVariant();
    _cat.text = widget.catname ?? "";
  }

  /// Function to pick image
  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) {
      setState(() {
        _productImage = File(pickedFile.path);
      });
    }
  }

  bool load = false;
  void addVariant() {
    variantList.add({
      'count': TextEditingController(),
      'price': TextEditingController(),
      'offerPrice': TextEditingController(),
      'selectedUnit': null,
      'selectedOffer': null,
    });
    setState(() {});
  }

  void removeVariant(int index) {
    variantList.removeAt(index);
    setState(() {});
  }

  void _save() {
    setState(() {
      load = true;
    });
    final List<Variant> variants = [];

    for (var variant in variantList) {
      variants.add(
        Variant(
          name: variant['count'].text,
          price: double.tryParse(variant['price'].text) ?? 0,
          offerAvailable: (variant['selectedOffer'] == "Yes").toString(),
          offerPrice: double.tryParse(variant['offerPrice'].text) ?? 0,
          unit: variant['selectedUnit'] ?? "",
        ),
      );
    }

    final model = ProductCreateReqModel(
      sellerId: widget.sellerId,
      storeId: widget.storeId,
      name: _name.text,
      sku: _sku.text,
      menuId: selectedMenuId,
      variants: variants,
      description: _des.text,
      comboOffer: isCombo,
      productImages: _productImage != null ? [_productImage!] : [],
    );

    try {
      context.read<ProductCreateCubit>().login(model);
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong: $e");
    }
  }

  void _showComboInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("What are Combos?"),
        content: const Text(
          "Combos allow you to bundle multiple products together "
          "and sell them as a single offer or package. "
          "For example, 'Inverter + Battery Combo'.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Got it"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final menuOptions =
        widget.menuList?.map((e) => e.name ?? e.name ?? '').toList() ?? [];

    final unitOptions = widget.units?.map((e) => e.name ?? '').toList() ?? [];

    return BlocConsumer<ProductCreateCubit, ProductCreateState>(
      listener: (context, state) {
        if (state.networkStatusEnum == NetworkStatusEnum.loaded) {
          final data = state.menuCreateResModel.message;
          setState(() {
            load = false;
          });
          context.pop(true);
          Fluttertoast.showToast(
              msg: data! ?? "Product has been created successfully");
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: const CustomAppBar(title: "Add Products"),
          body: SingleChildScrollView(
            child: Column(
              children: [
                /// ---- Upload Image Section ----
                CustomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TitleText(title: "Upload product image"),
                      vericalSpaceMedium,
                      const SubTitleText(title: "Upload product image"),
                      vericalSpaceMedium,
                      InkWell(
                        onTap: _pickImage,
                        child: Container(
                          height: 150.h,
                          padding: EdgeInsets.all(10.w),
                          child: DottedContainer(
                            child: _productImage != null
                                ? Image.file(
                                    _productImage!,
                                    fit: BoxFit.cover,
                                    height: 200.h,
                                    width: 1.sw,
                                  )
                                : const Center(
                                    child: Text("Upload Image"),
                                  ),
                          ),
                        ),
                      ),
                      const SubTitleText(
                          title: "Minimum file size 5MB (JPG and PNG)"),
                    ],
                  ),
                ),

                /// ---- Product Details ----
                CustomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SubTitleText(title: "Name"),
                      CustomTextField(
                        hintText: "Name",
                        controller: _name,
                      ),
                      vericalSpaceMedium,
                      const SubTitleText(
                        title: "Menu",
                      ),
                      vericalSpaceMedium,
                      DropdownButtonFormField<String>(
                        value: selectedMenu,
                        hint: const Text("Select Menu"),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                        items: widget.menuList?.map((menu) {
                          return DropdownMenuItem(
                            value: menu.name,
                            child: Text(menu.name ?? ''),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedMenu = value;

                            final menuObj = widget.menuList
                                ?.firstWhere((menu) => menu.name == value);

                            selectedMenuId = menuObj?.id;

                            _sub.text = menuObj?.subCategoryName ?? '';
                          });
                        },
                      ),
                      vericalSpaceMedium,
                      const SubTitleText(title: "Category name"),
                      CustomTextField(
                        controller: _cat,
                        hintText: "Category name",
                        readOnly: true,
                      ),
                      vericalSpaceMedium,
                      const SubTitleText(title: "Sub category name"),
                      CustomTextField(
                        controller: _sub,
                        hintText: "Sub category name",
                        readOnly: true,
                      ),
                      vericalSpaceMedium,
                      const SubTitleText(title: "SKU (optional)"),
                      CustomTextField(
                        hintText: "",
                        controller: _sku,
                      ),
                      vericalSpaceMedium,
                      const SubTitleText(title: "Description"),
                      CustomTextField(
                        hintText: "Description",
                        controller: _des,
                        maxLines: 5,
                      ),
                    ],
                  ),
                ),

                /// ---- Combo Option ----
                CustomCard(
                  child: Row(
                    children: [
                      const TitleText(title: "Combos"),
                      horizontalSpaceMedium,
                      GestureDetector(
                        onTap: _showComboInfoDialog,
                        child: const Icon(Icons.info_outline_rounded),
                      ),
                      const Spacer(),
                      Checkbox(
                        value: isCombo,
                        onChanged: (value) {
                          setState(() {
                            isCombo = value ?? false;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                /// ---- Variant Section ----
                CustomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const TitleText(title: "Variants"),
                          const Spacer(),
                          CustomOutlineButton(
                            title: "Add",
                            icon: Icons.add_circle_outline_sharp,
                            onPressed: addVariant,
                          ),
                        ],
                      ),
                      vericalSpaceMedium,

                      /// List of all variants
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: variantList.length,
                        itemBuilder: (context, index) {
                          final variant = variantList[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text("Variant ${index + 1}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  const Spacer(),
                                  if (variantList.length > 1)
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline,
                                          color: Colors.red),
                                      onPressed: () => removeVariant(index),
                                    ),
                                ],
                              ),
                              const SubTitleText(title: "Count"),
                              CustomTextField(
                                controller: variant['count'],
                                hintText: "",
                                keyboardType: TextInputType.number,
                              ),
                              vericalSpaceMedium,
                              const SubTitleText(title: "Select Unit"),
                              DropdownButtonFormField<String>(
                                value: variant['selectedUnit'],
                                hint: const Text("Select Unit"),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                ),
                                items: widget.units
                                        ?.map((unit) => DropdownMenuItem(
                                              value: unit.name,
                                              child: Text(unit.name ?? ''),
                                            ))
                                        .toList() ??
                                    [],
                                onChanged: (value) {
                                  setState(() {
                                    variant['selectedUnit'] = value;
                                  });
                                },
                              ),
                              vericalSpaceMedium,
                              const SubTitleText(title: "Price"),
                              CustomTextField(
                                controller: variant['price'],
                                hintText: "",
                                keyboardType: TextInputType.number,
                              ),
                              vericalSpaceMedium,
                              const SubTitleText(title: "Select Offer"),
                              DropdownButtonFormField<String>(
                                value: variant['selectedOffer'],
                                hint: const Text("Select Offer"),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                ),
                                items: offerOptions
                                    .map((offer) => DropdownMenuItem(
                                          value: offer,
                                          child: Text(offer),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    variant['selectedOffer'] = value;
                                  });
                                },
                              ),
                              vericalSpaceMedium,
                              const SubTitleText(title: "Offer Price"),
                              CustomTextField(
                                controller: variant['offerPrice'],
                                hintText: "",
                                keyboardType: TextInputType.number,
                              ),
                              const Divider(),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// ---- Bottom Save Button ----
          bottomNavigationBar: Container(
            margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.w),
            child: CustomButton(
              title: load == 'true' ? "Please wait.." : "Save",
              onPressed: _save,
            ),
          ),
        );
      },
    );
  }
}
