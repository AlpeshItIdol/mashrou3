import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:mashrou3/utils/app_localization.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import '../config/utils.dart';

String? validateFirstName(BuildContext context, String? value) {
  if (value!.isEmpty) {
    return appStrings(context).firstNameEmptyError;
  } else {
    return null;
  }
}

String? validateLastName(BuildContext context, String? value) {
  if (value!.isEmpty) {
    return appStrings(context).lastNameEmptyError;
  } else {
    return null;
  }
}

String? validateCompanyName(BuildContext context, String? value) {
  if (value!.isEmpty) {
    return appStrings(context).companyNameEmptyError;
  } else {
    return null;
  }
}

String? validateDescription(BuildContext context, String? value) {
  if (value!.isEmpty) {
    return appStrings(context).descriptionEmptyError;
  } else {
    return null;
  }
}

String? validateDescriptionField(BuildContext context, String? value) {
  if (value!.isEmpty) {
    return appStrings(context).descriptionFieldEmptyError;
  } else {
    return null;
  }
}

String? validatePropertyTitle(BuildContext context, String? value) {
  if (value!.isEmpty) {
    return appStrings(context).propertyTitleEmptyError;
  } else {
    return null;
  }
}

String? validatePropertyPrice(BuildContext context, String? value) {
  if (value!.isEmpty) {
    return appStrings(context).propertyPriceEmptyError;
  } else {
    return null;
  }
}

String? validatePropertyArea(BuildContext context, String? value) {
  if (value!.isEmpty) {
    return appStrings(context).propertyAreaEmptyError;
  } else {
    return null;
  }
}

String? validatePropertyLocation(BuildContext context, String? value) {
  if (value!.isEmpty) {
    return appStrings(context).propertyLocationEmptyError;
  } else {
    return null;
  }
}

String? validateNearByPropertyLocation(BuildContext context, String? value) {
  if (value!.isEmpty) {
    return appStrings(context).propertyNearByLocationEmptyError;
  } else {
    return null;
  }
}

String? validateOfferTitle(BuildContext context, String? value) {
  if (value!.isEmpty) {
    return appStrings(context).offerTitleEmptyError;
  } else {
    return null;
  }
}

String? validateOfferCost(BuildContext context, String? value) {
  if (value!.isEmpty) {
    return appStrings(context).offerCostEmptyError;
  } else {
    return null;
  }
}

String? validateWebsiteLink(BuildContext context, String? value) {
  if (value!.isEmpty) {
    return appStrings(context).websiteLinkEmptyError;
  } else {
    return null;
  }
}

String? validateLink(BuildContext context, String? value) {
  if ((value ?? "").isNotEmpty) {
    if (!AnyLinkPreview.isValidLink(value!)) {
      return appStrings(context).invalidUrlError;
    }
  }
  return null;
}

String? validateInstagramLink(BuildContext context, String? value) {
  if ((value ?? "").isNotEmpty) {
    if (!AnyLinkPreview.isValidLink(value!)) {
      return appStrings(context).invalidUrlError;
    }
    if (!value.contains('instagram.com')) {
      return appStrings(context).invalidInstagramLinkError;
    }
  }
  return null;
}

String? validateFacebookLink(BuildContext context, String? value) {
  if ((value ?? "").isNotEmpty) {
    if (!AnyLinkPreview.isValidLink(value!)) {
      return appStrings(context).invalidUrlError;
    }
    if (!value.contains('facebook.com')) {
      return appStrings(context).invalidFacebookLinkError;
    }
  }
  return null;
}

String? validateLinkedInLink(BuildContext context, String? value) {
  if ((value ?? "").isNotEmpty) {
    if (!AnyLinkPreview.isValidLink(value!)) {
      return appStrings(context).invalidUrlError;
    }
    if (!value.contains('linkedin.com')) {
      return appStrings(context).invalidLinkedInLinkError;
    }
  }
  return null;
}

String? validateUrlLink(BuildContext context, String? value) {
  if ((value ?? "").isNotEmpty) {
    if (!AnyLinkPreview.isValidLink(value!)) {
      return appStrings(context).invalidUrlError;
    }
  }
  return null;
}

String? validateXLink(BuildContext context, String? value) {
  if ((value ?? "").isNotEmpty) {
    if (!AnyLinkPreview.isValidLink(value!)) {
      return appStrings(context).invalidUrlError;
    }
    if (!value.contains('x.com')) {
      return appStrings(context).invalidXLinkError;
    }
  }
  return null;
}

String? validateCatalogLink(BuildContext context, String? value) {
  if (value!.isEmpty) {
    return appStrings(context).invalidCatalogLinkError;
  } else {
    return null;
  }
}

String? validateLocation(BuildContext context, String? value) {
  if (value!.isEmpty) {
    return appStrings(context).locationEmptyError;
  } else {
    return null;
  }
}

String? validateCompanyLogo(BuildContext context, String? value) {
  if (value!.isEmpty) {
    return appStrings(context).logoEmptyError;
  } else {
    return null;
  }
}

String? validateProfileLink(BuildContext context, String? value) {
  if (value!.isEmpty) {
    return appStrings(context).invalidProfileLinkError;
  } else {
    return null;
  }
}

String? validateEmail(
  BuildContext context,
  String? value,
) {
  const String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  final RegExp regExp = RegExp(pattern);
  if (value!.isEmpty) {
    return appStrings(context).emailEmptyError;
  } else if (!regExp.hasMatch(value)) {
    return appStrings(context).invalidEmailError;
  } else {
    return null;
  }
}

String? validatePassword(BuildContext context, String? value) {
  const String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  // Contains at least one uppercase letter (A-Z).
  // Contains at least one lowercase letter (a-z).
  // Contains at least one digit (0-9).
  // Contains at least one special character (!@#\$&*~).
  // Is at least 8 characters long.
  final RegExp regExp = RegExp(pattern);
  if (value!.isEmpty) {
    return appStrings(context).passwordEmptyError;
  } else if (!regExp.hasMatch(value)) {
    return appStrings(context).passwordInvalidError;
  } else {
    return null;
  }
}

String? validateEmptyPassword(BuildContext context, String? value) {
  if (value!.isEmpty) {
    return appStrings(context).passwordEmptyError;
  } else {
    return null;
  }
}

//
// String? validateCurrency(BuildContext context, String? value) {
//   if (value == null || value.isEmpty) {
//     return appStrings(context).currencyNameEmptyValidationMsg;
//   }
//   return null;
// }

String? validateCountry(BuildContext context, String? value) {
  if (value == null || value.isEmpty) {
    return appStrings(context).countryNameEmptyValidationMsg;
  }
  return null;
}

String? validateCountryCode(BuildContext context, String? value) {
  if (value == null || value.isEmpty) {
    return appStrings(context).countryCodeEmptyValidationMsg;
  }
  return null;
}

String? validateCurrency(BuildContext context, String? value) {
  if (value == null || value.isEmpty) {
    return appStrings(context).currencyEmptyValidationMsg;
  }
  return null;
}

/// Validate phone number using phone_numbers_parser package
///
String? validatePhoneNumber(
  BuildContext context,
  String? value,
  String isoCode, {
  bool showErrorForEmpty = false,
}) {
  if (!context.mounted) return null;
  // If value is empty or null
  if (value == null || value.isEmpty) {
    return showErrorForEmpty
        ? appStrings(context).phoneNumberEmptyErrorMsg
        : null;
  }

  // Try to find matching IsoCode, default to JO (Jordan) if not found
  final isoCodeStr = IsoCode.values.firstWhere(
    (e) => e.name == isoCode.toUpperCase(),
    orElse: () => IsoCode.JO, // Default to Jordan if ISO code not found
  );

  /// Validate phone number using the iso code
  ///
  bool isValidNumber =
      PhoneNumber.parse(value, callerCountry: isoCodeStr).isValid();
  printf("isValid-------$isValidNumber");
  if (!isValidNumber) {
    return appStrings(context).phoneNumberValidErrorMsg;
  }
  return null;
}

/// TODO: Validate phone number using country_phone_validator package
///

// String? validatePhoneNumber(
//   BuildContext context,
//   String? value,
//   String isoCode, {
//   bool showErrorForEmpty = false,
// }) {
//   // If value is empty or null
//   if (value == null || value.isEmpty) {
//     return showErrorForEmpty
//         ? appStrings(context).phoneNumberEmptyErrorMsg
//         : null;
//   }
//
//   // Convert ISO code to dial code
//   Country? country = CountryUtils.getCountryByIsoCode(isoCode);
//   String? dialCode = country?.dialCode;
//
//   if (dialCode == null) {
//     return appStrings(context)
//         .phoneNumberValidErrorMsg; // Add this to appStrings
//   }
//
//   // Validate phone number using the dial code
//   bool isValid = CountryUtils.validatePhoneNumber(value, dialCode);
//
//   if (!isValid) {
//     return appStrings(context).phoneNumberValidErrorMsg;
//   }
//
//   return null;
// }

String? validateNotes(BuildContext context, String? value) {
  if (value!.isEmpty) {
    return appStrings(context).notesEmptyErrorMsg;
  } else {
    return null;
  }
}

String? validatePriceRange(
    BuildContext context, String? startValue, String? endValue,
    {required bool isStartField}) {
  // Parse the values
  double? start = double.tryParse(startValue ?? "");
  double? end = double.tryParse(endValue ?? "");

  // If either value is null or empty, validation passes
  if (start == null || end == null) {
    return null;
  }

  // Check the range condition
  if (isStartField && start > end) {
    return appStrings(context).fromLessThanOrEqualToTo;
  } else if (!isStartField && end < start) {
    return appStrings(context).toGreaterThanOrEqualToFrom;
  }

  // Validation passed
  return null;
}

String? validateConfirmPassword(
  BuildContext context,
  String? passwordValue,
  String? confirmPasswordValue,
) {
  if (passwordValue!.isEmpty) {
    return appStrings(context).confirmPasswordEmptyError;
  } else if (passwordValue != confirmPasswordValue) {
    return appStrings(context).passwordNotMatchError;
  } else {
    return null;
  }
}

int? convertYearTo4Digits(int year) {
  if (year < 100 && year >= 0) {
    var now = DateTime.now();
    String currentYear = now.year.toString();
    String prefix = currentYear.substring(0, currentYear.length - 2);
    year = int.parse('$prefix${year.toString().padLeft(2, '0')}');
  }
  return year;
}
