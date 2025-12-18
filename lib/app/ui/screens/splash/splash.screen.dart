import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashrou3/utils/extensions.dart';

import '../../../../config/resources/app_assets.dart';
import '../../../../config/resources/app_colors.dart';
import '../../../../config/resources/app_values.dart';
import '../app_prefereces/cubit/app_preferences_cubit.dart';
import 'cubit/splash_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SplashCubit>().getData(context);
  }

  @override
  Widget build(BuildContext context) {
    AppValues.screenWidth = MediaQuery.of(context).size.width;
    AppValues.screenHeight = MediaQuery.of(context).size.height;
    SplashCubit cubit = context.read<SplashCubit>();
    return Scaffold(
      backgroundColor: AppColors.pageBackground.forLightMode(context),
      body: _buildCenterLogo(context),
    );
  }

  /// Build center logo
  Widget _buildCenterLogo(BuildContext context) {
    SplashCubit cubit = context.read<SplashCubit>();
    return BlocConsumer<SplashCubit, SplashState>(
      listener: buildBlocListener,
      builder: (_, __) {
        return Center(child: _buildAvatar(context));
      },
    );
  }

  /// Build bloc listener widget.
  Future<void> buildBlocListener(
      BuildContext context, SplashState state) async {
    if (!mounted) {
      return;
    }
    if (state is SplashInitial) {
      context.read<SplashCubit>().navigateToScreen();
    } else if (state is InitialiseComplete) {
      context.read<SplashCubit>().handleSplashNavigation(context);
    }
  }

  /// build app logo
  Widget _buildAvatar(BuildContext context) {
    return BlocConsumer<AppPreferencesCubit, AppPreferencesState>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = context.watch<AppPreferencesCubit>();
        final isDark = cubit.isDarkModeEnabled;

        return isDark
            ? Container(
                height: AppValues.screenHeight,
                decoration: BoxDecoration(gradient: AppColors.primaryGradient),
                child: Center(
                  child: SizedBox(height: AppValues.screenWidth * 0.8, child: AppAssets.splashLogoDarkThemeImg.toAssetImage()),
                ),
              )
            : Container(
                padding: EdgeInsets.only(right: 20),
                height: AppValues.screenHeight,
                decoration: const BoxDecoration(color: AppColors.white),
                child: Center(
                  child: SizedBox(height: AppValues.screenWidth * 0.9, child: AppAssets.splashLogoLightThemeImg.toAssetImage()),
                ),
              );
      },
    );
  }
}
