import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mashrou3/app/navigation/route_arguments.dart';
import 'package:mashrou3/app/navigation/routes.dart';
import 'package:mashrou3/app/ui/custom_widget/app_bar_mixin.dart';
import 'package:mashrou3/app/ui/screens/cms/cubit/cms_cubit.dart';
import 'package:mashrou3/config/resources/app_assets.dart';
import 'package:mashrou3/config/resources/app_colors.dart';
import 'package:mashrou3/config/resources/app_constants.dart';
import 'package:mashrou3/config/utils.dart';
import 'package:mashrou3/utils/app_localization.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:mashrou3/utils/ui_components.dart';

class CmsScreen extends StatefulWidget {
  const CmsScreen({super.key, required this.licenseUrl});

  final String licenseUrl;

  @override
  State<CmsScreen> createState() => _CmsScreenState();
}

class _CmsScreenState extends State<CmsScreen> with AppBarMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
          context: context,
          requireLeading: true,
          title: appStrings(context).policies_support,
          onBackTap: () {
            Navigator.pop(context);
          }),
      body: SingleChildScrollView(
        child: _buildBlocConsumer,
      ),
    );
  }

  /// Build bloc consumer widget.
  ///
  Widget get _buildBlocConsumer {
    return BlocConsumer<CmsCubit, CmsState>(
      listener: buildBlocListener,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
          child: Column(
            children: [
              UIComponent.customDrawerListItem(
                clipPath: Utils.isDark(context) ? SVGAssets.bookLightIcon : SVGAssets.bookIcon,
                tileName: appStrings(context).termsAndConditions,
                tileTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                onTap: () {
                  context.pushNamed(Routes.kWebViewScreen, extra: AppConstants.getTermsConditionsUrl(context), pathParameters: {
                    RouteArguments.title: appStrings(context).termsAndConditions,
                  });
                },
                buildContext: context,
                trailing: UIComponent.customRTLIcon(
                    child: SVGAssets.arrowRightIcon.toSvg(
                      context: context,
                      color: AppColors.colorPrimary
                          .adaptiveColor(context, lightModeColor: AppColors.colorPrimary, darkModeColor: AppColors.white),
                    ),
                    context: context),
              ),
              UIComponent.customDrawerListItem(
                clipPath: Utils.isDark(context) ? SVGAssets.customerSupportLightIcon : SVGAssets.customerSupportIcon,
                tileName: appStrings(context).supportAndSocialMedia,
                tileTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                onTap: () {
                  context.pushNamed(Routes.kWebViewScreen, extra: AppConstants.getTermsConditionsUrl(context), pathParameters: {
                    RouteArguments.title: appStrings(context).supportAndSocialMedia,
                  });
                },
                buildContext: context,
                trailing: UIComponent.customRTLIcon(
                    child: SVGAssets.arrowRightIcon.toSvg(
                      context: context,
                      color: AppColors.colorPrimary
                          .adaptiveColor(context, lightModeColor: AppColors.colorPrimary, darkModeColor: AppColors.white),
                    ),
                    context: context),
              ),
              UIComponent.customDrawerListItem(
                  clipPath: Utils.isDark(context) ? SVGAssets.licenceWhite : SVGAssets.licence,
                  tileName: appStrings(context).license,
                  tileTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  onTap: () {
                    context.pushNamed(Routes.kWebViewScreen, extra: widget.licenseUrl, pathParameters: {
                      RouteArguments.title: appStrings(context).license,
                    });
                  },
                  buildContext: context,
                  trailing: UIComponent.customRTLIcon(
                      child: SVGAssets.arrowRightIcon.toSvg(
                        context: context,
                        color: AppColors.colorPrimary
                            .adaptiveColor(context, lightModeColor: AppColors.colorPrimary, darkModeColor: AppColors.white),
                      ),
                      context: context)),
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
  void buildBlocListener(BuildContext context, CmsState state) {}
}
