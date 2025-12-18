import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/vendor_finance/model/vendor_category_list_response.dart';

import '../../app/model/country_list_model.dart';
import '../../app/model/property/property_category_response_model.dart';
import '../../utils/app_localization.dart';

class AppConstants {
  static GlobalKey<ScaffoldMessengerState> navigatorKey = GlobalKey<ScaffoldMessengerState>();

  static GlobalKey<NavigatorState> navigatorRouterKey = GlobalKey<NavigatorState>();

  static const multiLineMaxLength = 500;

  static const textFieldMaxLength = 100;

  static const phoneMaxLength = 15;

  /// Page limit for products
  static const paginationPageLimit = 30;

  //// Property categories list (list of category names)
  static List<PropertyCategoryData> propertyCategory = [];

  /// Method to set the property categories dynamically
  static void setPropertyCategory(BuildContext context, List<PropertyCategoryData>? propertyCategoryList) {
    if (propertyCategoryList != null) {
      propertyCategory = [PropertyCategoryData(sId: "", name: appStrings(context).textAll)] + propertyCategoryList;
    }
  }

  static List<VendorCategoryData> vendorCategory = [];

  static void setVendorCategory(BuildContext context, List<VendorCategoryData>? vendorCategoryList) {
    if (vendorCategoryList != null) {
      vendorCategory = [VendorCategoryData(sId: "", title: appStrings(context).textAll)] + vendorCategoryList;
    }
  }

  /// metric used in app
  static const currencySign = 'د.أ';
  static const areaMetric = 'm²';

  /// Default platform value for firebase analytics
  static const analyticsPlatformValue = "app";
  static const analyticsPlatformKey = "platform";
  static const analyticsIdOfUserKey = "id_of_user";
  static const analyticsPropertyIdKey = "property_id";
  static const analyticsPropertyClickKey = "property_click";
  static const analyticsUserTypeKey = "user_type";
  static const analyticsContactNumberKey = "contact_number";
  static const analyticsOfferIdKey = "offer_id";
  static const analyticsTimeKey = "time_period";
  static const analyticsDeviceTypeKey = "device_type";

  /// Default country object data
  static CountryListData defaultCountry =
      CountryListData(sId: "67da9bdddb549b07f71757c3", emoji: "🇯🇴", countryCode: "JO", name: "Jordan", phoneCode: "962");

  static String defaultCountryFlag = "🇯🇴";
  static String defaultCountryCode = "JO";
  static String defaultPhoneCode = "962";
  static String defaultCountryName = "Jordan";

  static BuildContext? appContext;

  static LatLng defaultLatLng = const LatLng(31.952775, 35.939847); // Downtown Amman

  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static String getLanguageCode(BuildContext context) {
    return Localizations.localeOf(context).languageCode;
  }

  /// Deep Linking strings
  static const viewProperty = "view-property";
  static const viewPropertyDetails = "property/details";
  static const viewOfferDetails = "view-offer/vendor";
  static const owner = "owner";
  static const vendor = "vendor";

  // Date Formats
  static const String timeFormatHhMmSs = "HH:mm:ss";
  static const String timeFormatHhMmA = "hh:mm a";
  static const String dateFormatDdMMYyyy = "dd/MM/yyyy";
  static const String dateFormatYyyyMMDd = "yyyy-MM-dd";
  static const String dateFormatDdMMYyyyDash = "dd-MM-yyyy";

  static const String liveServer = "https://reactapp.devhostserver.com/";
  static const String devServer = "https://devreactapp.devhostserver.com/";
  static const String prodServer = "https://mashrou3.com/";

  static String getTermsConditionsUrl(BuildContext context) {
    final String lang = Localizations.localeOf(context).languageCode;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    debugPrint("language -> $lang, dark mode -> $isDarkMode");

    return "${prodServer}terms-conditions?lang=$lang&dark=$isDarkMode";
  }

  static String getPrivacyPolicyUrl(BuildContext context) {
    final String lang = Localizations.localeOf(context).languageCode;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    debugPrint("language -> $lang, dark mode -> $isDarkMode");
    return "${prodServer}privacy-policy?lang=$lang&dark=$isDarkMode";
  }
}
