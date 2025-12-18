import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../config/resources/app_colors.dart';

extension Space on num {
  Widget get verticalSpace {
    return SizedBox(height: toDouble());
  }

  Widget get horizontalSpace {
    return SizedBox(width: toDouble());
  }
}

extension LightModeColor on Color {
  Color forLightMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? this
        : AppColors.white;
  }
}

extension DarkModeColor on Color {
  Color forDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? this
        : AppColors.black3D;
  }
}

extension AdaptiveColor on Color {
  Color adaptiveColor(BuildContext context,
      {required Color lightModeColor, required Color darkModeColor}) {
    return Theme.of(context).brightness == Brightness.light
        ? lightModeColor
        : darkModeColor;
  }
}

extension StringExtension on String? {
  Widget svgBasic(
      {double? height,
      double? width,
      Color? color,
      required BuildContext context}) {
    String path = '$this';
    return SvgPicture.asset(
      path,
      height: height,
      width: width,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  Widget toSvg(
          {double? height,
          double? width,
          Color? color,
          required BuildContext context}) =>
      svgBasic(height: height, width: width, color: color, context: context);
}

extension StringExtensions on String? {
  String? extractAndCapitalizeFirstLetter() {
    if (this == null || this!.isEmpty) {
      return '';
    }
    return this![0].toUpperCase() ?? "";
  }
}

extension StringDateExtensions on String? {
  String? formatPublishedDate({required String locale}) {
    // Parse the published date string
    DateTime dateTime = DateTime.parse(this ?? DateTime.now().toString());

    DateTime now = DateTime.now();
    int daysDifference = now.difference(dateTime).inDays;
    int monthsDifference =
        now.month - dateTime.month + (12 * (now.year - dateTime.year));
    int years = monthsDifference ~/ 12;
    int remainingMonths = monthsDifference % 12;
    int remainingDays = daysDifference - (monthsDifference * 30);

    // Localization strings
    Map<String, Map<String, String>> localization = {
      'en': {
        'today': 'Today',
        'yesterday': 'Yesterday',
        'year': 'year',
        'years': 'years',
        'month': 'month',
        'months': 'months',
        'day': 'day',
        'days': 'days',
        'ago': 'ago',
      },
      'ar': {
        'today': 'اليوم',
        'yesterday': 'الأمس',
        'year': 'سنة',
        'years': 'سنوات',
        'month': 'شهر',
        'months': 'أشهر',
        'day': 'يوم',
        'days': 'أيام',
        'ago': 'منذ',
      },
    };

    String? getLocalizedString(String key) =>
        localization[locale]?[key] ?? localization['en']![key];

    String pluralize(int count, String singular, String plural) =>
        '$count ${count > 1 ? getLocalizedString(plural) : getLocalizedString(singular)}';

   if (daysDifference == 1) {
      return getLocalizedString('yesterday');
   }

    // Format the date for other cases
    if (years > 0 && remainingMonths > 0) {
      return '${pluralize(years, 'year', 'years')} ${pluralize(remainingMonths, 'month', 'months')} ${getLocalizedString('ago')}';
    } else if (years > 0) {
      return '${pluralize(years, 'year', 'years')} ${getLocalizedString('ago')}';
    } else if (remainingMonths > 0) {
      return '${pluralize(remainingMonths, 'month', 'months')} ${getLocalizedString('ago')}';
    } else if (remainingMonths == 0 && remainingDays == 0) {
      return '${getTimeDifference(dateTime)}';
    } else {
      return '${pluralize(daysDifference, 'day', 'days')} ${getLocalizedString('ago')}';
    }
  }

  String getTimeDifference(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    }
  }
}

extension ShowHideExtension on Widget {
  Widget show() {
    return Visibility(
      visible: true,
      child: this,
    );
  }

  Widget hide() {
    return Visibility(
      visible: false,
      child: this,
    );
  }
}

extension ConditionalWidgetExtension on Widget {
  Widget showIf(bool condition) {
    return condition ? this : const SizedBox.shrink();
  }

  Widget hideIf(bool condition) {
    return condition ? const SizedBox.shrink() : this;
  }
}

// method for round off and return double value
extension DoubleExtension on double {
  double roundOff() {
    double decimalPart = this - floor();
    if (decimalPart >= 0.5) {
      return ceilToDouble();
    } else {
      return floorToDouble();
    }
  }
}

extension CustomDivider on Divider {
  static Divider colored(BuildContext context) {
    return Divider(
      height: 1,
      color: AppColors.greyE8.adaptiveColor(context,
          lightModeColor: AppColors.greyE8, darkModeColor: AppColors.grey50),
    );
  }
}

extension CurrencyFormatter on num {
  String formatCurrency({bool showSymbol = true, String? currencySymbol}) {
    final locale = _getLocaleForCurrencySymbol(currencySymbol);
    final currencyFormat = NumberFormat.currency(
      locale: locale,
      symbol: currencySymbol ?? (showSymbol ? "د.أ " : ''),
    );

    // if (this == 0) {
    //   return "-";
    // } else {
    final formattedValue = currencyFormat.format(this);
    if (currencySymbol == "\€") {
      return formattedValue.replaceAll(",00", "");
    } else {
      return formattedValue.replaceAll(".00", "");
    }

    // }
  }

  String _getLocaleForCurrencySymbol(String? currencySymbol) {
    switch (currencySymbol) {
      case 'إ.د':
        return 'ar';
      case '€':
        return 'de'; // Change this to appropriate locale
      case '£':
        return 'en_GB';
      case 'ق.ر':
        return 'ar';
      case '﷼':
        return 'ar';
      case '\$':
        return 'en_US';
      case 'د.أ':
        return 'en_JO';
      default:
        return 'en_US'; // Defaulting to English locale
    }
  }

  String formatCurrencyForSlider(
      {bool showSymbol = true, String? currencySymbol}) {
    if (currencySymbol != null && currencySymbol.isEmpty) {
      return "$this";
    }

    final locale = _getLocaleForCurrencySymbol(currencySymbol);
    final currencyFormat = NumberFormat.currency(
      locale: locale,
      symbol: currencySymbol ?? (showSymbol ? "د.أ " : ''),
    );

    final formattedValue = currencyFormat.format(this);
    return formattedValue.endsWith('.00')
        ? formattedValue.split('.').first
        : formattedValue;
  }
}

extension AssetImageExtension on String {
  Widget toAssetImage({
    Key? key,
    BoxFit fit = BoxFit.contain,
    double? height,
    double? width,
  }) {
    return Image(
      key: key,
      image: AssetImage(this),
      fit: fit,
      height: height,
      width: width,
    );
  }
}
