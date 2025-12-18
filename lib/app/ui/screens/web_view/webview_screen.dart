import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mashrou3/app/ui/custom_widget/app_bar_mixin.dart';
import 'package:mashrou3/app/ui/screens/app_prefereces/cubit/app_preferences_cubit.dart';
import 'package:mashrou3/config/network/network_constants.dart';
import 'package:mashrou3/config/resources/app_assets.dart';
import 'package:mashrou3/config/utils.dart';
import 'package:mashrou3/utils/app_localization.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:mashrou3/utils/ui_components.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../config/resources/app_colors.dart';
import 'cubit/web_view_cubit.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  final String title;

  const WebViewScreen({super.key, required this.url, required this.title});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> with AppBarMixin {
  late final WebViewController _controller;

  @override
  void dispose() {
    _controller.clearCache(); // Clears any ongoing activity
    _controller.clearLocalStorage(); // Clears any ongoing activity
    super.dispose();
  }

  @override
  void initState() {
    context.read<WebViewCubit>().getData();
    super.initState();
    context.read<WebViewCubit>().startLoading();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
          onPageStarted: (String url) {
            if (mounted) {
              context.read<WebViewCubit>().startLoading();
            }
          },
          onPageFinished: (String url) {
            if (mounted) {
              context.read<WebViewCubit>().finishLoading();
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
          onHttpError: (error){
            print("onHttpError $error");
          },
          onWebResourceError: (_) {
            print("onWebResourceError $_");
          },
          onHttpAuthRequest: (request) async {
            print("onHttpAuthRequest $request");
          }))
      ..loadRequest(Uri.parse(widget.url));
    if (mounted) {
      context.read<WebViewCubit>().finishLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    print("url ${widget.url}");
    return BlocConsumer<WebViewCubit, WebViewState>(
      listener: (context, state) {},
      builder: (_, state) {
        var cubit = context.read<WebViewCubit>();
        var isTitleNotNeeded = widget.title == appStrings(context).videoLink ||
            widget.title == appStrings(context).virtualTour;
        var isTextOnly =
            widget.title == appStrings(context).supportAndSocialMedia;

        return Scaffold(
          appBar: isTitleNotNeeded
              ? null
              : buildAppBar(
                  context: context,
                  title: widget.title,
                ),
          body: isTextOnly
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UIComponent.customDrawerListItem(
                        clipPath: Utils.isDark(context)
                            ? SVGAssets.supportMailWhite
                            : SVGAssets.supportMail,
                        tileName: cubit.supportData.email ?? "",
                        onTap: () {
                          Utils.composeMail(
                            context: context,
                            email: (cubit.supportData.email ?? "").toString(),
                          );
                        },
                        trailing: null,
                        buildContext: context,
                      ),
                      const SizedBox(height: 10),
                      UIComponent.customDrawerListItem(
                        clipPath: Utils.isDark(context)
                            ? SVGAssets.supportCallWhite
                            : SVGAssets.supportCall,
                        tileName: cubit.supportData.phone ?? "",
                        onTap: () {
                          Utils.makePhoneCall(
                            context: context,
                            phoneNumber:
                                (cubit.supportData.phone ?? "").toString(),
                          );
                        },
                        trailing: null,
                        buildContext: context,
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          UIComponent.customInkWellWidget(
                              onTap: () async {
                                await Utils.launchURL(
                                    url: NetworkConstants.facebookMashrou3);
                              },
                              child: SVGAssets.facebookVector.toSvg(
                                  context: context, height: 32, width: 32)),
                          12.horizontalSpace,
                          UIComponent.customInkWellWidget(
                              onTap: () async {
                                await Utils.launchURL(
                                    url: NetworkConstants.linkedInMashrou3);
                              },
                              child: SVGAssets.linkedinVector.toSvg(
                                  context: context, height: 32, width: 32)),
                          12.horizontalSpace,
                          UIComponent.customInkWellWidget(
                            onTap: () async {
                              await Utils.launchURL(
                                  url: NetworkConstants.instagramMashrou3);
                            },
                            child: SVGAssets.instagramVector
                                .toSvg(context: context, height: 32, width: 32),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : Stack(
                  children: [
                    WebViewWidget(controller: _controller),
                    if (state is WebViewLoadingStatus)
                      if (state.isLoading)
                        Container(
                          color: AppColors.white,
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: AppColors.colorPrimary,
                            ),
                          ),
                        ),
                    isTitleNotNeeded ? getBackIcon(context) : const SizedBox(),
                  ],
                ),
        );
      },
    );
  }

  Widget getBackIcon(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
          start: 16.0, top: MediaQuery.of(context).padding.top),
      child: UIComponent.customInkWellWidget(
        onTap: () {
          if (context.canPop()) {
            context.pop();
          }
        },
        child: Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: AppColors.greyE9.adaptiveColor(context,
                        lightModeColor: AppColors.greyE9,
                        darkModeColor: AppColors.black3D),
                    width: 1)),
            child: BlocConsumer<AppPreferencesCubit, AppPreferencesState>(
              listener: (context, state) {},
              builder: (context, state) {
                final cubit = context.watch<AppPreferencesCubit>();
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
                        Theme.of(context).focusColor, BlendMode.srcIn),
                  ),
                );
              },
            )),
      ),
    );
  }
}
