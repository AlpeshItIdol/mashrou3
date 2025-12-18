import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mashrou3/config/resources/app_assets.dart';
import 'package:mashrou3/config/resources/app_strings.dart';
import 'package:mashrou3/utils/extensions.dart';

import '../../../../config/resources/app_colors.dart';
import '../../../../config/utils.dart';
import '../../../../utils/app_localization.dart';
import '../../../../utils/ui_components.dart';
import '../../../db/app_preferences.dart';
import '../../../model/verify_response.model.dart';
import '../../../navigation/routes.dart';
import '../common_row_bottons.dart';
import 'bottom_navigation_cubit.dart';

class BottomNavigationWidget extends StatefulWidget {
  final String userRole;
  final bool isGuest;

  const BottomNavigationWidget({
    super.key,
    required this.userRole,
    this.isGuest = false,
  });

  @override
  State<BottomNavigationWidget> createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  bool isGuest = false;
  bool isVisitor = false;
  String userName = "";
  String userRoleType = AppStrings.visitor;
  VerifyResponseData? userSavedData;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      // Fetch user preferences
      isGuest = await GetIt.I<AppPreferences>().getIsGuestUser();
      userSavedData = await GetIt.I<AppPreferences>().getUserDetails() ??
          VerifyResponseData();

      // Assign user-related data
      userName =
          "${userSavedData?.users?.firstName ?? ""} ${userSavedData?.users?.lastName ?? ""}"
              .trim();
      userRoleType = userSavedData?.users?.userType ?? AppStrings.visitor;
      isVisitor = userRoleType == AppStrings.visitor;

      // Update UI
      setState(() {});
    } catch (e, stackTrace) {
      // Log errors
      printf("Error initializing SideDrawerWidget: $e\n$stackTrace");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavCubit, int>(
      builder: (context, selectedIndex) {
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: AppColors.colorPrimary.withOpacity(0.1),
                spreadRadius: 0,
                blurRadius: 18,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            child: MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: NavigationBar(
                selectedIndex: selectedIndex,
                onDestinationSelected: (int index) {
                  // If isGuest is true and the index is 1 or 2 (second or third), show bottom sheet instead
                  if (isGuest && (index == 1 || index == 2)) {
                    _showBottomSheet(context);
                  } else {
                    context.read<BottomNavCubit>().selectIndex(index);
                  }
                },
                destinations: widget.userRole == AppStrings.visitor
                    ? [
                        NavigationDestination(
                          icon: Utils.isDark(context)
                              ? SVGAssets.homeLightIcon.toSvg(context: context)
                              : SVGAssets.homeIcon.toSvg(context: context),
                          label: appStrings(context).lblHome,
                          selectedIcon: Utils.isDark(context)
                              ? SvgPicture.asset(
                                  SVGAssets.homeLightSelectedIcon,
                                )
                              : SvgPicture.asset(
                                  SVGAssets.homeSelectedIcon,
                                ),
                        ),
                        NavigationDestination(
                          icon: Utils.isDark(context)
                              ? SVGAssets.favouriteLightIcon
                                  .toSvg(context: context)
                              : SVGAssets.favouriteIcon.toSvg(context: context),
                          label: appStrings(context).lblFavourite,
                          selectedIcon: Utils.isDark(context)
                              ? SvgPicture.asset(
                                  SVGAssets.favouriteLightSelectedIcon,
                                )
                              : SvgPicture.asset(
                                  SVGAssets.favouriteSelectedIcon,
                                ),
                        ),
                        NavigationDestination(
                          icon: Utils.isDark(context)
                              ? SVGAssets.notificationLightIcon
                                  .toSvg(context: context)
                              : SVGAssets.notificationIcon
                                  .toSvg(context: context),
                          label: appStrings(context).lblNotification,
                          selectedIcon: Utils.isDark(context)
                              ? SvgPicture.asset(
                                  SVGAssets.notificationLightSelectedIcon,
                                )
                              : SvgPicture.asset(
                                  SVGAssets.notificationSelectedIcon,
                                ),
                        ),
                      ]
                    : widget.userRole == AppStrings.vendor
                        ? [
                            NavigationDestination(
                              icon: Utils.isDark(context)
                                  ? SVGAssets.homeLightIcon
                                      .toSvg(context: context)
                                  : SVGAssets.homeIcon.toSvg(context: context),
                              label: appStrings(context).lblHome,
                              selectedIcon: Utils.isDark(context)
                                  ? SvgPicture.asset(
                                      SVGAssets.homeLightSelectedIcon,
                                    )
                                  : SvgPicture.asset(
                                      SVGAssets.homeSelectedIcon,
                                    ),
                            ),
                            NavigationDestination(
                              icon: Utils.isDark(context)
                                  ? SVGAssets.favouriteLightIcon
                                      .toSvg(context: context)
                                  : SVGAssets.favouriteIcon
                                      .toSvg(context: context),
                              label: appStrings(context).lblFavourite,
                              selectedIcon: Utils.isDark(context)
                                  ? SvgPicture.asset(
                                      SVGAssets.favouriteLightSelectedIcon,
                                    )
                                  : SvgPicture.asset(
                                      SVGAssets.favouriteSelectedIcon,
                                    ),
                            ),
                            NavigationDestination(
                              icon: Utils.isDark(context)
                                  ? SVGAssets.myOfferLightIcon
                                      .toSvg(context: context)
                                  : SVGAssets.myOfferIcon
                                      .toSvg(context: context),
                              label: appStrings(context).lblMyOffer,
                              selectedIcon: Utils.isDark(context)
                                  ? SvgPicture.asset(
                                      SVGAssets.myOfferLightSelectedIcon,
                                    )
                                  : SvgPicture.asset(
                                      SVGAssets.myOfferSelectedIcon,
                                    ),
                            ),
                            NavigationDestination(
                              icon: Utils.isDark(context)
                                  ? SVGAssets.notificationLightIcon
                                      .toSvg(context: context)
                                  : SVGAssets.notificationIcon
                                      .toSvg(context: context),
                              label: appStrings(context).lblNotification,
                              selectedIcon: Utils.isDark(context)
                                  ? SvgPicture.asset(
                                      SVGAssets.notificationLightSelectedIcon,
                                    )
                                  : SvgPicture.asset(
                                      SVGAssets.notificationSelectedIcon,
                                    ),
                            ),
                          ]
                        : [
                            NavigationDestination(
                              icon: Utils.isDark(context)
                                  ? SVGAssets.homeLightIcon
                                      .toSvg(context: context)
                                  : SVGAssets.homeIcon.toSvg(context: context),
                              label: appStrings(context).lblHome,
                              selectedIcon: Utils.isDark(context)
                                  ? SvgPicture.asset(
                                      SVGAssets.homeLightSelectedIcon,
                                    )
                                  : SvgPicture.asset(
                                      SVGAssets.homeSelectedIcon,
                                    ),
                            ),
                            NavigationDestination(
                              icon: Utils.isDark(context)
                                  ? SVGAssets.clockLightIconFilled.toSvg(
                                      context: context,
                                      height: 24,
                                      width: 24,
                                    )
                                  : SVGAssets.clock2Icon
                                      .toSvg(context: context),
                              label: appStrings(context).inReview,
                              selectedIcon: Utils.isDark(context)
                                  ? SvgPicture.asset(
                                      SVGAssets.clockLightIconFilled,
                                      height: 24,
                                      width: 24,
                                    )
                                  : SVGAssets.clockIcon.toSvg(
                                      height: 24, width: 24, context: context),
                            ),
                            NavigationDestination(
                              icon: Utils.isDark(context)
                                  ? SVGAssets.notificationLightIcon
                                      .toSvg(context: context)
                                  : SVGAssets.notificationIcon
                                      .toSvg(context: context),
                              label: appStrings(context).lblNotification,
                              selectedIcon: Utils.isDark(context)
                                  ? SvgPicture.asset(
                                      SVGAssets.notificationLightSelectedIcon,
                                    )
                                  : SvgPicture.asset(
                                      SVGAssets.notificationSelectedIcon,
                                    ),
                            ),
                          ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showBottomSheet(BuildContext context) {
    UIComponent.showCustomBottomSheet(
        context: context,
        builder: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppAssets.loginToContinueImg.toAssetImage(height: 50, width: 50),
            12.verticalSpace,
            Text(
              appStrings(context).lblLogInToContinue,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            8.verticalSpace,
            Text(
              appStrings(context).textPleaseLogIn,
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
            20.verticalSpace,
            ButtonRow(
              leftButtonText: appStrings(context).cancel,
              rightButtonText: appStrings(context).lblLogIn,
              onLeftButtonTap: () {
                context.pop();
              },
              onRightButtonTap: () {
                context.pop();
                context.goNamed(Routes.kLoginScreen);
              },
              rightButtonBorderColor: AppColors.colorPrimary,
              leftButtonBgColor: Theme.of(context).cardColor,
              leftButtonBorderColor: Theme.of(context).primaryColor,
              leftButtonTextColor: Theme.of(context).primaryColor,
              rightButtonGradientColor: AppColors.primaryGradient,
              rightButtonTextColor: AppColors.white.forLightMode(context),
              isLeftButtonGradient: false,
              isRightButtonGradient: true,
              isLeftButtonBorderRequired: true,
              isRightButtonBorderRequired: true,
              padding: const EdgeInsetsDirectional.all(0),
            ),
          ],
        ));
  }
}
