import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mashrou3/app/navigation/route_arguments.dart';
import 'package:mashrou3/app/navigation/routes.dart';
import 'package:mashrou3/app/repository/offers_management_repository.dart';
import 'package:mashrou3/app/model/base/base_model.dart';
import 'package:mashrou3/app/ui/custom_widget/app_bar_mixin.dart';
import 'package:mashrou3/app/ui/custom_widget/text_form_fields/search_text_form_field.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/vendor_finance/model/property_vendor_finance_data.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/vendor_finance/model/vendor_category_list_response.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/vendor_finance/model/vendor_list_response_model.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/vendor_finance/vendor_categories/cubit/vendor_categories_cubit.dart';
import 'package:mashrou3/config/network/network_constants.dart';
import 'package:mashrou3/config/resources/app_assets.dart';
import 'package:mashrou3/config/resources/app_colors.dart';
import 'package:mashrou3/config/utils.dart';
import 'package:mashrou3/utils/debouncer.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:mashrou3/utils/input_formatters.dart';
import 'package:mashrou3/utils/ui_components.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../../../utils/app_localization.dart';
import '../../../../banks_offer/cubit/banks_offer_list_cubit.dart';
import '../component/vendor_list_item.dart';
import '../vendor_details/cubit/vendor_detail_cubit.dart';

class VendorCategoriesScreen extends StatefulWidget {
  final String propertyId;
  final String vendorId;

  const VendorCategoriesScreen({super.key, required this.propertyId, required this.vendorId});

  @override
  State<VendorCategoriesScreen> createState() => _VendorCategoriesScreenState();
}

class _VendorCategoriesScreenState extends State<VendorCategoriesScreen>
    with AppBarMixin, WidgetsBindingObserver {
  final _debouncer = Debouncer(milliseconds: 500);
  final ScrollController _scrollController = ScrollController();
  bool _isNavigating = false;
  Timer? _navigationTimeoutTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    context
        .read<VendorCategoriesCubit>()
        .getData(context, propertyId: widget.propertyId);
    // context.read<VendorCategoriesCubit>().setPropertyData(
    //     PropertyVendorFinanceData(propertyId: widget.propertyId));
    context.read<VendorDetailCubit>().getData(widget.vendorId, context);
    context.read<BanksOfferListCubit>().refresh();
    final cubit = context.read<BanksOfferListCubit>();
    cubit.getBankOffersList(hasMoreData: true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    _navigationTimeoutTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Reset navigation flag when app comes back to foreground
    if (state == AppLifecycleState.resumed && _isNavigating) {
      _resetNavigationFlag();
    }
  }

  void _resetNavigationFlag() {
    _navigationTimeoutTimer?.cancel();
    _navigationTimeoutTimer = null;
    if (mounted) {
      setState(() {
        _isNavigating = false;
      });
      debugPrint('Navigation flag reset - user can navigate again');
    }
  }

  void _startNavigationTimeout() {
    _navigationTimeoutTimer?.cancel();
    // Set a timeout as fallback - if navigation callback doesn't fire within 2 seconds,
    // reset the flag anyway (this handles edge cases where .then() doesn't fire)
    // Note: This should rarely be needed as GoRouter's .then() callback should fire immediately
    // when the route is popped
    _navigationTimeoutTimer = Timer(const Duration(seconds: 2), () {
      if (mounted && _isNavigating) {
        debugPrint('Navigation timeout - resetting flag as fallback (this should rarely happen)');
        _resetNavigationFlag();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBlocConsumer,
    );
  }

  /// Build bloc consumer widget.
  ///
  Widget get _buildBlocConsumer {
    return BlocConsumer<VendorCategoriesCubit, VendorCategoriesState>(
      listener: buildBlocListener,
      builder: (context, state) {
        print("state ${state.toString()}");

        if (state is VendorCategoriesLoading) {
          return Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16.0),
              child: UIComponent.getSkeletonProperty());
        }

        VendorCategoriesCubit cubit = context.read<VendorCategoriesCubit>();
        VendorDetailCubit cubitVendorDetail =  context.read<VendorDetailCubit>();
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
                      child: Center(
                        child: SvgPicture.asset(
                          TextDirection.rtl == Directionality.of(context)
                              ? SVGAssets.arrowRightIcon
                              : SVGAssets.arrowLeftIcon,
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
                            context
                                .read<VendorCategoriesCubit>()
                                .getData(context);
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
                        context.read<VendorCategoriesCubit>().getData(context);
                      },
                      suffixIcon: cubit.showSuffixIcon
                          ? SVGAssets.cancelIcon.toSvg(
                              context: context,
                              height: 18,
                              width: 18,
                              color: AppColors.black34.adaptiveColor(context,
                                  lightModeColor: AppColors.black34,
                                  darkModeColor: AppColors.white))
                          : SVGAssets.searchIcon.toSvg(
                              context: context,
                              height: 18,
                              width: 18,
                              color: AppColors.black34.adaptiveColor(context,
                                  lightModeColor: AppColors.black34,
                                  darkModeColor: AppColors.white)),
                      onSubmitted: (value) async {
                        if (value.isEmpty) {
                          setState(() {
                            cubit.showSuffixIcon = false;
                          });
                        }
                        _debouncer.run(() {
                          context
                              .read<VendorCategoriesCubit>()
                              .getData(context);
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
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 16.0, end: 12.0),
              child: Text(
                appStrings(context).lblSelectVendor,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w700),
              ),
            ),
            16.verticalSpace,
            Expanded(
              child: Skeletonizer(
                enabled: !cubit.hasShownSkeleton && state is VendorCategoriesLoading,
                child: Builder(
                  builder: (context) {
                    // Show skeleton when loading
                    if (state is VendorCategoriesLoading) {
                      return ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(bottom: 20),
                        physics: const ClampingScrollPhysics(),
                        itemCount: 6, // show 6 skeletons
                        separatorBuilder: (context, index) => 12.verticalSpace,
                        itemBuilder: (context, index) => UIComponent.getSkeletonProperty(),
                      );
                    }

                    // Show "No category found" message
                    if (cubit.vendorCategoryList == null || cubit.vendorCategoryList!.isEmpty) {
                      return const Center(
                        child: Text(
                          'No vendor category list found',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      );
                    }

                    // Show actual list when data is available
                    return ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(bottom: 20),
                      physics: const ClampingScrollPhysics(),
                      itemCount: cubit.vendorCategoryList!.length,
                      separatorBuilder: (context, index) => 12.verticalSpace,
                      itemBuilder: (context, index) {
                        final data = cubit.vendorCategoryList![index];
                        return VendorListItem(
                          data: data,
                          onItemTap: _isNavigating
                              ? () {}
                              : () async {
                                  await onItemTap(data.sId ?? "0", cubit);
                                },
                        );
                      },
                    );
                  },
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Future<void> onItemTap(String vendorCategoryId, VendorCategoriesCubit cubit) async {
    // Prevent multiple navigations
    if (_isNavigating || !mounted) {
      return;
    }

    setState(() {
      _isNavigating = true;
    });
    _startNavigationTimeout();

    try {
      // Persist selection so downstream screens/services know the chosen category
      context.read<VendorCategoriesCubit>().setPropertyData(
        PropertyVendorFinanceData(vendorCategoryId: vendorCategoryId),
      );

      final propertyId = cubit.service.getPropertyId() ?? widget.propertyId;

      // Directly fetch vendors for this category + property
      final repo = GetIt.I<OffersManagementRepository>();
      final response = await repo.getVendorList(
        queryParameters: {
          NetworkParams.kVendorCategory: vendorCategoryId,
          NetworkParams.kPropertyId: propertyId,
          NetworkParams.kPage: "1",
          NetworkParams.kItemPerPage: "10",
          NetworkParams.kSortOrder: "desc",
          NetworkParams.kSortField: "createdAt",
        },
        searchText: cubit.searchCtl.text.trim(),
      );

      if (!mounted) return;

      if (response is SuccessResponse && response.data is VendorListResponseModel) {
        final model = response.data as VendorListResponseModel;
        final users = model.data?.user ?? [];
        if (users.isNotEmpty) {
          final firstVendorId = users.first.sId ?? "";
          if (firstVendorId.isNotEmpty) {
            // Persist for downstream flows (e.g., finance request CTA)
            cubit.service.setVendorId(firstVendorId);
            
            // Fetch vendor offers to get the first offer
            final vendorDetailCubit = context.read<VendorDetailCubit>();
            await vendorDetailCubit.getVendorOffers(
              vendorId: firstVendorId,
              propertyId: propertyId,
              context: context,
            );
            
            if (!mounted) return;
            
            // Get the first offer from the fetched offers
            final offerDataList = vendorDetailCubit.offerDataList ?? [];
            if (offerDataList.isNotEmpty) {
              final firstOffer = offerDataList.first;
              final offerId = firstOffer.sId;
              
              // Validate offerId before navigation
              if (offerId != null && offerId.isNotEmpty) {
                debugPrint('Navigating to offer detail screen with offerId: $offerId, vendorId: $firstVendorId');
                // Navigate directly to offer details screen
                // Use .then() to reset flag when user returns from navigation
                context.pushNamed(
                  Routes.kOfferDetailScreen,
                  pathParameters: {
                    RouteArguments.offerId: offerId,
                    RouteArguments.isDraftOffer: "false",
                  },
                  queryParameters: {
                    RouteArguments.vendorId: firstVendorId,
                    RouteArguments.isForVendor: "true",
                  },
                ).then((result) {
                  // Reset navigation flag when route is popped
                  debugPrint('Navigation completed, resetting flag');
                  if (mounted) {
                    _resetNavigationFlag();
                  }
                }).catchError((error) {
                  // Reset flag on navigation error
                  debugPrint('Navigation error, resetting flag: $error');
                  if (mounted) {
                    _resetNavigationFlag();
                  }
                });
                return;
              } else {
                debugPrint('Error: Offer ID is empty or null. Cannot navigate to offer detail.');
                if (mounted) {
                  _resetNavigationFlag();
                  Utils.showErrorMessage(context: context, message: "Offer details not available.");
                }
                return;
              }
            } else {
              debugPrint('Error: No offers found for vendor. Cannot navigate to offer detail.');
              if (mounted) {
                _resetNavigationFlag();
                Utils.showErrorMessage(context: context, message: "No offers available for this vendor.");
              }
              return;
            }
          }
        }
      }
      
      if (mounted) {
        // Navigate to vendor list and reset flag when route is popped
        context.pushNamed(Routes.kVendorList).then((result) {
          debugPrint('Navigation to vendor list completed, resetting flag');
          if (mounted) {
            _resetNavigationFlag();
          }
        }).catchError((error) {
          debugPrint('Navigation to vendor list error, resetting flag: $error');
          if (mounted) {
            _resetNavigationFlag();
          }
        });
      }
    } catch (e) {
      debugPrint('Error in onItemTap: $e');
      if (mounted) {
        _resetNavigationFlag();
        Utils.showErrorMessage(context: context, message: "An error occurred. Please try again.");
      }
    }
  }

  /// bloc listener
  void buildBlocListener(BuildContext context, VendorCategoriesState state) {
    if (state is VendorCategoriesLoading) {
    } else if (state is VendorCategoriesError) {
      Utils.showErrorMessage(context: context, message: state.errorMessage);
    }
  }
}
