import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mashrou3/config/resources/app_colors.dart';
import 'package:mashrou3/utils/extensions.dart';

import '../../../../../../config/resources/app_assets.dart';
import '../../../../../../config/resources/app_values.dart';
import '../../../../../../config/resources/text_styles.dart';
import '../../../../../../config/utils.dart';
import '../../../../../../utils/app_localization.dart';
import '../../../../../../utils/ui_components.dart';
import '../../../../config/resources/app_strings.dart';
import '../../../db/app_preferences.dart';
import '../../../navigation/routes.dart';
import '../../custom_widget/bottom_navigation_widget/bottom_navigation_cubit.dart';
import 'cubit/property_not_found_cubit.dart';

class PropertyNotFoundScreen extends StatefulWidget {
  const PropertyNotFoundScreen({super.key});

  @override
  State<PropertyNotFoundScreen> createState() => _PropertyNotFoundScreenState();
}

class _PropertyNotFoundScreenState extends State<PropertyNotFoundScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PropertyNotFoundCubit, PropertyNotFoundState>(
        listener: buildBlocListener,
        builder: (context, state) {
          return Scaffold(
            body: PopScope(
              canPop: false,
              onPopInvokedWithResult: (bool didPop, Object? result) async {
                context.pop();
                context.pop();
              },
              child: SingleChildScrollView(
                child: SizedBox(
                  height: AppValues.screenHeight,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SVGAssets.noPropertyFound.toSvg(context: context),
                        40.verticalSpace,
                        Text(
                          appStrings(context).textPropertyNotFound,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).primaryColor,
                              ),
                        ),
                        12.verticalSpace,
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            appStrings(context).textThePropertyYouAreLookingFor,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color:
                                      AppColors.black3D.forLightMode(context),
                                ),
                          ),
                        ),
                        24.verticalSpace,
                        UIComponent.customInkWellWidget(
                          onTap: () async {
                            context.read<BottomNavCubit>().selectIndex(0);
                            var selectedUserRole =
                                await GetIt.I<AppPreferences>().getUserRole() ??
                                    "";
                            if (selectedUserRole == AppStrings.owner) {
                              context.goNamed(Routes.kOwnerDashboard);
                            } else {
                              context.goNamed(Routes.kDashboard);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsetsDirectional.all(4),
                            width: AppValues.screenWidth / 3.4,
                            height: 48,
                            decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.symmetric(
                                  vertical: 2),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    appStrings(context).lblHome,
                                    textAlign: TextAlign.center,
                                    style: h16().copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        20.verticalSpace,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  /// Build bloc listener widget.
  Future<void> buildBlocListener(
      BuildContext context, PropertyNotFoundState state) async {
    if (state is PropertyNotFoundLoading) {
      // OverlayLoadingProgress.start(context);
    } else if (state is PropertyNotFoundSuccess) {
    } else if (state is PropertyNotFoundError) {
      Utils.showErrorMessage(
          context: context,
          message: state.errorMessage.contains('No internet')
              ? appStrings(context).noInternetConnection
              : state.errorMessage);
    }
  }
}
