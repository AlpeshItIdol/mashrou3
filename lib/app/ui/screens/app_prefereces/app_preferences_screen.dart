import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mashrou3/app/ui/custom_widget/app_bar_mixin.dart';
import 'package:mashrou3/app/ui/screens/app_prefereces/cubit/app_preferences_cubit.dart';
import 'package:mashrou3/config/resources/app_assets.dart';
import 'package:mashrou3/config/resources/app_colors.dart';
import 'package:mashrou3/utils/app_localization.dart';
import 'package:mashrou3/utils/ui_components.dart';

import '../../../db/app_preferences.dart';

class AppPreferencesScreen extends StatefulWidget {
  const AppPreferencesScreen({super.key});

  @override
  State<AppPreferencesScreen> createState() => _AppPreferencesScreenState();
}

class _AppPreferencesScreenState extends State<AppPreferencesScreen>
    with AppBarMixin {
  var selectedRole = "";

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    selectedRole = await GetIt.I<AppPreferences>().getUserRole() ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        context: context,
        requireLeading: true,
        title: appStrings(context).appPreferences,
      ),
      body: SingleChildScrollView(
        child: _buildBlocConsumer,
      ),
    );
  }

  /// Build bloc consumer widget.
  ///
  Widget get _buildBlocConsumer {
    return BlocConsumer<AppPreferencesCubit, AppPreferencesState>(
      listener: buildBlocListener,
      builder: (context, state) {
        AppPreferencesCubit cubit = context.read<AppPreferencesCubit>();
        cubit.initializePreferences();
        bool langSwitchValue = cubit.isArabicSelected;
        bool modeSwitchValue = cubit.isDarkModeEnabled;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
          child: Column(
            children: [
              UIComponent.customDrawerListItem(
                  clipPath: modeSwitchValue
                      ? SVGAssets.langLightIcon
                      : SVGAssets.langIcon,
                  tileName: appStrings(context).switchToArabic,
                  tileTextStyle: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                  onTap: () {},
                  buildContext: context,
                  trailing: Transform.scale(
                    scale: 1,
                    child: Switch(
                      value: langSwitchValue,
                      activeTrackColor: AppColors.colorPrimary,
                      onChanged: (value) async {
                        cubit.toggleLanguage(
                            value, context); // Update switch value

                        setState(() {});
                      },
                    ),
                  )),
              UIComponent.customDrawerListItem(
                  clipPath:
                      modeSwitchValue ? SVGAssets.sunIcon : SVGAssets.moonIcon,
                  tileName: modeSwitchValue
                      ? appStrings(context).switchToLightMode
                      : appStrings(context).switchToDarkMode,
                  tileTextStyle: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                  onTap: () {},
                  buildContext: context,
                  trailing: Transform.scale(
                    scale: 1,
                    child: Switch(
                      value: modeSwitchValue,
                      activeTrackColor: AppColors.colorPrimary,
                      onChanged: (value) {
                        cubit.toggleDarkMode(value); // Update switch value
                      },
                    ),
                  ))
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Build bloc listener widget.
  ///
  void buildBlocListener(BuildContext context, AppPreferencesState state) {}
}
