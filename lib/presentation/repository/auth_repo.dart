import 'dart:developer';

import 'package:bringessesellerapp/config/constant/api_constant.dart';
import 'package:bringessesellerapp/config/constant/sharedpreference_helper.dart';
import 'package:bringessesellerapp/model/edit_profile_model.dart';
import 'package:bringessesellerapp/model/request/account_req_model.dart';
import 'package:bringessesellerapp/model/request/category_id_req_model.dart';
import 'package:bringessesellerapp/model/request/change_password_req_model.dart';
import 'package:bringessesellerapp/model/request/edit_profile_req_model.dart';
import 'package:bringessesellerapp/model/request/login_req_model.dart';
import 'package:bringessesellerapp/model/request/menu_creat_req_model.dart';
import 'package:bringessesellerapp/model/request/menu_update_req_model.dart';
import 'package:bringessesellerapp/model/request/notification_req_model.dart';
import 'package:bringessesellerapp/model/request/payout_prefs_req_model.dart';
import 'package:bringessesellerapp/model/request/product_req_model.dart';
import 'package:bringessesellerapp/model/request/productlist_req_model.dart';
import 'package:bringessesellerapp/model/request/promotion_checkout_req_model.dart';
import 'package:bringessesellerapp/model/request/promotion_req_model.dart';
import 'package:bringessesellerapp/model/request/send_otp_req_model.dart';
import 'package:bringessesellerapp/model/request/store_id_reqmodel.dart';
import 'package:bringessesellerapp/model/request/store_req_model.dart';
import 'package:bringessesellerapp/model/request/store_update_req.dart';
import 'package:bringessesellerapp/model/request/subcription_checkout_req_model.dart';
import 'package:bringessesellerapp/model/request/transaction_request_model.dart';
import 'package:bringessesellerapp/model/request/verify_otp_req_model.dart';
import 'package:bringessesellerapp/model/response/account_detail_model.dart';
import 'package:bringessesellerapp/model/response/change_password_model.dart';
import 'package:bringessesellerapp/model/response/dashboard_model.dart';
import 'package:bringessesellerapp/model/response/get_sore_response_model.dart';

import 'package:bringessesellerapp/model/response/login_model.dart';
import 'package:bringessesellerapp/model/response/logout_response_model.dart';
import 'package:bringessesellerapp/model/response/menu_create_res_model.dart';
import 'package:bringessesellerapp/model/response/menu_list_response_model.dart';
import 'package:bringessesellerapp/model/response/notification_model.dart';
import 'package:bringessesellerapp/model/response/payou_error_response_model.dart';
import 'package:bringessesellerapp/model/response/payout_response_model.dart';
import 'package:bringessesellerapp/model/response/product_list_response_model.dart';
import 'package:bringessesellerapp/model/response/promotion_checkout_response_model.dart';
import 'package:bringessesellerapp/model/response/promotion_create_response.dart';
import 'package:bringessesellerapp/model/response/promotion_predata_response_model.dart';
import 'package:bringessesellerapp/model/response/send_otp_response_model.dart';
import 'package:bringessesellerapp/model/response/store_default_model.dart';
import 'package:bringessesellerapp/model/response/store_upload_model.dart';
import 'package:bringessesellerapp/model/response/subcription_checkout_response.dart';
import 'package:bringessesellerapp/model/response/subription_defaults_response_model.dart';
import 'package:bringessesellerapp/model/response/transaction_response_model.dart';
import 'package:bringessesellerapp/model/response/verify_otp_response_model.dart';
import 'package:bringessesellerapp/model/response/view_profile_model.dart';
import 'package:bringessesellerapp/model/response/view_transaction_response_model.dart';

import 'package:bringessesellerapp/presentation/service/api_service.dart';
import 'package:dio/dio.dart';

class AuthRepository {
  final Dio _dio = Dio();
  final ApiService apiService;
  SharedPreferenceHelper sharedPreferenceHelper = SharedPreferenceHelper();
  AuthRepository(this.apiService);

  // Future<dynamic> registerUser(SignupRequestModel? signupreqModel) async {
  //   try {
  //     print("saaafad${signupreqModel!.email}");
  //     var response =
  //         await apiService.post(ApiConstant.userRegister, signupreqModel);
  //     print("sldfnbsj${response.statusCode}");
  //     if (response.statusCode == 200) {
  //       var responseData = response.data;
  //       log("sdsdfsdf$responseData");
  //       if (responseData['status'] == "true") {
  //         return (
  //           true,
  //           responseData['message'].toString(),
  //           RegisterModel.fromJson(responseData)
  //         );
  //       } else if (responseData['text'] == "Error") {
  //         return (
  //           true,
  //           responseData['message'].toString(),
  //           RegisterModel.fromJson(responseData)
  //         );
  //       }
  //     } else {
  //       // Handle other status codes
  //       print('Unexpected status code: ${response.statusCode}');
  //       return (false, "Unexpected error", RegisterModel());
  //     }
  //   } catch (e) {
  //     print('Exception occurred: $e');
  //     return (false, "Network error", RegisterModel());
  //   }
  // }
  Future<dynamic> validateUserLogin(LoginRequestModel loginRequestModel) async {
    try {
      var response = await apiService.post(
          ApiConstant.userLogin, loginRequestModel, false);

      if (response.data['status_code'] == 200) {
        print("asldfnd${response.data}");
        var responseData = response.data;
        return (true, LoginModel.fromJson(responseData));
      } else {
        print('Unexpected status code: ${response.data}');
        return (
          false,
          LoginModel(message: response.data['message'], status: 'false')
        );
      }
    } catch (e, stacktrace) {
      print('Exception occurred: $e');
      print('Stacktrace${stacktrace}');
      return (false, LoginModel());
    }
  }

  Future<dynamic> validateUserViewProfile() async {
    try {
      final sellerId = sharedPreferenceHelper?.getSellerId;
      print("sldfkns$sellerId");
      var response =
          await apiService.get(ApiConstant.userViewProfile(sellerId!), true);
      if (response.data['status_code'] == 200) {
        log("ProfileViewData:${response.data}");
        var responseData = response.data;
        return (true, ViewProfileModel.fromJson(responseData));
      } else {
        // Handle other status codes
        print('Unexpected status code: ${response.statusCode}');
        return (false, ViewProfileModel());
      }
    } catch (e, stacktrace) {
      print('Exception occurred: $e');
      print('Stacktrace${stacktrace}');
      return (false, ViewProfileModel());
    }
  }

  Future<dynamic> subcriptionDefaults() async {
    try {
      var response = await apiService.get(ApiConstant.subscriptionPlan, false);
      if (response.data['status_code'] == 200) {
        log("Subcrition defaults:${response.data}");
        var responseData = response.data;
        return (true, SubscriptionResponseModel.fromJson(responseData));
      } else {
        // Handle other status codes
        print('Unexpected status code: ${response.statusCode}');
        return (false, SubscriptionResponseModel());
      }
    } catch (e, stacktrace) {
      print('Exception occurred: $e');
      print('Stacktrace${stacktrace}');
      return (false, SubscriptionResponseModel());
    }
  }

  Future<dynamic> getAccountDetails(
      AccountReqModel editProfileRequestModel) async {
    try {
      var response = await apiService.post(
          ApiConstant.getpayoutAccount, editProfileRequestModel, false);

      if (response.data['status'] == "true") {
        print("dnjjjjj${response.data}");

        var responseData = response.data;
        return (true, AccountDetailModel.fromJson(responseData));
      } else {
        // Handle other status codes
        print('Unexpected status code: ${response.statusCode}');
        return (false, AccountDetailModel());
      }
    } catch (e, stacktrace) {
      print('Exception occurred: $e');
      print('Stacktrace${stacktrace}');
      return (false, AccountDetailModel());
    }
  }

  Future<dynamic> getDashboarddata() async {
    try {
      final storeId = sharedPreferenceHelper?.getStoreId;
      print("dfghbskf$storeId");
      var response =
          await apiService.get(ApiConstant.dashboardreq(storeId!), false);
      if (response.statusCode == 200) {
        log("Dashboard Data:${response.data}");
        var responseData = response.data;
        return (true, DashboardModel.fromJson(responseData));
      } else {
        print('Unexpected status code: ${response.statusCode}');
        return (false, DashboardModel());
      }
    } catch (e, stacktrace) {
      print('Exception occurred: $e');
      print('Stacktrace${stacktrace}');
      return (false, DashboardModel());
    }
  }

  Future<dynamic> validateUserEditProfile(
      EditProfileRequestModel editProfileRequestModel) async {
    try {
      print("Editreq:${editProfileRequestModel}");
      var response = await apiService.patch(
          ApiConstant.userEditProfile, editProfileRequestModel, false);
      log(" asda${response}");
      if (response.data['status_code'] == 200) {
        var responseData = response.data;
        return (true, EditProfileModel.fromJson(responseData));
      } else {
        // Handle other status codes
        print('Unexpected status code: ${response.statusCode}');
        return (false, EditProfileModel());
      }
    } catch (e, stacktrace) {
      print('Exception occurred: $e');
      print('Stacktrace${stacktrace}');
      return (false, EditProfileModel());
    }
  }

  Future<dynamic> userchangePassword(
      ChangePasswordReqModel changepasswordreqmodel) async {
    try {
      var response = await apiService.patch(
          ApiConstant.changePassword, changepasswordreqmodel, true);
      if (response.statusCode == 200) {
        var responseData = response.data;
        return (true, ChangePasswordModel.fromJson(responseData));
      } else {
        // Handle other status codes
        print('Unexpected status code: ${response.statusCode}');
        return (false, ChangePasswordModel());
      }
    } catch (e, stacktrace) {
      print('Exception occurred: $e');
      print('Stacktrace${stacktrace}');
      return (false, ChangePasswordModel());
    }
  }

  Future<dynamic> verifyOTP(VerifyOtpReqModel verifyOtpModel) async {
    try {
      var response =
          await apiService.post(ApiConstant.verifyOtp, verifyOtpModel, false);
      if (response.statusCode == 200) {
        var responseData = response.data;
        return (true, VerifyOtpResponseModel.fromJson(responseData));
      } else {
        // Handle other status codes
        print('Unexpected status code: ${response.statusCode}');
        return (false, VerifyOtpResponseModel());
      }
    } catch (e, stacktrace) {
      print('Exception occurred: $e');
      print('Stacktrace${stacktrace}');
      return (false, VerifyOtpResponseModel());
    }
  }

  Future<dynamic> sendOTP(SendOtpReqModel verifyOtpModel) async {
    try {
      var response =
          await apiService.post(ApiConstant.sendOtp, verifyOtpModel, false);
      if (response.statusCode == 200) {
        var responseData = response.data;
        return (true, SendOtpResModel.fromJson(responseData));
      } else {
        // Handle other status codes
        print('Unexpected status code: ${response.statusCode}');
        return (
          false,
          SendOtpResModel(
            message: response.data['message'],
            status: false,
          )
        );
      }
    } catch (e, stacktrace) {
      print('Exception occurred: $e');
      print('Stacktrace${stacktrace}');
      return (false, SendOtpResModel());
    }
  }

  Future<dynamic> storeDefaults() async {
    try {
      var response =
          await apiService.post(ApiConstant.storedefaults, {}, false);
      print("asldfnd${response.data}");
      if (response.data['status_code'] == 200) {
        var responseData = response.data;
        return (true, StoreDefaultModel.fromJson(responseData));
      } else {
        // Handle other status codes
        print('Unexpected status code: ${response.data['status_code']}');
        return (false, StoreDefaultModel());
      }
    } catch (e, stacktrace) {
      print('Exception occurred: $e');
      print('Stacktrace${stacktrace}');
      return (false, StoreDefaultModel());
    }
  }

  Future<dynamic> promotionPre() async {
    try {
      var response = await apiService.get(ApiConstant.promotionPre, false);
      print("asldfnd${response.data}");
      if (response.statusCode == 200) {
        var responseData = response.data;
        return (true, PromotionPredataResponseModel.fromJson(responseData));
      } else {
        // Handle other status codes
        print('Unexpected status code: ${response.data['status_code']}');
        return (false, PromotionPredataResponseModel());
      }
    } catch (e, stacktrace) {
      print('Exception occurred: $e');
      print('Stacktrace${stacktrace}');
      return (false, PromotionPredataResponseModel());
    }
  }

  Future<dynamic> getStoreDetails() async {
    try {
      final storeId = sharedPreferenceHelper?.getStoreId;
      var response =
          await apiService.get(ApiConstant.storeget(storeId!), false);
      print("dfsdfsdfsdfs${response.data}");
      if (response.data['status_code'] == 200) {
        var responseData = response.data;
        print("sdlkjsjnj$responseData");
        return (true, GetStoreModel.fromJson(responseData));
      } else {
        print('Unexpected status code: ${response.data['status_code']}');
        return (false, GetStoreModel());
      }
    } catch (e, stacktrace) {
      print('Exception occurred: $e');
      print('Stacktrace${stacktrace}');
      return (false, GetStoreModel());
    }
  }

  Future<dynamic> subscriptionCheckout(
      SubscriptionCheckoutReqModel editProfileRequestModel) async {
    try {
      print("Editreq:${editProfileRequestModel}");
      var response = await apiService.post(
          ApiConstant.subscriptionCheckout, editProfileRequestModel, false);
      log("${response}");
      if (response.data['status_code'] == 200) {
        var responseData = response.data;
        return (true, SubscriptionCheckoutResponse.fromJson(responseData));
      } else {
        // Handle other status codes
        print('Unexpected status code: ${response.statusCode}');
        return (false, SubscriptionCheckoutResponse());
      }
    } catch (e, stacktrace) {
      print('Exception occurred: $e');
      print('Stacktrace${stacktrace}');
      return (false, SubscriptionCheckoutResponse());
    }
  }

  Future<dynamic> notificationList(
      NotificationReqModel notificationReqModel) async {
    try {
      print("Editreq:${notificationReqModel}");
      var response = await apiService.post(
          ApiConstant.notificationlist, notificationReqModel, false);
      log(" asda${response}");
      if (response.data['status_code'] == 200) {
        var responseData = response.data;
        return (true, NotificationResponseModel.fromJson(responseData));
      } else {
        // Handle other status codes
        print('NotifyUnexpected status code: ${response.statusCode}');
        return (false, NotificationResponseModel());
      }
    } catch (e, stacktrace) {
      print('Exception occurred: $e');
      print('Stacktrace${stacktrace}');
      return (false, NotificationResponseModel());
    }
  }

  Future<dynamic> storeUpload(StoreUpdateReq storereqModel) async {
    try {
      print("Store request: $storereqModel");

      final formData = await storereqModel.toFormData();

      var response = await apiService.post(
        ApiConstant.uploadstore,
        formData,
        false,
        isFormData: true,
      );

      log("API response: $response");

      if (response.data['status_code'] == 200) {
        var responseData = response.data;
        return (true, StoreResponseModel.fromJson(responseData));
      } else {
        print('Unexpected status code: ${response.statusCode}');
        return (false, StoreResponseModel(message: response.data['message']));
      }
    } catch (e, stacktrace) {
      print('Exception occurred: $e');
      print('Stacktrace: $stacktrace');
      return (false, StoreResponseModel());
    }
  }

  Future<dynamic> PromotionCreate(PromotionRequestModel promotionReq) async {
    try {
      print("Store request: ${promotionReq.sectionId}");

      final formData = await promotionReq.toFormData();

      var response = await apiService.post(
        ApiConstant.promotionCreate,
        formData,
        false,
        isFormData: true,
      );

      log("API response: $response");

      if (response.statusCode == 200) {
        var responseData = response.data;
        return (true, PromotionResponseModel.fromJson(responseData));
      } else {
        print('Unexpected status code: ${response.statusCode}');
        return (false, PromotionResponseModel());
      }
    } catch (e, stacktrace) {
      print('Exception occurred: $e');
      print('Stacktrace: $stacktrace');
      return (false, PromotionResponseModel());
    }
  }

  Future<dynamic> storeUpdate(StoreUpdateReq storereqModel) async {
    try {
      print("Store request: $storereqModel");

      final formData = await storereqModel.toFormData();

      var response = await apiService.patch(
        ApiConstant.updatestore,
        formData,
        false,
        isFormData: true,
      );

      log("API response: $response");

      if (response.data['status_code'] == 200) {
        var responseData = response.data;
        return (true, StoreResponseModel.fromJson(responseData));
      } else {
        print('Unexpected status code: ${response.statusCode}');
        return (false, StoreResponseModel());
      }
    } catch (e, stacktrace) {
      print('Exception occurred: $e');
      print('Stacktrace: $stacktrace');
      return (false, StoreResponseModel());
    }
  }

  Future<(bool, dynamic)> payoutAccountRegister(
      PayoutRequestModel payoutReqModel) async {
    try {
      var response = await apiService.post(
          ApiConstant.payoutAccount, payoutReqModel, false);

      if (response.statusCode == 200) {
        var responseData = response.data;

        if (responseData['status'] == "true") {
          return (true, RazorpayAccountResponseModel.fromJson(responseData));
        } else {
          return (false, RazorpayErrorResponseModel.fromJson(responseData));
        }
      } else {
        print("s;dkfnlsdbnl${response.data['error']['error']['description']}");
        return (
          false,
          RazorpayErrorResponseModel(
            status: response.data['status'],
            message: response.data['error']['error']['description'],
          )
        );
      }
    } catch (e, stacktrace) {
      print('Exceptixxxon occurred: $e');
      print('Stacktrace: $stacktrace');
      return (
        false,
        RazorpayErrorResponseModel(status: "false", message: e.toString())
      );
    }
  }

  Future<dynamic> getCategory(CategoryIdReqModel catId) async {
    try {
      var response = await apiService.post(ApiConstant.category, catId, false);
      print("asldfnd${response.data}");
      if (response.data['status_code'] == 200) {
        var responseData = response.data;
        return (true, StoreDefaultModel.fromJson(responseData));
      } else {
        // Handle other status codes
        print('Unexpected status code: ${response.data['status_code']}');
        return (false, StoreDefaultModel());
      }
    } catch (e, stacktrace) {
      print('Exception occurred: $e');
      print('Stacktrace${stacktrace}');
      return (false, StoreDefaultModel());
    }
  }

  Future<dynamic> getproductCat(StoreIdReqmodel storeId) async {
    try {
      var response =
          await apiService.post(ApiConstant.category, storeId, false);
      print("asldfnd${response.data}");
      if (response.data['status_code'] == 200) {
        var responseData = response.data;
        return (true, StoreDefaultModel.fromJson(responseData));
      } else {
        // Handle other status codes
        print('Unexpected status code: ${response.data['status_code']}');
        return (false, StoreDefaultModel());
      }
    } catch (e, stacktrace) {
      print('Exception occurred: $e');
      print('Stacktrace${stacktrace}');
      return (false, StoreDefaultModel());
    }
  }

  Future<dynamic> menuList(StoreIdReqmodel storeId) async {
    try {
      var response =
          await apiService.post(ApiConstant.menulist, storeId, false);
      print("asldfnd${response.data}");
      if (response.data['status_code'] == 200) {
        var responseData = response.data;
        return (true, MenuListModel.fromJson(responseData));
      } else {
        // Handle other status codes
        print('Unexpected status code: ${response.data['status_code']}');
        return (false, MenuListModel());
      }
    } catch (e, stacktrace) {
      print('Exception occurred: $e');
      print('Stacktrace${stacktrace}');
      return (false, MenuListModel());
    }
  }

  Future<dynamic> productList(ProductListReqModel reqmodel) async {
    try {
      var response =
          await apiService.post(ApiConstant.productlist, reqmodel, false);
      print("asldfnd${response.data}");
      if (response.data['status_code'] == 200) {
        var responseData = response.data;
        return (true, ProductListResponseModel.fromJson(responseData));
      } else {
        // Handle other status codes
        print('Unexpected status code: ${response.data['status_code']}');
        return (false, ProductListResponseModel());
      }
    } catch (e, stacktrace) {
      print('Exception occurred: $e');
      print('Stacktrace${stacktrace}');
      return (false, ProductListResponseModel());
    }
  }

  Future<dynamic> menuCreate(MenuCreateReqModel menuCreateReq) async {
    try {
      print("Store request: $menuCreateReq");

      final formData = await menuCreateReq.toFormData();

      var response = await apiService.post(
        ApiConstant.menu,
        formData,
        false,
        isFormData: true,
      );

      log("API response: $response");

      if (response.statusCode == 200) {
        if (response.data['status'] == "true") {
          var responseData = response.data;
          return (true, MenuCreateResModel.fromJson(responseData));
        } else {
          print('Unexpected statusss: ${response.data['message']}');
          return (
            false,
            MenuCreateResModel(
              message: response.data['message'],
              status: 'false',
            )
          );
        }
      } else {
        print('Unexpected status code: ${response.statusCode}');
        return (false, MenuCreateResModel());
      }
    } catch (e, stacktrace) {
      print('Exception occurred: $e');
      print('Stacktrace: $stacktrace');
      return (false, MenuCreateResModel());
    }
  }

  Future<dynamic> menuUpdate(MenuUpdateReqModel menuCreateReq) async {
    try {
      print("Store request: $menuCreateReq");

      final formData = await menuCreateReq.toFormData();

      var response = await apiService.patch(
        ApiConstant.menuUpdate,
        formData,
        false,
        isFormData: true,
      );

      log("API response: $response");

      if (response.statusCode == 200) {
        if (response.data['status'] == "true") {
          var responseData = response.data;
          return (true, ChangePasswordModel.fromJson(responseData));
        } else {
          print('Unexpected statusss: ${response.data['message']}');
          return (
            false,
            ChangePasswordModel(
              message: response.data['message'],
              status: 'false',
            )
          );
        }
      } else {
        print('Unexpected status code: ${response.statusCode}');
        return (false, ChangePasswordModel());
      }
    } catch (e, stacktrace) {
      print('Exception occurred: $e');
      print('Stacktrace: $stacktrace');
      return (false, ChangePasswordModel());
    }
  }

  Future<dynamic> productCreate(ProductCreateReqModel proCreateReq) async {
    try {
      print("Store request: $proCreateReq");

      final formData = await proCreateReq.toFormData();

      var response = await apiService.post(
        ApiConstant.createproduct,
        formData,
        false,
        isFormData: true,
      );

      log("API response: $response");

      if (response.statusCode == 200) {
        var responseData = response.data;
        return (true, MenuCreateResModel.fromJson(responseData));
      } else {
        print('Unexpected status code: ${response.statusCode}');
        return (false, MenuCreateResModel());
      }
    } catch (e, stacktrace) {
      print('Exception occurred: $e');
      print('Stacktrace: $stacktrace');
      return (false, MenuCreateResModel());
    }
  }

  Future<dynamic> promotionCheckout(
      PromotionCheckoutReqModel notificationReqModel) async {
    try {
      print("Editreq:${notificationReqModel}");
      var response = await apiService.post(
          ApiConstant.promotionCheckout, notificationReqModel, false);
      log(" asda${response}");
      if (response.data['status_code'] == 200) {
        var responseData = response.data;
        return (true, PromotionCheckoutResponseModel.fromJson(responseData));
      } else {
        // Handle other status codes
        print('Unexpected status code: ${response.statusCode}');
        return (false, PromotionCheckoutResponseModel());
      }
    } catch (e, stacktrace) {
      print('Exception occurred: $e');
      print('Stacktrace${stacktrace}');
      return (false, PromotionCheckoutResponseModel());
    }
  }

  Future<dynamic> promotionDelete(String bannerId) async {
    try {
      var response =
          await apiService.delete(ApiConstant.deleteBanner(bannerId), false);

      if (response.data['status_code'] == 200) {
        var responseData = response.data;
        return (true, ChangePasswordModel.fromJson(responseData));
      } else {
        print('Unexpected status code: ${response.statusCode}');
        return (false, ChangePasswordModel());
      }
    } catch (e, stacktrace) {
      print('Exception occurred: $e');
      print('Stacktrace${stacktrace}');
      return (false, ChangePasswordModel());
    }
  }

  Future<dynamic> promotionTransaction(
      TransactionRequestModel notificationReqModel) async {
    try {
      var response = await apiService.post(
          ApiConstant.transcationPromotion, notificationReqModel, false);
      log(" asda${response}");
      if (response.data['status_code'] == 200) {
        var responseData = response.data;
        return (true, TransactionResponseModel.fromJson(responseData));
      } else {
        // Handle other status codes
        print('Unexpected status code: ${response.statusCode}');
        return (false, TransactionResponseModel());
      }
    } catch (e, stacktrace) {
      print('Exception occurred: $e');
      print('Stacktrace${stacktrace}');
      return (false, TransactionResponseModel());
    }
  }

  Future<dynamic> viewPromotion(StoreIdReqmodel notificationReqModel) async {
    try {
      var response = await apiService.post(
          ApiConstant.viewPromotion, notificationReqModel, false);
      log(" asda${response}");
      if (response.statusCode == 200) {
        var responseData = response.data;
        return (true, BannerResponseModel.fromJson(responseData));
      } else {
        // Handle other status codes
        print('Unexpected status code: ${response.statusCode}');
        return (false, BannerResponseModel());
      }
    } catch (e, stacktrace) {
      print('Exception occurred: $e');
      print('Stacktrace${stacktrace}');
      return (false, BannerResponseModel());
    }
  }

  Future<dynamic> logOut(AccountReqModel sellerId) async {
    try {
      var response = await apiService.post(ApiConstant.logout, sellerId, false);

      if (response.statusCode == 200) {
        var responseData = response.data;
        return (true, LogoutResponseModel.fromJson(responseData));
      } else {
        // Handle other status codes
        print('Unexpected status code: ${response.statusCode}');
        return (false, LogoutResponseModel());
      }
    } catch (e, stacktrace) {
      print('Exception occurred: $e');
      print('Stacktrace${stacktrace}');
      return (false, LogoutResponseModel());
    }
  }
}
