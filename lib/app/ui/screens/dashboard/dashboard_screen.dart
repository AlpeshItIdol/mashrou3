import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mashrou3/app/navigation/routes.dart';
import 'package:mashrou3/app/ui/custom_widget/app_bar_mixin.dart';
import 'package:mashrou3/app/ui/custom_widget/side_drawer_widget/side_drawer_widget.dart';
import 'package:mashrou3/app/ui/screens/app_prefereces/cubit/app_preferences_cubit.dart';
import 'package:mashrou3/app/ui/screens/dashboard/cubit/dashboard_cubit.dart';
import 'package:mashrou3/app/ui/screens/dashboard/sub_screens/favourite/cubit/favourite_cubit.dart';
import 'package:mashrou3/app/ui/screens/dashboard/sub_screens/favourite/favourite.screen.dart';
import 'package:mashrou3/app/ui/screens/dashboard/sub_screens/home/home.screen.dart';
import 'package:mashrou3/app/ui/screens/dashboard/sub_screens/my_offers_list/my_offers_list_screen.dart';
import 'package:mashrou3/app/ui/screens/dashboard/sub_screens/notification/notification.screen.dart';
import 'package:mashrou3/app/ui/screens/filter/cubit/filter_cubit.dart';
import 'package:mashrou3/app/ui/screens/filter/model/filter_request_model.dart';
import 'package:mashrou3/config/resources/app_colors.dart';
import 'package:mashrou3/config/resources/app_strings.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:mashrou3/utils/ui_components.dart';

import '../../../../config/resources/app_assets.dart';
import '../../../../config/services/fcm_helper.dart';
import '../../../../config/services/push_notification_service.dart';
import '../../../../config/utils.dart';
import '../../../../utils/app_localization.dart';
import '../../../../utils/location_manager.dart';
import '../../../db/app_preferences.dart';
import '../../../db/session_tracker.dart';
import '../../custom_widget/bottom_navigation_widget/bottom_navigation_cubit.dart';
import '../../custom_widget/bottom_navigation_widget/bottom_navigation_widget.dart';
import '../../custom_widget/loader/overlay_loading_progress.dart';
import 'sub_screens/home/cubit/home_cubit.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with AppBarMixin {
  final List<Widget> _pages = [
    HomeScreen(),
    FavouriteScreen(),
    NotificationScreen(),
  ];

  final List<Widget> _pagesForVendorRole = [
    HomeScreen(),
    FavouriteScreen(),
    MyOffersListScreen(),
    NotificationScreen(),
  ];

  @override
  void initState() {
    super.initState();
    FCMHelper().setupNotification(
      () {
        printf("called from dashboard");
        WidgetsBinding.instance.addPostFrameCallback(
            (_) => context.read<DashboardCubit>().saveFCMToken(context));
      },
    );
    context.read<DashboardCubit>().getData(context);
    context.read<BottomNavCubit>().selectIndex(0);
  }

  @override
  void dispose() {
    super.dispose();
    context.read<DashboardCubit>().scaffoldKey;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    DashboardCubit cubit = context.read<DashboardCubit>();
    return BlocConsumer<DashboardCubit, DashboardState>(
      listener: (context, state) async {
        if (state is LogoutLoading) {
          OverlayLoadingProgress.start(context);
        } else if (state is LogoutSuccess) {
          _handleLogout(context);
        } else if (state is LogoutError) {
          OverlayLoadingProgress.stop();
          Navigator.pop(context);
          Utils.showErrorMessage(
              context: context,
              message: state.errorMessage.contains('No internet')
                  ? appStrings(context).noInternetConnection
                  : state.errorMessage);
        }
      },
      builder: (context, state) {
        return BlocConsumer<BottomNavCubit, int>(
          listener: (context, state) async {
            cubit.selectedPageIndex = state;
            setState(() {
              context.read<DashboardCubit>().searchText = "";
            });
            if (cubit.selectedPageIndex == 0) {
              HomeCubit cubit = context.read<HomeCubit>();
              cubit.resetPropertyList();
              cubit.searchText =
                  context.read<DashboardCubit>().searchText ?? "";
              cubit.refreshData();
            } else if (cubit.selectedPageIndex == 1) {
              context.read<HomeCubit>().isBtnSelectPropertiesTapped = false;
              FavouriteCubit cubit = context.read<FavouriteCubit>();

              cubit.searchText =
                  context.read<DashboardCubit>().searchText ?? "";
              cubit.refreshPropertyFavList();
            }
          },
          builder: (context, state) {
            return PopScope(
              canPop: false,
              onPopInvokedWithResult: (bool didPop, Object? result) async {},
              child: AnnotatedRegion<SystemUiOverlayStyle>(
                value: const SystemUiOverlayStyle(
                  systemNavigationBarColor: Colors.white,
                  systemNavigationBarIconBrightness: Brightness.dark,
                ),
                child: BlocListener<FilterCubit, FilterState>(
                  listener: (context, state) {},
                  child:
                      BlocListener<AppPreferencesCubit, AppPreferencesState>(
                      listener: (context, state) {},
                      child: PopScope(
                        canPop: false,
                        onPopInvokedWithResult:
                            (bool didPop, Object? result) async {},
                        child: Scaffold(
                            key: cubit.scaffoldKey,
                            drawer: SideDrawerWidget(
                              onLogout: () async {
                                await cubit.logout();
                                if (!context.mounted) return;
                                context.pop();
                              },
                              onCancel: () {
                                context.pop();
                              },
                              onDeleteAccount: () {
                                context
                                    .pushReplacementNamed(Routes.kLoginScreen);
                              },
                              scaffoldKey: cubit.scaffoldKey,
                            ),
                            appBar: (cubit.selectedUserRole ==
                                        AppStrings.vendor &&
                                    cubit.selectedPageIndex == 3)
                                ? buildAppBar(
                                    context: context,
                                    requireMenu: true,
                                    onMenuTap: () {
                                      cubit.scaffoldKey.currentState!
                                          .openDrawer();
                                    },
                                    title: appStrings(context).lblNotifications,
                                  )
                                : (cubit.selectedUserRole ==
                                            AppStrings.vendor &&
                                        cubit.selectedPageIndex == 2)
                                    ? buildAppBar(
                                        context: context,
                                        requireMenu: true,
                                        onMenuTap: () {
                                          cubit.scaffoldKey.currentState!
                                              .openDrawer();
                                        },
                                        title: appStrings(context).lblMyOffers,
                                      )
                                    : (cubit.selectedPageIndex == 2)
                                        ? buildAppBar(
                                            context: context,
                                            requireMenu: true,
                                            onMenuTap: () {
                                              cubit.scaffoldKey.currentState!
                                                  .openDrawer();
                                            },
                                            title: appStrings(context)
                                                .lblNotifications,
                                          )
                                        : buildAppBar(
                                            context: context,
                                            requireMenu: true,
                                            requireLeading: true,
                                            requireSearchWidget: true,
                                            onMenuTap: () {
                                              cubit.scaffoldKey.currentState!
                                                  .openDrawer();
                                            },
                                            searchText: cubit.searchText,
                                            onCloseTap: () async {
                                              setState(() {
                                                context
                                                    .read<DashboardCubit>()
                                                    .searchText = "";
                                              });
                                              if (cubit.selectedPageIndex ==
                                                  0) {
                                                HomeCubit cubit =
                                                    context.read<HomeCubit>();
                                                cubit.resetPropertyList();
                                                cubit.searchText = context
                                                        .read<DashboardCubit>()
                                                        .searchText ??
                                                    "";
                                                cubit.refreshData();
                                              } else if (cubit
                                                      .selectedPageIndex ==
                                                  1) {
                                                FavouriteCubit cubit = context
                                                    .read<FavouriteCubit>();

                                                cubit.searchText = context
                                                        .read<DashboardCubit>()
                                                        .searchText ??
                                                    "";
                                                cubit.refreshPropertyFavList();
                                              }
                                            },
                                            onSearchTap: () async {
                                              final result = await context
                                                  .pushNamed<String>(
                                                      Routes.kSearch,
                                                      extra: context
                                                          .read<
                                                              DashboardCubit>()
                                                          .searchText);
                                              if (result != null &&
                                                  result.isNotEmpty) {
                                                setState(() {
                                                  context
                                                      .read<DashboardCubit>()
                                                      .searchText = result;
                                                });

                                                if (cubit.selectedPageIndex ==
                                                    0) {
                                                  HomeCubit cubit =
                                                      context.read<HomeCubit>();
                                                  cubit.resetPropertyList();
                                                  cubit.searchText = context
                                                          .read<
                                                              DashboardCubit>()
                                                          .searchText ??
                                                      "";
                                                  cubit.refreshData();
                                                } else if (cubit
                                                        .selectedPageIndex ==
                                                    1) {
                                                  FavouriteCubit cubit = context
                                                      .read<FavouriteCubit>();

                                                  cubit.searchText = context
                                                          .read<
                                                              DashboardCubit>()
                                                          .searchText ??
                                                      "";
                                                  cubit.refreshPropertyFavList();
                                                }
                                              }
                                            },
                                            onSortTap: () async {
                                              context
                                                      .read<HomeCubit>()
                                                      .sortOptions =
                                                  await Utils
                                                      .getSortOptionsList(
                                                          context);
                                              context
                                                      .read<FavouriteCubit>()
                                                      .sortOptions =
                                                  await Utils
                                                      .getSortOptionsList(
                                                          context);
                                              UIComponent.showCustomBottomSheet(
                                                  horizontalPadding: 0,
                                                  verticalPadding: 8,
                                                  context: context,
                                                  builder: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        width: 83,
                                                        height: 5,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              AppColors.black14,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                      ),
                                                      24.verticalSpace,
                                                      Text(
                                                        appStrings(context)
                                                            .lblSortBy,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelLarge
                                                            ?.copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                      ),
                                                      8.verticalSpace,
                                                      ListView.separated(
                                                        shrinkWrap: true,
                                                        physics:
                                                            const ClampingScrollPhysics(),
                                                        itemCount: context
                                                            .read<HomeCubit>()
                                                            .sortOptions
                                                            .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final option = context
                                                              .read<HomeCubit>()
                                                              .sortOptions[index];

                                                          bool isSelected = index ==
                                                              (cubit.selectedPageIndex ==
                                                                      0
                                                                  ? context
                                                                      .read<
                                                                          HomeCubit>()
                                                                      .selectedSortIndex
                                                                  : context
                                                                      .read<
                                                                          FavouriteCubit>()
                                                                      .selectedSortIndex);
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical: 4,
                                                                    horizontal:
                                                                        8),
                                                            child: UIComponent
                                                                .customInkWellWidget(
                                                              onTap: () async {
                                                                if (cubit
                                                                        .selectedPageIndex ==
                                                                    0) {
                                                                  HomeCubit
                                                                      cubit =
                                                                      context.read<
                                                                          HomeCubit>();
                                                                  // cubit
                                                                  //     .resetPropertyList();
                                                                  if (context
                                                                          .read<
                                                                              HomeCubit>()
                                                                          .filterRequestModel ==
                                                                      null) {
                                                                    context
                                                                        .read<
                                                                            HomeCubit>()
                                                                        .filterRequestModel = FilterRequestModel();
                                                                  }
                                                                  OverlayLoadingProgress
                                                                      .start(
                                                                          context);
                                                                  var callAPI =
                                                                      true;
                                                                  if (option
                                                                          .title ==
                                                                      appStrings(
                                                                              context)
                                                                          .textNearest) {
                                                                    var position = await LocationManager.fetchLocation(
                                                                        context:
                                                                            context,
                                                                        isForSort:
                                                                            true);
                                                                    if (position !=
                                                                        null) {
                                                                      cubit
                                                                          .resetPropertyList();

                                                                      context
                                                                          .read<
                                                                              HomeCubit>()
                                                                          .filterRequestModel!
                                                                          .nearest = "true";
                                                                      context
                                                                          .read<
                                                                              HomeCubit>()
                                                                          .filterRequestModel!
                                                                          .farthest = null;
                                                                      context
                                                                          .read<
                                                                              HomeCubit>()
                                                                          .filterRequestModel!
                                                                          .longitude = position.longitude.toString();
                                                                      context
                                                                          .read<
                                                                              HomeCubit>()
                                                                          .filterRequestModel!
                                                                          .latitude = position.latitude.toString();
                                                                      callAPI =
                                                                          true;
                                                                    } else {
                                                                      callAPI =
                                                                          false;
                                                                    }
                                                                  } else if (option
                                                                          .title ==
                                                                      appStrings(
                                                                              context)
                                                                          .textFurthest) {
                                                                    var position = await LocationManager.fetchLocation(
                                                                        context:
                                                                            context,
                                                                        isForSort:
                                                                            true);
                                                                    if (position !=
                                                                        null) {
                                                                      cubit
                                                                          .resetPropertyList();

                                                                      context
                                                                          .read<
                                                                              HomeCubit>()
                                                                          .filterRequestModel!
                                                                          .farthest = "true";
                                                                      context
                                                                          .read<
                                                                              HomeCubit>()
                                                                          .filterRequestModel!
                                                                          .nearest = null;
                                                                      context
                                                                          .read<
                                                                              HomeCubit>()
                                                                          .filterRequestModel!
                                                                          .longitude = position.longitude.toString();
                                                                      context
                                                                          .read<
                                                                              HomeCubit>()
                                                                          .filterRequestModel!
                                                                          .latitude = position.latitude.toString();
                                                                      callAPI =
                                                                          true;
                                                                    } else {
                                                                      callAPI =
                                                                          false;
                                                                    }
                                                                  } else {
                                                                    cubit
                                                                        .resetPropertyList();

                                                                    if (context
                                                                            .read<HomeCubit>()
                                                                            .filterRequestModel !=
                                                                        null) {
                                                                      context
                                                                          .read<
                                                                              HomeCubit>()
                                                                          .filterRequestModel!
                                                                          .nearest = null;
                                                                      context
                                                                          .read<
                                                                              HomeCubit>()
                                                                          .filterRequestModel!
                                                                          .farthest = null;
                                                                    }
                                                                    callAPI =
                                                                        true;
                                                                  }
                                                                  context
                                                                      .read<
                                                                          HomeCubit>()
                                                                      .selectedSortIndex = index;
                                                                  context
                                                                      .read<
                                                                          HomeCubit>()
                                                                      .refreshData();
                                                                  OverlayLoadingProgress
                                                                      .stop();
                                                                  if (callAPI) {
                                                                    Navigator.pop(
                                                                        context);
                                                                  }
                                                                  printf(
                                                                      '${option.title} selected');
                                                                } else if (cubit
                                                                        .selectedPageIndex ==
                                                                    1) {
                                                                  FavouriteCubit
                                                                      cubit =
                                                                      context.read<
                                                                          FavouriteCubit>();

                                                                  if (context
                                                                          .read<
                                                                              FavouriteCubit>()
                                                                          .filterRequestModel ==
                                                                      null) {
                                                                    context
                                                                        .read<
                                                                            FavouriteCubit>()
                                                                        .filterRequestModel = FilterRequestModel();
                                                                  }
                                                                  OverlayLoadingProgress
                                                                      .start(
                                                                          context);
                                                                  var callAPI =
                                                                      true;
                                                                  if (option
                                                                          .title ==
                                                                      appStrings(
                                                                              context)
                                                                          .textNearest) {
                                                                    var position = await LocationManager.fetchLocation(
                                                                        context:
                                                                            context,
                                                                        isForSort:
                                                                            true);

                                                                    if (position !=
                                                                        null) {
                                                                      cubit
                                                                          .refreshPropertyFavList();

                                                                      context
                                                                          .read<
                                                                              FavouriteCubit>()
                                                                          .filterRequestModel!
                                                                          .nearest = "true";
                                                                      context
                                                                          .read<
                                                                              FavouriteCubit>()
                                                                          .filterRequestModel!
                                                                          .farthest = null;
                                                                      context
                                                                          .read<
                                                                              FavouriteCubit>()
                                                                          .filterRequestModel!
                                                                          .longitude = position.longitude.toString();
                                                                      context
                                                                          .read<
                                                                              FavouriteCubit>()
                                                                          .filterRequestModel!
                                                                          .latitude = position.latitude.toString();
                                                                      callAPI =
                                                                          true;
                                                                    } else {
                                                                      callAPI =
                                                                          false;
                                                                    }
                                                                  } else if (option
                                                                          .title ==
                                                                      appStrings(
                                                                              context)
                                                                          .textFurthest) {
                                                                    var position = await LocationManager.fetchLocation(
                                                                        context:
                                                                            context,
                                                                        isForSort:
                                                                            true);
                                                                    if (position !=
                                                                        null) {
                                                                      cubit
                                                                          .refreshPropertyFavList();

                                                                      context
                                                                          .read<
                                                                              FavouriteCubit>()
                                                                          .filterRequestModel!
                                                                          .farthest = "true";
                                                                      context
                                                                          .read<
                                                                              FavouriteCubit>()
                                                                          .filterRequestModel!
                                                                          .nearest = null;
                                                                      context
                                                                          .read<
                                                                              FavouriteCubit>()
                                                                          .filterRequestModel!
                                                                          .longitude = position.longitude.toString();
                                                                      context
                                                                          .read<
                                                                              FavouriteCubit>()
                                                                          .filterRequestModel!
                                                                          .latitude = position.latitude.toString();
                                                                      callAPI =
                                                                          true;
                                                                    } else {
                                                                      callAPI =
                                                                          false;
                                                                    }
                                                                  } else {
                                                                    cubit
                                                                        .refreshPropertyFavList();

                                                                    if (context
                                                                            .read<FavouriteCubit>()
                                                                            .filterRequestModel !=
                                                                        null) {
                                                                      context
                                                                          .read<
                                                                              FavouriteCubit>()
                                                                          .filterRequestModel!
                                                                          .nearest = null;
                                                                      context
                                                                          .read<
                                                                              FavouriteCubit>()
                                                                          .filterRequestModel!
                                                                          .farthest = null;
                                                                    }
                                                                    callAPI =
                                                                        true;
                                                                  }
                                                                  context
                                                                      .read<
                                                                          FavouriteCubit>()
                                                                      .selectedSortIndex = index;
                                                                   context
                                                                      .read<
                                                                          FavouriteCubit>()
                                                                      .refreshPropertyFavList();
                                                                  OverlayLoadingProgress
                                                                      .stop();
                                                                  if (callAPI) {
                                                                    Navigator.pop(
                                                                        context);
                                                                  }
                                                                  printf(
                                                                      '${option.title} selected');
                                                                }
                                                              },
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color:
                                                                      isSelected
                                                                          ? AppColors
                                                                              .colorPrimaryShade
                                                                              .adaptiveColor(
                                                                              context,
                                                                              lightModeColor: AppColors.colorPrimaryShade,
                                                                              darkModeColor: AppColors.colorPrimary,
                                                                            )
                                                                          : Colors
                                                                              .transparent,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8), // Rounded corners
                                                                ),
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        20,
                                                                    vertical:
                                                                        12),
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        option
                                                                            .title,
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .titleSmall
                                                                            ?.copyWith(
                                                                              color: AppColors.black14.forLightMode(context),
                                                                            ),
                                                                      ),
                                                                    ),
                                                                    SVGAssets
                                                                        .arrowRightIcon
                                                                        .toSvg(
                                                                      context:
                                                                          context,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .highlightColor,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        separatorBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                    .symmetric(
                                                                    horizontal:
                                                                        0.0),
                                                            child: Divider(
                                                              height: 1,
                                                              color: AppColors.greyE8.adaptiveColor(
                                                                  context,
                                                                  lightModeColor:
                                                                      AppColors
                                                                          .greyE8,
                                                                  darkModeColor:
                                                                      AppColors
                                                                          .grey50),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ));
                                            },
                                            requireFilterSortIcon: true,
                                            isFilterApplied: context
                                                .watch<FilterCubit>()
                                                .isFilterApplied,
                                            onFilterTap: () {
                                              context.pushNamed(
                                                  Routes.kFilterScreen);
                                            }),
                            body: BlocBuilder<BottomNavCubit, int>(
                              builder: (context, selectedIndex) {
                                cubit.selectedDrawerIndex = selectedIndex;
                                return cubit.selectedUserRole ==
                                        AppStrings.vendor
                                    ? _pagesForVendorRole[selectedIndex]
                                    : _pages[selectedIndex];
                              },
                            ),
                            bottomNavigationBar:
                                BlocConsumer<DashboardCubit, DashboardState>(
                              builder: (context, state) =>
                                  BottomNavigationWidget(
                                isGuest: context.read<DashboardCubit>().isGuest
                                    ? true
                                    : false,
                                userRole:
                                    cubit.selectedUserRole == AppStrings.vendor
                                        ? AppStrings.vendor
                                        : AppStrings.visitor,
                              ),
                              listener:
                                  (BuildContext context, DashboardState state) {
                                if (state is LogoutError) {
                                  OverlayLoadingProgress.stop();
                                  Utils.showErrorMessage(
                                      context: context,
                                      message: state.errorMessage
                                              .contains('No internet')
                                          ? appStrings(context)
                                              .noInternetConnection
                                          : state.errorMessage);
                                }
                              },
                            )),
                      ),
                    ),
                  ),
                ),
              );
          },
        );
      },
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    context.read<HomeCubit>().filterRequestModel = FilterRequestModel();
    context.read<FilterCubit>().resetAndClearFilters(context);
    context.read<FavouriteCubit>().filterRequestModel = FilterRequestModel();
    await SessionTracker().onLogout();
    await GetIt.I<AppPreferences>().clearData();
    await NotificationService().cancelAllNotifications();
    OverlayLoadingProgress.stop();
    context.read<DashboardCubit>().searchText = "";
    context.read<HomeCubit>().searchText = "";

    if (!context.mounted) return;
    context.goNamed(Routes.kLoginScreen);
  }
}
