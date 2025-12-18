import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mashrou3/app/navigation/route_arguments.dart';
import 'package:mashrou3/app/navigation/routes.dart';
import 'package:mashrou3/app/ui/custom_widget/app_bar_mixin.dart';
import 'package:mashrou3/app/ui/custom_widget/text_form_fields/search_text_form_field.dart';
import 'package:mashrou3/app/ui/custom_widget/toggle_widget/toggle_row_item.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/vendor_finance/component/vendor_list_item.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/vendor_finance/model/vendor_category_list_response.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/vendor_finance/model/vendor_list_response_model.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/vendor_finance/vendor_list/cubit/vendor_list_cubit.dart';
import 'package:mashrou3/config/resources/app_assets.dart';
import 'package:mashrou3/config/resources/app_colors.dart';
import 'package:mashrou3/config/resources/app_constants.dart';
import 'package:mashrou3/config/utils.dart';
import 'package:mashrou3/utils/app_localization.dart';
import 'package:mashrou3/utils/debouncer.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:mashrou3/utils/input_formatters.dart';
import 'package:mashrou3/utils/ui_components.dart';

import '../../../../../../../config/services/property_vendor_finance_service.dart';
import '../../../../../custom_widget/toggle_widget/toggle_cubit.dart';

class VendorListScreen extends StatefulWidget {
  const VendorListScreen({super.key});

  @override
  State<VendorListScreen> createState() => _VendorListScreenState();
}

class _VendorListScreenState extends State<VendorListScreen> with AppBarMixin {
  final _debouncer = Debouncer(milliseconds: 500);
  bool isFetchingData = false;
  String? selectedCategoryId;
  final PagingController<int, VendorUserData> _pagingController = PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    if (mounted) {
      if (context.mounted) {
        var cubit = context.read<VendorListCubit>();
        cubit.resetList();
        cubit.selectedCategoryId = GetIt.I<PropertyVendorFinanceService>().data.vendorCategoryId;
        _pagingController.addPageRequestListener((pageKey) {
          context.read<VendorListCubit>().getVendorList(pageKey: pageKey, context: context, id: cubit.selectedCategoryId ?? "0");
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _initializeCategories(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    18.verticalSpace,
                    UIComponent.getSkeletonCategories(),
                  ],
                ),
              );
            }

            return BlocProvider(
              create: (context) {
                return ToggleCubit(
                  [],
                  defaultIndex: context.read<VendorListCubit>().selectedItemIndex,
                  vendorItems: AppConstants.vendorCategory,
                );
              },
              child: BlocListener<ToggleCubit, int>(
                listener: (context, state) {},
                child: BlocConsumer<VendorListCubit, VendorListState>(
                  listener: buildBlocListener,
                  builder: (context, state) {
                    VendorListCubit cubit = context.read<VendorListCubit>();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        (MediaQuery.of(context).padding.top + 8).verticalSpace,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Back Arrow Container
                            Padding(
                              padding: const EdgeInsetsDirectional.only(start: 16.0, end: 12.0),
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
                                      cubit.resetList();
                                      context.pop();
                                    }
                                  },
                                  child: Center(
                                    child: SvgPicture.asset(
                                      TextDirection.rtl == Directionality.of(context) ? SVGAssets.arrowRightIcon : SVGAssets.arrowLeftIcon,
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
                                          color: AppColors.black34
                                              .adaptiveColor(context, lightModeColor: AppColors.black34, darkModeColor: AppColors.white))
                                      : SVGAssets.searchIcon.toSvg(
                                          context: context,
                                          height: 18,
                                          width: 18,
                                          color: AppColors.black34
                                              .adaptiveColor(context, lightModeColor: AppColors.black34, darkModeColor: AppColors.white)),
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
                        20.verticalSpace,
                        BlocBuilder<ToggleCubit, int>(
                          builder: (context, selectedIndex) {
                            if (cubit.selectedItemIndex != selectedIndex) {
                              cubit.selectedItemIndex = selectedIndex;

                              if (selectedIndex >= 0) {
                                if (selectedIndex > (cubit.vendorCategoryList!.length - 1)) {
                                  selectedIndex = cubit.vendorCategoryList!.length - 1;
                                }
                                selectedCategoryId = cubit.vendorCategoryList![selectedIndex].sId;
                                cubit.updateSelectedCategoryId(selectedCategoryId);

                                Future.delayed(Duration.zero, () async {
                                  try {
                                    _pagingController.refresh();
                                  } catch (error) {
                                    printf("Error fetching properties: $error");
                                  } finally {
                                    isFetchingData = false;
                                  }
                                });
                              }
                            }

                            return Padding(
                              padding: const EdgeInsetsDirectional.only(start: 6.0),
                              child: ToggleRowItem(
                                cubit: context.read<ToggleCubit>(),
                                isForVendor: true,
                              ),
                            );
                          },
                        ),
                        20.verticalSpace,
                        Padding(
                          padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
                          child: Text(
                            appStrings(context).vendorList,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w700),
                          ),
                        ),
                        16.verticalSpace,
                        Padding(
                          padding: const EdgeInsetsDirectional.symmetric(horizontal: 18.0),
                          child: Text(
                            "${appStrings(context).textFound} ${cubit.totalVendor} ${formatResultText(cubit.totalVendor, context)}",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Theme.of(context).highlightColor, fontWeight: FontWeight.w500),
                          ).showIf(cubit.totalVendor != 0),
                        ),
                        6.verticalSpace,
                        Expanded(child: _buildLazyLoadProjectList(cubit)),
                      ],
                    );
                  },
                ),
              ),
            );
          }),
    );
  }

  Future<void> _initializeCategories() async {
    VendorListCubit cubit = context.read<VendorListCubit>();
    await Future.delayed(const Duration(milliseconds: 00));
    await cubit.getData(context);
  }

  /// pagination list
  Widget _buildLazyLoadProjectList(VendorListCubit cubit) {
    return PagedListView<int, VendorUserData>.separated(
      padding: EdgeInsets.zero,
      separatorBuilder: (BuildContext context, int index) {
        return 12.verticalSpace;
      },
      pagingController: _pagingController,
      shrinkWrap: true,
      builderDelegate: PagedChildBuilderDelegate<VendorUserData>(
        firstPageProgressIndicatorBuilder: (context) {
          return Padding(
            padding: EdgeInsets.zero,
            child: UIComponent.getSkeletonVendor(),
          );
        },
        itemBuilder: (context, item, index) {
          return VendorListItem(
            data: VendorCategoryData(),
            userData: item,
            isForCategory: false,
            onItemTap: () {
              cubit.service.setVendorId(item.sId ?? "0");
              context.pushNamed(Routes.kVendorDetailScreen,
                  extra: item.sId ?? "", queryParameters: {RouteArguments.isFromFinanceReq: "false"});
            },
          );
        },
        noItemsFoundIndicatorBuilder: (context) {
          return SizedBox(height: MediaQuery.of(context).size.height * 0.7, child: UIComponent.noData(context));
        },
      ),
    );
  }

  /// bloc listener
  void buildBlocListener(BuildContext context, VendorListState state) {
    if (state is VendorCategoryUpdated) {
      context.read<ToggleCubit>().selectItem(state.index);
    }
    if (state is VendorListSuccess) {
      if (state.isLastPage) {
        _pagingController.appendLastPage(state.vendorList);
      } else {
        _pagingController.appendPage(state.vendorList, state.currentKey + 1);
      }
    }
    if (state is NoVendorListFound) {
      _pagingController.appendLastPage([]);
    }
    if (state is VendorRefreshLoading) {
      _pagingController.refresh();
    }
    if (state is VendorListError) {
      _pagingController.appendLastPage([]);
      Utils.showErrorMessage(
          context: context,
          message: state.errorMessage.contains('No internet') ? appStrings(context).noInternetConnection : state.errorMessage);
    }
  }

  String formatResultText(int count, BuildContext context) {
    return count == 1 ? appStrings(context).result : appStrings(context).results;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
