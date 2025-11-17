import 'dart:io';
import 'package:bringessesellerapp/config/constant/api_constant.dart';
import 'package:bringessesellerapp/config/constant/contsant.dart';
import 'package:bringessesellerapp/model/request/product_req_model.dart';
import 'package:bringessesellerapp/model/request/product_update_req_model.dart';
import 'package:bringessesellerapp/model/request/remove_video_req_model.dart';
import 'package:bringessesellerapp/model/request/upload_video_req_model.dart';
import 'package:bringessesellerapp/model/response/product_by_id_response_model.dart'
    as pd;

import 'package:bringessesellerapp/model/response/store_default_model.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/product_create_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/product_create_state.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/product_update_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/product_update_state.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/remove_video_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/remove_video_state.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/upload_video_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/upload_video_state.dart';
import 'package:bringessesellerapp/presentation/widget/custom_card.dart';
import 'package:bringessesellerapp/presentation/widget/custom_conformation.dart';
import 'package:bringessesellerapp/presentation/widget/custome_appbar.dart';
import 'package:bringessesellerapp/presentation/widget/custome_button.dart';
import 'package:bringessesellerapp/presentation/widget/custome_outline_button.dart';
import 'package:bringessesellerapp/presentation/widget/custome_textfeild.dart';
import 'package:bringessesellerapp/presentation/widget/dotted_container.dart';
import 'package:bringessesellerapp/presentation/widget/sub_title.dart';
import 'package:bringessesellerapp/presentation/widget/title_text.dart';
import 'package:bringessesellerapp/presentation/widget/video_player_widget.dart';

import 'package:bringessesellerapp/utils/enums.dart';
import 'package:flutter/cupertino.dart';
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
  final String? subcat;
  final pd.ProductResult? editProduct;

  const AddProductScreen({
    super.key,
    this.catname,
    this.menuList,
    this.units,
    this.storeId,
    this.sellerId,
    this.editProduct,
    this.subcat,
  });

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
  final TextEditingController _stock = TextEditingController();
  final TextEditingController _gst = TextEditingController();
  final TextEditingController _cgst = TextEditingController();
  final TextEditingController _sgst = TextEditingController();
  List<Map<String, dynamic>> variantList = [];
  final List<String> offerOptions = ['Yes', 'No'];
  File? _productVideo;

  List<File> _productImages = []; // store picked images
  final ImagePicker _picker = ImagePicker();
  bool load = false;
  List<dynamic> _productMedia = [];
  @override
  void initState() {
    super.initState();
    addVariant();
    _cat.text = widget.catname ?? "";
    _sub.text = widget.subcat ?? "";
    final product = widget.editProduct;

    if (product != null) {
      _name.text = product.name ?? "";
      _sku.text = product.sku ?? "";
      _des.text = product.description ?? "";
      _cat.text = widget.catname ?? "";
      _stock.text = widget.editProduct!.quantity ?? "";
      isCombo = product.comboOffer == 0 ? false : true;
      if (product.videoUrl != null && product.videoUrl!.isNotEmpty) {
        uploadvideoUrl =
            "${ApiConstant.imageUrl}/public/media/items/${product.videoUrl}";
      }
      selectedMenuId = product.menuId;
      selectedMenu = widget.menuList
          ?.firstWhere((e) => e.id == product.menuId, orElse: () => Menu())
          .name;

      // ✅ Load existing images with full URL
      if (product.images != null && product.images!.isNotEmpty) {
        for (var img in product.images!) {
          _productMedia.add("${ApiConstant.imageUrl}/public/media/items/$img");
        }
      }

      // ✅ Prefill variants
      variantList.clear();
      for (var v in product.variants!) {
        final gstController =
            TextEditingController(text: v.gst?.toString() ?? "0");
        final cgstController =
            TextEditingController(text: ((v.gst ?? 0) / 2).toStringAsFixed(2));
        final sgstController =
            TextEditingController(text: ((v.gst ?? 0) / 2).toStringAsFixed(2));
        gstController.addListener(() {
          double gstValue = double.tryParse(gstController.text) ?? 0;
          double split = gstValue / 2;
          cgstController.text = split.toStringAsFixed(2);
          sgstController.text = split.toStringAsFixed(2);
          setState(() {});
        });
        if (product.variants != null && product.variants!.isNotEmpty) {
          for (var v in product.variants!) {
            final gstValue =
                v.price ?? 0; // Assuming product variant has gst field
            final splitValue = gstValue / 2;

            variantList.add({
              'count': TextEditingController(text: v.name ?? ""),
              'price': TextEditingController(text: v.price?.toString() ?? ""),
              'offerPrice':
                  TextEditingController(text: v.offerPrice?.toString() ?? ""),
              'gst': TextEditingController(text: gstValue.toString()),
              'cgst':
                  TextEditingController(text: splitValue.toStringAsFixed(2)),
              'sgst':
                  TextEditingController(text: splitValue.toStringAsFixed(2)),
              'selectedUnit': v.unit?.trim(),
              'selectedOffer': v.offerAvailable == "true" ? "Yes" : "No",
            });
          }
        } else {
          addVariant();
        }
      }
    }
  }

  _remove() async {
    context
        .read<RemoveVideoCubit>()
        .login(RemoveVideoReqModel(videoUrl: uploadvideoUrl));
  }

  /// Pick multiple images (max 5)
  Future<void> _pickImage() async {
    final List<XFile>? pickedFiles =
        await _picker.pickMultiImage(imageQuality: 80);

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      if (pickedFiles.length + _productMedia.length > 5) {
        Fluttertoast.showToast(msg: "You can upload a maximum of 5 images");
        return;
      }
      setState(() {
        _productMedia.addAll(pickedFiles.map((file) => File(file.path)));
      });
    }
  }

  bool loading = false;
  String? uploadvideoUrl;
  Future<void> _pickVideo() async {
    setState(() {
      loading = true;
    });
    final XFile? pickedVideo = await _picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(minutes: 2),
    );

    if (pickedVideo != null) {
      final file = File(pickedVideo.path);
      final fileSizeInBytes = await file.length();
      final fileSizeInMB = fileSizeInBytes / (1024 * 1024);
      if (fileSizeInMB > 20) {
        Fluttertoast.showToast(msg: "Video size should not exceed 20 MB");
        return;
      }

      setState(() {
        _productVideo = file;
      });

      context.read<UploadVideoCubit>().login(UploadVideoReqModel(video: file));
    }
  }

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

  void _showCalculation() {
    // Step 1: Prepare calculations for all variants
    List<Widget> calculationWidgets = [];

    for (var variant in variantList) {
      double price = double.tryParse(variant['price'].text) ?? 0;
      double offerPrice = double.tryParse(variant['offerPrice'].text) ?? 0;
      double gstPercent = double.tryParse(_gst.text) ?? 0;
      double processingFeePercent = 5; // Example: 5% processing fee
      bool isOffer = variant['selectedOffer'] == "Yes";

      final result = calculateFinalPrice(
        price: price,
        offerPrice: offerPrice,
        gstPercent: gstPercent,
        processingFeePercent: processingFeePercent,
        isOffer: isOffer,
      );

      // Add each field as a separate widget
      calculationWidgets.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            // Text(
            //   "Variant: ${variant['count'].text}",
            //   style: Theme.of(context)
            //       .textTheme
            //       .bodyLarge!
            //       .copyWith(fontSize: 18.sp, fontWeight: FontWeight.w700),
            // ),
            const SizedBox(height: 6),
            Text(
              "Selling Price: ₹${result['sellingPrice']!.toStringAsFixed(2)}",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),

            Text(
              "CGST (${(gstPercent / 2).toStringAsFixed(1)}%): ₹${result['cgst']!.toStringAsFixed(2)}",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
            Text(
              "SGST (${(gstPercent / 2).toStringAsFixed(1)}%): ₹${result['sgst']!.toStringAsFixed(2)}",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
            Text(
              "Processing Fee ($processingFeePercent%): ₹${result['processingFeeAmount']!.toStringAsFixed(2)}",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
            Text(
              "Final Price: ₹${result['finalPrice']!.toStringAsFixed(2)}",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontSize: 18.sp, fontWeight: FontWeight.w700),
            ),
            Text(
              "Earning Amount: ₹${result['earningAmount']!.toStringAsFixed(2)}",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontSize: 18.sp, fontWeight: FontWeight.w700),
            ),
            const Divider(height: 20, thickness: 1),
          ],
        ),
      );
    }

    // Step 2: Show Modal Bottom Sheet
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Price Calculation",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: calculationWidgets,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: CustomOutlineButton(
                      paddingHorizontal: 20.w,
                      onPressed: () => Navigator.pop(context),
                      title: "Cancel",
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      height: 40.h,
                      onPressed: () {
                        Navigator.pop(context);
                        _save(); // call your actual save function
                      },
                      title: "Add product",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
            ],
          ),
        );
      },
    );
  }

  void _save() async {
    setState(() => load = true);

    final variants = variantList.map((v) {
      return Variant(
        name: v['count'].text,
        price: double.tryParse(v['price'].text) ?? 0,
        offerAvailable: (v['selectedOffer'] == "Yes").toString(),
        offerPrice: double.tryParse(v['offerPrice'].text) ?? 0,
        unit: v['selectedUnit'] ?? "",
      );
    }).toList();

    // Separate local files & existing images
    final newFiles = _productMedia.whereType<File>().toList();
    final existingImages = _productMedia
        .whereType<String>()
        .map((url) => url.split('/').last)
        .toList();

    try {
      if (widget.editProduct == null) {
        final req = ProductCreateReqModel(
            sellerId: widget.sellerId,
            storeId: widget.storeId,
            name: _name.text,
            sku: _sku.text,
            menuId: selectedMenuId,
            variants: variants,
            description: _des.text,
            comboOffer: isCombo,
            quantity: _stock.text,
            productImages: newFiles,
            videoUrl: uploadvideoUrl);
        context.read<ProductCreateCubit>().login(req);
      } else {
        final req = ProductUpdateReqModel(
          itemId: widget.editProduct!.id,
          sellerId: widget.sellerId,
          storeId: widget.storeId,
          name: _name.text,
          sku: _sku.text,
          menuId: selectedMenuId,
          variants: variants,
          description: _des.text,
          comboOffer: isCombo,
          quantity: _stock.text,
          outOfStock: widget.editProduct!.outOfStock == 0 ? false : true,
          productImages: newFiles,
          existingImages: existingImages,
        );
        context.read<ProductUpdateCubit>().login(req);
      }
    } catch (e) {
      setState(() => load = false);
      Fluttertoast.showToast(msg: "Error: $e");
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
    final unitOptions = widget.units?.map((e) => e.name ?? '').toList() ?? [];

    return MultiBlocListener(
      listeners: [
        BlocListener<UploadVideoCubit, UploadVideoState>(
          listener: (context, state) {
            if (state.networkStatusEnum == NetworkStatusEnum.loaded) {
              setState(() {
                loading = false;
                uploadvideoUrl = state.videoResModel.videoUrl!.trim();
              });

              Fluttertoast.showToast(msg: "Product video upload successfully");
            }
          },
        ),
        BlocListener<RemoveVideoCubit, RemoveVideoState>(
          listener: (context, state) {
            if (state.networkStatusEnum == NetworkStatusEnum.loaded) {
              setState(() {
                loading = false;
              });
              setState(() {
                _productVideo = null;
              });
              Fluttertoast.showToast(msg: "Product upload Video removed ");
            }
          },
        ),
        BlocListener<ProductUpdateCubit, ProductUpdateState>(
          listener: (context, state) {
            if (state.networkStatusEnum == NetworkStatusEnum.loaded) {
              setState(() => load = false);
              Fluttertoast.showToast(
                  msg: state.productupdateres.message ??
                      "Product updated successfully");
              context.pop(true);
            } else if (state.networkStatusEnum == NetworkStatusEnum.failed) {
              setState(() => load = false);
              Fluttertoast.showToast(
                  msg: state.productupdateres.message ?? "Failed to update");
            }
          },
        ),
      ],
      child: BlocConsumer<ProductCreateCubit, ProductCreateState>(
        listener: (context, state) {
          if (state.networkStatusEnum == NetworkStatusEnum.loaded) {
            final data = state.menuCreateResModel.message;
            setState(() {
              load = false;
            });
            context.pop(true);
            Fluttertoast.showToast(
                msg: data ?? "Product has been created successfully");
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: CustomAppBar(
              title:
                  widget.editProduct != null ? "Edit Product" : "Add Product",
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  /// ---- Upload Image Section ----
                  CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TitleText(title: "Upload Product Images"),
                        vericalSpaceMedium,

                        // Grid View for images
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _productMedia.length +
                              (_productMedia.length < 5 ? 1 : 0),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1,
                          ),
                          itemBuilder: (context, index) {
                            if (index == _productMedia.length &&
                                _productMedia.length < 5) {
                              // Add Image button
                              return InkWell(
                                onTap: _pickImage,
                                child: DottedContainer(
                                  child: Center(
                                    child: Icon(Icons.add_a_photo_outlined,
                                        color: Colors.grey.shade600, size: 40),
                                  ),
                                ),
                              );
                            }

                            final media = _productMedia[index];
                            final isFile = media is File;

                            return Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: isFile
                                        ? Image.file(media, fit: BoxFit.cover)
                                        : Image.network(media,
                                            fit: BoxFit.cover),
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _productMedia.removeAt(index);
                                      });
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(4),
                                      child: const Icon(Icons.close,
                                          color: Colors.white, size: 16),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),

                        vericalSpaceMedium,
                        const SubTitleText(
                            title: "Maximum 5 images (JPG or PNG)"),
                      ],
                    ),
                  ),
                  CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TitleText(title: "Upload Product Video"),
                        vericalSpaceMedium,

                        // CASE 1: Prefilled network video (Edit mode)
                        if (widget.editProduct != null &&
                            _productVideo == null &&
                            widget.editProduct!.videoUrl != null)
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Container(
                                height: 180,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: VideoPlayerWidget(
                                  videoUrl: widget.editProduct!.videoUrl!,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  showCustomConfirmationDialog(
                                    content:
                                        'Are you sure you want to remove this video?',
                                    context: context,
                                    onConfirm: () {
                                      setState(() {
                                        widget.editProduct!.videoUrl = null;
                                      });
                                    },
                                    title: 'Remove',
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(4),
                                  child: const Icon(Icons.close,
                                      color: Colors.white, size: 30),
                                ),
                              ),
                            ],
                          )

// CASE 2: Local picked video
                        else if (_productVideo != null)
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Container(
                                height: 180,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: VideoPlayerWidget(
                                    videoFile: _productVideo!),
                              ),
                              InkWell(
                                onTap: () {
                                  showCustomConfirmationDialog(
                                    content:
                                        'Are you sure you want to remove this video?',
                                    context: context,
                                    onConfirm: _remove,
                                    title: 'Remove',
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(4),
                                  child: const Icon(Icons.close,
                                      color: Colors.white, size: 30),
                                ),
                              ),
                            ],
                          )

// CASE 3: Loading
                        else if (loading)
                          const Center(child: CupertinoActivityIndicator())

// CASE 4: Default upload UI
                        else
                          InkWell(
                            onTap: _pickVideo,
                            child: DottedContainer(
                              child: Container(
                                height: 150,
                                alignment: Alignment.center,
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.video_collection_outlined,
                                        color: Colors.grey, size: 40),
                                    SizedBox(height: 10),
                                    Text(
                                        "Upload product video (max 2 min, MP4/MOV)"),
                                  ],
                                ),
                              ),
                            ),
                          )
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
                        const SubTitleText(title: "Menu"),
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
                        const SubTitleText(title: "Stock Quantity"),
                        CustomTextField(
                            hintText: "",
                            controller: _stock,
                            keyboardType: TextInputType.number),
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
                  CustomCard(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const TitleText(title: "GST"),
                            horizontalSpaceMedium,
                            GestureDetector(
                              onTap: _showComboInfoDialog,
                              child: const Icon(Icons.info_outline_rounded),
                            ),
                          ],
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
                                  value: unitOptions
                                          .contains(variant['selectedUnit'])
                                      ? variant['selectedUnit']
                                      : null,
                                  hint: const Text("Select Unit"),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                  ),
                                  items: unitOptions
                                      .map((unit) => DropdownMenuItem(
                                            value: unit,
                                            child: Text(unit),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      variant['selectedUnit'] = value;
                                    });
                                  },
                                ),
                                vericalSpaceMedium,
                                const SubTitleText(title: "GST"),
                                CustomTextField(
                                  controller: _gst,
                                  //variant['gst'],
                                  hintText: "",
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    double gstValue =
                                        double.tryParse(value) ?? 0;
                                    double split = gstValue / 2;

                                    // Update CGST & SGST controllers
                                    _cgst.text = split.toStringAsFixed(2);
                                    _sgst.text = split.toStringAsFixed(2);

                                    setState(() {}); // Refresh UI
                                  },
                                ),
                                vericalSpaceMedium,
                                const SubTitleText(title: "CGST"),
                                CustomTextField(
                                  controller: _cgst,
                                  hintText: "",
                                  keyboardType: TextInputType.number,
//  enabled: false, // Auto-filled
                                ),
                                vericalSpaceMedium,
                                const SubTitleText(title: "SGST"),
                                CustomTextField(
                                  controller: _sgst,
                                  hintText: "",
                                  keyboardType: TextInputType.number,
                                  // enabled: false, // Auto-filled
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
                                if (variant['selectedOffer'] == "Yes") ...[
                                  const SubTitleText(title: "Offer Price"),
                                  CustomTextField(
                                    controller: variant['offerPrice'],
                                    hintText: "",
                                    keyboardType: TextInputType.number,
                                  ),
                                  vericalSpaceMedium,
                                ],
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
            bottomNavigationBar: SafeArea(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.w),
                child: CustomButton(
                  title: load
                      ? "Please wait..."
                      : widget.editProduct != null
                          ? "Update Product"
                          : "Save Product",
                  onPressed: _showCalculation,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Map<String, double> calculateFinalPrice({
    required double price,
    required double offerPrice,
    required double gstPercent,
    required double processingFeePercent,
    required bool isOffer,
  }) {
    final sellingPrice = isOffer ? offerPrice : price;

    double cgst = gstPercent / 2;
    double sgst = gstPercent / 2;
    double gstAmount = sellingPrice * gstPercent / 100;

    double processingFeeAmount = sellingPrice * processingFeePercent / 100;

    double finalPrice = sellingPrice + gstAmount + processingFeeAmount;

    double earningAmount = finalPrice - processingFeeAmount;

    return {
      'sellingPrice': sellingPrice,
      'cgst': sellingPrice * cgst / 100,
      'sgst': sellingPrice * sgst / 100,
      'gstAmount': gstAmount,
      'processingFeeAmount': processingFeeAmount,
      'finalPrice': finalPrice,
      'earningAmount': earningAmount
    };
  }
}
