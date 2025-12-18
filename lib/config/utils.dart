import 'dart:developer' as dev;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../app/ui/screens/vendors/model/vendors_sequence_response.dart';
import '../l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:mashrou3/app/model/property/contact_now_model.dart';
import 'package:mashrou3/app/model/property/property_detail_response_model.dart';
import 'package:mashrou3/config/resources/app_assets.dart';
import 'package:mashrou3/config/resources/app_colors.dart';
import 'package:mashrou3/config/resources/app_constants.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app/model/property/get_finance_model.dart';
import '../app/model/property/sort_by_model.dart';
import '../utils/app_localization.dart';

void printf(dynamic value) {
  if (!kReleaseMode) dev.log(value.toString());
}

class Utils {
  /// Returns status if device has internet available.
  ///
  /// Return true if network available otherwise false.

  static List<SortByModel> sortOptions = [];

  // static Future<bool> isConnected() async {
  //   try {
  //     final response = await http
  //         .get(Uri.parse('https://google.com'))
  //         .timeout(Duration(seconds: 5));
  //     if (response.statusCode == 200) return true;
  //     return false;
  //   } catch (_) {
  //     return false;
  //   }
  // }
  // static Future<bool> isConnected() async {
  //   var connectivityResult = await (Connectivity().checkConnectivity());
  //   if (connectivityResult.contains(ConnectivityResult.mobile) ||
  //       connectivityResult.contains(ConnectivityResult.wifi)) {
  //     return true;
  //   }
  //   return false;
  // }
  static Future<bool> isConnected() async {
    // Step 1: Check network interface
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false; // No Wi-Fi or mobile connection
    }

    // Step 2: Confirm real internet access via Dio
    try {
      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 5), // 5 seconds
        receiveTimeout: const Duration(seconds: 5),
      ));

      final response = await dio.get(
        'https://www.google.com/generate_204', // lightweight endpoint
        options: Options(
          validateStatus: (_) => true, // prevent Dio from throwing on non-200
        ),
      );

      return response.statusCode == 204;
    } catch (_) {
      return false;
    }
  }
  // static Future<bool> isConnected() async {
  //   var connectivityResult = await Connectivity().checkConnectivity();
  //
  //   // Print the connectivity type
  //   print('Connectivity result: $connectivityResult');
  //
  //   // Return true if connected to Wi-Fi, mobile, or ethernet
  //   return connectivityResult != ConnectivityResult.none;
  // }

  static Future<List<SortByModel>> getSortOptionsList(
      BuildContext context) async {
    var appStrings = AppLocalizations.of(context)!;
    return [
      SortByModel(
          title: appStrings.textNewest,
          sortField: "createdAt",
          sortOrder: "desc"),
      SortByModel(
          title: appStrings.textPriceLowToHigh,
          sortField: "price",
          sortOrder: "asc"),
      SortByModel(
          title: appStrings.textPriceHighToLow,
          sortField: "price",
          sortOrder: "desc"),
      SortByModel(
          title: appStrings.textAscending,
          sortField: "title",
          sortOrder: "asc"),
      SortByModel(
          title: appStrings.textDescending,
          sortField: "title",
          sortOrder: "desc"),
      SortByModel(
          title: appStrings.textNearest, sortField: null, sortOrder: null),
      SortByModel(
          title: appStrings.textFurthest, sortField: null, sortOrder: null),
    ];
  }

  static Future<List<ContactNowModel>> getContactNowList(
      BuildContext context) async {
    return [
      ContactNowModel(
        title: appStrings(context).textDirectCall,
        icon: SVGAssets.callIcon,
      ),
      ContactNowModel(
        title: appStrings(context).textWhatsApp,
        icon: SVGAssets.whatsAppIcon,
      ),
      ContactNowModel(
          title: appStrings(context).textTextMessage,
          icon: SVGAssets.messageIcon),
    ];
  }

  static Future<List<GetFinanceModel>> getPaymentType(
      BuildContext context) async {
    return [
      GetFinanceModel(
          title: appStrings(context).cash,
          icon: SVGAssets.cashIcon,
          isEnable: true),
      GetFinanceModel(
          title: appStrings(context).bank,
          icon: SVGAssets.bankIcon,
          isEnable: true),
    ];
  }

  static Future<void> getStorageReadPermission() async {
    final storage = await Permission.storage.status;
    !storage.isGranted
        ? await Permission.storage.request()
        : debugPrint("Storage read permission already granted");
  }

  static Future<void> getStorageManagePermission() async {
    final manageStorage = await Permission.manageExternalStorage.status;
    !manageStorage.isGranted
        ? await Permission.manageExternalStorage.request()
        : debugPrint("storage permission already granted");
  }

  /// Return string date with yyyy-MM-dd format.
  static String getTodayDate() {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    return formattedDate;
  }

  static String getTimeDifferenceWithContext(
      BuildContext context, DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time.toLocal());

    if (difference.inMinutes < 1) {
      return appStrings(context).justNow;
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? appStrings(context).minute : appStrings(context).minutes} ${appStrings(context).ago}';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ${difference.inHours == 1 ? appStrings(context).hour : appStrings(context).hours} ${appStrings(context).ago}';
    } else if (difference.inDays == 1) {
      return appStrings(context).yesterday;
    } else if (difference.inDays < 30) {
      return '${difference.inDays} ${difference.inDays == 1 ? appStrings(context).day : appStrings(context).days} ${appStrings(context).ago}';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? appStrings(context).month : appStrings(context).months} ${appStrings(context).ago}';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? appStrings(context).year : appStrings(context).years} ${appStrings(context).ago}';
    }
  }

  static String getTimeDifference(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time.toLocal());

    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min${difference.inMinutes == 1 ? '' : 's'}';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} h';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'}';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months == 1 ? '' : 's'}';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years year${years == 1 ? '' : 's'}';
    }
  }

  // static String getTimeDifference(DateTime time) {
  //   // getTimeDifference(item.messageDateTime ?? DateTime.now()),
  //   final now = DateTime.now();
  //   final difference = now.difference(time.toLocal());
  //
  //   if (difference.inMinutes < 1) {
  //     return 'just now';
  //   } else if (difference.inMinutes < 60) {
  //     return '${difference.inMinutes} min${difference.inMinutes == 1 ? '' : 's'}';
  //   } else if (difference.inHours < 24) {
  //     return '${difference.inHours} h';
  //   } else {
  //     return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'}';
  //   }
  // }

  static String formatArea(String? amountStr, String? unit) {
    // Check if the input is null or empty or represents 0
    if (amountStr == null ||
        amountStr.isEmpty ||
        double.tryParse(amountStr) == 0.0) {
      return "";
    }

    // Parse the amount string to a double
    double amount = double.tryParse(amountStr) ?? 0.0;

    // Format the number with commas
    final formatter = NumberFormat('#,##0');
    String formattedAmount = formatter.format(amount);

    // Check if the unit is "sqm" and replace with "m²"
    if (unit == 'sqm') {
      unit = AppConstants.areaMetric;
    }

    // Return the formatted string with the unit
    return '$formattedAmount ${unit ?? ''}';
  }

  static void showErrorMessage(
      {required BuildContext context, required String message}) {
    final snackBar = SnackBar(
      elevation: 4,
      duration: const Duration(seconds: 5),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.red,
      content: Text(message),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..clearSnackBars()
      ..showSnackBar(snackBar);
  }

  static void snackBar(
      {required BuildContext context, required String message}) {
    if (message.isEmpty) {
      return;
    }
    final snackBar = SnackBar(
      backgroundColor: AppColors.black3D.adaptiveColor(context,
          lightModeColor: AppColors.black3D, darkModeColor: AppColors.white),
      elevation: 4,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      content: Text(message),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..clearSnackBars()
      ..showSnackBar(snackBar);
  }

  static bool isEmpty(String? string) {
    return string == null || string.isEmpty;
  }

  static String? getLatestPropertyImage(
      List<String> fileLinks, String thumbnail) {
    List<String> imageLinks =
        fileLinks.where((link) => _isImageFile(link)).toList();

    if (thumbnail.isEmpty) {
      if (imageLinks.isEmpty) {
        return null;
      }
      return imageLinks.first;
    } else {
      return thumbnail;
    }
  }

  static List<String> getAllImageFiles(List<String> fileLinks) {
    return fileLinks.where((link) => _isImageFile(link)).toList();
  }

  static List<String> getAllDocFiles(List<String> fileLinks) {
    return fileLinks.where((link) => !_isImageFile(link)).toList();
  }

  static bool _isImageFile(String fileName) {
    List<String> imageExtensions = [
      '.jpg',
      '.jpeg',
      '.png',
      '.gif',
      '.bmp',
      '.webp'
    ];
    String? extension = fileName.split('.').last.toLowerCase();
    return imageExtensions.contains('.$extension');
  }

  static String extractFileName(String url) {
    final uri = Uri.parse(url);
    final fileName = uri.pathSegments.last.split('.').first;
    return fileName;
  }

  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Future<void> openMapWithMarker({
    required double latitude,
    required double longitude,
  }) async {
    final String googleMapsUrl =
        "https://www.google.com/maps?q=$latitude,$longitude";
    final Uri uri = Uri.parse(googleMapsUrl);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint("Could not open Google Maps.");
      }
    } catch (e) {
      debugPrint("Error opening Google Maps: $e");
    }
  }

  static Future<void> launchURL({
    required String url,
  }) async {
    try {
      final Uri uri = Uri.parse(url.startsWith('http')
          ? url
          : 'https://$url'); // Ensure URL is fully qualified
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint("Could not launch $url");
      }
    } catch (e) {
      debugPrint("Error launching URL: $e");
    }
  }

  // static void makePhoneCall(
  //     {required BuildContext context, required String phoneNumber}) async {
  //   // bool? res = await FlutterPhoneDirectCaller.callNumber(phoneNumber);
  //   // if (res == true) {
  //   //   debugPrint('call true $res');
  //   // } else {
  //   //   debugPrint('call false $res');
  //   //   if (!context.mounted) return;
  //   //   snackBar(
  //   //     context: context,
  //   //     message: appStrings(context).canNotMakeCall,
  //   //   );
  //   // }
  // }

  static void makeWhatsAppCall({
    required BuildContext context,
    required String phoneNumber,
  }) async {
    final whatsappUrl =
        Uri.parse("https://wa.me/$phoneNumber"); // WhatsApp URL format

    // Check if WhatsApp can be launched
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl);
    } else {
      debugPrint('WhatsApp cannot be opened');
      if (!context.mounted) return;
      snackBar(
        context: context,
        message: 'Could not open WhatsApp.',
      );
    }
  }

  static void makePhoneCall({
    required BuildContext context,
    required String phoneNumber,
  }) async {
    final phoneCallUrl = Uri.parse("tel:$phoneNumber"); // Phone call URL format

    // Check if the phone call can be initiated
    if (await canLaunchUrl(phoneCallUrl)) {
      await launchUrl(phoneCallUrl); // Launch the phone dialer
    } else {
      debugPrint('Phone call cannot be made');
      if (!context.mounted) return;
      snackBar(
        context: context,
        message: 'Could not open phone dialer.',
      );
    }
  }

  static void composeMail({
    required BuildContext context,
    required String email,
  }) async {
    final mailUrl = Uri.parse("mailto:$email");

    if (await canLaunchUrl(mailUrl)) {
      await launchUrl(mailUrl);
    } else {
      debugPrint('Email cannot be sent');
      if (!context.mounted) return;
      snackBar(
        context: context,
        message: 'Could not open mail app.',
      );
    }
  }

  static void makeSms({
    required BuildContext context,
    required String phoneNumber,
  }) async {
    final smsUrl = Uri.parse("sms:$phoneNumber"); // SMS URL format

    if (await canLaunchUrl(smsUrl)) {
      await launchUrl(smsUrl);
    } else {
      debugPrint('SMS cannot be sent');
      if (!context.mounted) return;
      snackBar(
        context: context,
        message: 'Could not open SMS app.',
      );
    }
  }

  static void shareProperty(BuildContext context,
      {required PropertyDetailData? propertyDetails}) async {
    final box = context.findRenderObject() as RenderBox?;

    final localizedMessage = appStrings(context).shareProjectMessage;
    final message = '$localizedMessage\n\n${propertyDetails?.shareLink ?? ''}';

    await Share.share(
      message,
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }

  static void shareVendor(BuildContext context,
      {required VendorSequenceUser? vendorSequenceUser}) async {
    final box = context.findRenderObject() as RenderBox?;

    final localizedMessage = appStrings(context).shareProjectMessage;
    final message = '$localizedMessage\n\n${vendorSequenceUser ?? ''}';

    await Share.share(
      message,
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }

  static notificationType() => {};

  static String getNotificationLabelFromNotificationType(
      BuildContext context, String propertyType) {
    Map<String, String> propertyTypeMap = {
      "propertyCreated": appStrings(context).lblAddedNewProperty,
      "rejected": appStrings(context).lblRequestRejected,
      "approved": appStrings(context).lblRequestApproved,
      "requestCreated": appStrings(context).lblVisitRequestCreated,
      "propertyFinance": appStrings(context).lblPropertyFinance,
    };

    final selectedIndex = propertyTypeMap.keys
        .toList()
        .indexWhere((key) => key.toLowerCase() == propertyType.toLowerCase());

    if (selectedIndex == -1) {
      return propertyType;
    }
    return propertyTypeMap.values.toList()[selectedIndex];
  }
}
