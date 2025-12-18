import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mashrou3/utils/app_localization.dart';
import 'package:mashrou3/utils/ui_components.dart';

abstract class LocationManager {
  static ValueNotifier<Position?> lastFetched = ValueNotifier(null);

  static Future<Position?> checkForPermission() async {
    if (await hasPermission) {
      return await fetchLocation();
    } else {
      return lastFetched.value = null;
    }
  }

  static Future<bool> get hasPermission async {
    final permission = await Geolocator.checkPermission();
    return (permission == LocationPermission.whileInUse || permission == LocationPermission.always);
  }

  static Future<Position?> getLocation() async {
    try {
      return lastFetched.value = await Geolocator.getCurrentPosition();
    } catch (e) {
      debugPrint('LOCATION MANAGER :: ERROR :: ${e.toString()}');
    }
    return null;
  }

  static Future<Position?> fetchLocation({BuildContext? context, bool isForSort = false, bool isNeighbourhood = false}) async {
    try {
      if (!(await hasPermission)) {
        final permission = await Geolocator.requestPermission();
        if (!isNeighbourhood) {
          if (permission == LocationPermission.deniedForever) {
            if (context != null) {
              if (!context.mounted) {
                return null;
              }

              UIComponent.showConfirmDialog(
                  title: appStrings(context).alert,
                  subtitle: appStrings(context).permissionDenied,
                  context: context,
                  positive: appStrings(context).ok,
                  onPositiveTap: () {
                    Navigator.pop(context);
                    if (isForSort) {
                      Navigator.pop(context);
                    }
                  });
            } else {
              if (context != null) {
                if (!context.mounted) {
                  return null;
                }
                UIComponent.showMobileToast(appStrings(context).permissionDenied, Toast.LENGTH_LONG);
              }
            }
          }
        } else if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
          lastFetched.value = await Geolocator.getCurrentPosition();
          return lastFetched.value;
        }
      } else {
        lastFetched.value = await Geolocator.getCurrentPosition();
        return lastFetched.value;
      }
    } on Exception catch (e) {
      debugPrint('LOCATION MANAGER :: ERROR :: ${e.toString()}');
    }
    return null;
  }
}
