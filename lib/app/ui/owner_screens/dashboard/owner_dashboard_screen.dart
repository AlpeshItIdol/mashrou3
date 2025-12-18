import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mashrou3/app/navigation/routes.dart';
import 'package:mashrou3/app/ui/custom_widget/app_bar_mixin.dart';
import 'package:mashrou3/app/ui/custom_widget/bottom_navigation_widget/bottom_navigation_cubit.dart';
import 'package:mashrou3/app/ui/custom_widget/bottom_navigation_widget/bottom_navigation_widget.dart';
import 'package:mashrou3/app/ui/custom_widget/side_drawer_widget/side_drawer_widget.dart';
import 'package:mashrou3/app/ui/owner_screens/dashboard/cubit/owner_dashboard_cubit.dart';
import 'package:mashrou3/app/ui/owner_screens/dashboard/sub_screens/home/cubit/owner_home_cubit.dart';
import 'package:mashrou3/app/ui/owner_screens/dashboard/sub_screens/home/owner_home_screen.dart';
import 'package:mashrou3/app/ui/owner_screens/dashboard/sub_screens/in_review/cubit/in_review_cubit.dart';
import 'package:mashrou3/app/ui/owner_screens/dashboard/sub_screens/in_review/in.review.screen.dart';
import 'package:mashrou3/app/ui/owner_screens/owner_filter/cubit/in_review_filter_cubit.dart';
import 'package:mashrou3/app/ui/owner_screens/owner_filter/cubit/owner_filter_cubit.dart';
import 'package:mashrou3/app/ui/screens/dashboard/sub_screens/notification/notification.screen.dart';
import 'package:mashrou3/app/ui/screens/filter/model/filter_request_model.dart';
import 'package:mashrou3/config/resources/app_strings.dart';
import 'package:mashrou3/utils/app_localization.dart';
import 'package:mashrou3/utils/extensions.dart';

import '../../../../config/resources/app_assets.dart';
import '../../../../config/resources/app_colors.dart';
import '../../../../config/services/fcm_helper.dart';
import '../../../../config/services/push_notification_service.dart';
import '../../../../config/utils.dart';
import '../../../../utils/location_manager.dart';
import '../../../../utils/ui_components.dart';
import '../../../db/app_preferences.dart';
import '../../../db/session_tracker.dart';
import '../../custom_widget/loader/overlay_loading_progress.dart';

class OwnerDashboardScreen extends StatefulWidget {
  const OwnerDashboardScreen({super.key});

  @override
  State<OwnerDashboardScreen> createState() => _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends State<OwnerDashboardScreen>
    with AppBarMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _pages = [
    OwnerHomeScreen(),
    InReviewScreen(),
    NotificationScreen(),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    FCMHelper().setupNotification(() {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => context.read<OwnerDashboardCubit>().saveFCMToken(context));
    });
    context.read<BottomNavCubit>().selectIndex(0);
    context.read<OwnerDashboardCubit>().getData(context);
  }

  @override
  Widget build(BuildContext context) {
    OwnerDashboardCubit cubit = context.read<OwnerDashboardCubit>();
    return BlocConsumer<OwnerDashboardCubit, OwnerDashboardState>(
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
          listener: (context, navState) async {
            cubit.selectedPageIndex = navState;
            setState(() {
              context.read<OwnerDashboardCubit>().searchText = "";
            });
            if (cubit.selectedPageIndex == 0) {
              OwnerHomeCubit cubit = context.read<OwnerHomeCubit>();
              cubit.resetPropertyList();
              cubit.searchText =
                  context.read<OwnerDashboardCubit>().searchText ?? "";
              await cubit.getPropertyList();
            } else if (cubit.selectedPageIndex == 1) {
              InReviewCubit cubit = context.read<InReviewCubit>();
              cubit.resetPropertyList();
              cubit.searchText =
                  context.read<OwnerDashboardCubit>().searchText ?? "";
              await cubit.getPropertyList();
            }
          },
          builder: (context, selectedIndex) {
            return PopScope(
              canPop: false,
              onPopInvokedWithResult: (bool didPop, Object? result) async {},
              child: BlocListener<InReviewFilterCubit, InReviewFilterState>(
                listener: (context, state) {},
                child: BlocListener<OwnerFilterCubit, OwnerFilterState>(
                  listener: (context, state) {},
                  child: Scaffold(
                    key: _scaffoldKey,
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
                        context.pop();
                        context.pushReplacementNamed(Routes.kLoginScreen);
                      },
                      scaffoldKey: _scaffoldKey,
                    ),
                    appBar: (cubit.selectedPageIndex == 2)
                        ? buildAppBar(
                            context: context,
                            requireMenu: true,
                            onMenuTap: () {
                              _scaffoldKey.currentState!.openDrawer();
                            },
                            title: appStrings(context).lblNotifications,
                          )
                        : (cubit.selectedPageIndex == 1)
                            ? buildAppBar(
                                context: context,
                                requireMenu: true,
                                requireLeading: true,
                                requireSearchWidget: true,
                                requireFilterSortIcon: false,
                                onMenuTap: () {
                                  _scaffoldKey.currentState!.openDrawer();
                                },
                                searchText: cubit.searchText,
                                onCloseTap: () async {
                                  setState(() {
                                    context
                                        .read<OwnerDashboardCubit>()
                                        .searchText = "";
                                  });

                                  if (cubit.selectedPageIndex == 0) {
                                    OwnerHomeCubit cubit =
                                        context.read<OwnerHomeCubit>();
                                    cubit.resetPropertyList();
                                    cubit.searchText = context
                                            .read<OwnerDashboardCubit>()
                                            .searchText ??
                                        "";
                                    await cubit.getPropertyList();
                                  } else if (cubit.selectedPageIndex == 1) {
                                    InReviewCubit cubit =
                                        context.read<InReviewCubit>();
                                    cubit.resetPropertyList();
                                    cubit.searchText = context
                                            .read<OwnerDashboardCubit>()
                                            .searchText ??
                                        "";
                                    await cubit.getPropertyList();
                                  }
                                },
                                onSearchTap: () async {
                                  final result = await context
                                      .pushNamed<String>(Routes.kSearch,
                                          extra: context
                                              .read<OwnerDashboardCubit>()
                                              .searchText);
                                  if (result != null && result.isNotEmpty) {
                                    setState(() {
                                      context
                                          .read<OwnerDashboardCubit>()
                                          .searchText = result;
                                    });

                                    if (cubit.selectedPageIndex == 0) {
                                      OwnerHomeCubit cubit =
                                          context.read<OwnerHomeCubit>();
                                      cubit.resetPropertyList();
                                      cubit.searchText = context
                                              .read<OwnerDashboardCubit>()
                                              .searchText ??
                                          "";
                                      await cubit.getPropertyList();
                                    } else if (cubit.selectedPageIndex == 1) {
                                      InReviewCubit cubit =
                                          context.read<InReviewCubit>();
                                      cubit.resetPropertyList();
                                      cubit.searchText = context
                                              .read<OwnerDashboardCubit>()
                                              .searchText ??
                                          "";
                                      await cubit.getPropertyList();
                                    }
                                  }
                                },
                              )
                            : buildAppBar(
                                context: context,
                                requireMenu: true,
                                requireLeading: true,
                                requireSearchWidget: true,
                                onMenuTap: () {
                                  _scaffoldKey.currentState!.openDrawer();
                                },
                                searchText: cubit.searchText,
                                onCloseTap: () async {
                                  setState(() {
                                    context
                                        .read<OwnerDashboardCubit>()
                                        .searchText = "";
                                  });

                                  if (cubit.selectedPageIndex == 0) {
                                    OwnerHomeCubit cubit =
                                        context.read<OwnerHomeCubit>();
                                    cubit.resetPropertyList();
                                    cubit.searchText = context
                                            .read<OwnerDashboardCubit>()
                                            .searchText ??
                                        "";
                                    await cubit.getPropertyList();
                                  } else if (cubit.selectedPageIndex == 1) {
                                    InReviewCubit cubit =
                                        context.read<InReviewCubit>();
                                    cubit.resetPropertyList();
                                    cubit.searchText = context
                                            .read<OwnerDashboardCubit>()
                                            .searchText ??
                                        "";
                                    await cubit.getPropertyList();
                                  }
                                },
                                onSearchTap: () async {
                                  final result = await context
                                      .pushNamed<String>(Routes.kSearch,
                                          extra: context
                                              .read<OwnerDashboardCubit>()
                                              .searchText);
                                  if (result != null && result.isNotEmpty) {
                                    setState(() {
                                      context
                                          .read<OwnerDashboardCubit>()
                                          .searchText = result;
                                    });

                                    if (cubit.selectedPageIndex == 0) {
                                      OwnerHomeCubit cubit =
                                          context.read<OwnerHomeCubit>();
                                      cubit.resetPropertyList();
                                      cubit.searchText = context
                                              .read<OwnerDashboardCubit>()
                                              .searchText ??
                                          "";
                                      await cubit.getPropertyList();
                                    } else if (cubit.selectedPageIndex == 1) {
                                      InReviewCubit cubit =
                                          context.read<InReviewCubit>();
                                      cubit.resetPropertyList();
                                      cubit.searchText = context
                                              .read<OwnerDashboardCubit>()
                                              .searchText ??
                                          "";
                                      await cubit.getPropertyList();
                                    }
                                  }
                                },
                                onSortTap: () async {
                                  context.read<OwnerHomeCubit>().sortOptions =
                                      await Utils.getSortOptionsList(context);
                                  context.read<InReviewCubit>().sortOptions =
                                      await Utils.getSortOptionsList(context);
                                  UIComponent.showCustomBottomSheet(
                                      horizontalPadding: 0,
                                      verticalPadding: 8,
                                      context: context,
                                      builder: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 83,
                                            height: 5,
                                            decoration: BoxDecoration(
                                              color: AppColors.black14,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          24.verticalSpace,
                                          Text(
                                            appStrings(context).lblSortBy,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.w700),
                                          ),
                                          8.verticalSpace,
                                          ListView.separated(
                                            shrinkWrap: true,
                                            physics:
                                                const ClampingScrollPhysics(),
                                            itemCount: context
                                                .read<OwnerHomeCubit>()
                                                .sortOptions
                                                .length,
                                            itemBuilder: (context, index) {
                                              final option = context
                                                  .read<OwnerHomeCubit>()
                                                  .sortOptions[index];

                                              bool isSelected = index ==
                                                  (cubit.selectedPageIndex == 0
                                                      ? context
                                                          .read<
                                                              OwnerHomeCubit>()
                                                          .selectedSortIndex
                                                      : context
                                                          .read<InReviewCubit>()
                                                          .selectedSortIndex);
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4,
                                                        horizontal: 8),
                                                child: UIComponent
                                                    .customInkWellWidget(
                                                  onTap: () async {
                                                    if (cubit
                                                            .selectedPageIndex ==
                                                        0) {
                                                      OwnerHomeCubit cubit =
                                                          context.read<
                                                              OwnerHomeCubit>();
                                                      // cubit.resetPropertyList();
                                                      if (context
                                                              .read<
                                                                  OwnerHomeCubit>()
                                                              .filterRequestModel ==
                                                          null) {
                                                        context
                                                                .read<
                                                                    OwnerHomeCubit>()
                                                                .filterRequestModel =
                                                            FilterRequestModel();
                                                      }
                                                      OverlayLoadingProgress
                                                          .start(context);
                                                      var callAPI = true;
                                                      if (option.title ==
                                                          appStrings(context)
                                                              .textNearest) {
                                                        var position =
                                                            await LocationManager
                                                                .fetchLocation(
                                                                    context:
                                                                        context,
                                                                    isForSort:
                                                                        true);

                                                        if (position != null) {
                                                          cubit
                                                              .resetPropertyList();

                                                          context
                                                              .read<
                                                                  OwnerHomeCubit>()
                                                              .filterRequestModel!
                                                              .nearest = "true";
                                                          context
                                                              .read<
                                                                  OwnerHomeCubit>()
                                                              .filterRequestModel!
                                                              .farthest = null;
                                                          context
                                                                  .read<
                                                                      OwnerHomeCubit>()
                                                                  .filterRequestModel!
                                                                  .longitude =
                                                              position.longitude
                                                                  .toString();
                                                          context
                                                                  .read<
                                                                      OwnerHomeCubit>()
                                                                  .filterRequestModel!
                                                                  .latitude =
                                                              position.latitude
                                                                  .toString();
                                                          callAPI = true;
                                                        } else {
                                                          callAPI = false;
                                                        }
                                                      } else if (option.title ==
                                                          appStrings(context)
                                                              .textFurthest) {
                                                        var position =
                                                            await LocationManager
                                                                .fetchLocation(
                                                                    context:
                                                                        context,
                                                                    isForSort:
                                                                        true);
                                                        if (position != null) {
                                                          cubit
                                                              .resetPropertyList();

                                                          context
                                                              .read<
                                                                  OwnerHomeCubit>()
                                                              .filterRequestModel!
                                                              .farthest = "true";
                                                          context
                                                              .read<
                                                                  OwnerHomeCubit>()
                                                              .filterRequestModel!
                                                              .nearest = null;
                                                          context
                                                                  .read<
                                                                      OwnerHomeCubit>()
                                                                  .filterRequestModel!
                                                                  .longitude =
                                                              position.longitude
                                                                  .toString();
                                                          context
                                                                  .read<
                                                                      OwnerHomeCubit>()
                                                                  .filterRequestModel!
                                                                  .latitude =
                                                              position.latitude
                                                                  .toString();
                                                          callAPI = true;
                                                        } else {
                                                          callAPI = false;
                                                        }
                                                      } else {
                                                        cubit
                                                            .resetPropertyList();

                                                        if (context
                                                                .read<
                                                                    OwnerHomeCubit>()
                                                                .filterRequestModel !=
                                                            null) {
                                                          context
                                                              .read<
                                                                  OwnerHomeCubit>()
                                                              .filterRequestModel!
                                                              .nearest = null;
                                                          context
                                                              .read<
                                                                  OwnerHomeCubit>()
                                                              .filterRequestModel!
                                                              .farthest = null;
                                                        }
                                                        callAPI = true;
                                                      }
                                                      context
                                                          .read<
                                                              OwnerHomeCubit>()
                                                          .selectedSortIndex = index;
                                                      await context
                                                          .read<
                                                              OwnerHomeCubit>()
                                                          .getPropertyList();
                                                      if (callAPI) {
                                                        Navigator.pop(context);
                                                      }

                                                      OverlayLoadingProgress
                                                          .stop();

                                                      printf(
                                                          '${option.title} selected');
                                                    } else if (cubit
                                                            .selectedPageIndex ==
                                                        1) {
                                                      InReviewCubit cubit =
                                                          context.read<
                                                              InReviewCubit>();
                                                      // cubit.resetPropertyList();
                                                      OverlayLoadingProgress
                                                          .start(context);
                                                      if (context
                                                              .read<
                                                                  InReviewCubit>()
                                                              .filterRequestModel ==
                                                          null) {
                                                        context
                                                                .read<
                                                                    InReviewCubit>()
                                                                .filterRequestModel =
                                                            FilterRequestModel();
                                                      }
                                                      var callAPI = true;
                                                      if (option.title ==
                                                          appStrings(context)
                                                              .textNearest) {
                                                        var position =
                                                            await LocationManager
                                                                .fetchLocation(
                                                                    context:
                                                                        context,
                                                                    isForSort:
                                                                        true);
                                                        if (position != null) {
                                                          cubit
                                                              .resetPropertyList();

                                                          context
                                                              .read<
                                                                  InReviewCubit>()
                                                              .filterRequestModel!
                                                              .nearest = "true";
                                                          context
                                                              .read<
                                                                  InReviewCubit>()
                                                              .filterRequestModel!
                                                              .farthest = null;
                                                          context
                                                                  .read<
                                                                      InReviewCubit>()
                                                                  .filterRequestModel!
                                                                  .longitude =
                                                              position.longitude
                                                                  .toString();
                                                          context
                                                                  .read<
                                                                      InReviewCubit>()
                                                                  .filterRequestModel!
                                                                  .latitude =
                                                              position.latitude
                                                                  .toString();
                                                          callAPI = true;
                                                        } else {
                                                          callAPI = false;
                                                        }
                                                      } else if (option.title ==
                                                          appStrings(context)
                                                              .textFurthest) {
                                                        var position =
                                                            await LocationManager
                                                                .fetchLocation(
                                                                    context:
                                                                        context,
                                                                    isForSort:
                                                                        true);
                                                        if (position != null) {
                                                          cubit
                                                              .resetPropertyList();

                                                          context
                                                              .read<
                                                                  InReviewCubit>()
                                                              .filterRequestModel!
                                                              .farthest = "true";
                                                          context
                                                              .read<
                                                                  InReviewCubit>()
                                                              .filterRequestModel!
                                                              .nearest = null;
                                                          context
                                                                  .read<
                                                                      InReviewCubit>()
                                                                  .filterRequestModel!
                                                                  .longitude =
                                                              position.longitude
                                                                  .toString();
                                                          context
                                                                  .read<
                                                                      InReviewCubit>()
                                                                  .filterRequestModel!
                                                                  .latitude =
                                                              position.latitude
                                                                  .toString();
                                                          callAPI = true;
                                                        } else {
                                                          callAPI = false;
                                                        }
                                                      } else {
                                                        if (context
                                                                .read<
                                                                    InReviewCubit>()
                                                                .filterRequestModel !=
                                                            null) {
                                                          context
                                                              .read<
                                                                  InReviewCubit>()
                                                              .filterRequestModel!
                                                              .nearest = null;
                                                          context
                                                              .read<
                                                                  InReviewCubit>()
                                                              .filterRequestModel!
                                                              .farthest = null;
                                                          context
                                                              .read<
                                                                  InReviewCubit>()
                                                              .filterRequestModel!
                                                              .longitude = null;
                                                          context
                                                              .read<
                                                                  InReviewCubit>()
                                                              .filterRequestModel!
                                                              .latitude = null;
                                                        }
                                                        callAPI = true;
                                                      }
                                                      cubit.resetPropertyList();

                                                      context
                                                          .read<InReviewCubit>()
                                                          .selectedSortIndex = index;
                                                      await context
                                                          .read<InReviewCubit>()
                                                          .getPropertyList();
                                                      if (callAPI) {
                                                        Navigator.pop(context);
                                                      }
                                                      OverlayLoadingProgress
                                                          .stop();

                                                      printf(
                                                          '${option.title} selected');
                                                    }
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: isSelected
                                                          ? AppColors
                                                              .colorPrimaryShade
                                                              .adaptiveColor(
                                                              context,
                                                              lightModeColor:
                                                                  AppColors
                                                                      .colorPrimaryShade,
                                                              darkModeColor:
                                                                  AppColors
                                                                      .colorPrimary,
                                                            )
                                                          : Colors.transparent,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8), // Rounded corners
                                                    ),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 20,
                                                        vertical: 12),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            option.title,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleSmall
                                                                ?.copyWith(
                                                                  color: AppColors
                                                                      .black14
                                                                      .forLightMode(
                                                                          context),
                                                                ),
                                                          ),
                                                        ),
                                                        SVGAssets.arrowRightIcon
                                                            .toSvg(
                                                          context: context,
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
                                                (BuildContext context,
                                                    int index) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .symmetric(
                                                        horizontal: 0.0),
                                                child: Divider(
                                                  height: 1,
                                                  color: AppColors.greyE8
                                                      .adaptiveColor(
                                                          context,
                                                          lightModeColor:
                                                              AppColors.greyE8,
                                                          darkModeColor:
                                                              AppColors.grey50),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ));
                                },
                                requireFilterSortIcon: true,
                                isFilterApplied: cubit.selectedPageIndex == 0
                                    ? context
                                        .watch<OwnerFilterCubit>()
                                        .isFilterApplied
                                    : context
                                        .watch<InReviewFilterCubit>()
                                        .isFilterApplied,
                                onFilterTap: () {
                                  cubit.selectedPageIndex == 0
                                      ? context
                                          .pushNamed(Routes.kOwnerFilterScreen)
                                      : context.pushNamed(
                                          Routes.kInReviewFilterScreen);
                                }),
                    body: BlocBuilder<BottomNavCubit, int>(
                      builder: (context, selectedIndex) {
                        if (selectedIndex >= 0 &&
                            selectedIndex < _pages.length) {
                          return _pages[selectedIndex];
                        }

                        return Center(
                          child: Text(
                            "Page not found",
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        );
                      },
                    ),
                    bottomNavigationBar: const BottomNavigationWidget(
                      userRole: AppStrings.owner,
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
    context.read<OwnerHomeCubit>().filterRequestModel = FilterRequestModel();
    context.read<OwnerFilterCubit>().clearFilters(context);
    context.read<InReviewCubit>().filterRequestModel = FilterRequestModel();
    await SessionTracker().onLogout();
    await GetIt.I<AppPreferences>().clearData();
    await NotificationService().cancelAllNotifications();

    OverlayLoadingProgress.stop();
    context.read<OwnerDashboardCubit>().searchText = "";
    context.read<OwnerHomeCubit>().searchText = "";
    if (!context.mounted) return;
    context.goNamed(Routes.kLoginScreen);
  }
}
