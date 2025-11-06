import 'dart:io';
import 'package:bringessesellerapp/config/constant/api_constant.dart';
import 'package:bringessesellerapp/config/constant/contsant.dart';
import 'package:bringessesellerapp/model/request/menu_creat_req_model.dart';
import 'package:bringessesellerapp/model/request/menu_update_req_model.dart';
import 'package:bringessesellerapp/model/response/menu_list_response_model.dart'
    as list;
import 'package:bringessesellerapp/model/response/store_default_model.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/menu_create_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/menu_create_state.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/menu_update_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/menu_update_state.dart';
import 'package:bringessesellerapp/presentation/widget/custom_card.dart';
import 'package:bringessesellerapp/presentation/widget/custome_appbar.dart';
import 'package:bringessesellerapp/presentation/widget/custome_button.dart';
import 'package:bringessesellerapp/presentation/widget/custome_textfeild.dart';
import 'package:bringessesellerapp/presentation/widget/dotted_container.dart';
import 'package:bringessesellerapp/presentation/widget/sub_title.dart';
import 'package:bringessesellerapp/presentation/widget/title_text.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:bringessesellerapp/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class AddMenuScreen extends StatefulWidget {
  final List<Subcategory>? catogery;
  final String storeId;
  final list.Menu? menu;
  final String? from;

  const AddMenuScreen({
    super.key,
    this.catogery,
    required this.storeId,
    this.menu,
    this.from,
  });

  @override
  State<AddMenuScreen> createState() => _AddMenuScreenState();
}

class _AddMenuScreenState extends State<AddMenuScreen> {
  final TextEditingController _nameController = TextEditingController();
  Subcategory? selectedSubcategory;
  bool isActive = true;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();

    // Pre-fill data if editing
    if (widget.from == "edit" && widget.menu != null) {
      _nameController.text = widget.menu!.name ?? "";
      isActive = (widget.menu!.status == 1);

      // ✅ Prefill subcategory using ID match
      if (widget.menu!.subCategoryId != null && widget.catogery != null) {
        try {
          selectedSubcategory = widget.catogery!.firstWhere(
            (cat) => cat.id == widget.menu!.subCategoryId,
          );
        } catch (e) {
          selectedSubcategory = null; // fallback if not found
        }
      }
    }
  }

  bool load = false;

  /// Pick Image
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  /// Save (Add New Menu)
  void _save() {
    if (_nameController.text.isEmpty || selectedSubcategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload an image")),
      );
      return;
    }
    setState(() {
      load = true;
    });
    final model = MenuCreateReqModel(
      name: _nameController.text,
      image: _selectedImage,
      status: isActive ? 1 : 0,
      subCategoryId: selectedSubcategory!.id,
      storeId: widget.storeId,
    );

    context.read<MenuCreateCubit>().login(model);
  }

  void _update() {
    setState(() {
      load = true;
    });
    final model = MenuUpdateReqModel(
      menuId: widget.menu!.id,
      name: _nameController.text,
      menuImage: _selectedImage,
      existingImage: widget.menu?.image,
      status: isActive ? 1 : 0,
      subCategoryId: selectedSubcategory!.id,
      storeId: widget.storeId,
    );

    context.read<MenuUpdateCubit>().login(model);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.from == "edit";

    return BlocListener<MenuUpdateCubit, MenuUpdateState>(
      listener: (context, state) {
        if (state.networkStatusEnum == NetworkStatusEnum.loaded &&
            state.menuCreateResModel.status == "true") {
          setState(() {
            load = false;
          });
          Navigator.pop(context, true);
          final data = state.menuCreateResModel.message;
          showAppToast(
              message: data ?? "Menu created successfully", isError: false);
          Navigator.pop(context, true);
        }
      },
      child: BlocConsumer<MenuCreateCubit, MenuCreateState>(
        listener: (context, state) {
          if (state.networkStatusEnum == NetworkStatusEnum.loaded &&
              state.menuCreateResModel.status == "true") {
            setState(() {
              load = false;
            });
            final data = state.menuCreateResModel.message;
            Fluttertoast.showToast(
              msg: data ?? "Menu created successfully",
            );
            Navigator.pop(context, true);
          }
          if (state.networkStatusEnum == NetworkStatusEnum.failed) {
            setState(() {
              load = false;
            });
            Fluttertoast.showToast(
              msg: state.menuCreateResModel.message ?? "Something went wrong",
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: CustomAppBar(
              title: isEdit ? "Edit Menu" : "Add Menu",
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ---- Upload Image Section ----
                  CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleText(
                            title: isEdit
                                ? "Update menu image"
                                : "Upload menu image"),
                        vericalSpaceMedium,
                        InkWell(
                          onTap: _pickImage,
                          child: Container(
                            height: 130.h,
                            padding: EdgeInsets.all(10.w),
                            child: DottedContainer(
                              child: _selectedImage != null
                                  ? Image.file(_selectedImage!,
                                      height: 150.h,
                                      width: 1.sw,
                                      fit: BoxFit.cover)
                                  : (widget.menu?.image != null
                                      ? Image.network(
                                          '${ApiConstant.imageUrl}/public/media/menus/${widget.menu!.image}',
                                          fit: BoxFit.cover,
                                          height: 150.h,
                                          width: 1.sw,
                                        )
                                      : const Center(
                                          child: Text("Upload Image"),
                                        )),
                            ),
                          ),
                        ),
                        const SubTitleText(
                          title: "Minimum file size 5MB (JPG and PNG)",
                        ),
                      ],
                    ),
                  ),

                  vericalSpaceMedium,

                  /// ---- Menu Details ----
                  CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SubTitleText(title: "Menu name"),
                        CustomTextField(
                          hintText: "Name",
                          controller: _nameController,
                        ),
                        vericalSpaceMedium,
                        const SubTitleText(title: "Subcategory"),
                        vericalSpaceMedium,
                        DropdownButtonFormField<Subcategory>(
                          value: selectedSubcategory,
                          items: widget.catogery!.map((option) {
                            return DropdownMenuItem<Subcategory>(
                              value: option,
                              child: Text(option.name ?? 'Unknown'),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedSubcategory = value;
                            });
                          },
                          decoration: const InputDecoration(
                            //   labelText: 'Select Subcategory',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        vericalSpaceMedium,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SubTitleText(title: "Status"),
                            Row(
                              children: [
                                Text(
                                  isActive ? "Active" : "Inactive",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: isActive
                                        ? Colors.green
                                        : Colors.redAccent,
                                  ),
                                ),
                                Switch(
                                  value: isActive,
                                  activeColor: Colors.green,
                                  onChanged: (value) {
                                    setState(() {
                                      isActive = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// ---- Bottom Button ----
            bottomNavigationBar: SafeArea(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.w),
                child: CustomButton(
                  title: load ? "Please wait..." : (isEdit ? "Update" : "Save"),
                  onPressed: isEdit ? _update : _save,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
