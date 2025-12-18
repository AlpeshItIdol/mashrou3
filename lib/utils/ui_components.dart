import 'dart:io';
import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_phone_validator/country_phone_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart' as intl;
import 'package:mashrou3/app/db/app_preferences.dart';
import 'package:mashrou3/app/navigation/route_arguments.dart';
import 'package:mashrou3/app/navigation/routes.dart';
import 'package:mashrou3/app/ui/custom_widget/my_gif_widget.dart';
import 'package:mashrou3/config/resources/app_constants.dart';
import 'package:mashrou3/config/resources/app_strings.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:mashrou3/utils/material_dialog.dart';
import 'package:place_picker_google/place_picker_google.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../app/ui/custom_widget/common_button.dart';
import '../config/resources/app_assets.dart';
import '../config/resources/app_colors.dart';
import '../config/resources/text_styles.dart';
import '../config/utils.dart';
import 'app_localization.dart';

class UIComponent {
  static bool isSystemFontMax(BuildContext context) {
    double currentScaleFactor = MediaQuery.of(context).textScaleFactor;
    return currentScaleFactor >= 1.1;
  }

  static showCustomBottomSheet(
      {BuildContext? context, Widget? builder, double? height, double? horizontalPadding, double? verticalPadding, Color? bgColor}) {
    showModalBottomSheet(
      context: context!,
      backgroundColor: bgColor ?? AppColors.white.adaptiveColor(context, lightModeColor: AppColors.white, darkModeColor: AppColors.black2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      isScrollControlled: true,
      // This allows dynamic height based on content
      builder: (BuildContext context) {
        return SingleChildScrollView(
          // Use this to prevent overflow when content is large
          child: Padding(
            padding: EdgeInsetsDirectional.only(
              top: verticalPadding ?? 20,
              start: horizontalPadding ?? 16,
              end: horizontalPadding ?? 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + (verticalPadding ?? 20),
            ),
            child: builder!, // Content inside the bottom sheet
          ),
        );
      },
    );
  }

  static buildUserProfileWidget({
    required BuildContext context,
    String? userRoleType,
    String? userName,
    String imageStr = "",
    bool isGuest = false,
    bool isVisitor = false,
    bool isUploadIconNeeded = false,
  }) {
    final userDisplayName = isGuest
        ? appStrings(context).textGuest
        : userRoleType == AppStrings.visitor
            ? userName != null && userName.isNotEmpty
                ? userName
                : appStrings(context).textVisitorUser
            : userRoleType == AppStrings.vendor
                ? userName != null && userName.isNotEmpty
                    ? userName
                    : appStrings(context).textVendorUser
                : userRoleType == AppStrings.owner
                    ? userName != null && userName.isNotEmpty
                        ? userName
                        : appStrings(context).textOwnerUser
                    : userName ?? "";

    return Container(
      margin: EdgeInsetsDirectional.only(
        top: MediaQuery.of(context).padding.top,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (imageStr.isEmpty)
            userProfileInitialImg(
              buildContext: context,
              name: userDisplayName,
            ),
          if (imageStr.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: UIComponent.cachedNetworkImageWidget(
                imageUrl: imageStr,
                fit: BoxFit.cover,
                height: 100,
                width: 100,
              ),
            ),
          12.verticalSpace,
          Text(
            userDisplayName,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Theme.of(context).primaryColor),
          ),
          4.verticalSpace,
          Text(
            isVisitor
                ? appStrings(context).textVisitor
                : userRoleType == AppStrings.owner
                    ? appStrings(context).textRealEstateOwner
                    : userRoleType == AppStrings.vendor
                        ? appStrings(context).textVendor
                        : userRoleType ?? '',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).primaryColor),
          ).showIf(!isGuest),
        ],
      ),
    );
  }

  static userProfileInitialImg({String? name, required BuildContext buildContext, Size? size, double? radius, TextStyle? style}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(radius ?? 34),
          child: SvgPicture.asset(
            SVGAssets.profileClipPath,
            height: size?.height ?? 100,
            width: size?.width ?? 100,
          ),
        ),
        Center(
          child: name != null && name != ""
              ? Text(
                  name[0],
                  textAlign: TextAlign.center,
                  style: style ?? h48(color: AppColors.white),
                )
              : Container(),
        ),
      ],
    );
  }

  static buildUserProfileWidgetForProfileDetail({
    required BuildContext context,
    String? userRoleType,
    String userName = "",
    String userCountryCity = "",
    String? imageStr,
    double? radius,
    bool isGuest = false,
    bool isVisitor = false,
    bool showUserName = true,
    bool isUploadIconNeeded = false,
    required VoidCallback onAddImageTap,
  }) {
    final userDisplayName = userName;

    return Container(
      margin: EdgeInsetsDirectional.only(
        top: MediaQuery.of(context).padding.top,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 0),
            child: userProfileInitialImgForProfileDetail(
                buildContext: context,
                radius: radius,
                name: (userName != "") ? userName : userDisplayName,
                imageStr: imageStr ?? "",
                userCountryCity: userCountryCity,
                isUploadIconNeeded: false),
          ),
          12.verticalSpace /*.showIf(showUserName)*/,
          Text(
            userDisplayName,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Theme.of(context).primaryColor),
          ).showIf(userDisplayName != ""),
          4.verticalSpace,
          Text(
            userCountryCity != "" ? userCountryCity : '',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).primaryColor),
          ).showIf(userCountryCity != ""),
        ],
      ),
    );
  }

  static buildUserProfileWidgetForPersonalInformation({
    required BuildContext context,
    String? userRoleType,
    String userName = "",
    String? imageStr,
    bool isGuest = false,
    bool isVisitor = false,
    bool showUserName = true,
    bool isUploadIconNeeded = false,
    required VoidCallback onAddImageTap,
  }) {
    final userDisplayName = isGuest
        ? appStrings(context).textGuest
        : userRoleType == AppStrings.visitor
            ? appStrings(context).textVisitorUser
            : userRoleType == AppStrings.vendor
                ? appStrings(context).textVendorUser
                : userRoleType == AppStrings.owner
                    ? appStrings(context).textOwnerUser
                    : userName;

    return Container(
      margin: EdgeInsetsDirectional.only(
        top: MediaQuery.of(context).padding.top,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 0),
            child: userProfileInitialImgForPersonalInformation(
                buildContext: context,
                name: !isGuest && (userName != "") ? userName : userDisplayName,
                imageStr: imageStr ?? "",
                onAddImageTap: onAddImageTap,
                isUploadIconNeeded: isUploadIconNeeded),
          ),
          12.verticalSpace /*.showIf(showUserName)*/,
          Text(
            userDisplayName,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Theme.of(context).primaryColor),
          ).hideIf(userName != ""),
          4.verticalSpace,
          Text(
            isVisitor
                ? userName != ""
                    ? appStrings(context).textVisitor
                    : ""
                : userRoleType == AppStrings.owner
                    ? appStrings(context).textRealEstateOwner
                    : userRoleType == AppStrings.vendor
                        ? appStrings(context).textVendor
                        : userRoleType ?? '',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).primaryColor),
          ).showIf(!isGuest && userName != ""),
        ],
      ),
    );
  }

  static userProfileInitialImgForPersonalInformation(
      {String? name,
      required BuildContext buildContext,
      Size? size,
      double? radius,
      String imageStr = "",
      bool isUploadIconNeeded = false,
      VoidCallback? onAddImageTap,
      TextStyle? style}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(radius ?? 24),
                child: imageStr.contains("http")
                    ? UIComponent.cachedNetworkImageWidget(
                        imageUrl: imageStr,
                        fit: BoxFit.cover,
                        height: size?.height ?? 100,
                        width: size?.width ?? 100,
                      )
                    : Image.file(
                        File(imageStr),
                        height: size?.height ?? 100,
                        width: size?.width ?? 100,
                        fit: BoxFit.cover,
                      ),
              ).showIf(imageStr.isNotEmpty),
              ClipRRect(
                borderRadius: BorderRadius.circular(radius ?? 24),
                child: SvgPicture.asset(
                  SVGAssets.profileClipPath,
                  height: size?.height ?? 100,
                  width: size?.width ?? 100,
                ),
              ).showIf(imageStr.isEmpty),
              Positioned(
                top: -10,
                right: -10,
                child: UIComponent.customInkWellWidget(
                  onTap: onAddImageTap ?? () {},
                  child: Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.greyE8.adaptiveColor(
                        buildContext,
                        lightModeColor: AppColors.greyE8,
                        darkModeColor: AppColors.black2E,
                      )),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SVGAssets.imageAddIcon.toSvg(context: buildContext),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Center(
          child: name != null && name != ""
              ? Text(
                  name[0],
                  textAlign: TextAlign.center,
                  style: style ?? h48(color: AppColors.white),
                )
              : Container(),
        ).showIf(imageStr.isEmpty),
      ],
    );
  }

  static userProfileInitialImgForProfileDetail(
      {String? name,
      String? userCountryCity,
      required BuildContext buildContext,
      Size? size,
      double? radius,
      String imageStr = "",
      bool isUploadIconNeeded = false,
      VoidCallback? onAddImageTap,
      TextStyle? style}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(radius ?? 24),
                child: imageStr.contains("http")
                    ? UIComponent.cachedNetworkImageWidget(
                        imageUrl: imageStr,
                        fit: BoxFit.cover,
                        height: size?.height ?? 100,
                        width: size?.width ?? 100,
                      )
                    : Image.file(
                        File(imageStr),
                        height: size?.height ?? 100,
                        width: size?.width ?? 100,
                        fit: BoxFit.cover,
                      ),
              ).showIf(imageStr.isNotEmpty),
              ClipRRect(
                borderRadius: BorderRadius.circular(radius ?? 24),
                child: SvgPicture.asset(
                  SVGAssets.profileClipPath,
                  height: size?.height ?? 100,
                  width: size?.width ?? 100,
                ),
              ).showIf(imageStr.isEmpty),
              Positioned(
                top: -10,
                right: -10,
                child: UIComponent.customInkWellWidget(
                  onTap: onAddImageTap ?? () {},
                  child: Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.greyE8.adaptiveColor(
                        buildContext,
                        lightModeColor: AppColors.greyE8,
                        darkModeColor: AppColors.black2E,
                      )),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SVGAssets.imageAddIcon.toSvg(context: buildContext),
                    ),
                  ),
                ),
              ).showIf(isUploadIconNeeded),
            ],
          ),
        ),
        Center(
          child: name != null && name != ""
              ? Text(
                  name[0],
                  textAlign: TextAlign.center,
                  style: style ?? h48(color: AppColors.white),
                )
              : Container(),
        ).showIf(imageStr.isEmpty),
      ],
    );
  }

  static mandatoryLabel({
    required BuildContext context,
    required String? label,
  }) {
    return RichText(
      text: TextSpan(
        text: label,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.black3D.adaptiveColor(context, lightModeColor: AppColors.black3D, darkModeColor: AppColors.greyB0)),
        children: [
          TextSpan(
            text: ' *',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.black3D.adaptiveColor(context, lightModeColor: AppColors.black3D, darkModeColor: AppColors.greyB0)),
          ),
        ],
      ),
    );
  }

  static addFieldLabel({
    required BuildContext context,
    required String label,
  }) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Text(label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.black14.adaptiveColor(context, lightModeColor: AppColors.black14, darkModeColor: AppColors.greyB0))),
    );
  }

  static createDestinationWithLabel({
    required String labelText,
    required BuildContext context,
    TextStyle? textStyle,
    Color? containerColor,
    Color? borderColor,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: customInkWellWidget(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              color: containerColor ?? AppColors.white,
              border: Border.all(color: borderColor ?? AppColors.greyE8)),
          child: ListTile(
            title: Text(
              labelText,
              textAlign: TextAlign.center,
              style: textStyle ?? Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
      ),
    );
  }

  static customDrawerListItem(
      {required String clipPath,
      String? tileName,
      required VoidCallback onTap,
      required BuildContext buildContext,
      TextStyle? tileTextStyle,
      Widget? trailing}) {
    return customInkWellWidget(
      onTap: onTap,
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsetsDirectional.fromSTEB(4, 6, 6, 4),
            leading: svgIconContainer(context: buildContext, clipPath: clipPath, backgroundColor: Theme.of(buildContext).disabledColor),
            title: Text(
              tileName ?? '',
              style: tileTextStyle ?? Theme.of(buildContext).textTheme.titleMedium,
            ),
            trailing: trailing ?? const SizedBox.shrink(),
          ),
          Divider(
            color: Theme.of(buildContext).dividerColor,
            thickness: 1,
            height: 1,
          )
        ],
      ),
    );
  }

  static termsAndPrivacyText({
    required BuildContext context,
  }) {
    final localizations = appStrings(context);
    return Directionality(
      textDirection: Localizations.localeOf(context).languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: RichText(
        // textAlign: TextAlign.center,
        text: TextSpan(
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.black14.forLightMode(context),
              ),
          children: [
            TextSpan(
              text: localizations.agreeToTerms("", "", ""),
            ),
            TextSpan(
              text: localizations.terms,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.black14.forLightMode(context),
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  context.pushNamed(Routes.kWebViewScreen, extra: AppConstants.getTermsConditionsUrl(context), pathParameters: {
                    RouteArguments.title: appStrings(context).termsAndConditions,
                  });
                },
            ),
            TextSpan(
              text: " ${localizations.connector} ",
            ),
            TextSpan(
              text: localizations.privacy,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.black14.forLightMode(context),
                    decoration: TextDecoration.underline,
                  ),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  context.pushNamed(Routes.kWebViewScreen, extra: AppConstants.getPrivacyPolicyUrl(context), pathParameters: {
                    RouteArguments.title: appStrings(context).privacy,
                  });
                },
            ),
            const TextSpan(
              text: ".",
            ),
          ],
        ),
      ),
    );
  }

  static svgIconContainer(
      {required String clipPath,
      required Color backgroundColor,
      Size? size,
      double? radius,
      BuildContext? context,
      bool applyColorFilter = false,
      double? padding}) {
    return Container(
      padding: EdgeInsets.all(padding ?? 8.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius ?? 12),
      ),
      child: SvgPicture.asset(
        clipPath,
        width: size?.width ?? 24,
        height: size?.height ?? 24,
        colorFilter: applyColorFilter
            ? ColorFilter.mode(
                Theme.of(context!).highlightColor,
                BlendMode.srcIn,
              )
            : null,
        /*     colorFilter:
            ColorFilter.mode(Theme.of(context!).focusColor, BlendMode.srcIn),*/
      ),
    );
  }

  static iconRowAndText({
    required String svgPath,
    Color? iconColor,
    required String text,
    required Color backgroundColor,
    required BuildContext context,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            svgPath,
            colorFilter: ColorFilter.mode(
                iconColor ??
                    AppColors.colorPrimary.adaptiveColor(context, lightModeColor: AppColors.colorPrimary, darkModeColor: AppColors.white),
                BlendMode.srcIn),
          ),
          6.horizontalSpace,
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: h12().copyWith(color: textColor),
              textDirection: svgPath == SVGAssets.aspectRatioIcon ? TextDirection.ltr : Directionality.of(context),
            ),
          ),
        ],
      ),
    );
  }

  static dynamicIconRowAndText({
    required String svgPath,
    required String text,
    String? valueText,
    required Color backgroundColor,
    required BuildContext context,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          svgPath.startsWith('http')
              ? Image.network(
                  svgPath,
                  width: 22,
                  height: 22,
                  color:
                      AppColors.colorPrimary.adaptiveColor(context, lightModeColor: AppColors.colorPrimary, darkModeColor: AppColors.white),
                  fit: BoxFit.contain,
            errorBuilder: (context, error, stack) {
              return const SizedBox.shrink(); // Hides the image
            },
                )
              : SvgPicture.asset(
                  svgPath,
                  colorFilter: ColorFilter.mode(
                      AppColors.colorPrimary.adaptiveColor(context, lightModeColor: AppColors.colorPrimary, darkModeColor: AppColors.white),
                      BlendMode.srcIn),
                ),
          6.horizontalSpace,
          Visibility(
            visible: valueText != null && valueText != "",
            child: Flexible(
              child: Text(
                valueText ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: h12().copyWith(color: textColor),
              ),
            ),
          ),
          6.horizontalSpace.showIf(
                valueText != null && valueText != "",
              ),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: h12().copyWith(color: textColor),
              textDirection: svgPath == SVGAssets.aspectRatioIcon ? TextDirection.ltr : Directionality.of(context),
            ),
          ),
        ],
      ),
    );
  }

  static dataLoader() {
    return GestureDetector(
      // onTap: OverlayLoadingProgress.stop,
      child: Container(
        constraints: const BoxConstraints.expand(),
        color: Colors.white,
        child: GestureDetector(
          onTap: () {},
          child: const Center(
            child: SizedBox.square(
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: AppColors.colorPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  static dataListTile({
    required String title,
    required String icon,
    required VoidCallback onTap,
    required BuildContext context,
    bool isEnable = true,
  }) {
    return ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isEnable
                ? AppColors.colorPrimary
                    .withOpacity(0.10)
                    .adaptiveColor(context, lightModeColor: AppColors.colorPrimary.withOpacity(0.10), darkModeColor: AppColors.colorPrimary)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8), // Rounded container
          ),
          child: icon.toSvg(
            context: context,
            color: isEnable
                ? AppColors.colorPrimary.adaptiveColor(context, lightModeColor: AppColors.colorPrimary, darkModeColor: AppColors.white)
                : AppColors.grey77.adaptiveColor(context, lightModeColor: AppColors.grey77, darkModeColor: AppColors.greyE9),
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        trailing: UIComponent.customRTLIcon(
            child: SVGAssets.arrowRightIcon.toSvg(
              context: context,
              color: isEnable
                  ? AppColors.colorPrimary.adaptiveColor(context, lightModeColor: AppColors.colorPrimary, darkModeColor: AppColors.white)
                  : AppColors.grey77.adaptiveColor(context, lightModeColor: AppColors.grey77, darkModeColor: AppColors.greyE9),
            ),
            context: context),
        onTap: onTap);
  }

  static dataProgressLoader() {
    return const Expanded(
        child: Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [],
    ));
  }

  static noData(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              appStrings(context).textNoData,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  static noDataRoundedCard(BuildContext context) {
    return Container(
      width: double.infinity,
      // height: /*AppValues.screenHeight / 5*/ 200,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        /*border: Border.all(color: AppColors.greyBF, width: 1),
          borderRadius: BorderRadius.circular(10)*/
      ),
      child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SVGAssets.noData.toSvg(context: context),
              8.verticalSpace,
              Text(
                appStrings(context).noFileFound,
                textAlign: TextAlign.center,
                style: h12().copyWith(fontWeight: FontWeight.w500, color: Theme.of(context).primaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Get a phone number based on the country's dial code.
  static int getPhoneNumberLengthByDialCode(String countryCode) {
    Country? country = CountryUtils.getCountryByIsoCode(countryCode);
    if (country == null) {
      throw ArgumentError("Invalid dial code: $countryCode");
    }
    return country.phoneMaxLength;
  }

  static customStatusChip({
    required String statusTitle,
    required Color chipColor,
    required double borderRadius,
    Color? borderColor = Colors.transparent,
    double? horizontalPadding = 16.0,
    required TextStyle textStyle,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor ?? Colors.transparent),
        color: chipColor,
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(vertical: 6.0, horizontal: horizontalPadding ?? 16.0),
        child: Text(
          statusTitle,
          maxLines: 1,
          style: textStyle,
        ),
      ),
    );
  }

  static showMobileToast(String message, Toast toast) {
    Fluttertoast.showToast(msg: message, toastLength: toast);
  }

  static Future<void> showConfirmDialog({
    required String title,
    required String subtitle,
    required BuildContext context,
    required String positive,
    bool dismissible = true,
    String? negative,
    VoidCallback? onPositiveTap,
    VoidCallback? onNegativeTap,
  }) async =>
      await showDialog(
        context: context,
        barrierDismissible: dismissible,
        builder: (BuildContext context) {
          return MaterialAlertDialog(
            title: title,
            subtitle: subtitle,
            positiveButtonText: positive,
            negativeButtonText: negative,
            onPositiveTap: onPositiveTap,
            onNegativeTap: onNegativeTap,
            dismissible: dismissible, // Pass dismissible to control dialog behavior
          );
        },
      );

  Future<dynamic> showScreenDialog(Widget widget, BuildContext context, {bool dismissible = true, double borderRadius = 14}) async {}

  static socialMediaLoginButton(
      {required String text, required Widget icon, required Color textColor, required Color borderColor, required VoidCallback onTap}) {
    return UIComponent.customInkWellWidget(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(44), border: Border.all(color: borderColor)),
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(vertical: 14.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              icon,
              6.horizontalSpace,
              Text(
                text,
                style: h14().copyWith(color: textColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget customInkWellWidget({
    VoidCallback? onTap,
    Widget? child,
    double? padding,
  }) {
    return InkWell(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsetsDirectional.all(padding ?? 0),
          child: child,
        ));
  }

  static Widget createDivider({
    EdgeInsetsGeometry padding = const EdgeInsetsDirectional.symmetric(horizontal: 16.0, vertical: 8),
    double height = 2,
    Color color = AppColors.greyE8,
  }) {
    return Padding(
      padding: padding,
      child: Divider(
        height: height,
        color: color,
      ),
    );
  }

  static buildDropdownFormField<T>(
      {required List<DropdownMenuItem<T>> items,
      required T? value,
      required void Function(T?) onChanged,
      required String labelText,
      InputDecoration? decoration,
      required BuildContext context}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: h14().copyWith(fontWeight: FontWeight.w500),
        ),
        5.verticalSpace,
        DropdownButtonFormField<T>(
          icon: SVGAssets.arrowDownIcon.toSvg(context: context),
          items: items,
          value: value,
          onChanged: onChanged,
          decoration: InputDecoration(
            contentPadding: const EdgeInsetsDirectional.symmetric(vertical: 14.0, horizontal: 16.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: AppColors.greyE8, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: AppColors.greyE8, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: AppColors.greyE8, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: AppColors.deleteIconColor, width: 2),
            ),
          ),
        ),
      ],
    );
  }



  static bottomSheetWithButtonWithGradient(
      {required BuildContext context,
      required void Function() onTap,
      void Function()? onSecondTap,
      required String buttonTitle,
      String? secondButtonTitle,
      Color? buttonBgColor,
      Color? buttonTextColor,
      Color? secondButtonBgColor,
      bool? isGradientColor = true,
      bool? isGradientColorForSecondButton = false,
      bool isShadowNeeded = false,
      bool? isSecondButtonNeeded = false,
      bool? isSelected = false,
      bool? enabled = true,
      String? suffixIcon,
      String? prefixIcon,
      bool? isSuffixArrowNeeded}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white.adaptiveColor(context, lightModeColor: AppColors.white, darkModeColor: AppColors.black2E),
        boxShadow: isShadowNeeded
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      height: 94,
      child: ClipPath(
          clipper: TopRoundedClipper(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
            child: Row(
              children: [
                Expanded(
                  child: CommonButton(
                    onTap: onSecondTap ?? () {},
                    enabled: enabled ?? true,
                    title: secondButtonTitle ?? "-",
                    buttonBgColor: secondButtonBgColor,
                    isGradientColor: isGradientColorForSecondButton,
                  ),
                ).showIf(isSecondButtonNeeded == true),
                12.horizontalSpace.showIf(isSecondButtonNeeded == true),
                Expanded(
                  child: CommonButton(
                    onTap: onTap,
                    title: buttonTitle,
                    enabled: enabled ?? true,
                    buttonTextColor: buttonTextColor ?? AppColors.white,
                    buttonBgColor: buttonBgColor ?? AppColors.colorPrimary,
                    prefixIcon: prefixIcon,
                    suffixIcon: suffixIcon,
                    isSuffixArrowNeeded: isSuffixArrowNeeded,
                  ),
                ),
              ],
            ),
          )),
    );
  }

  static Widget cachedNetworkImageWidget(
      {required dynamic imageUrl, double? height, double? width, BoxFit? fit, VoidCallback? onTap, bool isForProperty = false}) {
    if (imageUrl == null || imageUrl.toString().isEmpty) {
      return SvgPicture.asset(
        isForProperty ? SVGAssets.propertyPlaceholder : SVGAssets.placeholder,
        fit: BoxFit.cover,
        height: height,
        width: double.infinity,
      );
    }
    if (imageUrl.toString().endsWith('.gif')) {
      return MyGif(
        gifUrl: imageUrl.toString(),
        height: height,
      );
    }
    if (imageUrl.toString().endsWith('.svg')) {
      return SvgPicture.network(
        imageUrl.toString(),
        height: height,
        fit: BoxFit.cover,
        width: double.infinity,
      );
    }

    return CachedNetworkImage(
      height: height ?? double.infinity,
      width: width ?? double.infinity,
      fit: fit ?? BoxFit.cover,
      imageUrl: imageUrl.toString(),
      errorWidget: (context, url, error) => SvgPicture.asset(
        isForProperty ? SVGAssets.propertyPlaceholder : SVGAssets.placeholder,
        fit: BoxFit.cover,
        height: height ?? double.infinity,
        width: double.infinity,
      ),
      placeholder: (context, url) => SvgPicture.asset(
        isForProperty ? SVGAssets.propertyPlaceholder : SVGAssets.placeholder,
        fit: BoxFit.cover,
        height: height ?? double.infinity,
        width: double.infinity,
      ),
    );
  }

  static noDataWidgetWithInfo({required String? title, required String? info, required BuildContext context}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          title ?? '',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        8.verticalSpace,
        Text(
          info ?? '',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.grey8A,
              ),
        ),
      ],
    );
  }

  static Widget titleWithUnit({
    required BuildContext context,
    required String fieldName,
    String? fieldMetricValue,
    TextStyle? fieldNameStyle,
    TextStyle? fieldMetricValueStyle,
  }) {
    return RichText(
      text: TextSpan(
        text: fieldName,
        style: fieldNameStyle ??
            Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.black3D.adaptiveColor(
                    context,
                    lightModeColor: AppColors.black3D,
                    darkModeColor: AppColors.greyB0,
                  ),
                ),
        children: [
          if (fieldMetricValue != null)
            TextSpan(
              text: ' ($fieldMetricValue)',
              style: fieldMetricValueStyle ??
                  Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w400,
                        color: AppColors.black3D.adaptiveColor(
                          context,
                          lightModeColor: AppColors.black3D,
                          darkModeColor: AppColors.greyB0,
                        ),
                      ),
            ),
        ],
      ),
    );
  }

  static Future<void> showPlacePicker({
    required BuildContext context,
    required Function(LocationResult result) onPlacePicked,
    required TextDirection someNullableTextDirection,
    LatLng? initialLocation,
    bool? enableNearbyPlaces,
  }) async {
    AppPreferences appPreferences = AppPreferences();
    var locale = await appPreferences.getLanguageCode();
    print("initialLocation ${initialLocation?.latitude} ${initialLocation?.longitude}");
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return PlacePicker(
            mapsBaseUrl: kIsWeb
                ? 'https://cors-anywhere.herokuapp.com/https://maps.googleapis.com/maps/api/'
                : "https://maps.googleapis.com/maps/api/",
            usePinPointingSearch: true,
            apiKey: Platform.isAndroid ? AppStrings.mapAPIKey : AppStrings.iosMapAPIKey,
            localizationConfig: LocalizationConfig(
              languageCode: locale == 'ar' ? 'ar_ae' : 'en_us',
              noResultsFound: appStrings(context).noResultsFound,
              selectActionLocation: appStrings(context).selectActionLocation,
              unnamedLocation: appStrings(context).unnamedLocation,
              findingPlace: appStrings(context).findingPlace,
            ),
            initialLocation: initialLocation,
            onPlacePicked: (LocationResult result) {
              debugPrint("Place picked: ${result.latLng?.latitude}:${result.latLng?.longitude}");

              Navigator.of(context).pop();
              onPlacePicked(result);
            },
            enableNearbyPlaces: enableNearbyPlaces ?? false,
            showSearchInput: true,
            // initialLocation: initialLocation,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onMapCreated: (controller) {},
            searchInputConfig: SearchInputConfig(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              autofocus: false,
              textDirection: someNullableTextDirection,
            ),
            searchInputDecorationConfig: SearchInputDecorationConfig(
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SvgPicture.asset(
                  SVGAssets.searchIcon,
                  height: 22,
                  width: 22,
                  colorFilter: ColorFilter.mode(Theme.of(context).focusColor, BlendMode.srcIn),
                ),
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
// Adjust the radius as needed
                borderSide: BorderSide.none, // Set to none if you don't want a visible border
              ),
              hintText: appStrings(context).textSearchForABuilding,
              hintStyle: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.black3D.forLightMode(context)),
            ),
            autocompletePlacesSearchRadius: 16,
          );
        },
      ),
    );
  }

  static Future<String> chooseDate(
    BuildContext context,
    String helpText,
    TextEditingController textController,
    String datFormat,
    DateTime selectedDate, {
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: firstDate ?? DateTime(1990),
      lastDate: lastDate ?? DateTime(2100),
      helpText: helpText,
      useRootNavigator: false,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
          child: Theme(
            data: Theme.of(context).copyWith(
              cardColor: AppColors.white,
              dialogBackgroundColor: Colors.white,
              textTheme: Theme.of(context).textTheme.copyWith(
                    titleSmall: Theme.of(context).textTheme.bodySmall,
                    titleMedium: Theme.of(context).textTheme.bodyMedium,
                    titleLarge: Theme.of(context).textTheme.titleMedium,
                  ),
              colorScheme: Theme.of(context).colorScheme.copyWith(
                    surface: AppColors.primaryGradient.colors[1].adaptiveColor(
                      context,
                      lightModeColor: AppColors.primaryGradient.colors[1],
                      darkModeColor: AppColors.goldA1,
                    ),
                    primary: AppColors.primaryGradient.colors[1].adaptiveColor(
                      context,
                      lightModeColor: AppColors.primaryGradient.colors[1],
                      darkModeColor: AppColors.goldA1,
                    ),
                    onSurface: Theme.of(context).highlightColor,
                    onPrimary: AppColors.white,
                  ),
            ),
            child: child!,
          ),
        );
      },
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      selectedDate = pickedDate;
      textController.text = intl.DateFormat(datFormat).format(selectedDate).toString();
    }

    return textController.text.toString();
  }

  static Future<String> chooseTime(
    BuildContext context,
    String helpText,
    TextEditingController textController,
    TimeOfDay selectedTime,
    String selectedDate, // In the format 'dd/MM/yyyy'
  ) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            cardColor: AppColors.white,
            dialogBackgroundColor: Colors.white,
            textTheme: Theme.of(context).textTheme.copyWith(
                  titleSmall: Theme.of(context).textTheme.bodySmall,
                  titleMedium: Theme.of(context).textTheme.bodyMedium,
                  titleLarge: Theme.of(context).textTheme.titleMedium,
                ),
            buttonTheme: const ButtonThemeData(
              colorScheme: ColorScheme.light(
                primary: AppColors.colorPrimary,
              ),
            ),
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  surface: AppColors.primaryGradient.colors[1].adaptiveColor(
                    context,
                    lightModeColor: AppColors.primaryGradient.colors[1],
                    darkModeColor: AppColors.goldA1,
                  ),
                  primary: AppColors.primaryGradient.colors[1].adaptiveColor(
                    context,
                    lightModeColor: AppColors.primaryGradient.colors[1],
                    darkModeColor: AppColors.goldA1,
                  ),
                  onSurface: Theme.of(context).highlightColor,
                  onPrimary: Theme.of(context).highlightColor,
                ),
          ),
          child: child!,
        );
      },
      initialEntryMode: TimePickerEntryMode.input,
      helpText: helpText,
      cancelText: appStrings(context).cancelText,
      confirmText: appStrings(context).confirmText,
      errorInvalidText: appStrings(context).errorInvalidText,
      hourLabelText: appStrings(context).hourLabelText,
      minuteLabelText: appStrings(context).minuteLabelText,
    );

    if (pickedTime != null) {
// Print logs for debugging
      print("selectedDate--- $selectedDate");
      print("PickedTime--- $pickedTime");

// Convert selectedDate to DateTime
      intl.DateFormat dateFormat = intl.DateFormat("dd/MM/yyyy");
      DateTime selectedDateTime = dateFormat.parse(selectedDate);

// Get the current date and time
      DateTime now = DateTime.now();

// Combine the selected date with the picked time (so that we can compare them)
      DateTime selectedDateTimeWithPickedTime = DateTime(
        selectedDateTime.year,
        selectedDateTime.month,
        selectedDateTime.day,
        pickedTime.hour,
        pickedTime.minute,
      );

// Compare the selected datetime with the current datetime
      if (selectedDateTimeWithPickedTime.isBefore(now)) {
        Utils.snackBar(
          context: context,
          message: appStrings(context).timeInPastError,
        );
        return textController.text; // Return without updating
      }

// If time is valid, format and update the textController
      selectedTime = pickedTime;
      final localizations = MaterialLocalizations.of(context);
      final formattedTimeOfDay = localizations.formatTimeOfDay(selectedTime);
      textController.text = formattedTimeOfDay;
      return formattedTimeOfDay;
    }

    return MaterialLocalizations.of(context).formatTimeOfDay(selectedTime);
  }

  static bool isSelectableDay(DateTime day, DateTime initialDate) {
    return !initialDate.isAtSameMomentAs(day);
  }

  static Future<String> chooseDateRange(
      BuildContext context, String helpText, TextEditingController textController, String datFormat, DateTime startDate, DateTime endDate,
      {DateTime? firstDate, String? selectedDateRange, DateTime? lastDate}) async {
    DateTimeRange? pickedDate = await showDateRangePicker(
      context: context,
      firstDate: firstDate ?? DateTime(1990),
      lastDate: lastDate ?? DateTime(2100),
      helpText: helpText,
    );
    if (pickedDate != null) {
      startDate = pickedDate.start;
      endDate = pickedDate.end;
      String formatStartDate = intl.DateFormat(datFormat).format(startDate).toString();
      String formatEndDate = intl.DateFormat(datFormat).format(endDate).toString();
      selectedDateRange = "$formatStartDate - $formatEndDate";
      textController.text = selectedDateRange;
    }
    return textController.text.toString();
  }

  static String formatDate(String date, String dateFormat) {
    print("date $date");
    if (date.isEmpty) {
      return "";
    }
    var newDate = "";
    final intl.DateFormat formatter = intl.DateFormat(dateFormat);
    newDate = formatter.format(DateTime.parse(date).toLocal());
    return newDate;
  }

  static String convertDateFormat(String date) {
// Parse the original date string
    intl.DateFormat originalFormat = intl.DateFormat('dd/MM/yyyy');
    DateTime parsedDate = originalFormat.parse(date);

// Format the parsed date to the new format
    intl.DateFormat newFormat = intl.DateFormat('yyyy-MM-dd');
    return newFormat.format(parsedDate);
  }

  static String formatTimestamp(int timestamp, String dateFormat) {
// Convert Unix timestamp (milliseconds) to DateTime
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

// Format DateTime to "dd/MM/yyyy, HH:mm" format
    String formattedDateTime = intl.DateFormat(dateFormat).format(dateTime);

    return formattedDateTime;
  }

  static String formatTimeStr(String timeStr, String timeFormat) {
// Convert Unix timestamp (milliseconds) to DateTime
    DateTime dateTime = intl.DateFormat("HH:mm:ss").parse(timeStr);

// Format DateTime to "dd/MM/yyyy, HH:mm" format
    String formattedDateTime = intl.DateFormat(timeFormat).format(dateTime);

    return formattedDateTime;
  }

  static String formatDateTimeStr(String timeStr, String timeFormat, {String locale = 'en'}) {
    DateTime dateTime = DateTime.parse(timeStr).toLocal(); // Convert to local time if needed

    // Format DateTime to the desired format
    String formattedDateTime = intl.DateFormat(timeFormat, locale).format(dateTime);

    return formattedDateTime;
  }

  static num calculateTotalMilestonePrice({num? hours, num? hourlyPrice}) {
    if (hours != null && hourlyPrice != null) {
// Multiply the hours and hourlyPrice
      num totalPrice = hours * hourlyPrice;

// Convert the total price to a string
      return totalPrice;
    } else {
// If either hours or hourlyPrice is null, return an empty string
      return 0;
    }
  }

  static Row buildCupertinoOptionRow({required IconData iconData, required String text, required BuildContext context}) {
    return Row(
      children: [
        Icon(
          iconData,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(width: 10),
        Text(text, style: TextStyle(color: Theme.of(context).primaryColor)),
      ],
    );
  }

  static Widget customRTLIcon({required Widget child, required BuildContext context, Alignment? alignment = Alignment.center}) {
    return Transform(
      alignment: alignment,
      transform: TextDirection.rtl == Directionality.of(context) ? Matrix4.rotationY(math.pi) : Matrix4.identity(),
      child: child,
    );
  }

  static Widget customTextChip({required String? chipLabel, required bool isForDetails}) {
    return Container(
      padding: isForDetails ? const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 12) : const EdgeInsetsDirectional.all(12),
      decoration: BoxDecoration(
        color: AppColors.colorPrimary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        chipLabel ?? "",
        style: h12().copyWith(fontWeight: FontWeight.w500),
      ),
    );
  }

  static customFieldNameWithClearText(
      {required String fieldName, required VoidCallback onTap, required BuildContext context, required bool isNoData}) {
    return Row(
      children: [
        RichText(
          text: TextSpan(
            text: fieldName,
            style: h14().copyWith(fontWeight: FontWeight.w500),
            children: const [
              TextSpan(
                text: ' *',
                style: TextStyle(
                  color: AppColors.black,
                ),
              ),
            ],
          ),
        ),
        16.horizontalSpace,
        UIComponent.customInkWellWidget(
          onTap: onTap,
          child: Text(appStrings(context).textClear,
              style: redditSansCondensedText(
                14,
                fontWeight: FontWeight.w500,
                color: AppColors.black14,
                hasUnderLine: true,
                decorationColor: AppColors.black,
              )),
        ).hideIf(isNoData),
      ],
    );
  }

  static customColoredContainer({required String title}) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.greyE8, width: 2), color: AppColors.black14, borderRadius: BorderRadius.circular(4)),
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(vertical: 14.0, horizontal: 12),
          child: Text(
            title,
            style: h14().copyWith(fontWeight: FontWeight.w500),
          ),
        ));
  }

  static settingItem({required VoidCallback onTap, required String title}) {
    return UIComponent.customInkWellWidget(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(vertical: 14.0, horizontal: 16),
        child: Text(
          title,
          style: h14().copyWith(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  static getSkeletonCategories() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 34,
            child: ListView.separated(
              itemCount: 3,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                return Skeletonizer.zone(
                  containersColor: AppColors.greyE8,
                  child: Container(
                    width: 120,
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: AppColors.greyE8,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Bone(
                      width: double.infinity,
                      height: 34,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return 8.horizontalSpace;
              },
            ),
          ),
        ],
      ),
    );
  }

  static getSkeletonProperty({bool isHorizontal = false}) {
    if (isHorizontal) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        child: Row(
          children: List.generate(3, (index) {
            return Padding(
              padding: EdgeInsets.only(
                left: index == 0 ? 0 : 12,
                right: index == 2 ? 0 : 12,
              ),
              child: Skeletonizer.zone(
                containersColor: AppColors.greyE8,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                  child: SizedBox(
                    width: 350,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Skeleton for the image
                        Bone(
                          width: double.infinity,
                          height: 220,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Skeleton for the title
                              const Bone.text(
                                words: 3,
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              // Skeleton for the price
                              Bone(
                                width: 60,
                                height: 16,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              const SizedBox(height: 16),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Skeleton for location
                                  Row(
                                    children: [
                                      Bone.circle(size: 20), // Location icon
                                      SizedBox(width: 8),
                                      Bone.text(words: 2),
                                    ],
                                  ),
                                  SizedBox(width: 8),
                                  // Skeleton for size
                                  Row(
                                    children: [
                                      Bone.circle(size: 20), // Size icon
                                      SizedBox(width: 8),
                                      Bone.text(
                                        words: 1,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      );
    }
    
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return Skeletonizer.zone(
          containersColor: AppColors.greyE8,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
// Skeleton for the image
                Bone(
                  width: double.infinity,
                  height: 220,
                  borderRadius: BorderRadius.circular(16),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
// Skeleton for the title
                      const Bone.text(
                        words: 3,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
// Skeleton for the price
                      Bone(
                        width: 60,
                        height: 16,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(height: 16),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
// Skeleton for location
                          Row(
                            children: [
                              Bone.circle(size: 20), // Location icon
                              SizedBox(width: 8),
                              Bone.text(words: 2),
                            ],
                          ),
                          SizedBox(width: 8),
// Skeleton for size
                          Row(
                            children: [
                              Bone.circle(size: 20), // Size icon
                              SizedBox(width: 8),
                              Bone.text(
                                words: 1,
                              ),
                            ],
                          ),
// SizedBox(width: 8),
// Skeleton for rating
// Row(
//   children: [
//     Bone.circle(size: 20), // Star icon
//     SizedBox(width: 8),
//     Bone.text(width: 0.3),
//   ],
// ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return 12.verticalSpace;
      },
    );
  }

  static getSkeletonVendor() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return Skeletonizer.zone(
          containersColor: AppColors.greyE8,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
// Skeleton for the image
                Bone(
                  width: double.infinity,
                  height: 180,
                  borderRadius: BorderRadius.circular(16),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
// Skeleton for the title
                      const Bone.text(
                        words: 3,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
// Skeleton for the price
                      Bone(
                        width: 60,
                        height: 16,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return 12.verticalSpace;
      },
    );
  }

  static getSkeletonNotification() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 8,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return Skeletonizer.zone(
          containersColor: AppColors.greyE8,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
// Skeleton for the image

                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// Skeleton for the title

                    Row(
                      children: [
                        Bone(
                          width: 54,
                          height: 54,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        const Column(
                          children: [
                            Bone.text(
                              words: 2,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Bone.text(
                              words: 2,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ],
                    ),

                    const SizedBox(height: 8),
// Skeleton for the price
                    const Bone.text(
                      words: 4,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    const Bone.text(
                      words: 4,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    const Bone.text(
                      words: 1,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return 12.verticalSpace;
      },
    );
  }

  static getSkeletonProfileDetail() {
    return Skeletonizer.zone(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          // Profile Image
          Skeletonizer.zone(
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Name
          const Center(
            child: Bone.text(
              words: 2,
            ),
          ),
          const SizedBox(height: 4),

          // Location
          const Center(
            child: Bone.text(
              words: 4,
            ),
          ),
          const SizedBox(height: 26),

          // Certificates Section
          Skeletonizer.zone(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: List.generate(3, (index) {
                  return Expanded(
                    child: Container(
                      height: 80,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 26),

          // Personal Information Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(6, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: index % 2 == 0
                      ? const Bone.text(
                          words: 6,
                        )
                      : const Bone.multiText(
                          lines: 3,
                        ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  static getSkeletonPropertyDetail() {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
// Skeleton for the image carousel
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Bone(
            width: double.infinity,
            height: 220,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        const SizedBox(height: 16),

// Skeleton for the title and description
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
// Title
              Bone.text(
                words: 3,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
// Description
              Bone.text(
                words: 6,
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 16),
// Location, size, and tags
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Bone.circle(size: 13), // Location icon
                        SizedBox(width: 4),
                        Bone.text(words: 2),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Row(
                      children: [
                        Bone.circle(size: 13), // Size icon
                        SizedBox(width: 4),
                        Bone.text(words: 2),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
// Skeleton for video and virtual tour buttons
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Bone(
                  height: 40,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Bone(
                  height: 40,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
// Skeleton for user profile section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              const Bone.circle(size: 40), // User profile image
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Bone.text(words: 2), // User name
                  const SizedBox(height: 4),
                  Bone(
                    width: 100,
                    height: 12,
                    borderRadius: BorderRadius.circular(4),
                  ), // Join date
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

// Skeleton for living space and amenities
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
// Living space
              const Bone.text(
                words: 2,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Bone(
                    width: 100,
                    height: 40,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  const SizedBox(width: 8),
                  Bone(
                    width: 100,
                    height: 40,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  const SizedBox(width: 8),
                  Bone(
                    width: 100,
                    height: 40,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ],
              ),
              const SizedBox(height: 16),

// Amenities
              const Bone.text(
                words: 2,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Bone(
                    width: 100,
                    height: 40,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  const SizedBox(width: 8),
                  Bone(
                    width: 100,
                    height: 40,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  const SizedBox(width: 8),
                  Bone(
                    width: 100,
                    height: 40,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        const SizedBox(height: 16),

// Skeleton for the map
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Bone(
            width: double.infinity,
            height: 200,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  static getReviewSkeleton() {
    return Column(
      children: [
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 6,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Skeletonizer.zone(
              containersColor: AppColors.greyE9,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Bone.circle(size: 40),
                          SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Bone.text(
                                words: 2,
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Bone(width: 20, height: 14), // Star skeleton
                                  SizedBox(width: 8),
                                  Bone(width: 40, height: 14), // Rating
                                  SizedBox(width: 8),
                                  Bone(width: 100, height: 14), // Published
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
// Skeleton for Comment
                      Bone.text(words: 10),
                    ],
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return 12.verticalSpace;
          },
        ),
      ],
    );
  }

  static getBankListSkeleton() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return Skeletonizer.zone(
          containersColor: AppColors.greyE8,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
// Image Skeleton
                Padding(
                  padding: const EdgeInsetsDirectional.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
// Skeleton for image
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 50,
                          width: 50,
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.greyE9,
                              width: 1,
                            ),
                          ),
                          child: const Bone.circle(size: 38), // Placeholder for image
                        ),
                      ),
                      const SizedBox(width: 8),
// Content Skeleton
                      const Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
// Skeleton for title
                            Bone.text(
                              words: 3,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
// Skeleton for description
                            Bone.text(words: 5),
                            SizedBox(height: 16),
// Footer Skeleton
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 4,
                                  children: [
// Skeleton for location icon and text
                                    Row(
                                      children: [
                                        Bone.circle(size: 20),
// Icon
                                        SizedBox(width: 8),
                                        Bone.text(words: 2),
// Location text
                                      ],
                                    ),
                                  ],
                                ),
                                Bone.circle(size: 22),
// Skeleton for arrow
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 12);
      },
    );
  }

  static getBankDetailSkeleton() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Row(
          children: [
            SkeletonBox(width: 100, height: 20, borderRadius: BorderRadius.circular(4)),
            const Spacer(),
            SkeletonBox(width: 40, height: 40, borderRadius: BorderRadius.circular(20)),
          ],
        ),
        const SizedBox(height: 24),

        SkeletonBox(width: double.infinity, height: 40, borderRadius: BorderRadius.circular(8)),
        const SizedBox(height: 8),
        SkeletonBox(width: double.infinity, height: 20, borderRadius: BorderRadius.circular(4)),
        const SizedBox(height: 16),

// Skeleton for "Contact Details" section
        SkeletonBox(width: double.infinity, height: 40, borderRadius: BorderRadius.circular(8)),
        const SizedBox(height: 16),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 2,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                SkeletonBox(width: 100, height: 20, borderRadius: BorderRadius.circular(4)),
                const Spacer(),
                SkeletonBox(width: 120, height: 20, borderRadius: BorderRadius.circular(4)),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),
        Row(
          children: [
            SkeletonBox(width: 20, height: 20, borderRadius: BorderRadius.circular(4)),
            const SizedBox(width: 12),
            SkeletonBox(width: 120, height: 20, borderRadius: BorderRadius.circular(4)),
          ],
        ),
      ],
    );
  }

  static getSkeletonVendorDetail() {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
// Skeleton for the image carousel
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Bone(
            width: double.infinity,
            height: 320,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        const SizedBox(height: 16),

// Skeleton for the title and description
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
// Title
              Bone.text(
                words: 16,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
// Description
              Bone.text(
                words: 100,
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
// Skeleton for video and virtual tour buttons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Bone(
                  height: 40,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Bone(
                  height: 40,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 158,
                child: ListView.separated(
                  itemCount: 2,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      height: 140,
                      width: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.colorPrimary.withOpacity(0.1),
                            blurRadius: 18,
                            offset: Offset(2, 2),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white.adaptiveColor(context, lightModeColor: Colors.white, darkModeColor: AppColors.black2E),
                      ),
                      child: Bone(),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return 24.horizontalSpace;
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  static getSkeletonOfferDetail() {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
// Skeleton for the image carousel
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Bone(
            width: double.infinity,
            height: 320,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        const SizedBox(height: 16),

// Skeleton for the title and description
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
// Title
              Bone.text(
                words: 16,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
// Description
              Bone.text(
                words: 100,
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 16),
              Bone.text(
                words: 100,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),
      ],
    );
  }
}

class TopRoundedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, 20); // Adjust the height of top rounded corners
    path.quadraticBezierTo(0, 0, 20, 0); // Adjust radius of top left corner
    path.lineTo(size.width - 20, 0);
    path.quadraticBezierTo(size.width, 0, size.width, 20); // Adjust radius of top right corner
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;

  const SkeletonBox({
    required this.width,
    required this.height,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: borderRadius,
      ),
    );
  }
}
