import 'package:bringessesellerapp/config/constant/api_constant.dart';
import 'package:bringessesellerapp/config/constant/contsant.dart';
import 'package:bringessesellerapp/config/constant/sharedpreference_helper.dart';
import 'package:bringessesellerapp/model/request/account_req_model.dart';
import 'package:bringessesellerapp/model/request/payout_prefs_req_model.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/get_account_detail_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/get_account_detail_state.dart';

import 'package:bringessesellerapp/presentation/screen/profile/bloc/payout_account_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/payout_account_state.dart';
import 'package:bringessesellerapp/presentation/widget/custome_appbar.dart';
import 'package:bringessesellerapp/presentation/widget/custome_button.dart';
import 'package:bringessesellerapp/presentation/widget/custome_textfeild.dart';

import 'package:bringessesellerapp/presentation/widget/sub_title.dart';
import 'package:bringessesellerapp/presentation/widget/title_text.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

class PayoutPrefsScreen extends StatefulWidget {
  const PayoutPrefsScreen({super.key});

  @override
  State<PayoutPrefsScreen> createState() => _PayoutPrefsScreenState();
}

class _PayoutPrefsScreenState extends State<PayoutPrefsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _panCardController = TextEditingController();
  final TextEditingController _ifscController = TextEditingController();
  final TextEditingController _street1Controller = TextEditingController();
  final TextEditingController _street2Controller = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();
  late SharedPreferenceHelper sharedPreferenceHelper;
  @override
  void initState() {
    sharedPreferenceHelper = SharedPreferenceHelper();
    sharedPreferenceHelper.init();
    _loadProfile();
    super.initState();
  }

  void _loadProfile() {
    context
        .read<GetAccountDetailCubit>()
        .login(AccountReqModel(sellerId: sharedPreferenceHelper.getSellerId));
  }

  bool loading = false;
  @override
  void dispose() {
    _accountNameController.dispose();
    _accountController.dispose();
    _panCardController.dispose();
    _ifscController.dispose();
    _street1Controller.dispose();
    _street2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _pinCodeController.dispose();
    super.dispose();
  }

  String? validateIFSC(String? value) {
    if (value == null || value.isEmpty) {
      return "IFSC code is required";
    }

    final regex = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');
    if (!regex.hasMatch(value.toUpperCase())) {
      return "Enter a valid IFSC code";
    }

    return null; // valid
  }

  String? validateAccountNumber(String? value) {
    if (value == null || value.isEmpty) {
      return "Account number is required";
    }

    final regex = RegExp(r'^\d+$');
    if (!regex.hasMatch(value)) {
      return "Account number should contain digits only";
    }

    if (value.length < 9 || value.length > 18) {
      return "Account number should be 9 to 18 digits";
    }

    return null; // valid
  }

  String cleanCity(String city) {
    // Keep only letters, numbers, and spaces
    return city.replaceAll(RegExp(r'[^A-Za-z0-9 ]'), '').trim();
  }

  void _saveForm() {
    setState(() {
      loading = true;
    });
    if (_formKey.currentState!.validate()) {
      context.read<PayoutAccountCubit>().registerAccount(PayoutRequestModel(
          accountName: _accountNameController.text,
          accountNumber: _accountController.text,
          city: cleanCity(_cityController.text),
          ifsc: _ifscController.text,
          pancard: _panCardController.text,
          postalCode: _pinCodeController.text,
          sellerId: sharedPreferenceHelper.getSellerId,
          state: _stateController.text,
          street1: _street1Controller.text,
          street2: _street2Controller.text));
      // Fluttertoast.showToast(
      //   msg: "Profile data updated",
      //   backgroundColor: Colors.green,
      //   textColor: Colors.white,
      //   toastLength: Toast.LENGTH_SHORT,
      // );
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: ""),
      body: MultiBlocListener(
        listeners: [
          BlocListener<GetAccountDetailCubit, GetAccountDetailState>(
            listener: (context, state) {
              final data = state.accountDetailModel.sellerDetails;
              if (state.networkStatusEnum == NetworkStatusEnum.loaded &&
                  state.accountDetailModel.status == 'true') {
                // Fluttertoast.showToast(
                //   msg: "Account setup successful",
                //   backgroundColor: Colors.green,
                //   textColor: Colors.white,
                //   toastLength: Toast.LENGTH_SHORT,
                // );
                _accountNameController.text = data!.accountName!;
                _accountController.text = data!.accountNumber.toString();
                _panCardController.text = data.pancard.toString();
                _ifscController.text = data.ifsc!;
                _street1Controller.text = data.street1 ?? "";
                _street2Controller.text = data.street2 ?? "";
                _cityController.text = data.city ?? "";
                _stateController.text = data.state ?? "";
                _countryController.text = data.country ?? "";
                _pinCodeController.text = data.postalCode.toString();
              }
            },
          ),
        ],
        child: BlocConsumer<PayoutAccountCubit, PayoutAccountState>(
          listener: (context, state) {
            if (state.networkStatusEnum == NetworkStatusEnum.loaded &&
                state.accountResponse!.status == 'true') {
              setState(() {
                loading = false;
              });
              context.pop();
              Fluttertoast.showToast(
                msg: state.accountResponse!.message ??
                    "Account setup successful",
                textColor: Colors.white,
                toastLength: Toast.LENGTH_SHORT,
              );
              Fluttertoast.showToast(
                msg: state.accountResponse!.activationStatus ??
                    "Account setup successful",
                textColor: Colors.white,
                toastLength: Toast.LENGTH_SHORT,
              );
            } else if (state.networkStatusEnum == NetworkStatusEnum.failed &&
                state.errorResponse != null) {
              Fluttertoast.showToast(
                msg: state.errorResponse!.message ?? "",
                backgroundColor: Colors.red,
                textColor: Colors.white,
                toastLength: Toast.LENGTH_SHORT,
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(15.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TitleText(title: "Account"),
                      vericalSpaceMedium,
                      const SubTitleText(title: "Account Name"),
                      CustomTextField(
                        controller: _accountNameController,
                        hintText: "Name",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Account name is required';
                          }
                          return null;
                        },
                      ),
                      const SubTitleText(
                        title:
                            "Please enter account holder name exactly on passbook",
                      ),
                      vericalSpaceMedium,
                      const SubTitleText(title: "Account Number"),
                      CustomTextField(
                        controller: _accountController,
                        hintText: "Account number",
                        keyboardType: TextInputType.number,
                        validator: validateAccountNumber,
                      ),
                      const SubTitleText(
                        title:
                            "(We never share this data with others. These details are mandatory for account setup.)",
                      ),
                      vericalSpaceMedium,
                      const SubTitleText(title: "PAN number"),
                      CustomTextField(
                        controller: _panCardController,
                        hintText: "PAN number",
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'PAN card number is required';
                          }
                          return null;
                        },
                      ),
                      const SubTitleText(
                        title:
                            "(We never share this data with others. These details are mandatory for account setup.)",
                      ),
                      vericalSpaceMedium,
                      const SubTitleText(title: "IFSC number"),
                      CustomTextField(
                        controller: _ifscController,
                        hintText: "IFSC number",
                        validator: validateIFSC,
                      ),
                      const SubTitleText(
                        title:
                            "(We never share this data with others. These details are mandatory for account setup.)",
                      ),
                      vericalSpaceMedium,
                      const SubTitleText(title: "Street 1"),
                      CustomTextField(
                        controller: _street1Controller,
                        hintText: "Street 1",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Street 1 is required';
                          }
                          return null;
                        },
                      ),
                      vericalSpaceSmall,
                      const SubTitleText(title: "Street 2"),
                      CustomTextField(
                        controller: _street2Controller,
                        hintText: "Street 2",
                      ),
                      vericalSpaceSmall,
                      const SubTitleText(title: "City"),
                      vericalSpaceSmall,
                      GooglePlaceAutoCompleteTextField(
                        textEditingController: _cityController,
                        googleAPIKey: ApiConstant.kGoogleApiKey,
                        boxDecoration: const BoxDecoration(),
                        inputDecoration: InputDecoration(
                          fillColor: Colors.grey.shade200,
                          hintText: 'City',
                          border: const OutlineInputBorder(),
                        ),
                        debounceTime: 800,
                        itemClick: (Prediction prediction) {
                          setState(() {
                            _cityController.text = prediction.description ?? "";
                            _cityController.selection =
                                TextSelection.fromPosition(
                              TextPosition(offset: _cityController.text.length),
                            );
                          });
                        },
                      ),
                      vericalSpaceSmall,
                      // CustomTextField(
                      //   controller: _cityController,
                      //   hintText: "City",
                      //   validator: (value) {
                      //     if (value == null || value.isEmpty) {
                      //       return 'City is required';
                      //     }
                      //     return null;
                      //   },
                      // ),
                      const SubTitleText(title: "State"),
                      CustomTextField(
                        controller: _stateController,
                        hintText: "State",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'State is required';
                          }
                          return null;
                        },
                      ),
                      vericalSpaceSmall,
                      const SubTitleText(title: "Country"),
                      CustomTextField(
                        controller: _countryController,
                        hintText: "Country",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Country is required';
                          }
                          return null;
                        },
                      ),
                      vericalSpaceSmall,
                      const SubTitleText(title: "Pin code"),
                      CustomTextField(
                        labelText: "Pin Code",
                        controller: _pinCodeController,
                        hintText: "Pin code",
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Pin code is required';
                          }
                          if (value.length != 6) {
                            return 'Enter a valid 6-digit pin code';
                          }
                          return null;
                        },
                      ),
                      verticalSpaceDynamic(40.h),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.w),
        child: CustomButton(
          title: loading != false ? "Please Wait..." : "Save",
          onPressed: loading != false ? () {} : _saveForm,
        ),
      ),
    );
  }
}
