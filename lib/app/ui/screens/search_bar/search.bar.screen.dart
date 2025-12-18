import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mashrou3/app/ui/custom_widget/app_bar_mixin.dart';
import 'package:mashrou3/app/ui/screens/authentication/component/otp_widget/bloc/otp_input_section_cubit.dart';
import 'package:mashrou3/config/resources/app_colors.dart';
import 'package:mashrou3/utils/extensions.dart';

import '../../../../../../config/utils.dart';
import '../../../../../../utils/app_localization.dart';
import '../../../../../config/resources/app_assets.dart';
import '../../../../../utils/ui_components.dart';
import '../../../../utils/input_formatters.dart';
import '../../custom_widget/loader/overlay_loading_progress.dart';
import '../../custom_widget/text_form_fields/search_text_form_field.dart';
import '../app_prefereces/cubit/app_preferences_cubit.dart';
import 'cubit/search_bar_cubit.dart';

class SearchBarScreen extends StatefulWidget {
  const SearchBarScreen({super.key, required this.searchText});

  final String searchText;

  @override
  State<SearchBarScreen> createState() => _SearchBarScreenState();
}

class _SearchBarScreenState extends State<SearchBarScreen> with AppBarMixin {
  @override
  void initState() {
    context.read<SearchBarCubit>().getData(context, widget.searchText);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SearchBarCubit cubit = context.read<SearchBarCubit>();
    return BlocConsumer<SearchBarCubit, SearchBarState>(
        listener: buildBlocListener,
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Form(
              key: cubit.searchFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      (MediaQuery.of(context).padding.top + 8).verticalSpace,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Back Arrow Container
                          Padding(
                            padding: const EdgeInsetsDirectional.only(
                                start: 16.0, end: 12.0),
                            child: Container(
                              height: 48,
                              width: 48,
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColors.greyE8.adaptiveColor(
                                    context,
                                    lightModeColor: AppColors.greyE8,
                                    darkModeColor: AppColors.black2E,
                                  ),
                                  width: 1,
                                ),
                              ),
                              child: UIComponent.customInkWellWidget(
                                onTap: () {
                                  if (context.canPop()) {
                                    context.pop();
                                  }
                                },
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

                                    return Center(
                                      child: SvgPicture.asset(
                                        arrowIcon,
                                        height: 26,
                                        width: 26,
                                        colorFilter: ColorFilter.mode(
                                          Theme.of(context).focusColor,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),

                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsetsDirectional.only(end: 16.0),
                              child: SearchTextFormField(
                                controller: cubit.searchCtl,
                                fieldHint: appStrings(context).textSearch,
                                maxLines: 1,
                                textInputAction: TextInputAction.search,
                                keyboardType: TextInputType.text,
                                onChanged: (value) {
                                  if (value.isEmpty &&
                                      MediaQuery.of(context)
                                              .viewInsets
                                              .bottom !=
                                          0) {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  }
                                  cubit.showSuffixIcon = true;
                                  cubit.showHideSuffix(cubit.showSuffixIcon);
                                },
                                showSuffixIcon: true,
                                functionSuffix: () {
                                  cubit.searchCtl.clear();
                                  cubit.showSuffixIcon = false;
                                  cubit.showHideSuffix(cubit.showSuffixIcon);
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                                suffixIcon: cubit.showSuffixIcon
                                    ? SVGAssets.cancelIcon.toSvg(
                                        context: context,
                                        height: 18,
                                        width: 18,
                                        color: AppColors.black34.adaptiveColor(
                                            context,
                                            lightModeColor: AppColors.black34,
                                            darkModeColor: AppColors.white))
                                    : SVGAssets.searchIcon.toSvg(
                                        context: context,
                                        height: 18,
                                        width: 18),
                                onSubmitted: (value) async {
                                  if (value.isNotEmpty) {
                                    await cubit.saveSearchHistory(
                                        value); // Save to history
                                    cubit.searchCtl.clear();
                                    Navigator.pop(context,
                                        value); // Return the search text
                                  }
                                },
                                inputFormatters: [
                                  InputFormatters().emojiRestrictInputFormatter,
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                            start: 16.0, top: 16.0, end: 12.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            appStrings(context).textRecentSearch,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.black3D.adaptiveColor(
                                        context,
                                        lightModeColor: AppColors.black3D,
                                        darkModeColor: AppColors.white)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: cubit.searchHistory.length,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      // reverse: true,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        // Access the reversed index
                        final reversedIndex =
                            cubit.searchHistory.length - 1 - index;
                        return ListTile(
                          horizontalTitleGap: 8,
                          leading: UIComponent.customInkWellWidget(
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsetsDirectional.only(
                                  start: 8.0, end: 4),
                              child: SVGAssets.searchIcon.toSvg(
                                  context: context,
                                  height: 18,
                                  width: 18,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                          trailing: UIComponent.customInkWellWidget(
                            onTap: () {
                              cubit.removeSearchTerm(
                                  cubit.searchHistory[reversedIndex]);
                            },
                            child: Padding(
                              padding: const EdgeInsetsDirectional.only(
                                  start: 8.0, end: 4),
                              child: SVGAssets.cancelIcon.toSvg(
                                  context: context,
                                  height: 18,
                                  width: 18,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                          title: Text(
                            cubit.searchHistory[reversedIndex],
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context).primaryColor),
                          ),
                          onTap: () {
                            Navigator.pop(
                                context, cubit.searchHistory[reversedIndex]);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  /// Build bloc listener widget.
  Future<void> buildBlocListener(
      BuildContext context, SearchBarState state) async {
    if (state is SearchBarLoading) {
      OverlayLoadingProgress.start(context);
    } else if (state is SearchBarError) {
      OverlayLoadingProgress.stop();
      if (state.errorMessage.toLowerCase().contains("exist")) {
        context.read<OtpInputSectionCubit>().isAlreadyExist = true;
      }
      Utils.showErrorMessage(
          context: context,
          message: state.errorMessage.contains('No internet')
              ? appStrings(context).noInternetConnection
              : state.errorMessage);
    }
  }
}
