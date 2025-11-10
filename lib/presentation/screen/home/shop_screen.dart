import 'dart:io';

import 'package:bringessesellerapp/config/constant/contsant.dart';
import 'package:bringessesellerapp/config/constant/sharedpreference_helper.dart';
import 'package:bringessesellerapp/config/themes.dart';
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
import 'package:bringessesellerapp/presentation/widget/headline_text.dart';
import 'package:bringessesellerapp/presentation/widget/medium_text.dart';
import 'package:bringessesellerapp/presentation/widget/sub_title.dart';
import 'package:bringessesellerapp/presentation/widget/title_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:bringessesellerapp/utils/location_permission_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

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
  double? selectedLat;
  double? selectedLng;
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

  double? _existingLat;
  double? _existingLng;
  String? storeName;
  Future<String?> getFullAddressFromLatLng({
    required double latitude,
    required double longitude,
  }) async {
    try {
      // 🔹 Get placemarks from coordinates
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        // 🔹 Combine all non-empty address parts
        String fullAddress = [
          place.name,
          place.street,
          place.subLocality,
          place.locality,
          place.subAdministrativeArea,
          place.administrativeArea,
          place.postalCode,
          place.country
        ].where((e) => e != null && e.trim().isNotEmpty).join(", ");

        print("📍 Full Address: $fullAddress");
        return fullAddress;
      } else {
        print("⚠️ No address found for given coordinates.");
        return null;
      }
    } catch (e) {
      print("❌ Error getting address: $e");
      return null;
    }
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

    File? newImageFile;
    String? existingImageName;

    if (_selectedImage != null) {
      newImageFile = _selectedImage;
    } else if (_storeImg != null && _storeImg!.isNotEmpty) {
      existingImageName =
          _storeImg!.split('/').last; // send as existing image name
    }

    List<String> existingDocs = [];
    for (var doc in documents) {
      if (doc.containsKey('name') && !doc.containsKey('file')) {
        existingDocs.add(doc['name']!);
      }
    }

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
      image: newImageFile,
      documents: newDocuments,
      lat: (selectedLat ??
              double.tryParse(sharedPreferenceHelper.getSearchLat) ??
              0.0)
          .toString(),
      lon: (selectedLng ??
              double.tryParse(sharedPreferenceHelper.getSearchLng) ??
              0.0)
          .toString(),
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
      lat: (selectedLat ??
              _existingLat ?? // ✅ fallback to old API lat
              double.tryParse(sharedPreferenceHelper.getSearchLat) ??
              0.0)
          .toString(),
      lon: (selectedLng ??
              _existingLng ?? // ✅ fallback to old API lon
              double.tryParse(sharedPreferenceHelper.getSearchLng) ??
              0.0)
          .toString(),
    );
    if (_isDataLoaded) {
      context.read<UpdateStoreCubit>().login(storeUpdate);
    } else {
      context.read<StoreUploadCubit>().login(storeReq);
    }
  }

  final List<String> paymentMethods = [
    "Cash on Delivery",
    "Razorpay",
    "UPI",
    "Credit/Debit Card",
  ];
  String selectedSize = 'Small';
  bool isOwnDelivery = false;
  final List<String> storeSizes = ['Small', 'Medium', 'Large'];
  final Set<String> selectedMethods = {};
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
                    if (data!.lat != null && data.lon != null) {
                      String? address = await getFullAddressFromLatLng(
                        latitude: data.lat!,
                        longitude: data.lon!,
                      );
                      setState(() {
                        storeName = address;
                        _existingLat = data.lat;
                        _existingLng = data.lon;
                      });
                    }
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
                          for (var fileName in data.documents!) {
                            final fileUrl =
                                "https://www.bringesse.com/public/media/stores/$fileName";
                            documents.add({
                              "name": fileName, // actual file name from API
                              "url":
                                  fileUrl, // full URL for downloading/opening
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
                    print(
                        "sd;kbf${sharedPreferenceHelper.getSearchLng}.${sharedPreferenceHelper.getSearchLat}");
                    // await getFullAddressFromLatLng(
                    //     latitude:
                    //         double.parse(sharedPreferenceHelper.getSearchLat),
                    //     longitude:
                    //         double.parse(sharedPreferenceHelper.getSearchLng));
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
                              backgroundColor: Theme.of(context).cardColor,
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
                                print("");
                              });
                            },
                          ),
                          vericalSpaceMedium,
                          const SubTitleText(title: "Store location"),
                          CustomTextField(
                            maxLines: 2,
                            onTap: () async {
                              final result = await context.push('/map');

                              if (result != null && result is Map) {
                                double lat = double.parse(result['lat']);
                                double lng = double.parse(result['lng']);

                                String? address =
                                    await getFullAddressFromLatLng(
                                  latitude: lat,
                                  longitude: lng,
                                );

                                // Save coordinates + address
                                await sharedPreferenceHelper
                                    .saveSearchLat(lat.toString());
                                await sharedPreferenceHelper
                                    .saveSearchLng(lng.toString());

                                setState(() {
                                  selectedLat = lat;
                                  selectedLng = lng;
                                  storeName = address;
                                });
                              }
                            },
                            readOnly: true,
                            controller:
                                TextEditingController(text: storeName ?? ''),
                            hintText: "Location",
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
                          vericalSpaceSmall,
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
                                        // color: _openTime == null
                                        //     ? Colors.grey
                                        //     : Colors.black,
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
                          vericalSpaceSmall,
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
                                        // color: _closeTime == null
                                        //     ? Colors.grey
                                        //     : Colors.black,
                                        ),
                                  ),
                                  const Icon(Icons.access_time,
                                      color: Colors.grey),
                                ],
                              ),
                            ),
                          ),
                          vericalSpaceMedium,
                          const SubTitleText(title: "Select delivery option"),
                          vericalSpaceSmall,
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: paymentMethods.map((method) {
                              final bool isSelected =
                                  selectedMethods.contains(method);
                              return FilterChip(
                                showCheckmark: true,
                                checkmarkColor: Colors.white,
                                label: Text(
                                  method,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                selected: isSelected,
                                selectedColor: AppTheme.primaryColor,
                                backgroundColor: Theme.of(context).cardColor,
                                onSelected: (bool selected) {
                                  setState(() {
                                    if (selected) {
                                      selectedMethods.add(method);
                                    } else {
                                      selectedMethods.remove(method);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ),
                          vericalSpaceMedium,
                          const SubTitleText(title: "Store type"),
                          vericalSpaceSmall,
                          Wrap(
                            spacing: 16,
                            children: storeSizes.map((size) {
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Radio<String>(
                                    value: size,
                                    groupValue: selectedSize,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedSize = value!;
                                      });
                                    },
                                    activeColor: AppTheme.primaryColor,
                                  ),
                                  MediumText(
                                    title: size,
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                          vericalSpaceMedium,
                          Row(
                            children: [
                              const SubTitleText(title: "Own delivery"),
                              const Spacer(),
                              Switch(
                                value: isOwnDelivery,
                                onChanged: (value) {
                                  setState(() {
                                    isOwnDelivery = value;
                                  });
                                },
                                activeColor: Colors.green,
                              ),
                            ],
                          ),
                          vericalSpaceSmall,
                          const SubTitleText(
                            title:
                                '(To manage deliveries, get our Delivery Partner App)',
                          ),
                          if (isOwnDelivery) ...[
                            const SizedBox(height: 8),
                            GestureDetector(
                              child: Center(
                                child: CachedNetworkImage(
                                  imageUrl:
                                      'https://upload.wikimedia.org/wikipedia/commons/2/29/Google_Play_Store_badge_NL_%28New%29_and_Apple_App_Store_badge.png',
                                  height: 50,
                                ),
                              ),
                            ),
                          ],
                          vericalSpaceMedium,
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
                                        _openDocument(
                                          doc["name"] ?? "",
                                        );
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

  Future<void> _openDocument(String fileName) async {
    try {
      // ✅ Construct full URL using your server path
      final url = "https://www.bringesse.com/public/media/stores/$fileName";

      Fluttertoast.showToast(msg: "Opening $fileName...");

      // ✅ Create temp file path
      final dir = await getTemporaryDirectory();
      final filePath = "${dir.path}/$fileName";

      // ✅ Check if file already downloaded
      final file = File(filePath);
      if (file.existsSync()) {
        await OpenFilex.open(file.path);
        return;
      }

      // ✅ Download from URL
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        await OpenFilex.open(file.path);
        Fluttertoast.showToast(msg: "Opened $fileName");
      } else {
        Fluttertoast.showToast(msg: "Failed to download file");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error opening file: $e");
    }
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
