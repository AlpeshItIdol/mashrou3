import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mashrou3/app/model/drawer_options.dart';
import 'package:mashrou3/app/navigation/routes.dart';
import 'package:mashrou3/app/navigation/route_arguments.dart';
import 'package:mashrou3/app/ui/custom_widget/common_row_bottons.dart';
import 'package:mashrou3/app/ui/custom_widget/side_drawer_widget/side_drawer_cubit.dart';
import 'package:mashrou3/app/ui/screens/app_prefereces/cubit/app_preferences_cubit.dart';
import 'package:mashrou3/app/ui/screens/dashboard/sub_screens/favourite/cubit/favourite_cubit.dart';
import 'package:mashrou3/app/ui/screens/dashboard/sub_screens/home/cubit/home_cubit.dart';
import 'package:mashrou3/app/ui/screens/filter/cubit/fav_filter_cubit.dart';
import 'package:mashrou3/app/ui/screens/filter/cubit/filter_cubit.dart';
import 'package:mashrou3/app/ui/screens/filter/model/filter_request_model.dart';
import 'package:mashrou3/app/ui/screens/personal_information/cubit/personal_information_cubit.dart';
import 'package:mashrou3/config/resources/app_assets.dart';
import 'package:mashrou3/config/resources/app_strings.dart';
import 'package:mashrou3/config/utils.dart';
import 'package:mashrou3/utils/app_localization.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:mashrou3/utils/ui_components.dart';

import '../../../../config/resources/app_colors.dart';
import '../../../../config/services/property_vendor_finance_service.dart';
import '../../../db/app_preferences.dart';
import '../../../db/session_tracker.dart';

class SideDrawerWidget extends StatefulWidget {
  final VoidCallback onLogout;
  final VoidCallback onCancel;
  final VoidCallback onDeleteAccount;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const SideDrawerWidget({
    super.key,
    required this.onLogout,
    required this.onCancel,
    required this.onDeleteAccount,
    required this.scaffoldKey,
  });

  @override
  State<SideDrawerWidget> createState() => _SideDrawerWidgetState();
}

class _SideDrawerWidgetState extends State<SideDrawerWidget> {
  @override
  void initState() {
    context.read<SideDrawerCubit>().initializeData();
    super.initState();
  }

  Future<void> _handleLogout() async {
    // Reset preferences
    context.read<HomeCubit>().filterRequestModel = FilterRequestModel();
    context.read<FilterCubit>().resetAndClearFilters(context);
    context.read<FavouriteCubit>().filterRequestModel = FilterRequestModel();
    context.read<FavFilterCubit>().resetAndClearFilters(context);
    await SessionTracker().onLogout();
    await GetIt.I<AppPreferences>().clearData();
    _navigateToRoute(routeName: Routes.kLoginScreen, isForLogout: true);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SideDrawerCubit, SideDrawerState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = context.read<SideDrawerCubit>();
        var licenceUrl =
            "https://docs.google.com/gview?embedded=true&url=${cubit.supportData.license?.url ?? ""}";
        final double drawerWidth = MediaQuery.of(context).size.width * 0.9;
        final bool shouldHideRequestedAndVisitedProperties =
            cubit.userRoleType == AppStrings.owner;

        return Drawer(
          width: drawerWidth,
          backgroundColor: Theme.of(context).cardColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BlocConsumer<PersonalInformationCubit,
                    PersonalInformationState>(
                  listener: (context, state) {
                    if (state is CompleteProfileSuccess) {
                      context.read<SideDrawerCubit>().initializeData();
                    }
                  },
                  builder: (context, state) {
                    return UIComponent.buildUserProfileWidget(
                      isGuest: cubit.isGuest,
                      isVisitor: cubit.isVisitor,
                      context: context,
                      userName: cubit.userName,
                      imageStr: cubit.userImg,
                      userRoleType: cubit.userRoleType,
                    );
                  },
                ),
                12.verticalSpace,
                BlocConsumer<SideDrawerCubit, SideDrawerState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    return Expanded(
                      child: _buildDrawerList(cubit.isGuest
                          ? [
                              DrawerOption(
                                icon: Utils.isDark(context)
                                    ? SVGAssets.scrollWhiteIcon
                                    : SVGAssets.scrollIcon,
                                title: appStrings(context).policies_support,
                                onTap: () {
                                  widget.scaffoldKey.currentState
                                      ?.closeDrawer();
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    context.pushNamed(
                                      Routes.kCmsScreen,
                                      extra: licenceUrl,
                                    );
                                  });
                                },
                              ),
                              DrawerOption(
                                icon: Utils.isDark(context)
                                    ? SVGAssets.prefLightIcon
                                    : SVGAssets.prefIcon,
                                title: appStrings(context).appPreferences,
                                onTap: () => _navigateToRoute(
                                    routeName: Routes.kAppPreferencesScreen),
                              ),
                            ]
                          : cubit.isVendor
                              ? [
                                  DrawerOption(
                                    icon: Utils.isDark(context)
                                        ? SVGAssets.userLightIcon
                                        : SVGAssets.userIcon,
                                    title:
                                        appStrings(context).personalInformation,
                                    onTap: () => _navigateToRoute(
                                        routeName:
                                            Routes.kPersonalInformationScreen),
                                  ),
                                  DrawerOption(
                                      icon: Utils.isDark(context)
                                          ? SVGAssets.clockLightIconFilled
                                          : SVGAssets.clockIcon,
                                      title:
                                          appStrings(context).recentlyVisited,
                                      onTap: () {
                                        widget.scaffoldKey.currentState
                                            ?.closeDrawer();
                                        context.pushNamed(
                                            Routes
                                                .kRecentlyVisitedPropertiesList,
                                            extra: false);
                                      }),
                                  DrawerOption(
                                      icon: Utils.isDark(context)
                                          ? SVGAssets.propertiesWithOffersWhite
                                          : SVGAssets.propertiesWithOffers,
                                      title: appStrings(context)
                                          .lblPropertiesWithOffers,
                                      onTap: () {
                                        widget.scaffoldKey.currentState
                                            ?.closeDrawer();
                                        context.pushNamed(
                                            Routes
                                                .kRecentlyVisitedPropertiesList,
                                            extra: true);
                                      }),
                                  DrawerOption(
                                    icon: Utils.isDark(context)
                                        ? SVGAssets.financeRequestWhiteIcon
                                        : SVGAssets.financeRequestIcon,
                                    title: appStrings(context).financeRequest,
                                    onTap: () => _navigateToRoute(
                                        routeName:
                                            Routes.kFinanceRequestScreen),
                                  ),
                                  if (shouldHideRequestedAndVisitedProperties)
                                    DrawerOption(
                                      icon: Utils.isDark(context)
                                          ? SVGAssets.calenderWhite
                                          : SVGAssets.calenderPrimaryIcon,
                                      title:
                                          appStrings(context).lblVisitRequests,
                                      onTap: () => _navigateToRoute(
                                          routeName: Routes.kVisitRequestsList),
                                    ),
                                  DrawerOption(
                                    icon: Utils.isDark(context)
                                        ? SVGAssets.scrollWhiteIcon
                                        : SVGAssets.scrollIcon,
                                    title: appStrings(context).policies_support,
                                    onTap: () {
                                      widget.scaffoldKey.currentState
                                          ?.closeDrawer();
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        context.pushNamed(
                                          Routes.kCmsScreen,
                                          extra: licenceUrl,
                                        );
                                      });
                                    },
                                  ),
                                  DrawerOption(
                                    icon: Utils.isDark(context)
                                        ? SVGAssets.prefLightIcon
                                        : SVGAssets.prefIcon,
                                    title: appStrings(context).appPreferences,
                                    onTap: () => context.pushNamed(
                                        Routes.kAppPreferencesScreen),
                                  ),
                                ]
                              : [
                                  DrawerOption(
                                    icon: Utils.isDark(context)
                                        ? SVGAssets.userLightIcon
                                        : SVGAssets.userIcon,
                                    title:
                                        appStrings(context).personalInformation,
                                    onTap: () => _navigateToRoute(
                                        routeName:
                                            Routes.kPersonalInformationScreen),
                                  ),
                                  if (!shouldHideRequestedAndVisitedProperties)
                                    DrawerOption(
                                        icon: Utils.isDark(context)
                                            ? SVGAssets.clockLightIconFilled
                                            : SVGAssets.clockIcon,
                                        title:
                                            appStrings(context).recentlyVisited,
                                        onTap: () {
                                          widget.scaffoldKey.currentState
                                              ?.closeDrawer();
                                          context.pushNamed(
                                              Routes
                                                  .kRecentlyVisitedPropertiesList,
                                              extra: false);
                                        }),
                                  if (!shouldHideRequestedAndVisitedProperties)
                                    DrawerOption(
                                      icon: Utils.isDark(context)
                                          ? SVGAssets.calenderWhite
                                          : SVGAssets.calenderPrimaryIcon,
                                      title: appStrings(context)
                                          .requestedProperties,
                                      onTap: () => _navigateToRoute(
                                          routeName:
                                              Routes.kRequestedPropertiesList),
                                    ),
                                  if (!shouldHideRequestedAndVisitedProperties)
                                    DrawerOption(
                                      icon: Utils.isDark(context)
                                          ? SVGAssets.financeRequestWhiteIcon
                                          : SVGAssets.financeRequestIcon,
                                      title: appStrings(context).financeRequest,
                                      onTap: () => _navigateToRoute(
                                          routeName:
                                              Routes.kFinanceRequestScreen),
                                    ),
                                  if (shouldHideRequestedAndVisitedProperties)
                                    DrawerOption(
                                      icon: Utils.isDark(context)
                                          ? SVGAssets.calenderWhite
                                          : SVGAssets.calenderPrimaryIcon,
                                      title:
                                          appStrings(context).lblVisitRequests,
                                      onTap: () => _navigateToRoute(
                                          routeName: Routes.kVisitRequestsList),
                                    ),
                                  DrawerOption(
                                    icon: Utils.isDark(context)
                                        ? SVGAssets.scrollWhiteIcon
                                        : SVGAssets.scrollIcon,
                                    title: appStrings(context).policies_support,
                                    onTap: () {
                                      widget.scaffoldKey.currentState
                                          ?.closeDrawer();
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        context.pushNamed(
                                          Routes.kCmsScreen,
                                          extra: licenceUrl,
                                        );
                                      });
                                    },
                                  ),
                                  DrawerOption(
                                    icon: Utils.isDark(context)
                                        ? SVGAssets.prefLightIcon
                                        : SVGAssets.prefIcon,
                                    title: appStrings(context).appPreferences,
                                    onTap: () => context.pushNamed(
                                        Routes.kAppPreferencesScreen),
                                  ),
                                  DrawerOption(
                                    icon: Utils.isDark(context)
                                        ? SVGAssets.scrollWhiteIcon
                                        : SVGAssets.scrollIcon,
                                    title: appStrings(context).lblBanks,
                                    onTap: () {
                                      widget.scaffoldKey.currentState?.closeDrawer();
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        context.pushNamed(
                                          Routes.kBanksListScreen,
                                        );
                                      });
                                    },
                                  ),
                                  DrawerOption(
                                    icon: Utils.isDark(context)
                                        ? SVGAssets.prefLightIcon
                                        : SVGAssets.prefIcon,
                                    title: appStrings(context).textVendor,
                                    onTap: () => context
                                        .pushNamed(Routes.kDrawerVendorList),
                                  ),
                                ]),
                    );
                  },
                ),
                UIComponent.createDestinationWithLabel(
                  labelText: cubit.isGuest
                      ? appStrings(context).lblLogIn
                      : appStrings(context).logout,
                  context: context,
                  containerColor: Theme.of(context).cardColor,
                  textStyle: Theme.of(context).textTheme.titleMedium,
                  onTap: cubit.isGuest
                      ? _handleLogout
                      : () => UIComponent.showCustomBottomSheet(
                            context: context,
                            builder: _buildLogoutBottomSheet(cubit.isGuest),
                          ),
                ),
                Text(
                  AppStrings.liveVersion,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: Theme.of(context).primaryColor),
                ),
                8.verticalSpace,
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToRoute({String? routeName, bool isForLogout = false}) {
    widget.scaffoldKey.currentState?.closeDrawer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      routeName != null
          ? isForLogout
              ? context.goNamed(routeName)
              : context.pushNamed(routeName)
          : widget.scaffoldKey.currentState!.closeDrawer();
    });
  }

  Widget _buildLogoutBottomSheet(bool isGuest) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        UIComponent.customRTLIcon(
            child: SVGAssets.logoutIcon.toSvg(context: context),
            context: context),
        12.verticalSpace,
        Text(
          appStrings(context).wantToLogOut,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        8.verticalSpace,
        Text(
          appStrings(context).logoutInfo,
          style: Theme.of(context).textTheme.displaySmall,
          textAlign: TextAlign.center,
        ),
        20.verticalSpace,
        isGuest
            ? ButtonRow(
                leftButtonText: appStrings(context).cancel,
                rightButtonText: appStrings(context).logout,
                onLeftButtonTap: widget.onCancel,
                onRightButtonTap: widget.onLogout,
                rightButtonBorderColor: AppColors.red00,
              )
            : ButtonRow(
                isRightButtonGradient: false,
                isRightButtonBorderRequired: true,
                isLeftButtonBorderRequired: true,
                leftButtonText: appStrings(context).cancel,
                rightButtonText: appStrings(context).logout,
                onLeftButtonTap: widget.onCancel,
                onRightButtonTap: widget.onLogout,
                rightButtonBgColor: AppColors.white,
                rightButtonTextColor: AppColors.red00,
                rightButtonBorderColor: AppColors.red00,
                leftButtonBorderColor: AppColors.black3D,
              ),
      ],
    );
  }

  Widget _buildDrawerList(List<DrawerOption> options) {
    return options.isEmpty
        ? Center(
            child: Text(
              appStrings(context).noItemsAvailable,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          )
        : BlocConsumer<AppPreferencesCubit, AppPreferencesState>(
            listener: (context, state) {},
            builder: (context, state) {
              final cubit = context.watch<AppPreferencesCubit>();
              final isArabic = cubit.isArabicSelected;
              final arrowIcon =
                  isArabic ? SVGAssets.arrowLeftIcon : SVGAssets.arrowRightIcon;
              return ListView.builder(
                shrinkWrap: true,
                itemCount: options.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  final item = options[index];
                  return UIComponent.customDrawerListItem(
                    clipPath: item.icon,
                    tileName: item.title,
                    onTap: item.onTap,
                    trailing: arrowIcon.toSvg(
                        context: context,
                        color: Theme.of(context).primaryColor),
                    buildContext: context,
                  );
                },
              );
            },
          );
  }
}
