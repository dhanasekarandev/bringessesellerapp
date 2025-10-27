// import 'package:bizzol/src/config/model/site_setting_model.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static late SharedPreferences? _sharedPreferences;

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<void> clearPreferences() async {
    await _sharedPreferences?.clear();
  }

  Future<void> saveUserID(String? authToken) async {
    await _sharedPreferences?.setString(PrefKeys.user_id, authToken ?? "");
  }

  Future<void> saveSellerId(String? authToken) async {
    await _sharedPreferences?.setString(PrefKeys.seller_id, authToken ?? "");
  }

  Future<void> savePaymentstatus(String? paymentStatus) async {
    await _sharedPreferences?.setString(
        PrefKeys.seller_id, paymentStatus ?? "");
  }

  Future<void> saveSiteurl(String? siturl) async {
    await _sharedPreferences?.setString(PrefKeys.siturl, siturl ?? "");
  }

  Future<void> saveLogo(String? logo) async {
    await _sharedPreferences?.setString(PrefKeys.logo, logo ?? "");
  }

  Future<void> saveVersion(String? version) async {
    await _sharedPreferences?.setString(PrefKeys.version, version ?? "");
  }

  Future<void> saveMpinStatus(String? mpinStatus) async {
    await _sharedPreferences?.setString(PrefKeys.mpinStatus, mpinStatus ?? "");
  }

  Future<void> saveToken(String? version) async {
    await _sharedPreferences?.setString(PrefKeys.token, version ?? "");
  }

  Future<void> saveTemp(String? tempId) async {
    await _sharedPreferences?.setString(PrefKeys.token, tempId ?? "");
  }

  Future<void> saveStoreId(String? storeId) async {
    await _sharedPreferences?.setString(PrefKeys.storeId, storeId ?? "");
  }

  Future<void> saveCategoryId(String? catId) async {
    await _sharedPreferences?.setString(PrefKeys.catId, catId ?? "");
  }

  Future<void> saveCategoryName(String? catName) async {
    await _sharedPreferences?.setString(PrefKeys.catName, catName ?? "");
  }

  Future<void> saveCurrentLat(String? currentLat) async {
    await _sharedPreferences?.setString(PrefKeys.currentLat, currentLat ?? "");
  }

  Future<void> saveCurrentLng(String? currentLng) async {
    await _sharedPreferences?.setString(PrefKeys.currentLng, currentLng ?? "");
  }

  Future<void> saveCurrentLocation(String? currentLng) async {
    await _sharedPreferences?.setString(PrefKeys.currentLng, currentLng ?? "");
  }

  Future<void> saveSearchLat(String? searchLat) async {
    await _sharedPreferences?.setString(PrefKeys.searchLat, searchLat ?? "");
  }

  Future<void> saveSearchLng(String? searchLng) async {
    await _sharedPreferences?.setString(PrefKeys.searchLng, searchLng ?? "");
  }

  Future<void> saveSearchLocation(String? searchLocation) async {
    await _sharedPreferences?.setString(
        PrefKeys.searchLocation, searchLocation ?? "");
  }
  // Future<void> saveLang(SiteSettingsModel? siteModel) async {
  //   // Convert the LanguageModel to a JSON string
  //   String langJson = jsonEncode(siteModel?.toJson());

  //   // Save the JSON string in shared preferences
  //   await _sharedPreferences?.setString(PrefKeys.site, langJson);
  // }

  String get getUserId {
    return _sharedPreferences?.getString(PrefKeys.user_id) ?? '';
  }

  String get getSellerId {
    return _sharedPreferences?.getString(PrefKeys.seller_id) ?? '';
  }

  String get getPaymentSatatus {
    return _sharedPreferences?.getString(PrefKeys.paymentStatus) ?? '';
  }

  String get getSiturl {
    return _sharedPreferences?.getString(PrefKeys.siturl) ?? '';
  }

  String get getLogo {
    return _sharedPreferences?.getString(PrefKeys.logo) ?? '';
  }

  String get getTempId {
    return _sharedPreferences?.getString(PrefKeys.tempId) ?? '';
  }

  String get getVersion {
    return _sharedPreferences?.getString(PrefKeys.version) ?? '';
  }

  String get getToken {
    return _sharedPreferences?.getString(PrefKeys.token) ?? '';
  }

  String get getMpinStatus {
    return _sharedPreferences?.getString(PrefKeys.mpinStatus) ?? '';
  }

  String get getStoreId {
    return _sharedPreferences?.getString(PrefKeys.storeId) ?? '';
  }

  String get getCatId {
    return _sharedPreferences?.getString(PrefKeys.catId) ?? '';
  }

  String get getcatName {
    return _sharedPreferences?.getString(PrefKeys.catName) ?? '';
  }

  String get getcurrentLat {
    return _sharedPreferences?.getString(PrefKeys.currentLat) ?? '';
  }

  String get getcurrentLng {
    return _sharedPreferences?.getString(PrefKeys.currentLng) ?? '';
  }

  String get getcurrentLocation {
    return _sharedPreferences?.getString(PrefKeys.currentLocation) ?? '';
  }

  String get getSearchLat {
    return _sharedPreferences?.getString(PrefKeys.searchLat) ?? '';
  }

  String get getSearchLng {
    return _sharedPreferences?.getString(PrefKeys.searchLng) ?? '';
  }

  String get getSearchLocation {
    return _sharedPreferences?.getString(PrefKeys.searchLocation) ?? '';
  }
  // SiteSettingsModel? getSite() {
  //   // Get the JSON string from shared preferences
  //   String? langJson = _sharedPreferences?.getString(PrefKeys.site);

  //   if (langJson != null && langJson.isNotEmpty) {
  //     // Decode the JSON string back to LanguageModel
  //     Map<String, dynamic> jsonData = jsonDecode(langJson);
  //     return SiteSettingsModel.fromJson(jsonData);
  //   }
  //   return null;
  // }
}

mixin PrefKeys {
  static const String user_id = "userID";
  static const String siturl = 'siturl';
  static const String logo = 'logo';
  static const String version = 'version';
  static const String token = 'token';
  static const String site = 'site';
  static const String tempId = 'tempId';
  static const String mpinStatus = 'mpinStatus';
  static const String seller_id = 'sellerId';
  static const String paymentStatus = 'paymentStatus';
  static const String storeId = 'storeId';
  static const String catId = 'categoryId';
  static const String catName = 'categoryName';
  static const String currentLat = 'currentLat';
  static const String currentLng = 'currentLng';
  static const String currentLocation = 'currentLocation';
  static const String searchLat = 'searchLat';
  static const String searchLng = 'searchLng';
  static const String searchLocation = 'searchLocation';
}
