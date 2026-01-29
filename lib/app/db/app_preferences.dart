import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mashrou3/app/model/property/address_location_response_model.dart';
import 'package:mashrou3/app/model/property/property_list_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/utils.dart';
import '../model/verify_response.model.dart';

class AppPreferences {
  static final AppPreferences _instance = AppPreferences._internal();

  static AppPreferences get instance => _instance;

  factory AppPreferences() => _instance;

  AppPreferences._internal();

  /// Cached language code for quick synchronous access around the app.
  /// Defaults to 'en' and is updated whenever [setLanguageCode] is called.
  static String currentLanguageCode = 'en';

  static String getCurrentLanguageCode() => currentLanguageCode;

  //------------------------- Preference Constants -----------------------------
  static const String keyLanguageCode = "keyLanguageCode";
  static const String keyLoginDetails = "keyLoginDetails";
  static const String keySupportDetails = "keySupportDetails";
  static const String keyUserSettingDetails = "keyUserSettingDetails";
  static const String keySystemAttributeData = "keySystemAttributeData";
  static const String keyIsUserClient = "keyIsUserClient";
  static const String keyLoginMethod = "keyLoginMethod";
  static const String keyApiToken = "keyApiToken";
  static const String keyUserID = "keyUserID";
  static const String keySelectedCountryID = "keySelectedCountryID";
  static const String keyIsLoggedIn = "keyIsLoggedIn";
  static const String keyIsGuestUser = "keyIsGuestUser";
  static const String keyIsProfileCompleted = "keyIsProfileCompleted";
  static const String keyIsVerified = "keyIsVerified";
  static const String keyIsActive = "keyIsActive";
  static const String keyUserRole = 'keyUserRole';
  static const String keyLanguagePref = "languagePrefs";
  static const String keyIsDarkMode = "keyIsDarkMode";
  static const String keySearchHistory = 'keySearchHistory';
  static const String fcmToken = 'keyFCMToken';
  static const String keyIsFCMUpdated = 'keyFCMUpdated';

  // Denotes if subscription is enabled by admin or not.
  static const String keyIsSubscriptionEnabled = 'keyIsSubscriptionEnabled';

  // If logged in user has active subscription or not.
  static const String keyIsSubscribed = 'keyIsSubscribed';

  // Address location data
  static const String keyAddressLocationData = 'keyAddressLocationData';

  // Method to set User Role details
  Future<bool> setIsUserClient(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(keyIsUserClient, value);
  }

  //Method to get User Role details
  Future<bool> getIsUserClient() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyIsUserClient) ?? false;
  }

  // Method to set dark mode
  Future<bool> setIsDarkMode({bool? value}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(keyIsDarkMode, value ?? false);
  }

  //Method to get dark mode
  Future<bool> getIsDarkMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyIsDarkMode) ?? false;
  }

  //Method to set User Role details
  Future<void> saveApiToken({String? value}) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    shared.setString(keyApiToken, value!);
  }

  //Method to get User Role details
  Future<String> getApiToken() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    return shared.getString(keyApiToken) ?? "";
  }

  Future<void> isLoggedIn({bool? value}) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    await shared.setBool(keyIsLoggedIn, value!);
    debugPrint('isLoggedIn ::::::::::   $value');
  }

  Future<bool> getIsLoggedIn() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    return shared.getBool(keyIsLoggedIn) ?? false;
  }

  Future<void> isGuestUser({bool? value}) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    await shared.setBool(keyIsGuestUser, value!);
    debugPrint('IsGuestUser ::::::::::   $value');
  }

  Future<bool> getIsGuestUser() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    return shared.getBool(keyIsGuestUser) ?? false;
  }

  Future<void> isProfileCompleted({bool? value}) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    await shared.setBool(keyIsProfileCompleted, value!);
    debugPrint('isProfileCompleted ::::::::::   $value');
  }

  Future<bool> getIsProfileCompleted() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    return shared.getBool(keyIsProfileCompleted) ?? false;
  }

  Future<void> isVerified({bool? value}) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    await shared.setBool(keyIsVerified, value!);
    debugPrint('isVerified ::::::::::   $value');
  }

  Future<bool> getIsVerified() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    return shared.getBool(keyIsVerified) ?? false;
  }

  Future<void> isActive({bool? value}) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    await shared.setBool(keyIsActive, value!);
    debugPrint('isVerified ::::::::::   $value');
  }

  Future<bool> getIsActive() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    return shared.getBool(keyIsActive) ?? false;
  }

  /// Return true if Admin enable subscription for this user role.
  Future<bool> getSubscriptionRequired() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    return shared.getBool(keyIsSubscriptionEnabled) ?? false;
  }

  /// Return true when user has active subscription.
  Future<bool> isSubscriptionEnable() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    return shared.getBool(keyIsSubscribed) ?? false;
  }

  Future<bool> setSubscriptionRequired({bool? value}) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    return shared.setBool(keyIsSubscriptionEnabled, value ?? false);
  }

  Future<bool> setUserSubscribed({bool? value}) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    return shared.setBool(keyIsSubscribed, value ?? false);
  }

  // Method to set user role
  Future<bool> setUserRole(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(keyUserRole, value);
  }

  // Method to get user role
  Future<String?> getUserRole() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyUserRole);
  }

  Future<void> saveUserID({String? value}) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    shared.setString(keyUserID, value!);
  }

  Future<String> getUserID() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    return shared.getString(keyUserID) ?? "";
  }

  Future<void> saveSelectedCountryID({String? value}) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    shared.setString(keySelectedCountryID, value!);
  }

  Future<String> getSelectedCountryID() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    return shared.getString(keySelectedCountryID) ?? "";
  }

  // Method to get language code
  Future<String?> getLanguageCode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(keyLanguageCode);
    // Keep in-memory language code in sync with stored value
    if (code != null && code.isNotEmpty) {
      currentLanguageCode = code;
    }
    return code;
  }

  // Method to set language code
  Future<bool> setLanguageCode(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    currentLanguageCode = value;
    return prefs.setString(keyLanguageCode, value);
  }

  // Method to get login details
  Future<VerifyResponseData?> getUserDetails() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    String? userDetailsData = shared.getString(keyLoginDetails);
    if (Utils.isEmpty(userDetailsData)) {
      return null;
    }
    try {
      return VerifyResponseData.fromJson(json.decode(userDetailsData!));
    } catch (e) {
      debugPrint("App Preference error: ${e.toString()}");
    }
    return null;
  }

  // Method to set login details
  Future<bool> setUserDetails(VerifyResponseData userDetailsData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String userDetails = json.encode(userDetailsData.toJson());
    return prefs.setString(keyLoginDetails, userDetails);
  }

  // Method to save the entire search history list
  Future<void> saveFCMToken(String fcmTokenVal) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(fcmToken, fcmTokenVal);
  }

  // Method to save the entire search history list
  Future<String> getFCMToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(fcmToken) ?? "";
  }

  // Method to save if FCM token updated to server or not.
  Future<void> setFCMTokenUpdate(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyIsFCMUpdated, value);
  }

  // Method to save the entire search history list
  Future<bool> isFCMTokenUpdated() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyIsFCMUpdated) ?? false;
  }

  Future<Support?> getSupportDetails() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    String? supportData = shared.getString(keySupportDetails);
    if (Utils.isEmpty(supportData)) {
      return null;
    }
    try {
      return Support.fromJson(json.decode(supportData!));
    } catch (e) {
      debugPrint("App Preference error: ${e.toString()}");
    }
    return null;
  }

  Future<bool> setSupportDetails(Support supportData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String userDetails = json.encode(supportData.toJson());
    return prefs.setString(keySupportDetails, userDetails);
  }

  // Method to save a search term to the history
  Future<void> saveSearchHistory({String? searchTerm}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> searchHistory = await getSearchHistory();
    if (searchTerm != null && searchTerm.isNotEmpty && !searchHistory.contains(searchTerm)) {
      searchHistory.add(searchTerm);
      await prefs.setStringList(keySearchHistory, searchHistory);
    }
  }

  // Method to save the entire search history list
  Future<void> saveSearchHistoryList(List<String> searchHistory) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(keySearchHistory, searchHistory);
  }

  Future<List<String>> getSearchHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final dynamic value = prefs.get(keySearchHistory);
    printf("Retrieved search history: $value");

    if (value is List) {
      return value.map((e) => e.toString()).toList();
    } else if (value is String) {
      try {
        final List<dynamic> decoded = jsonDecode(value) as List<dynamic>;
        return decoded.map((e) => e.toString()).toList();
      } catch (e) {
        printf("Error decoding search history: $e");
      }
    }
    return [];
  }

  // Method to clear the search history
  Future<void> clearSearchHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(keySearchHistory);
  }

  Future<void> clearData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var selectedLanguage = await getLanguageCode() ?? 'en';
    var isDarkMode = await getIsDarkMode();
    await prefs.clear();
    await setLanguageCode(selectedLanguage);
    await setIsDarkMode(value: isDarkMode);
  }

  Future<void> clearLangData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(keyLanguagePref);
  }

  // Method to save address location data
  Future<bool> saveAddressLocationData(AddressLocationData locationData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String locationDataJson = json.encode(locationData.toJson());
    return prefs.setString(keyAddressLocationData, locationDataJson);
  }

  // Method to get address location data
  Future<AddressLocationData?> getAddressLocationData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? locationDataJson = prefs.getString(keyAddressLocationData);
    if (locationDataJson != null && locationDataJson.isNotEmpty) {
      try {
        Map<String, dynamic> decoded = json.decode(locationDataJson);
        return AddressLocationData.fromJson(decoded);
      } catch (e) {
        debugPrint("Error decoding address location data: $e");
        return null;
      }
    }
    return null;
  }

  // Method to get location text by ID
  Future<String?> getLocationTextById(String? locationId) async {
    if (locationId == null || locationId.isEmpty) {
      return null;
    }
    final locationData = await getAddressLocationData();
    if (locationData?.locationData != null) {
      final locationItem = locationData!.locationData!.firstWhere(
        (item) => item.sId == locationId,
        orElse: () => AddressLocationItem(),
      );
      return locationItem.text;
    }
    return null;
  }

  // Method to get location text by IDs (for list of IDs)
  Future<String?> getLocationTextByIds(List<String>? locationIds) async {
    if (locationIds == null || locationIds.isEmpty) {
      return null;
    }
    // Get the first location ID from the list
    final firstLocationId = locationIds.first;
    return getLocationTextById(firstLocationId);
  }
}
