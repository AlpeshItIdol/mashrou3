import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mashrou3/app/model/city_list_response_model.dart';
import 'package:mashrou3/app/ui/custom_widget/app_bar_mixin.dart';
import 'package:mashrou3/app/ui/custom_widget/city_list/cubit/city_list_cubit.dart';
import 'package:mashrou3/app/ui/custom_widget/text_form_fields/search_text_form_field.dart';
import 'package:mashrou3/config/resources/app_assets.dart';
import 'package:mashrou3/config/resources/app_colors.dart';
import 'package:mashrou3/utils/app_localization.dart';
import 'package:mashrou3/utils/debouncer.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:mashrou3/utils/input_formatters.dart';
import 'package:mashrou3/utils/ui_components.dart';

import '../../screens/app_prefereces/cubit/app_preferences_cubit.dart';

class CityListScreen extends StatefulWidget {
  const CityListScreen({super.key, required this.countryId});

  final String countryId;

  @override
  State<CityListScreen> createState() => _CityListScreenState();
}

class _CityListScreenState extends State<CityListScreen> with AppBarMixin {
  final _debouncer = Debouncer(milliseconds: 500);
  final PagingController<int, Cities> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    context.read<CityListCubit>().searchCtl.clear();
    context.read<CityListCubit>().showSuffixIcon = false;
    _pagingController.addPageRequestListener((pageKey) {
      context.read<CityListCubit>().getCityListWithPagination(
          pageKey: pageKey, context: context, id: widget.countryId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CityListCubit, CityListState>(
      listener: buildBlocListener,
      builder: (context, state) {
        CityListCubit cubit = context.read<CityListCubit>();
        return Scaffold(
            body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            (MediaQuery.of(context).padding.top + 8).verticalSpace,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Back Arrow Container
                Padding(
                  padding:
                      const EdgeInsetsDirectional.only(start: 16.0, end: 12.0),
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
                          final cubit = context.watch<AppPreferencesCubit>();
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
                    padding: const EdgeInsetsDirectional.only(end: 16.0),
                    child: SearchTextFormField(
                      controller: cubit.searchCtl,
                      fieldHint: appStrings(context).textSearch,
                      maxLines: 1,
                      textInputAction: TextInputAction.search,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        if (value.isEmpty) {
                          setState(() {
                            cubit.showSuffixIcon = false;
                          });
                        } else {
                          _debouncer.run(() async {
                            _pagingController.refresh();
                          });
                          cubit.showSuffixIcon = true;
                          cubit.showHideSuffix(cubit.showSuffixIcon);
                        }
                      },
                      showSuffixIcon: true,
                      functionSuffix: () {
                        setState(() {
                          cubit.searchCtl.clear();
                        });
                        cubit.showSuffixIcon = false;
                        cubit.showHideSuffix(cubit.showSuffixIcon);
                        FocusManager.instance.primaryFocus?.unfocus();
                        _pagingController.refresh();
                      },
                      suffixIcon: cubit.showSuffixIcon
                          ? SVGAssets.cancelIcon.toSvg(
                              context: context,
                              height: 18,
                              width: 18,
                              color: AppColors.black34.adaptiveColor(context,
                                  lightModeColor: AppColors.black34,
                                  darkModeColor: AppColors.white))
                          : SVGAssets.searchIcon
                              .toSvg(context: context, height: 18, width: 18),
                      onSubmitted: (value) async {
                        if (value.isEmpty) {
                          setState(() {
                            cubit.showSuffixIcon = false;
                          });
                        }
                        _debouncer.run(() {
                          _pagingController.refresh();
                        });
                      },
                      inputFormatters: [
                        InputFormatters().emojiRestrictInputFormatter,
                      ],
                    ),
                  ),
                ),
              ],
            ),
            12.verticalSpace,
            Expanded(child: _buildLazyLoadProjectList(cubit)),
          ],
        ));
      },
    );
  }

  /// pagination list
  Widget _buildLazyLoadProjectList(CityListCubit cubit) {
    return PagedListView<int, Cities>.separated(
      padding: EdgeInsets.zero,
      separatorBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 20.0),
          child: Divider(
            height: 1,
            color: AppColors.greyE8.adaptiveColor(context,
                lightModeColor: AppColors.greyE8,
                darkModeColor: AppColors.grey50),
          ),
        );
      },
      pagingController: _pagingController,
      shrinkWrap: true,
      builderDelegate: PagedChildBuilderDelegate<Cities>(
        itemBuilder: (context, item, index) {
          return UIComponent.customInkWellWidget(
            onTap: () {
              Navigator.pop(context, item);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    item.name ?? "",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.black14.forLightMode(
                              context), // Applied specific color based on theme mode
                        ),
                  ),
                ],
              ),
            ),
          );
        },
        noItemsFoundIndicatorBuilder: (context) {
          return UIComponent.noData(context);
        },
      ),
    );
  }

  /// bloc listener
  void buildBlocListener(BuildContext context, CityListState state) {
    if (state is CityListSuccess) {
      if (state.isLastPage) {
        _pagingController.appendLastPage(state.cityList);
      } else {
        _pagingController.appendPage(state.cityList, state.currentKey + 1);
      }
    }
    if (state is NoCityListFoundState) {
      _pagingController.appendLastPage([]);
    }
    if (state is CityListError) {
      _pagingController.appendLastPage([]);
    }
    if (state is CityRefreshLoading) {
      _pagingController.refresh();
    }
  }
}
