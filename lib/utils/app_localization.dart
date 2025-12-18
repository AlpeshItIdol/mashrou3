import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

AppLocalizations appStrings(BuildContext context) {
  return AppLocalizations.of(context)!;
}

String localizedDistanceText(BuildContext context, int distance) {
  return AppLocalizations.of(context)!.upToDistance(distance);
}
