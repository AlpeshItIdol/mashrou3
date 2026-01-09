import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mashrou3/app/ui/custom_widget/app_bar_mixin.dart';
import 'package:mashrou3/config/resources/app_colors.dart';
import 'package:mashrou3/config/resources/app_values.dart';
import 'package:mashrou3/utils/debouncer.dart';
import 'package:mashrou3/utils/extensions.dart';

import '../../../../../../config/resources/app_assets.dart';
import '../../../../../../config/utils.dart';
import '../../../../../../utils/app_localization.dart';
import '../../../../../../utils/input_formatters.dart';
import '../../../../../../utils/ui_components.dart';
import '../../../../../navigation/route_arguments.dart';
import '../../../../../navigation/routes.dart';
import '../../../../custom_widget/loader/overlay_loading_progress.dart';
import '../../../../custom_widget/text_form_fields/search_text_form_field.dart';
import '../../../app_prefereces/cubit/app_preferences_cubit.dart';
import 'component/banks_list_card.dart';
import 'cubit/banks_list_cubit.dart';
import 'model/banks_list_response_model.dart';

class BanksListScreen extends StatefulWidget {
  const BanksListScreen(
      {super.key});

  @override
  State<BanksListScreen> createState() => _BanksListScreenState();
}

class _BanksListScreenState extends State<BanksListScreen> with AppBarMixin {
  final _debouncer = Debouncer(milliseconds: 500);
  final PagingController<int, BankUser> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    if (mounted) {
      if (context.mounted) {
        var cubit = context.read<BanksListCubit>();
        cubit.getData(context);
        _pagingController.addPageRequestListener((pageKey) {
          cubit.getFromMenuBanksList(
              pageKey: pageKey);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    BanksListCubit cubit = context.read<BanksListCubit>();
    return BlocConsumer<BanksListCubit, BanksListState>(
        listener: buildBlocListener,
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Back button with Arabic localization
                        Container(
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
                            child: BlocBuilder<AppPreferencesCubit,
                                AppPreferencesState>(
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
                        8.horizontalSpace,
                        Expanded(
                          child: SearchTextFormField(
                            controller: cubit.searchCtl,
                            fieldHint: appStrings(context).textSearch,
                            onChanged: (value) {
                              if (value.isEmpty &&
                                  MediaQuery.of(context).viewInsets.bottom !=
                                      0) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              }
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
                            showSuffixIcon: cubit.showSuffixIcon,
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
                                    height: 20,
                                    width: 20,
                                    color: AppColors.black34,
                                  )
                                : SVGAssets.searchIcon.toSvg(
                                    context: context,
                                    height: 18,
                                    width: 18,
                                  ),
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
                            textInputAction: TextInputAction.search,
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      appStrings(context).lblBanks,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.black14.adaptiveColor(
                              context,
                              lightModeColor: AppColors.black14,
                              darkModeColor: AppColors.white,
                            ),
                          ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: _buildLazyLoadProjectList(cubit),
                  ),
                ],
              ),
            ),
          );
        });
  }

  /// pagination list
  Widget _buildLazyLoadProjectList(BanksListCubit cubit) {
    return PagedListView<int, BankUser>.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      separatorBuilder: (BuildContext context, int index) {
        return 12.verticalSpace;
      },
      pagingController: _pagingController,
      shrinkWrap: true,
      builderDelegate: PagedChildBuilderDelegate<BankUser>(
        firstPageProgressIndicatorBuilder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: UIComponent.getBankListSkeleton(),
          );
        },
        itemBuilder: (context, item, index) {
          return BanksListCard(
            name: item.bankName ?? item.companyName,
            data: item,
            description: item.offers?.isNotEmpty == true
                ? item.offers != null
                    ? item.offers![0].title ?? ""
                    : ""
                : "",
            city: item.bankLocation?.city ?? "",
            country: item.bankLocation?.country ?? "",
            imageUrl: false
                ? (item.companyLogo ?? "")
                : ((item.offers != null && item.offers!.isNotEmpty && (item.offers!.first.image?.isNotEmpty ?? false))
                    ? item.offers!.first.image!
                    : (item.companyLogo ?? "")),
            onTap: () async {
              // await context.pushNamed(
              //   Routes.kBankDetailsScreen,
              //   pathParameters: {
              //     RouteArguments.propertyId: widget.propertyId,
              //     RouteArguments.vendorId: widget.vendorId,
              //     RouteArguments.isForVendor: widget.isForVendor.toString(),
              //   },
              //   extra: item.sId,
              // );
            },
          );
        },
        noItemsFoundIndicatorBuilder: (context) {
          return SizedBox(
            height: AppValues.screenHeight * 0.8,
            child: Center(
              child: UIComponent.noDataWidgetWithInfo(
                title: appStrings(context).emptyBanksList,
                info: appStrings(context).emptyBanksListInfo,
                context: context,
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> buildBlocListener(
      BuildContext context, BanksListState state) async {
    if (state is BanksListSuccess) {
      if (state.isLastPage) {
        _pagingController.appendLastPage(state.banksList);
      } else {
        _pagingController.appendPage(state.banksList, state.currentKey + 1);
      }
    }
    if (state is NoBanksListFoundState) {
      _pagingController.appendLastPage([]);
    }
    if (state is BankListRefresh) {
      _pagingController.refresh();
    } else if (state is BanksListError) {
      _pagingController.appendLastPage([]);
      OverlayLoadingProgress.stop();
      Utils.showErrorMessage(
          context: context,
          message: state.errorMessage.contains('No internet')
              ? appStrings(context).noInternetConnection
              : state.errorMessage);
    }
  }
}
