import 'dart:io';

import 'package:bringessesellerapp/config/constant/contsant.dart';
import 'package:bringessesellerapp/config/constant/sharedpreference_helper.dart';
import 'package:bringessesellerapp/model/request/store_req_model.dart';
import 'package:bringessesellerapp/model/request/store_update_req.dart';

import 'package:bringessesellerapp/model/response/store_default_model.dart';
import 'package:bringessesellerapp/presentation/screen/shop/bloc/get_store_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/shop/bloc/get_store_state.dart';
import 'package:bringessesellerapp/presentation/screen/shop/bloc/store_default_state.dart';
import 'package:bringessesellerapp/presentation/screen/shop/bloc/store_defaults_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/shop/bloc/store_upload_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/shop/bloc/store_upload_state.dart';
import 'package:bringessesellerapp/presentation/screen/shop/bloc/update_store_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/shop/bloc/update_store_state.dart';
import 'package:bringessesellerapp/presentation/widget/custom_card.dart';
import 'package:bringessesellerapp/presentation/widget/custome_appbar.dart';
import 'package:bringessesellerapp/presentation/widget/custome_button.dart';
import 'package:bringessesellerapp/presentation/widget/custome_outline_button.dart';
import 'package:bringessesellerapp/presentation/widget/custome_textfeild.dart';
import 'package:bringessesellerapp/presentation/widget/sub_title.dart';

import 'package:bringessesellerapp/utils/enums.dart';
import 'package:bringessesellerapp/utils/location_permission_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  late SharedPreferenceHelper sharedPreferenceHelper;
  @override
  void initState() {
    sharedPreferenceHelper = SharedPreferenceHelper();
    sharedPreferenceHelper.init();
    _loadShop();
    _loadShopdata();
    locationPermission();
    super.initState();
  }

  TextEditingController _name = TextEditingController();

  TextEditingController _phone = TextEditingController();
  TextEditingController _des = TextEditingController();
  TextEditingController _packingchrg = TextEditingController();
  TextEditingController _packingtime = TextEditingController();

  String? selectedOption;

  List<Map<String, String>> documents = [];
  Future<void> _pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      setState(() {
        documents.add({
          "name": file.name,
          "size": "${(file.size / (1024 * 1024)).toStringAsFixed(2)} MB",
          "date": DateTime.now().toString().split(' ')[0],
        });
      });
    }
  }

  void _removeDocument(int index) {
    setState(() {
      documents.removeAt(index);
    });
  }

  locationPermission() async {
    bool granted = await LocationPermissionHelper.isLocationGranted();
    if (!granted) {
      await LocationPermissionHelper.requestLocationPermission();
    }
  }

  void _loadShop() {
    context.read<StoreDefaultsCubit>().login();
  }

  void _loadShopdata() {
    context.read<GetStoreCubit>().login();
  }

  TimeOfDay? _openTime;
  TimeOfDay? _closeTime;
  String? _storeImg;
  String? _storeId;
  String? _catId;
  Future<void> _pickTime({required bool isOpenTime}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        if (isOpenTime) {
          _openTime = picked;
        } else {
          _closeTime = picked;
        }
      });
    }
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return TimeOfDay.fromDateTime(dt).format(context);
  }

  String? storeName;
  Future<String?> getCityFromLatLng(
      {double? latitude, double? longitude}) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude!, longitude!);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        storeName = place.locality ??
            place.subAdministrativeArea ??
            place.administrativeArea;

        print("Store city name: $storeName");
      }
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }

  List<Category> _cat = [];
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isDataLoaded = false;
  void _save() {
    // Validate mandatory fields
    if (_name.text.isEmpty || _phone.text.isEmpty || selectedOption == null) {
      Fluttertoast.showToast(
        msg: "Please fill all mandatory fields",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    }
    String? _formatTime(TimeOfDay? time) {
      if (time == null) return '';
      final hour = time.hour.toString().padLeft(2, '0');
      final minute = time.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    }

    // Build list of new document files if any
    List<File> newDocuments = [];
    for (var doc in documents) {
      if (doc.containsKey('file') && doc['file'] != null) {
        newDocuments.add(doc['file'] as File);
      }
    }

    // Determine image to send: new selected image or keep existing
    File? newImageFile;
    String? existingImageName;

    if (_selectedImage != null) {
      newImageFile = _selectedImage;
    } else if (_storeImg != null && _storeImg!.isNotEmpty) {
      existingImageName =
          _storeImg!.split('/').last; // send as existing image name
    }

    // Prepare list of existing document names
    List<String> existingDocs = [];
    for (var doc in documents) {
      if (doc.containsKey('name') && !doc.containsKey('file')) {
        existingDocs.add(doc['name']!);
      }
    }

    // Create StoreReqModel for update or new
    final storeReq = StoreReqModel(
      sellerId: sharedPreferenceHelper.getSellerId,
      storeId: _storeId,
      name: _name.text.trim(),
      contactNo: _phone.text.trim(),
      categoryId: selectedOption ?? _catId,
      description: _des.text.trim(),
      packingcharge: _packingchrg.text.trim(),
      packingtime: _packingtime.text.trim(),
      opentime: _formatTime(_openTime),
      closetime: _formatTime(_closeTime),
      image: newImageFile, // new image file if selected

      documents: newDocuments, // new documents to upload

      lat: '31.9876', // replace with real coordinates
      lon: '75.1234', // replace with real coordinates
    );
    final storeUpdate = StoreUpdateReq(
      sellerId: sharedPreferenceHelper.getSellerId,
      storeId: _storeId,
      name: _name.text.trim(),
      contactNo: _phone.text.trim(),
      categoryId: selectedOption ?? _catId,
      description: _des.text.trim(),
      packingcharge: _packingchrg.text.trim(),
      packingtime: _packingtime.text.trim(),
      opentime: _formatTime(_openTime),
      closetime: _formatTime(_closeTime),
      image: newImageFile,
      storeImage: existingImageName,
      documents: newDocuments,
      storeDocuments: existingDocs,
      lat: '31.9876',
      lon: '75.1234',
    );
    if (_isDataLoaded) {
      // Edit shop
      context.read<UpdateStoreCubit>().login(storeUpdate);
    } else {
      // Create new shop
      context.read<StoreUploadCubit>().login(storeReq);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(
          title: 'Shop Information',
          showLeading: false,
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<StoreUploadCubit, StoreUploadState>(
              listener: (context, state) {
                if (state.networkStatusEnum == NetworkStatusEnum.loaded) {
                  if (state.storeResponseModel.status == true) {
                    Fluttertoast.showToast(
                      msg: "Store Created Successfully",
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      toastLength: Toast.LENGTH_SHORT,
                    );
                  } else {
                    Fluttertoast.showToast(
                      msg: "Store creation failed",
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      toastLength: Toast.LENGTH_SHORT,
                    );
                  }
                } else if (state.networkStatusEnum ==
                    NetworkStatusEnum.failed) {
                  Fluttertoast.showToast(
                    msg: "Network error",
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    toastLength: Toast.LENGTH_SHORT,
                  );
                }
              },
            ),
            BlocListener<UpdateStoreCubit, UpdateStoreState>(
              listener: (context, state) {
                if (state.networkStatusEnum == NetworkStatusEnum.loaded) {
                  if (state.editStore.status == true) {
                    Fluttertoast.showToast(
                      msg: "Store Upodated Successfully",
                      textColor: Colors.white,
                      toastLength: Toast.LENGTH_SHORT,
                    );
                  } else {
                    Fluttertoast.showToast(
                      msg: "Store creation failed",
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      toastLength: Toast.LENGTH_SHORT,
                    );
                  }
                } else if (state.networkStatusEnum ==
                    NetworkStatusEnum.failed) {
                  Fluttertoast.showToast(
                    msg: "Network error",
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    toastLength: Toast.LENGTH_SHORT,
                  );
                }
              },
            ),
            BlocListener<GetStoreCubit, GetStoreState>(
              listener: (context, state) async {
                if (state.networkStatusEnum == NetworkStatusEnum.initial) {
                  CircularProgressIndicator();
                }
                if (state.networkStatusEnum == NetworkStatusEnum.loaded) {
                  if (state.getStoreModel.status == 'true') {
                    final data = state.getStoreModel.result;
                    sharedPreferenceHelper
                        .saveStoreId(state.getStoreModel.result?.storeId);
                    sharedPreferenceHelper
                        .saveCategoryId(state.getStoreModel.result?.categoryId);
                    sharedPreferenceHelper.saveCategoryName(
                        state.getStoreModel.result?.categoryName);
                    String storeId = sharedPreferenceHelper.getStoreId;
                    String catId = sharedPreferenceHelper.getCatId;
                    String name = sharedPreferenceHelper.getcatName;

                    print("StoreID---->${storeId}");
                    print("CategoryId---->${catId}");
                    print("CategoryName---->${name}");

                    if (data != null) {
                      setState(() {
                        _storeId = data!.storeId;
                        _catId = data!.categoryId;
                        print("${data.image}");
                        _name.text = data.name ?? '';
                        _phone.text = data.contactNo?.toString() ?? '';
                        selectedOption = data.categoryId;
                        _des.text = data.description ?? "";
                        _packingtime.text = data.packingTime.toString();
                        _packingchrg.text = data.packingCharge.toString();
                        if (data.openingTime != null &&
                            data.openingTime!.isNotEmpty) {
                          final openParts = data.openingTime!.split(':');
                          _openTime = TimeOfDay(
                            hour: int.parse(openParts[0]),
                            minute: int.parse(openParts[1]),
                          );
                        }

                        if (data.closingTime != null &&
                            data.closingTime!.isNotEmpty) {
                          final closeParts = data.closingTime!.split(':');
                          _closeTime = TimeOfDay(
                            hour: int.parse(closeParts[0]),
                            minute: int.parse(closeParts[1]),
                          );
                        }

                        _isDataLoaded = true;

                        // Handle documents if they exist
                        if (data.documents != null &&
                            data.documents!.isNotEmpty) {
                          documents.clear();
                          for (var _ in data.documents!) {
                            documents.add({
                              "name": "Document",
                              "size": "Unknown",
                              "date": DateTime.now().toString().split(' ')[0],
                            });
                          }
                        }

                        // Handle store image if it exists
                        if (data.image != null && data.image!.isNotEmpty) {
                          // Note: You might want to load the image from URL here
                          // For now, we'll just show that an image exists
                          setState(() {
                            _storeImg =
                                "https://www.bringesse.com/public/media/stores/logo/${data.image}";
                          });
                        }

                        // Note: Other fields like description, packing charge, packing time,
                        // open/close times are not available in the current API response
                        // They would need to be added to the API or stored separately
                      });
                    }
                    // await getCityFromLatLng(
                    //     latitude:
                    //         double.parse(sharedPreferenceHelper.getcurrentLat),
                    //     longitude:
                    //         double.parse(sharedPreferenceHelper.getcurrentLng));
                  } else {
                    Fluttertoast.showToast(
                      msg: "Failed to load store data",
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      toastLength: Toast.LENGTH_SHORT,
                    );
                  }
                } else if (state.networkStatusEnum ==
                    NetworkStatusEnum.failed) {
                  Fluttertoast.showToast(
                    msg: "Network error while loading store data",
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    toastLength: Toast.LENGTH_SHORT,
                  );
                }
              },
            ),
          ],
          child: BlocConsumer<StoreDefaultsCubit, StoreDefaultState>(
            listener: (context, state) {
              if (state.networkStatusEnum == NetworkStatusEnum.loaded) {
                if (state.storeDefaultModel.status == 'true') {
                  _cat = state.storeDefaultModel.result!.categories!;
                } else {
                  Fluttertoast.showToast(
                    msg: "Something went wrong",
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    toastLength: Toast.LENGTH_SHORT,
                  );
                }
              } else if (state.networkStatusEnum == NetworkStatusEnum.failed) {
                Fluttertoast.showToast(
                  msg: "Network error",
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  toastLength: Toast.LENGTH_SHORT,
                );
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Show data loaded indicator
                    // if (_isDataLoaded)
                    //   Container(
                    //     margin: EdgeInsets.all(8.w),
                    //     padding: EdgeInsets.all(12.w),
                    //     decoration: BoxDecoration(
                    //       color: Colors.green.shade50,
                    //       borderRadius: BorderRadius.circular(8.r),
                    //       border: Border.all(color: Colors.green.shade200),
                    //     ),
                    //     child: Row(
                    //       children: [
                    //         Icon(Icons.check_circle, color: Colors.green, size: 20.sp),
                    //         SizedBox(width: 8.w),
                    //         Text(
                    //           "Store data loaded successfully",
                    //           style: TextStyle(
                    //             color: Colors.green.shade700,
                    //             fontWeight: FontWeight.w500,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    CustomCard(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          vericalSpaceSmall,
                          InkWell(
                            onTap: () {
                              _pickImage();
                            },
                            child: Center(
                                child: CircleAvatar(
                              radius: 60.r,
                              backgroundColor: Colors.grey.shade200,
                              backgroundImage: _selectedImage != null
                                  ? FileImage(_selectedImage!)
                                  : (_storeImg != null && _storeImg!.isNotEmpty
                                      ? NetworkImage(_storeImg!)
                                      : null),
                              child: _selectedImage == null &&
                                      (_storeImg == null || _storeImg!.isEmpty)
                                  ? Icon(
                                      Icons.person_2_outlined,
                                      color: Colors.grey,
                                      size: 40.sp,
                                    )
                                  : null,
                            )),
                          ),
                          vericalSpaceMedium,
                          const SubTitleText(title: "Store name"),
                          CustomTextField(
                            hintText: "Store name",
                            controller: _name,
                          ),
                          vericalSpaceMedium,
                          const SubTitleText(title: "Mobile number"),
                          CustomTextField(
                            hintText: "Mobile number",
                            controller: _phone,
                          ),
                          vericalSpaceMedium,
                          const SubTitleText(title: "Store category"),
                          vericalSpaceMedium,
                          DropdownButtonFormField<String>(
                            value: selectedOption,
                            hint: const Text("Store category"),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                            ),
                            items: _cat.map((option) {
                              return DropdownMenuItem(
                                value: option.id,
                                child: Text(option.name ?? ""),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedOption = value;
                                print("//");
                              });
                            },
                          ),
                          vericalSpaceMedium,
                          const SubTitleText(title: "Store location"),
                          CustomTextField(
                            onTap: () {
                              context.push('/map');
                            },
                            readOnly: true,
                            controller:
                                TextEditingController(text: storeName ?? ''),
                            onChanged: (value) {},
                            hintText: "location",
                          ),
                          vericalSpaceMedium,
                          const SubTitleText(title: "Store description"),
                          CustomTextField(
                            controller: _des,
                            maxLines: 5,
                            hintText: "description",
                          ),
                          vericalSpaceMedium,
                          const SubTitleText(title: "Packing charge"),
                          CustomTextField(
                            controller: _packingchrg,
                            hintText: "packing charge",
                          ),
                          vericalSpaceMedium,
                          const SubTitleText(title: "packing time"),
                          CustomTextField(
                            controller: _packingtime,
                            hintText: "packing time",
                          ),
                          vericalSpaceMedium,
                          const SubTitleText(title: "Shop opening time"),
                          InkWell(
                            onTap: () => _pickTime(isOpenTime: true),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 14),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _openTime == null
                                        ? "Select open time"
                                        : _formatTime(_openTime!),
                                    style: TextStyle(
                                      color: _openTime == null
                                          ? Colors.grey
                                          : Colors.black,
                                    ),
                                  ),
                                  const Icon(Icons.access_time,
                                      color: Colors.grey),
                                ],
                              ),
                            ),
                          ),
                          vericalSpaceMedium,
                          const SubTitleText(title: "Shop close time"),
                          InkWell(
                            onTap: () => _pickTime(isOpenTime: false),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 14),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _closeTime == null
                                        ? "Select close time"
                                        : _formatTime(_closeTime!),
                                    style: TextStyle(
                                      color: _closeTime == null
                                          ? Colors.grey
                                          : Colors.black,
                                    ),
                                  ),
                                  const Icon(Icons.access_time,
                                      color: Colors.grey),
                                ],
                              ),
                            ),
                          ),
                          const SubTitleText(title: "Add document"),
                          vericalSpaceMedium,
                          if (documents.isNotEmpty)
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: documents.length,
                              itemBuilder: (context, index) {
                                final doc = documents[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: CustomCard(
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
                                      leading: const Icon(Icons.picture_as_pdf,
                                          color: Colors.red),
                                      title: Text(doc["name"]!),
                                      subtitle: Text(
                                          "${doc["size"]} • ${doc["date"]}"),
                                      trailing: IconButton(
                                        icon: const Icon(
                                            Icons.delete_outline_outlined,
                                            color: Colors.red),
                                        onPressed: () => _removeDocument(index),
                                      ),
                                      onTap: () {
                                        // Optional: Open PDF file
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          SizedBox(
                            width: double.infinity,
                            child: CustomOutlineButton(
                              icon: Icons.add_circle_outline_sharp,
                              title: "Add document",
                              onPressed: () {
                                _pickPdf();
                              },
                            ),
                          ),
                          vericalSpaceMedium,
                          SizedBox(
                            width: double.infinity,
                            child: CustomButton(
                              title: _isDataLoaded
                                  ? "Update Store"
                                  : "Create Store",
                              onPressed: () => _save(),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ));
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile = await _picker.pickImage(
                      source: ImageSource.camera, imageQuality: 80);
                  if (pickedFile != null) {
                    setState(() {
                      _selectedImage = File(pickedFile.path);
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile = await _picker.pickImage(
                      source: ImageSource.gallery, imageQuality: 80);
                  if (pickedFile != null) {
                    setState(() {
                      _selectedImage = File(pickedFile.path);
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
