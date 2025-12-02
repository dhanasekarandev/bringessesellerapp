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
  final String? processingfee;
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
    this.processingfee,
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
  final TextEditingController _return = TextEditingController();
  final TextEditingController _refund = TextEditingController();
  final TextEditingController _foodtype = TextEditingController();
  final TextEditingController _des = TextEditingController();
  final TextEditingController _cat = TextEditingController();
  final TextEditingController _sub = TextEditingController();
  final TextEditingController _stock = TextEditingController();

  List<Map<String, dynamic>> variantList = [];
  final List<String> offerOptions = ['Yes', 'No'];
  File? _productVideo;

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
            final gstValue = v.gst ?? 0; // ✅ FIXED
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
      'gst': TextEditingController(),
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

      // ⬇️ now GST is taken from each variant
      double gstPercent = double.tryParse(variant['gst'].text) ?? 0;

      double processingFeePercent =
          double.tryParse(widget.processingfee.toString()) ?? 0;
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
            if (!isFood)
              Text(
                "CGST (${(gstPercent / 2).toStringAsFixed(1)}%): ₹${result['cgst']!.toStringAsFixed(2)}",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
            if (!isFood)
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
                        _save();
                      },
                      title: widget.editProduct == null
                          ? 'Add product'
                          : "Edit product",
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
      double price = double.tryParse(v['price'].text) ?? 0;
      double offerPrice = double.tryParse(v['offerPrice'].text) ?? 0;
      double gstPercent = double.tryParse(v['gst'].text) ?? 0;

      bool isOffer = v['selectedOffer'] == "Yes";

      double sellingPrice = isOffer ? offerPrice : price;
      double processingFeePercent =
          double.tryParse(widget.processingfee.toString()) ?? 0;
      // GST calculations
      double cgstPercent = gstPercent / 2;
      double sgstPercent = gstPercent / 2;

      double cgstAmount = sellingPrice * (cgstPercent / 100);
      double sgstAmount = sellingPrice * (sgstPercent / 100);

      double totalAmount =
          sellingPrice + cgstAmount + sgstAmount + processingFeePercent;
      print("dsdfsdf$totalAmount");
      return Variant(
        name: v['count'].text,
        price: price,
        offerAvailable: isOffer.toString(),
        offerPrice: offerPrice,
        unit: v['selectedUnit'] ?? "",

        // Percent Values
        gst: gstPercent,
        cGstInPercent: cgstPercent,
        sGstInPercent: sgstPercent,

        // Amount Values
        cGstInAmount: cgstAmount,
        sGstInAmount: sgstAmount,

        // Final Total
        totalAmount: totalAmount,
      );
    }).toList();

    // Separate new image files & existing images
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
            type: _foodtype.text,
            menuId: selectedMenuId,
            variants: variants,
            description: _des.text,
            comboOffer: isCombo,
            quantity: _stock.text,
            productImages: newFiles,
            videoUrl: uploadvideoUrl,
            isRefund: isRefundEnabled ? 'true' : 'false',
            noOfDaysToReturn: _return.text);

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
            isRefund: isRefundEnabled ? 'true' : 'false',
            noOfDaysToReturn: _return.text);

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

  bool isRefundEnabled = false;
  bool isReturn = false;
  bool isFood = false;
  @override
  Widget build(BuildContext context) {
    print("sljdfgbs${widget.processingfee}");
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
                            widget.editProduct!.videoUrl != null &&
                            widget.editProduct!.videoUrl != '')
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
                        const SubTitleText(
                          title: "Name",
                          isMandatory: true,
                        ),
                        CustomTextField(
                          hintText: "Name",
                          controller: _name,
                        ),
                        vericalSpaceMedium,
                        const SubTitleText(
                          title: "Menu",
                          isMandatory: true,
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
                        const SubTitleText(
                          title: "Category name",
                          isMandatory: true,
                        ),
                        CustomTextField(
                          controller: _cat,
                          hintText: "Category name",
                          readOnly: true,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SubTitleText(
                              title: "Food product",
                            ),
                            Switch(
                              value: isFood,
                              onChanged: (value) {
                                setState(() {
                                  isFood = value;
                                });
                              },
                            ),
                          ],
                        ),
                        vericalSpaceMedium,
                        if (isFood)
                          CustomTextField(
                            hintText: "Enter food type",
                            controller: _foodtype,
                          ),
                        vericalSpaceMedium,
                        const SubTitleText(
                          title: "Sub category name",
                          isMandatory: true,
                        ),
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
                        const SubTitleText(
                          title: "Stock Quantity",
                          isMandatory: true,
                        ),
                        CustomTextField(
                            hintText: "",
                            controller: _stock,
                            keyboardType: TextInputType.number),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!isFood)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SubTitleText(
                                    title: "Refund feature",
                                  ),
                                  Switch(
                                    value: isRefundEnabled,
                                    onChanged: (value) {
                                      setState(() {
                                        isRefundEnabled = value;
                                      });
                                    },
                                  ),
                                ],
                              ),

                            // Show text field when refund = true
                            if (isRefundEnabled && !isFood)
                              CustomTextField(
                                hintText: "Enter refund days",
                                controller: _refund,
                              ),
                            vericalSpaceMedium,
                            if (!isFood)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SubTitleText(
                                    title: "Return Policy",
                                  ),
                                  Switch(
                                    value: isReturn,
                                    onChanged: (value) {
                                      setState(() {
                                        isReturn = value;
                                      });
                                    },
                                  ),
                                ],
                              ),

                            // Show text field when return = true
                            if (isReturn && !isFood)
                              CustomTextField(
                                hintText: "Enter return days",
                                controller: _return,
                              ),
                          ],
                        ),
                        vericalSpaceMedium,
                        const SubTitleText(
                          title: "Description",
                          isMandatory: true,
                        ),
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
                            const TitleText(
                              title: "Variants",
                            ),
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
                                const SubTitleText(
                                  title: "Count",
                                  isMandatory: true,
                                ),
                                CustomTextField(
                                  controller: variant['count'],
                                  hintText: "",
                                  keyboardType: TextInputType.number,
                                ),
                                vericalSpaceMedium,
                                const SubTitleText(
                                  title: "Select Unit",
                                  isMandatory: true,
                                ),
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
                                if (!isFood) vericalSpaceMedium,
                                if (!isFood)
                                  const SubTitleText(
                                    title: "GST(%)",
                                    isMandatory: true,
                                  ),
                                if (!isFood)
                                  CustomTextField(
                                    controller: variant['gst'],
                                    hintText: "",
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      double gstValue =
                                          double.tryParse(value) ?? 0;

                                      if (gstValue > 28) {
                                        variant['gstError'] =
                                            "GST cannot be more than 28%";
                                      } else {
                                        variant['gstError'] = null;

                                        double split = gstValue / 2;
                                        variant['cgst']!.text =
                                            split.toStringAsFixed(2);
                                        variant['sgst']!.text =
                                            split.toStringAsFixed(2);
                                      }

                                      setState(() {});
                                    },
                                  ),

// Show error only for this variant
                                if (variant['gstError'] != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      variant['gstError'],
                                      style: const TextStyle(
                                          color: Colors.red, fontSize: 12),
                                    ),
                                  ),

//                                 vericalSpaceMedium,
//                                 const SubTitleText(title: "CGST(%)"),
//                                 CustomTextField(
//                                   controller: _cgst,
//                                   hintText: "",
//                                   keyboardType: TextInputType.number,
// //  enabled: false, // Auto-filled
//                                 ),
//                                 vericalSpaceMedium,
//                                 const SubTitleText(title: "SGST(%)"),
//                                 CustomTextField(
//                                   controller: _sgst,
//                                   hintText: "",
//                                   keyboardType: TextInputType.number,
//                                   // enabled: false, // Auto-filled
//                                 ),
                                vericalSpaceMedium,
                                const SubTitleText(
                                  title: "Price",
                                  isMandatory: true,
                                ),
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
                  onPressed: () {
                    if (_validateForm()) {
                      _showCalculation(); // open bottom sheet
                    }
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  bool _validateForm() {
    // Product basic fields
    if (_name.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Enter product name");
      return false;
    }

    if (_stock.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Enter stock");
      return false;
    }

    if (variantList.isEmpty) {
      Fluttertoast.showToast(msg: "Add at least one variant");
      return false;
    }

    // Validate each variant
    for (var v in variantList) {
      String name = v['count'].text.trim();
      double price = double.tryParse(v['price'].text) ?? 0;
      double offerPrice = double.tryParse(v['offerPrice'].text) ?? 0;
      double gst = double.tryParse(v['gst'].text) ?? 0;

      if (name.isEmpty) {
        Fluttertoast.showToast(msg: "Enter variant name");
        return false;
      }

      if (price <= 0) {
        Fluttertoast.showToast(msg: "Enter valid price for $name");
        return false;
      }

      if (v['selectedOffer'] == "Yes" && offerPrice <= 0) {
        Fluttertoast.showToast(msg: "Enter offer price for $name");
        return false;
      }

      if (offerPrice > price) {
        Fluttertoast.showToast(msg: "Offer price cannot be more than price");
        return false;
      }

      if (gst < 0 || gst > 28) {
        Fluttertoast.showToast(msg: "GST must be between 0% and 28%");
        return false;
      }

      if (v['selectedUnit'] == null || v['selectedUnit'].toString().isEmpty) {
        Fluttertoast.showToast(msg: "Select unit for $name");
        return false;
      }
    }

    // Images must be added (optional)
    if (_productMedia.isEmpty) {
      Fluttertoast.showToast(msg: "Add at least one product image");
      return false;
    }

    return true;
  }

  Map<String, double> calculateFinalPrice({
    required double price,
    required double offerPrice,
    required double gstPercent,
    required double processingFeePercent,
    required bool isOffer,
  }) {
    // Step 1: Determine selling price
    double sellingPrice = isOffer ? offerPrice : price;

    // Step 2: Calculate GST split
    double halfGstPercent = gstPercent / 2;

    double cgst = sellingPrice * (halfGstPercent / 100);
    double sgst = sellingPrice * (halfGstPercent / 100);

    // Step 3: Processing fee
    double processingFeeAmount = sellingPrice * (processingFeePercent / 100);

    // Step 4: Final price (customer pays)
    double finalPrice = sellingPrice + cgst + sgst + processingFeeAmount;

    // Step 5: Earning (your profit)
    double earningAmount = finalPrice - processingFeeAmount;

    return {
      "sellingPrice": sellingPrice,
      "cgst": cgst,
      "sgst": sgst,
      "processingFeeAmount": processingFeeAmount,
      "finalPrice": finalPrice,
      "earningAmount": earningAmount,
    };
  }
}
