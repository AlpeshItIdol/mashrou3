import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'package:mashrou3/utils/extensions.dart';

import '../../../../config/resources/app_assets.dart';
import '../../../../config/resources/app_colors.dart';
import '../../../../utils/app_localization.dart';
import '../../../../utils/input_formatters.dart';
import '../../../bloc/common_api_services/common_api_cubit.dart';
import '../../../model/base/base_model.dart';
import '../../../model/city_list_request.model.dart';
import '../../../model/city_list_response_model.dart';

import '../text_form_fields/search_text_form_field.dart';

class CityListBottomSheet extends StatefulWidget {
  final String selectedCountryId;
  final TextEditingController searchController;

  const CityListBottomSheet({
    super.key,
    required this.selectedCountryId,
    required this.searchController,
  });

  @override
  State<CityListBottomSheet> createState() => _CityListBottomSheetState();
}

class _CityListBottomSheetState extends State<CityListBottomSheet> {
  // static const int _pageSize = 10;
  // final PagingController<int, Cities> _pagingController =
  //     PagingController(firstPageKey: 1);
  //
  // bool _showSuffixIcon = false;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _showSuffixIcon = false;
  //
  //   widget.searchController.clear();
  //
  //   widget.searchController.addListener(() {
  //     setState(() {
  //       _showSuffixIcon = widget.searchController.text.isNotEmpty;
  //     });
  //   });
  //   _pagingController.addPageRequestListener((pageKey) {
  //     _fetchPage(pageKey);
  //   });
  // }
  static const int _pageSize = 10;
  final PagingController<int, Cities> _pagingController =
  PagingController(firstPageKey: 1);

  bool _showSuffixIcon = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _showSuffixIcon = false;

    widget.searchController.clear();

    widget.searchController.addListener(() {
      setState(() {
        _showSuffixIcon = widget.searchController.text.isNotEmpty;
      });
    });
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }



  // void _onSearchChanged(String value) {
  //   // Cancel the previous debounce timer if it exists
  //   if (_debounce?.isActive ?? false) _debounce!.cancel();
  //
  //   // Start a new debounce timer
  //   _debounce = Timer(const Duration(milliseconds: 700), () {
  //     _pagingController.refresh(); // Refresh the paging controller
  //   });
  // }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final requestModel = CityListRequestModel(
        pagination: true,
        countryId: widget.selectedCountryId.toString(),
        sortField: 'createdAt',
        sortOrder: 'desc',
        search: widget.searchController.text.trim(),
        itemsPerPage: _pageSize,
        page: pageKey,
      );

      final response = await context
          .read<CommonApiCubit>()
          .fetchCityListWithPagination(requestModel: requestModel);

      if (response is CityListResponseModel) {
        final newItems = response.cityListData?.cities ?? [];
        final isLastPage = pageKey >= (response.cityListData?.pageCount ?? 1);
        if (isLastPage) {
          _pagingController.appendLastPage(newItems);
        } else {
          final nextPageKey = pageKey + 1;
          _pagingController.appendPage(newItems, nextPageKey);
        }
      } else if (response is FailedResponse) {
        _pagingController.error = response.errorMessage;
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.6,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Material(
          elevation: 4,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(vertical: 12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 83,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.black14,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                18.verticalSpace,
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                      start: 16.0, end: 16.0, bottom: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        appStrings(context).lblSelectCity,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.black3D.forLightMode(context),
                            ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          context.pop();
                        },
                      ),
                    ],
                  ),
                ),
                // Search bar
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                      start: 10.0, end: 10.0, bottom: 10.0),
                  child: SearchTextFormField(
                    controller: widget.searchController,
                    fieldHint: appStrings(context).textSearch,
                    showSuffixIcon: true,
                    keyboardType: TextInputType.text,
                    inputFormatters: [
                      InputFormatters().emojiRestrictInputFormatter,
                    ],
                    functionSuffix: () {
                      setState(() {
                        widget.searchController.clear();
                        _showSuffixIcon = false;
                      });
                      FocusManager.instance.primaryFocus?.unfocus();
                      _pagingController.refresh();
                    },
                    suffixIcon: _showSuffixIcon
                        ? SVGAssets.cancelIcon.toSvg(
                            context: context,
                            height: 20,
                            width: 20,
                            color: AppColors.black34,
                          )
                        : SVGAssets.searchIcon.toSvg(
                            context: context,
                            height: 18,
                            width: 18,
                          ),
                    // onChanged: (value) {
                    //   _pagingController.refresh();
                    // },
                    onChanged: (String value) {
                      // Cancel the previous debounce timer if it exists
                      if (_debounce?.isActive ?? false) _debounce!.cancel();

                      // Start a new debounce timer
                      _debounce = Timer(const Duration(milliseconds: 700), () {
                        _pagingController.refresh(); // Refresh the paging controller
                      });
                    },
                    onSubmitted: (value) {
                      _pagingController.refresh();
                    },

                  ),
                ),
                // List of cities
                Expanded(
                  child: PagedListView<int, Cities>(
                    pagingController: _pagingController,
                    scrollController: scrollController,
                    builderDelegate: PagedChildBuilderDelegate<Cities>(
                      itemBuilder: (context, city, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.pop(context, city);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  city.name ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        color: AppColors.black14
                                            .forLightMode(context),
                                      ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      firstPageProgressIndicatorBuilder: (context) =>
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              14.verticalSpace,
                              const CircularProgressIndicator(
                                strokeWidth: 3,
                                color: AppColors.colorPrimary,
                              ),
                            ],
                          ),
                      newPageProgressIndicatorBuilder: (context) =>
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              14.verticalSpace,
                              const CircularProgressIndicator(
                                strokeWidth: 3,
                                color: AppColors.colorPrimary,
                              ),
                            ],
                          ),
                      noItemsFoundIndicatorBuilder: (context) =>
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              14.verticalSpace,
                              Text(
                                appStrings(context).textNoData,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),


                      firstPageErrorIndicatorBuilder: (context) => Center(
                        child: Text(
                          appStrings(context).textErrorLoadingCities,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                      newPageErrorIndicatorBuilder: (context) => Center(
                        child: Text(
                          appStrings(context).textErrorLoadingMoreCities,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    widget.searchController.removeListener(() {});
    _debounce?.cancel();
    super.dispose();
  }
}
