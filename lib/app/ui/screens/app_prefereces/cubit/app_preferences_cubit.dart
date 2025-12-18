import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mashrou3/app/bloc/common_api_services/common_api_cubit.dart';
import 'package:mashrou3/app/db/app_preferences.dart';
import 'package:mashrou3/app/ui/screens/dashboard/cubit/dashboard_cubit.dart';

import '../../../../../config/resources/app_strings.dart';
import '../../../owner_screens/dashboard/cubit/owner_dashboard_cubit.dart';

part 'app_preferences_state.dart';

class AppPreferencesCubit extends Cubit<AppPreferencesState> {
  AppPreferencesCubit() : super(AppPreferencesInitial());

  var selectedRole = "";
  String selectedLanguage = 'en';
  bool isArabicSelected = false;
  bool isDarkModeEnabled = false;

  Future<void> initializePreferences() async {
    isDarkModeEnabled = await GetIt.I<AppPreferences>().getIsDarkMode();
    selectedLanguage =
        await GetIt.I<AppPreferences>().getLanguageCode() ?? 'en';
    selectedRole = await GetIt.I<AppPreferences>().getUserRole() ?? "";
    isArabicSelected = selectedLanguage == 'ar';

    emit(AppPreferencesUpdated(
      isDarkMode: isDarkModeEnabled,
      languageCode: selectedLanguage,
      isArabicSelected: isArabicSelected,
    ));
  }

  Future<void> toggleLanguage(bool isArabic, BuildContext context) async {
    emit(LanguageChangeInProgress());
    selectedLanguage = isArabic ? 'ar' : 'en';
    isArabicSelected = isArabic;

    await GetIt.I<AppPreferences>().setLanguageCode(selectedLanguage);
    var isDarkMode = await GetIt.I<AppPreferences>().getIsDarkMode();
    isDarkModeEnabled = isDarkMode;

    var userRole = await GetIt.I<AppPreferences>().getUserRole();
    if (userRole != AppStrings.guest) {
      await context.read<CommonApiCubit>().updateLang();
    }

    emit(AppPreferencesUpdated(
      isDarkMode: isDarkModeEnabled,
      languageCode: selectedLanguage,
      isArabicSelected: isArabicSelected,
    ));
  }

  Future<void> toggleDarkMode(bool isEnabled) async {
    emit(DarkModeChangeInProgress());
    isDarkModeEnabled = isEnabled;
    await GetIt.I<AppPreferences>().setIsDarkMode(value: isDarkModeEnabled);

    emit(AppPreferencesUpdated(
      isDarkMode: isDarkModeEnabled,
      languageCode: selectedLanguage,
      isArabicSelected: isArabicSelected,
    ));
  }
}
