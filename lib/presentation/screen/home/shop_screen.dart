import 'dart:developer';
import 'dart:io';

import 'package:bringessesellerapp/config/constant/sharedpreference_helper.dart';
import 'package:bringessesellerapp/config/themes.dart';
import 'package:bringessesellerapp/model/request/store_req_model.dart';
import 'package:bringessesellerapp/model/request/store_update_req.dart';
import 'package:bringessesellerapp/model/request/subcription_checkout_req_model.dart';
import 'package:bringessesellerapp/model/request/subs_transaction_req_model.dart';

import 'package:bringessesellerapp/model/response/store_default_model.dart';
import 'package:bringessesellerapp/model/response/subcription_checkout_response.dart';
import 'package:bringessesellerapp/model/response/subription_defaults_response_model.dart';
import 'package:bringessesellerapp/presentation/repository/juspay_repo.dart';
import 'package:bringessesellerapp/presentation/repository/razorpay_repo.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/subscription_checkout_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/subscription_checkout_state.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/subscription_default_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/subscription_transaction_cubit.dart';
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
import 'package:bringessesellerapp/utils/toast.dart';

import 'package:flutter/cupertino.dart';
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
import 'package:hypersdkflutter/hypersdkflutter.dart';
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

  // Multi-step form state
  int _currentStep = 0;

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
  TextEditingController _return = TextEditingController();
  TextEditingController _deliverycharge = TextEditingController();
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
          "file": file.path!, // saving path
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
    context.read<SubscriptionDefaultCubit>().login();
  }

  bool storeLoading = true;
  void _loadShopdata() {
    if (sharedPreferenceHelper.getStoreId != 'err')
      context.read<GetStoreCubit>().login();
  }

  bool _isfood = false;
  TimeOfDay? _openTime;
  TimeOfDay? _closeTime;
  String? _storeImg;
  String? _storeId;
  String? _catId;
  String selectedPlan = "Subscription";

  final List<String> plans = ["Subscription", "Partnership"];
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

  bool _isLoading = false;
  String deliveryType = "free";
  List<Category> _cat = [];
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isDataLoaded = false;
  void _save() {
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
        newDocuments.add(File(doc['file']!)); // convert path → File
      }
    }
    print("sdjfbsd${newDocuments}");
    File? newImageFile;
    String? existingImageName;
    setState(() {
      _isLoading = true;
    });
    if (_selectedImage != null) {
      newImageFile = _selectedImage;
    } else if (_storeImg != null && _storeImg!.isNotEmpty) {
      existingImageName = _storeImg!.split('/').last;
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
      deliveryCharge: _deliverycharge.text.trim(),
      deliveryType: deliveryType,
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
      isfood: _isfood,
      lat: (selectedLat ??
              double.tryParse(sharedPreferenceHelper.getSearchLat) ??
              0.0)
          .toString(),
      lon: (selectedLng ??
              double.tryParse(sharedPreferenceHelper.getSearchLng) ??
              0.0)
          .toString(),
      storeType: selectedSize,
      paymentOptions: selectedMethods.toList(),

      // returnPolicy: _return.text
    );
    final storeUpdate = StoreUpdateReq(
      deliveryType: deliveryType,
      deliveryCharge: _deliverycharge.text.trim(),
      sellerId: sharedPreferenceHelper.getSellerId,
      storeId: _storeId,
      isfood: _isfood ? 'true' : 'false',
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
      storeType: selectedSize,
      paymentOptions: selectedMethods.toList(),
      // returnPolicy: _return.text
    );
    if (_isDataLoaded) {
      context.read<UpdateStoreCubit>().login(storeUpdate);
    } else {
      print("saoudfgs");
      context.read<StoreUploadCubit>().login(storeReq);
    }
  }

  String selectedSubPlan = "";
  final List<String> paymentMethods = ["Cash on Delivery", "Online"];
  String selectedSize = 'Small';
  String selectedService = 'Subscription';
  bool isOwnDelivery = false;
  final List<String> storeSizes = ['Small', 'Medium', 'Large', 'Mini'];
  final List<String> servicetype = ['Subscription', 'Partnership'];
  final Set<String> selectedMethods = {};
  final hyperSDKInstance = HyperSDK();
  final List<String> options = [
    "Own Delivery",
    "Courier",
    "Store Pickup",
    "Bringesse Delivery"
  ];
  bool isLoading = false;
  String? selectedplanId;
  int? selectedplanPrice;
  void _checkout({String? subsId, double? subsPrice}) {
    context.read<SubscriptionCheckoutCubit>().login(
        SubscriptionCheckoutReqModel(
            subscriptionId: subsId,
            subscriptionPrice: subsPrice,
            sellerId: sharedPreferenceHelper.getSellerId));
  }

  void _paymentSuccess(
      {String? orderId, String? paymentId, String? signature}) {
    context.read<SubscriptionTransactionCubit>().login(
        SubscriptionTransactionReq(
            orderId: orderId, paymentId: paymentId, signature: signature));
  }

  void _juspaymentSuccess({
    String? storeId,
    String? orderId,
    String? subscriptionId,
    String? sellerId,
  }) {
    context.read<SubscriptionTransactionCubit>().login(
          SubscriptionTransactionReq(
              gateway: 'juspay',
              orderId: orderId,
              sellerId: sellerId,
              paymentId: orderId,
              subscriptionPlanId: subscriptionId,
              storeId: storeId,
              status: 'CHARGED',
              gatewayName: 'Juspay'),
        );
  }

  Future<void> jusPayment(
    BuildContext context,
    SdkPayload? payload,
  ) async {
    final res = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentPageScreen(
          hyperSDK: hyperSDKInstance,
          payload: payload,
        ),
      ),
    );

    if (res != null && res['success'] == true) {
      showAppToast(message: 'Payment Successful');
      log("slkdjfhbskj${selectedplanId},${selectedplanPrice}");
      _juspaymentSuccess(
        orderId: res['orderId'],
        sellerId: sharedPreferenceHelper.getSellerId,
        storeId: sharedPreferenceHelper.getStoreId,
        subscriptionId: selectedplanId,
      );
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    } else {
      print('Payment Failed or Aborted => $res');
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      Future.delayed(Duration(milliseconds: 50), () {
        showAppToast(message: 'Payment Failed');
      });
    }
  }

  List<String> selectedOptions = [];
  // Validate current step before moving to next
  bool _validateStep(int step) {
    switch (step) {
      case 0: // Basic Info
        if (_name.text.isEmpty ||
            _phone.text.isEmpty ||
            selectedOption == null) {
          Fluttertoast.showToast(
            msg: "Please fill all mandatory fields",
            backgroundColor: Colors.red,
            textColor: Colors.white,
            toastLength: Toast.LENGTH_SHORT,
          );
          return false;
        }
        return true;
      case 1: // Location
        if (storeName == null || storeName!.isEmpty) {
          Fluttertoast.showToast(
            msg: "Please select a location",
            backgroundColor: Colors.red,
            textColor: Colors.white,
            toastLength: Toast.LENGTH_SHORT,
          );
          return false;
        }
        return true;
      case 2: // Operating Hours
        if (_openTime == null || _closeTime == null) {
          Fluttertoast.showToast(
            msg: "Please set opening and closing times",
            backgroundColor: Colors.red,
            textColor: Colors.white,
            toastLength: Toast.LENGTH_SHORT,
          );
          return false;
        }
        return true;
      default:
        return true;
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
            BlocListener<SubscriptionCheckoutCubit, SubscriptionCheckoutState>(
              listener: (context, state) {
                if (state.networkStatusEnum == NetworkStatusEnum.loaded &&
                    state.editProfile.statusCode == 200) {
                  if (state.editProfile.gateway == 'Juspay') {
                    final payload = state.editProfile.session!.sdkPayload;
                    jusPayment(context, payload);
                  } else {
                    final paymentRepo = PaymentRepository();

                    paymentRepo.init(
                      onSuccess: (paymentId) {
                        _paymentSuccess(
                            orderId: paymentId.orderId,
                            paymentId: paymentId.paymentId,
                            signature: paymentId.signature);

                        showAppToast(message: "Payment Success: $paymentId");
                      },
                      onError: (response) {
                        setState(() => isLoading = false);
                        showAppToast(
                            message: "Payment Failed: ${response.message}");
                      },
                      onExternalWallet: (response) {},
                    );

                    paymentRepo.openCheckout(
                      key: state.editProfile.key ?? '',
                      amount: ((double.tryParse(selectedplanPrice.toString()) ??
                                  0) *
                              100)
                          .toInt(),
                      name: "Subscription Payment",
                      description: "Subscription Payment",
                      orderId: state.editProfile.orderId,
                      email: "seller@example.com",
                    );
                  }
                }
              },
            ),
            BlocListener<StoreUploadCubit, StoreUploadState>(
              listener: (context, state) {
                if (state.networkStatusEnum == NetworkStatusEnum.loaded) {
                  if (state.storeResponseModel.status == true) {
                    sharedPreferenceHelper
                        .saveStoreId(state.storeResponseModel.result?.storeId);
                    sharedPreferenceHelper.saveCategoryId(
                        state.storeResponseModel.result?.categoryId);
                    context.read<GetStoreCubit>().login();
                    Fluttertoast.showToast(
                      msg: "Store Created Successfully",
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      toastLength: Toast.LENGTH_SHORT,
                    );
                    setState(() {
                      _isLoading = false;
                    });
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
                    setState(() {
                      _isLoading = false;
                    });
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
                  setState(() {
                    storeLoading = true;
                  });
                }
                if (state.networkStatusEnum == NetworkStatusEnum.loading) {
                  setState(() {
                    storeLoading = true;
                  });
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

                    setState(() {
                      _storeId = data.storeId;
                      _catId = data.categoryId;
                      print("sdcsds${data.isfood}");
                      _name.text = data.name ?? '';
                      _isfood = data.isfood == 'true' ? true : false;
                      _phone.text = data.contactNo?.toString() ?? '';
                      selectedOption = data.categoryId;
                      _des.text = data.description ?? "";
                      _deliverycharge.text = data.deliveryCharge.toString();
                      _return.text = data.returnPolicy ?? '';
                      if (data.storeType != null &&
                          data.storeType!.isNotEmpty) {
                        selectedSize = data.storeType!;
                      }
                      if (data.deliveryType != null &&
                          data.deliveryType!.isNotEmpty) {
                        deliveryType = data.deliveryType!;
                      }
                      _packingtime.text = data.packingTime.toString();
                      _packingchrg.text = data.packingCharge.toString();
                      if (data.paymentOptions != null &&
                          data.paymentOptions!.isNotEmpty) {
                        selectedMethods
                            .addAll(List<String>.from(data.paymentOptions!));
                      }
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
                            "url": fileUrl, // full URL for downloading/opening
                            "size": "Unknown",
                            "date": DateTime.now().toString().split(' ')[0],
                          });
                        }
                      }

                      // Handle store image if it exists
                      if (data.image != null && data.image!.isNotEmpty) {
                        // Note: You might want to load the image from URL here
                        // For now, we'll just show that an image exists
                        _storeImg =
                            "https://www.bringesse.com/public/media/stores/logo/${data.image}";
                      }

                      // Note: Other fields like description, packing charge, packing time,
                      // open/close times are not available in the current API response
                      // They would need to be added to the API or stored separately
                    });

                    setState(() {
                      storeLoading = false;
                    });
                  } else {
                    setState(() {
                      storeLoading = false;
                    });
                    Fluttertoast.showToast(
                      msg: "Failed to load store data",
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      toastLength: Toast.LENGTH_SHORT,
                    );
                  }
                } else if (state.networkStatusEnum ==
                    NetworkStatusEnum.failed) {
                  setState(() {
                    storeLoading = false;
                  });
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
              if (state.networkStatusEnum == NetworkStatusEnum.loading) {
                setState(() {
                  storeLoading = true;
                });
              } else if (state.networkStatusEnum == NetworkStatusEnum.loaded) {
                setState(() {
                  storeLoading = false;
                });
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
                setState(() {
                  storeLoading = false;
                });
                Fluttertoast.showToast(
                  msg: "Network error",
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  toastLength: Toast.LENGTH_SHORT,
                );
              }
            },
            builder: (context, state) {
              // Show loading indicator when data is being fetched
              if (state.networkStatusEnum == NetworkStatusEnum.loading ||
                  storeLoading) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CupertinoActivityIndicator(
                        color: AppTheme.primaryColor,
                        radius: 20.r,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        "Loading store information...",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return SingleChildScrollView(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  child: Column(
                    children: [
                      // ========== STEP INDICATOR ==========
                      _buildStepIndicator(),
                      SizedBox(height: 24.h),

                      // ========== FORM CONTENT ==========
                      _buildStepContent(state),

                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }

  // ========== STEP INDICATOR WIDGET ==========
  Widget _buildStepIndicator() {
    const steps = ['Basic Info', 'Location', 'Hours', 'Config', 'Documents'];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(steps.length, (index) {
            final isCompleted = index < _currentStep;
            final isActive = index == _currentStep;

            return Column(
              children: [
                Container(
                  width: 30.w,
                  height: 30.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted || isActive
                        ? AppTheme.primaryColor
                        : Colors.grey.shade300,
                  ),
                  child: Center(
                    child: isCompleted
                        ? Icon(Icons.check, color: Colors.white, size: 20.sp)
                        : Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: isActive
                                  ? Colors.white
                                  : Colors.grey.shade600,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 8.h),
                SizedBox(
                  width: 60.w,
                  child: Text(
                    steps[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                      color: isActive
                          ? AppTheme.primaryColor
                          : Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
        SizedBox(height: 16.h),
        LinearProgressIndicator(
          value: (_currentStep + 1) / 5,
          minHeight: 4.h,
          backgroundColor: Colors.grey.shade300,
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
        ),
      ],
    );
  }

  // ========== STEP CONTENT BUILDER ==========
  Widget _buildStepContent(StoreDefaultState state) {
    switch (_currentStep) {
      case 0:
        return _buildStep1BasicInfo(state);
      case 1:
        return _buildStep2Location();
      case 2:
        return _buildStep3OperatingHours(state);
      case 3:
        return _buildStep4StoreConfig(state);
      case 4:
        return _buildStep5DocumentsAndSubscription(state);
      default:
        return const SizedBox();
    }
  }

  // ========== STEP 1: BASIC INFO ==========
  Widget _buildStep1BasicInfo(StoreDefaultState state) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Store Image
          Center(
            child: CircleAvatar(
              radius: 60.r,
              backgroundColor: AppTheme.primaryColor,
              child: InkWell(
                onTap: () {
                  _pickImage();
                },
                child: CircleAvatar(
                  radius: 57.r,
                  backgroundColor: Theme.of(context).cardColor,
                  backgroundImage: _selectedImage != null
                      ? FileImage(_selectedImage!)
                      : (_storeImg != null && _storeImg!.isNotEmpty
                          ? NetworkImage(_storeImg!)
                          : null),
                  child: _selectedImage == null &&
                          (_storeImg == null || _storeImg!.isEmpty)
                      ? Icon(Icons.store_outlined,
                          color: Colors.grey, size: 35.sp)
                      : null,
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'Basic Information',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryColor,
            ),
          ),
          SizedBox(height: 16.h),
          const SubTitleText(
            title: "Store name",
            isMandatory: true,
          ),
          SizedBox(height: 8.h),
          CustomTextField(
            hintText: "e.g. John's Store",
            controller: _name,
          ),
          SizedBox(height: 16.h),
          const SubTitleText(
            title: "Mobile number",
            isMandatory: true,
          ),
          SizedBox(height: 8.h),
          CustomTextField(
            hintText: "+91 98765 43210",
            controller: _phone,
          ),
          SizedBox(height: 16.h),
          const SubTitleText(
            title: "Store category",
            isMandatory: true,
          ),
          SizedBox(height: 8.h),
          DropdownButtonFormField<String>(
            value: selectedOption,
            hint: const Text("Select category"),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
              });
            },
          ),
          SizedBox(height: 24.h),
          _buildStepNavigation(),
        ],
      ),
    );
  }

  // ========== STEP 2: LOCATION ==========
  Widget _buildStep2Location() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Store Location',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryColor,
            ),
          ),
          SizedBox(height: 16.h),
          const SubTitleText(
            title: "Select your store location",
            isMandatory: true,
          ),
          SizedBox(height: 8.h),
          CustomTextField(
            maxLines: 3,
            onTap: () async {
              final result = await context.push('/map');

              if (result != null && result is Map) {
                double lat = double.parse(result['lat']);
                double lng = double.parse(result['lng']);

                String? address = await getFullAddressFromLatLng(
                  latitude: lat,
                  longitude: lng,
                );

                await sharedPreferenceHelper.saveSearchLat(lat.toString());
                await sharedPreferenceHelper.saveSearchLng(lng.toString());

                setState(() {
                  selectedLat = lat;
                  selectedLng = lng;
                  storeName = address;
                });
              }
            },
            readOnly: true,
            controller: TextEditingController(text: storeName ?? ''),
            hintText: "Tap to select location on map",
          ),
          SizedBox(height: 12.h),
          if (storeName != null && storeName!.isNotEmpty)
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 20.sp),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'Location selected',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(height: 24.h),
          _buildStepNavigation(),
        ],
      ),
    );
  }

  // ========== STEP 3: OPERATING HOURS ==========
  Widget _buildStep3OperatingHours(StoreDefaultState state) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Operating Hours',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryColor,
            ),
          ),
          SizedBox(height: 16.h),
          const SubTitleText(
            title: "Opening time",
            isMandatory: true,
          ),
          SizedBox(height: 8.h),
          InkWell(
            onTap: () => _pickTime(isOpenTime: true),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _openTime == null
                        ? "Select opening time"
                        : _formatTime(_openTime!),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: _openTime == null ? Colors.grey : Colors.black,
                    ),
                  ),
                  Icon(Icons.access_time, color: Colors.grey.shade600),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),
          const SubTitleText(
            title: "Closing time",
            isMandatory: true,
          ),
          SizedBox(height: 8.h),
          InkWell(
            onTap: () => _pickTime(isOpenTime: false),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _closeTime == null
                        ? "Select closing time"
                        : _formatTime(_closeTime!),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: _closeTime == null ? Colors.grey : Colors.black,
                    ),
                  ),
                  Icon(Icons.access_time, color: Colors.grey.shade600),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),
          const SubTitleText(title: "Description"),
          SizedBox(height: 8.h),
          CustomTextField(
            controller: _des,
            maxLines: 3,
            hintText: "Tell customers about your store...",
          ),
          SizedBox(height: 24.h),
          _buildStepNavigation(),
        ],
      ),
    );
  }

  // ========== STEP 4: STORE CONFIG ==========
  Widget _buildStep4StoreConfig(StoreDefaultState state) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Store Configuration',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryColor,
            ),
          ),
          SizedBox(height: 16.h),
          const SubTitleText(title: "Packing charge (₹)"),
          SizedBox(height: 8.h),
          CustomTextField(
            controller: _packingchrg,
            hintText: "e.g. 10",
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 16.h),
          const SubTitleText(title: "Packing time (minutes)"),
          SizedBox(height: 8.h),
          CustomTextField(
            controller: _packingtime,
            hintText: "e.g. 15",
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 16.h),
          const SubTitleText(title: "Store type"),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 12.w,
            runSpacing: 8.h,
            children: (state.storeDefaultModel.storeType != null
                    ? {
                        "small": state.storeDefaultModel.storeType!.small ?? 0,
                        "medium":
                            state.storeDefaultModel.storeType!.medium ?? 0,
                        "large": state.storeDefaultModel.storeType!.large ?? 0,
                        "mini": state.storeDefaultModel.storeType!.mini ?? 0,
                      }
                    : {})
                .entries
                .map((entry) {
              final displayText =
                  entry.value == 0 ? "No restriction" : "${entry.value} km";

              return FilterChip(
                label: Text(
                  "${entry.key.toUpperCase()} ($displayText)",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color:
                        selectedSize == entry.key ? Colors.white : Colors.black,
                  ),
                ),
                selected: selectedSize == entry.key,
                selectedColor: AppTheme.primaryColor,
                backgroundColor: Colors.grey.shade200,
                onSelected: (bool selected) {
                  setState(() {
                    if (selected) selectedSize = entry.key;
                  });
                },
              );
            }).toList(),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SubTitleText(title: "Food Product"),
              Switch(
                value: _isfood,
                onChanged: (value) {
                  setState(() {
                    _isfood = value;
                  });
                },
                activeColor: AppTheme.primaryColor,
              )
            ],
          ),
          SizedBox(height: 16.h),
          const SubTitleText(title: "Payment options"),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: paymentMethods.map((method) {
              final bool isSelected = selectedMethods.contains(method);
              return FilterChip(
                showCheckmark: true,
                checkmarkColor: Colors.white,
                label: Text(
                  method,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontSize: 12.sp,
                  ),
                ),
                selected: isSelected,
                selectedColor: AppTheme.primaryColor,
                backgroundColor: Colors.grey.shade200,
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
          SizedBox(height: 16.h),
          const SubTitleText(title: "Delivery type"),
          SizedBox(height: 12.h),
          RadioListTile(
            title: Text("Free Delivery", style: TextStyle(fontSize: 13.sp)),
            value: "free",
            groupValue: deliveryType,
            contentPadding: EdgeInsets.zero,
            onChanged: (value) {
              setState(() {
                deliveryType = value.toString();
              });
            },
          ),
          RadioListTile(
            title: Text("Paid Delivery", style: TextStyle(fontSize: 13.sp)),
            value: "paid",
            groupValue: deliveryType,
            contentPadding: EdgeInsets.zero,
            onChanged: (value) {
              setState(() {
                deliveryType = value.toString();
              });
            },
          ),
          SizedBox(height: 24.h),
          _buildStepNavigation(),
        ],
      ),
    );
  }

  // ========== STEP 5: DOCUMENTS & SUBSCRIPTION ==========
  Widget _buildStep5DocumentsAndSubscription(StoreDefaultState state) {
    return Column(
      children: [
        CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Documents & Subscription',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryColor,
                ),
              ),
              SizedBox(height: 16.h),
              const SubTitleText(title: "Add supporting documents (PDF)"),
              SizedBox(height: 12.h),
              if (documents.isNotEmpty)
                Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        final doc = documents[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12.w, vertical: 8.h),
                              leading: Icon(Icons.picture_as_pdf,
                                  color: Colors.red, size: 24.sp),
                              title: Text(doc["name"]!,
                                  style: TextStyle(fontSize: 12.sp)),
                              subtitle: Text("${doc["size"]} • ${doc["date"]}",
                                  style: TextStyle(fontSize: 10.sp)),
                              trailing: IconButton(
                                icon: Icon(Icons.delete_outline_outlined,
                                    color: Colors.red, size: 20.sp),
                                onPressed: () => _removeDocument(index),
                              ),
                              onTap: () {
                                _openDocument(doc["name"] ?? "");
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 12.h),
                  ],
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
              SizedBox(height: 20.h),
              Divider(color: Colors.grey.shade300),
              SizedBox(height: 20.h),
              Text(
                'Subscription Plans',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
              SizedBox(height: 12.h),
              subscriptionPlanWidgets(),
            ],
          ),
        ),
        SizedBox(height: 24.h),
        _buildStepNavigationFinal(),
      ],
    );
  }

  // ========== STEP NAVIGATION BUTTONS ==========
  Widget _buildStepNavigation() {
    return Row(
      children: [
        if (_currentStep > 0)
          Expanded(
            child: SizedBox(
              height: 48.h,
              child: CustomOutlineButton(
                title: "Back",
                onPressed: () {
                  setState(() {
                    _currentStep--;
                  });
                },
              ),
            ),
          ),
        if (_currentStep > 0) SizedBox(width: 12.w),
        Expanded(
          child: SizedBox(
            height: 48.h,
            child: CustomButton(
              title: "Next",
              onPressed: () {
                if (_validateStep(_currentStep)) {
                  setState(() {
                    _currentStep++;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  // ========== FINAL NAVIGATION (SUBMIT) ==========
  Widget _buildStepNavigationFinal() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 48.h,
            child: CustomOutlineButton(
              title: "Back",
              onPressed: () {
                setState(() {
                  _currentStep--;
                });
              },
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: SizedBox(
            height: 48.h,
            child: CustomButton(
              isLoading: _isLoading,
              title: _isDataLoaded ? "Update Store" : "Create Store",
              onPressed: () => _save(),
            ),
          ),
        ),
      ],
    );
  }

  Widget subscriptionPlanWidgets() {
    final subscriptionData =
        context.read<SubscriptionDefaultCubit>().state.viewProfile.result;

    if (subscriptionData == null || subscriptionData.isEmpty) {
      return const Text("No subscription plans available");
    }

    // Take only first two plans for display
    final firstTwoPlans = subscriptionData.take(2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SubTitleText(title: "Subscription Plans"),
        const SizedBox(height: 10),

        // ---- FIRST TWO PLANS ----
        Row(
          children: List.generate(firstTwoPlans.length, (index) {
            final plan = firstTwoPlans[index];
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: index == firstTwoPlans.length - 1 ? 0 : 10,
                ),
                child: planCard(plan.name!.toUpperCase(),
                    "₹${plan.price} / ${plan.duration}", subscriptionData),
              ),
            );
          }),
        ),

        const SizedBox(height: 10),

        // ---- SHOW MORE ----
        if (subscriptionData.length > 2)
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {
                showSubscriptionBottomSheet(subscriptionData);
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  "Show more",
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget planCard(String title, String subtitle,
      List<SubscriptionModel>? subscriptionData) {
    return GestureDetector(
      onTap: () {
        showSubscriptionBottomSheet(subscriptionData);
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          //     color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(),
            ),
          ],
        ),
      ),
    );
  }

  void showSubscriptionBottomSheet(List<SubscriptionModel>? plans) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      //backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        String selectedPlanId = "";
        SubscriptionModel? selectedPlan;
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height:
                  MediaQuery.of(context).size.height * 0.65, // <<< FIXED HEIGHT
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  /// Top Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        // color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Choose Subscription Plan",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Scrollable list
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: plans!.map((plan) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedPlanId = plan.id.toString();
                                selectedPlan = plan;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: selectedPlanId == plan.id.toString()
                                      ? (isDark
                                          ? Colors.orangeAccent
                                          : Colors.black) // Selected border
                                      : (isDark
                                          ? Colors.grey.shade700
                                          : Colors.grey.shade300), // Unselected
                                  width: 2,
                                ),
                                // color: Colors.grey.shade100,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          plan.name!.toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          "₹${plan.price} / ${plan.duration}",
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          plan.description ?? "",
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Radio(
                                    value: plan.id.toString(),
                                    groupValue: selectedPlanId,
                                    onChanged: (val) {
                                      setState(() {
                                        selectedPlanId = val!;
                                        selectedPlan = plan;
                                      });
                                    },
                                    //  activeColor: Colors.black,
                                  )
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// Bottom button (never hides)
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        if (selectedPlanId.isEmpty || selectedPlan == null) {
                          showAppToast(message: "Select a plan");
                          return;
                        }

                        selectedplanId = selectedPlanId;
                        selectedplanPrice = selectedPlan!.price;

                        showAppToast(
                            message: "Processing your subscription...");

                        _checkout(
                          subsId: selectedPlanId,
                          subsPrice:
                              double.tryParse(selectedPlan!.price.toString()) ??
                                  0.0,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Select Plan",
                        style: TextStyle(fontSize: 17, color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
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
