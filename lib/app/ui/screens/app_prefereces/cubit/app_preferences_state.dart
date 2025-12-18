part of 'app_preferences_cubit.dart';

sealed class AppPreferencesState extends Equatable {
  const AppPreferencesState();
}

final class AppPreferencesInitial extends AppPreferencesState {
  @override
  List<Object> get props => [];
}

class AppPreferencesUpdated extends AppPreferencesState {
  final bool isDarkMode;
  final String languageCode;
  final bool isArabicSelected;

  const AppPreferencesUpdated({
    required this.isDarkMode,
    required this.languageCode,
    required this.isArabicSelected,
  });

  @override
  List<Object> get props => [];
}

class LanguageChangeInProgress extends AppPreferencesState {
  @override
  List<Object> get props => [];
}

class DarkModeChangeInProgress extends AppPreferencesState {
  @override
  List<Object> get props => [];
}
