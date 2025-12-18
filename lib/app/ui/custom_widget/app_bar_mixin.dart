import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mashrou3/app/ui/screens/app_prefereces/cubit/app_preferences_cubit.dart';
import 'package:mashrou3/app/ui/screens/dashboard/cubit/dashboard_cubit.dart';
import 'package:mashrou3/config/resources/app_assets.dart';
import 'package:mashrou3/config/resources/app_colors.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:mashrou3/utils/ui_components.dart';

import '../../../utils/app_localization.dart';

mixin AppBarMixin {
  PreferredSizeWidget buildAppBar({
    String? title,
    Widget? searchWidget,
    required BuildContext context,
    bool requireMenu = false,
    bool requireSearchWidget = false,
    bool requireTransparent = false,
    bool requireLeading = true,
    bool requireFilterSortIcon = false,
    bool requireShareMoreIcon = false,
    bool requireShareFavIcon = false,
    bool notRequireFavIcon = false,
    bool requireLogoutIcon = false,
    bool requireProfileImg = false,
    bool isFilterApplied = false,
    bool isFavourite = false,
    bool isForInReview = false,
    bool isSoldOut = false,
    bool isMoreOnly = false,
    String? searchText,
    String? profilePicUrl,
    String? notificationCount = "0",
    final VoidCallback? onSearchTap,
    final VoidCallback? onMenuTap,
    final VoidCallback? onFilterTap,
    final VoidCallback? onSortTap,
    final VoidCallback? onBackTap,
    final VoidCallback? onShareTap,
    final VoidCallback? onDeletePropertyTap,
    final VoidCallback? onSoldOutTap,
    final VoidCallback? onMoreVerticalTap,
    VoidCallback? onCloseTap,
    ValueChanged<bool>? onFavouriteToggle,
    List<Widget>? actions,
    double? appBarHeight,
  }) {
    appBarHeight ??= kToolbarHeight;
    final key = GlobalKey();
    List<Widget>? appBarActions = actions;

    if (requireFilterSortIcon) {
      final filterIcon = Padding(
        padding: const EdgeInsetsDirectional.only(end: 8.0, top: 12),
        child: Row(
          children: [
            UIComponent.customInkWellWidget(
                onTap: onFilterTap ?? () {},
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.greyE9.adaptiveColor(
                        context,
                        lightModeColor: AppColors.greyE9,
                        darkModeColor: AppColors.black3D,
                      ),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.all(10.0),
                    child: BlocListener<DashboardCubit, DashboardState>(
                      listener: (context, state) {},
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          SvgPicture.asset(
                            SVGAssets.filterIcon,
                            height: 26,
                            width: 26,
                            colorFilter: ColorFilter.mode(
                              Theme.of(context).focusColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          if (isFilterApplied)
                            Positioned(
                              top: -12,
                              right: -10,
                              child: Container(
                                height: 10,
                                width: 10,
                                decoration: const BoxDecoration(
                                  color: AppColors.colorPrimary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                )),
            10.horizontalSpace,
            UIComponent.customInkWellWidget(
              onTap: onSortTap ?? () {},
              child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: AppColors.greyE9.adaptiveColor(context,
                              lightModeColor: AppColors.greyE9,
                              darkModeColor: AppColors.black3D),
                          width: 1)),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.all(10.0),
                    child: SvgPicture.asset(
                      SVGAssets.sortIcon,
                      height: 26,
                      width: 26,
                      colorFilter: ColorFilter.mode(
                          Theme.of(context).focusColor, BlendMode.srcIn),
                    ),
                  )),
            ),
          ],
        ),
      );
      if (appBarActions != null) {
        appBarActions = [filterIcon, ...appBarActions];
      } else {
        appBarActions = [filterIcon];
      }
    }

    if (requireShareMoreIcon) {
      final isRTL = Directionality.of(context) == TextDirection.rtl;

      final shareMoreIcon = Padding(
        padding: const EdgeInsetsDirectional.only(end: 8.0, top: 12),
        child: Row(
          children: [
            if (!isMoreOnly)
              UIComponent.customInkWellWidget(
                onTap: onShareTap ?? () {},
                child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: AppColors.greyE9.adaptiveColor(context,
                                lightModeColor: AppColors.greyE9,
                                darkModeColor: AppColors.black3D),
                            width: 1)),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.all(10.0),
                      child: UIComponent.customRTLIcon(
                          child: SvgPicture.asset(
                            SVGAssets.shareIcon,
                            height: 26,
                            width: 26,
                            colorFilter: ColorFilter.mode(
                                Theme.of(context).focusColor, BlendMode.srcIn),
                          ),
                          context: context),
                    )),
              ),
            10.horizontalSpace,
            GestureDetector(
              key: key,
              onTap: () {
                final RenderBox renderBox =
                    key.currentContext?.findRenderObject() as RenderBox;
                final Offset offset = renderBox.localToGlobal(Offset.zero);

                isForInReview || isSoldOut
                    ? showMenu(
                        context: context,
                        position: RelativeRect.fromLTRB(
                          isRTL ? offset.dx - 20 : offset.dx,
                          offset.dy +
                              renderBox.size.height +
                              8, // Below the icon
                          0,
                          0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              16), // Rounded corners for the menu
                        ),
                        color: Theme.of(context).cardColor,
                        items: [
                          PopupMenuItem<String>(
                            value: 'Option1',
                            child: ListTile(
                              leading: SVGAssets.deleteIcon.toSvg(
                                context: context,
                              ),
                              title: Text(
                                appStrings(context).deleteProperty,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context).primaryColor),
                              ),
                              onTap: onDeletePropertyTap ?? () {},
                            ),
                          ),
                        ],
                        elevation: 8.0,
                      )
                    : showMenu<String>(
                        context: context,
                        position: RelativeRect.fromLTRB(
                          isRTL ? offset.dx - 20 : offset.dx,
                          offset.dy +
                              renderBox.size.height +
                              8, // Below the icon
                          0,
                          0,
                        ),
                        color: Theme.of(context).cardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        menuPadding: const EdgeInsets.symmetric(vertical: 0.0),
                        items: [
                          // First Menu Item
                          PopupMenuItem<String>(
                            value: 'Option1',
                            child: Row(
                              children: [
                                SVGAssets.circleArrowUpRightSharpIcon
                                    .toSvg(context: context),
                                const SizedBox(width: 8),
                                Text(
                                  appStrings(context).soldOut,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          // Divider
                          const PopupMenuDivider(),
                          // Second Menu Item
                          PopupMenuItem<String>(
                            value: 'Option2',
                            child: Row(
                              children: [
                                SVGAssets.deleteIcon.toSvg(context: context),
                                const SizedBox(width: 8),
                                Text(
                                  appStrings(context).deleteProperty,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        elevation: 8.0,
                      ).then((value) {
                        if (value == 'Option1') {
                          onSoldOutTap?.call();
                        } else if (value == 'Option2') {
                          onDeletePropertyTap?.call();
                        }
                      });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.greyE9.adaptiveColor(context,
                        lightModeColor: AppColors.greyE9,
                        darkModeColor: AppColors.black3D),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SvgPicture.asset(
                    SVGAssets.moreVerticalIcon,
                    height: 26,
                    width: 26,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).focusColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
      if (appBarActions != null) {
        appBarActions = [shareMoreIcon, ...appBarActions];
      } else {
        appBarActions = [shareMoreIcon];
      }
    }

    if (requireShareFavIcon) {
      final shareFavIcon = StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: const EdgeInsetsDirectional.only(end: 8.0, top: 12),
            child: Row(
              children: [
                UIComponent.customInkWellWidget(
                  onTap: () {
                    setState(() {
                      isFavourite = !isFavourite;
                    });
                    onFavouriteToggle!(isFavourite);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.greyE9.adaptiveColor(
                          context,
                          lightModeColor: AppColors.greyE9,
                          darkModeColor: AppColors.black3D,
                        ),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.all(10.0),
                      child: SvgPicture.asset(
                        isFavourite
                            ? SVGAssets.favouriteSelectedIcon
                            : SVGAssets.favouriteIcon,
                        height: 26,
                        width: 26,
                        colorFilter: ColorFilter.mode(
                          Theme.of(context).highlightColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ).hideIf(notRequireFavIcon),
                10.horizontalSpace,
                UIComponent.customInkWellWidget(
                  onTap: onShareTap ?? () {},
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.greyE9.adaptiveColor(
                          context,
                          lightModeColor: AppColors.greyE9,
                          darkModeColor: AppColors.black3D,
                        ),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.all(10.0),
                      child: SvgPicture.asset(
                        SVGAssets.shareIcon,
                        height: 26,
                        width: 26,
                        colorFilter: ColorFilter.mode(
                          Theme.of(context).focusColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );

      if (appBarActions != null) {
        appBarActions = [shareFavIcon, ...appBarActions];
      } else {
        appBarActions = [shareFavIcon];
      }
    }

    return PreferredSize(
      preferredSize: Size.fromHeight(appBarHeight),
      child: AppBar(
        centerTitle: true,
        leadingWidth: requireLeading ? 60 : null,
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        leading: requireLeading
            ? requireMenu
                ? Padding(
                    padding:
                        const EdgeInsetsDirectional.only(start: 16.0, top: 12),
                    child: UIComponent.customInkWellWidget(
                      onTap: onMenuTap ?? () {},
                      child: Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: AppColors.greyE9.adaptiveColor(context,
                                      lightModeColor: AppColors.greyE9,
                                      darkModeColor: AppColors.black3D),
                                  width: 1)),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.all(10.0),
                            child: UIComponent.customRTLIcon(
                                child: SvgPicture.asset(
                                  SVGAssets.menuIcon,
                                  height: 12,
                                  width: 6,
                                  colorFilter: ColorFilter.mode(
                                      Theme.of(context).focusColor,
                                      BlendMode.srcIn),
                                ),
                                context: context),
                          )),
                    ),
                  )
                : Padding(
                    padding:
                        const EdgeInsetsDirectional.only(start: 16.0, top: 12),
                    child: UIComponent.customInkWellWidget(
                      onTap: onBackTap ??
                          () {
                            if (context.canPop()) {
                              context.pop();
                            }
                          },
                      child: Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: AppColors.greyE9.adaptiveColor(context,
                                      lightModeColor: AppColors.greyE9,
                                      darkModeColor: AppColors.black3D),
                                  width: 1)),
                          child: BlocConsumer<AppPreferencesCubit,
                              AppPreferencesState>(
                            listener: (context, state) {},
                            builder: (context, state) {
                              final cubit =
                                  context.watch<AppPreferencesCubit>();
                              final isArabic = cubit.isArabicSelected;
                              final arrowIcon = isArabic
                                  ? SVGAssets.arrowRightIcon
                                  : SVGAssets.arrowLeftIcon;

                              return Padding(
                                padding: const EdgeInsetsDirectional.all(8.0),
                                child: SvgPicture.asset(
                                  arrowIcon,
                                  height: 12,
                                  width: 6,
                                  colorFilter: ColorFilter.mode(
                                      Theme.of(context).focusColor,
                                      BlendMode.srcIn),
                                ),
                              );
                            },
                          )),
                    ),
                  )
            : null,
        elevation: 0.1,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).primaryColor,
        title: requireSearchWidget
            ? Padding(
                padding: const EdgeInsets.only(top: 14.0),
                child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: AppColors.greyE9.adaptiveColor(context,
                                lightModeColor: AppColors.greyE9,
                                darkModeColor: AppColors.black3D),
                            width: 1)),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(
                        start: 16.0,
                        top: 9.0,
                        bottom: 9.0,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: UIComponent.customInkWellWidget(
                              onTap: onSearchTap ?? () {},
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    SVGAssets.searchIcon,
                                    height: 22,
                                    width: 22,
                                    colorFilter: ColorFilter.mode(
                                        Theme.of(context).focusColor,
                                        BlendMode.srcIn),
                                  ),
                                  12.horizontalSpace,
                                  if (searchText != null &&
                                      searchText.isNotEmpty)
                                    Expanded(
                                      child: Text(
                                        searchText,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: AppColors.grey8A,
                                              fontWeight: FontWeight.w400,
                                            ),
                                      ),
                                    )
                                  else
                                    Expanded(
                                      child: Text(
                                        appStrings(context).textSearch,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: AppColors.grey8A,
                                              fontWeight: FontWeight.w400,
                                            ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          if (searchText != null && searchText.isNotEmpty)
                            GestureDetector(
                              onTap: onCloseTap,
                              child: Padding(
                                padding:
                                    const EdgeInsetsDirectional.only(end: 8),
                                child: SVGAssets.cancelIcon.toSvg(
                                    context: context,
                                    height: 18,
                                    width: 18,
                                    color: AppColors.black14.adaptiveColor(
                                        context,
                                        lightModeColor: AppColors.black14,
                                        darkModeColor: AppColors.white)
                                ),
                              ),
                            ),
                        ],
                      ),
                    )),
              )
            : Text(title ?? "",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.w700)),
        actions: appBarActions,
      ),
    );
  }
}
