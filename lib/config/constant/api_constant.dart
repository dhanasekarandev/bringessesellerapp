import 'package:bringessesellerapp/config/constant/sharedpreference_helper.dart';

class ApiConstant {
  static String get siteUrl {
    final sharedPreferenceHelper = SharedPreferenceHelper();
    return sharedPreferenceHelper.getSiturl;
  }

  static String get logoUrl {
    final sharedPreferenceHelper = SharedPreferenceHelper();

    return "${imageUrl}public/media/stores/logo${sharedPreferenceHelper.getLogo}";
  }

  static String get userId {
    final sharedPreferenceHelper = SharedPreferenceHelper();
    return sharedPreferenceHelper.getUserId;
  }

  static String get tempId {
    final sharedPreferenceHelper = SharedPreferenceHelper();
    return sharedPreferenceHelper.getTempId;
  }

  // static SiteSettingsModel? get site {
  //   final prefs = SharedPreferenceHelper();
  //   return prefs.getSite();
  // }

  static String baseUrl = "https://bringesse.com:3002/";
  static String imageUrl = "https://www.bringesse.com";
  static String kGoogleApiKey = "AIzaSyD3aWLyn9qHavlshIy49b1Pi9jjKjIPMnc";

  static const String userSiteSettings = "app-site-settings";
  static const String userRegister = "accounts/signup";
  static const String userRegisterConfirmOtp = 'app-user-register-confirm-otp';
  static const String userRegisterMpin = 'app-user-register-mpin';
  static const String userLoginMpin = 'app-user-login-mpin';
  static const String userForgotMpin = 'app-user-forgot-mpin';
  static const String userResetMpin = 'app-user-reset-mpin';
  static const String userLogin = 'accounts/signin';
  static String userViewProfile(String userId) => 'accounts/profile/$userId';
  static String dashboardreq(String storeId) => 'dashboard/$storeId';
  static const String userEditProfile = 'accounts/editprofile';
  static const String homeUrl = 'app-home-page';
  static const String siteLanguages = 'app-languages';
  static const String userProduct = 'app-products';
  static const String userProductCategories = 'app-product-categories';
  static const String userAddCart = 'app-product-add-cart';
  static const String userProductDetail = 'app-product-detail';
  static const String userAddresList = 'app-shipping-address';
  static const String userAddres = 'app-get-shipping-address';
  static const String userAddAddres = 'app-update-shipping-address';
  static const String userDelAddress = 'app-delete-shipping-address';
  static const String userCartList = 'app-user-cart';
  static const String userCheckout = 'app-user-cart-summary';
  static const String userBook = 'app-user-cart';
  static const String userBillAddAddres = 'app-add-billing-address';
  static const String userResendOtp = 'app-user-resend-otp';
  static const String userTerms = 'app-terms-conditions';
  static const String userPrivacy = 'app-privacy-policy';
  static const String userOrder = 'app-list-orders';
  static const String userOrderDetail = 'app-order-detail';
  static const String changePassword = 'accounts/changepassword';
  static const String bankingdetails = 'app-bank-details';
  static const String kycverification = 'app-kyc-verification';
  static const String staticpage = 'app-static-pages';
  static const String storedefaults = 'store/defaults';
  static const String notificationlist = 'notification/lists';
  static const String uploadstore = 'store/register';
  static const String payoutAccount = 'accounts/razorurl';
  static const String getpayoutAccount = 'accounts/showrazorpayaccountdetail';
  static String storeget(String storeId) => 'store/list/$storeId';
  static const String updatestore = 'store/update';
  static const String promotionPre = 'promotions/beforedata';
  static const String promotionCreate = 'promotions/create';
  static const String promotionCheckout = 'promotions/checkout';
  static const String category = 'store/defaults';
  static const String menu = 'menus/create';
  static const String menulist = 'menus/lists';
  static const String createproduct = 'items/create';
  static const String productupdate = 'items/update';
  static const String productlist = 'items/lists';
  static const String logout = 'accounts/logout';
  static const String transcationPromotion = 'promotions/transaction';
  static const String viewPromotion = 'promotions/views';
  static const String order = 'orders/lists';
  static const String menuUpdate = 'menus/update';
  static const String subscriptionPlan = 'subscriptionplans/defaults';
  static String deleteBanner(String bannerId) => 'promotions/delete/$bannerId';
  static String productbyId(String productId) => 'items/list/$productId';
  static const String subscriptionCheckout = 'subscriptions/checkout';
  static const String verifyOtp = 'accounts/verifyotp';
  static const String sendOtp = 'accounts/sendotp';
  static const String refreshToken = 'refreshtoken';
  static const String deleteproduct = 'items/changestatus';
}
