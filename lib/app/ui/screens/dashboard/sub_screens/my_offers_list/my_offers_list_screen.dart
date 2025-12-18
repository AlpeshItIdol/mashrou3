import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';
import 'package:mashrou3/app/ui/custom_widget/app_bar_mixin.dart';
import 'package:mashrou3/config/resources/app_colors.dart';
import 'package:mashrou3/utils/extensions.dart';

import '../../../../../../config/resources/app_asse../../../../../../utils/app_localization.dart';
import '../../../../../../config/resources/app_assets.dart';
import '../../../../../../config/utils.dart';
import '../../../../../../utils/debouncer.dart';
import '../../../../../../utils/input_formatters.dart';
import '../../../../../../utils/ui_components.dart';
import '../../../../../navigation/routes.dart';
import '../../../../custom_widget/custom_tab_bar/custom_tab_bar.dart';
import '../../../../custom_widget/loader/overlay_loading_progress.dart';
import '../../../../custom_widget/text_form_fields/search_text_form_field.dart';
import 'component/approved_vendor_offer_widget.dart';
import 'component/draft_vendor_offer_widget.dart';
import 'cubit/my_offers_list_cubit.dart';

class MyOffersListScreen extends StatefulWidget {
  const MyOffersListScreen({super.key});

  @override
  State<MyOffersListScreen> createState() => _MyOffersListScreenState();
}

class _MyOffersListScreenState extends State<MyOffersListScreen>
    with AppBarMixin {
  String? selectedCategoryId;

  final _debouncer = Debouncer(milliseconds: 800);

  @override
  void initState() {
    super.initState();
    context.read<MyOffersListCubit>().getData(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                  24.verticalSpace,
                  UIComponent.getSkeletonProperty()
                ],
              ),
            );
          }
          return _buildBlocConsumer;
        },
      ),
      floatingActionButton:
          KeyboardVisibilityBuilder(builder: (ctx, isKeyboardVisible) {
        return isKeyboardVisible ? const SizedBox.shrink() : _buildAddOffer();
      }),
    );
  }

  Future<void> _initializeCategories() async {
    // await Future.delayed(const Duration(milliseconds: 00));
    // // Fetch or update the propertyCategory list here
    // await context.read<CommonApiCubit>().fetchPropertyCategoryList(context);
    // await context
    //     .read<ToggleCubit>()
    //     .updateCategories(AppConstants.propertyCategory);
  }

  bool isFetchingData = false;

  /// Build bloc consumer widget.
  ///
  Widget get _buildBlocConsumer {
    return BlocConsumer<MyOffersListCubit, MyOffersListState>(
      listener: buildBlocListener,
      builder: (context, state) {
        MyOffersListCubit cubit = context.read<MyOffersListCubit>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomTabBar(
                isScrollable: false,
                isPreferredSizeNeeded: true,
                // tabAlignment: TabAlignment.center,
                expandedHeight: 108,
                flexibleSpaceBarWidget: Container(
                  color: AppColors.white.adaptiveColor(context,
                      lightModeColor: AppColors.white,
                      darkModeColor: AppColors.black14),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        12.verticalSpace,
                        SearchTextFormField(
                          controller: cubit.searchCtl,
                          fieldHint: appStrings(context).textSearch,
                          maxLines: 1,
                          textInputAction: TextInputAction.search,
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            if (value.isEmpty &&
                                MediaQuery.of(context).viewInsets.bottom != 0) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            }
                            cubit.showSuffixIcon = value.isNotEmpty;
                            cubit.showHideSuffix(cubit.showSuffixIcon);

                            _debouncer.run(() async {
                              cubit.refreshData(context);
                            });
                          },
                          showSuffixIcon: true,
                          functionSuffix: () {
                            cubit.searchCtl.clear();
                            cubit.showSuffixIcon = false;
                            cubit.showHideSuffix(cubit.showSuffixIcon);
                            FocusManager.instance.primaryFocus?.unfocus();
                            cubit.getData(context);
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
                                  context: context, height: 18, width: 18),
                          onSubmitted: (value) async {
                            if (value.isNotEmpty) {
                              await cubit
                                  .refreshData(context); // Save to history
                            }
                          },
                          inputFormatters: [
                            InputFormatters().emojiRestrictInputFormatter,
                          ],
                        ),
                        // 12.verticalSpace,
                      ],
                    ),
                  ),
                ),
                tabsList: [
                  Tab(
                    child: Text(
                      appStrings(context).lblApprovedOffers,
                    ),
                  ),
                  Tab(
                    child: Text(
                      appStrings(context).lblPendingOffers,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
                tabsLength: 2,
                tabBarViewsList: const [
                  ApprovedVendorOfferWidget(),
                  DraftVendorOfferWidget()
                ],
                onTabControllerUpdated: (tabController) {
                  cubit.animateToCurrentTab(tabController);
                },

                onTabChanged: (index) async {
                  if (isFetchingData) return; // Prevent simultaneous calls

                  isFetchingData = true;
                  try {
                    // Update sold-out state and reset the list

                    cubit.tabCurrentIndex = index;
                    cubit.refreshData(context);
                  } catch (error) {
                    printf("Error fetching properties: $error");
                    // Optionally handle the error here
                  } finally {
                    isFetchingData = false; // Allow new API calls
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildAddOffer() {
    return BlocConsumer<MyOffersListCubit, MyOffersListState>(
      listener: buildBlocListener,
      builder: (context, state) {
        return Container(
          height: 48,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 6,
              ),
            ],
            borderRadius: BorderRadius.circular(16),
            gradient: AppColors.primaryGradient,
          ),
          child: FloatingActionButton.extended(
            isExtended: true,
            elevation: 0,
            onPressed: () async {
              context
                  .pushNamed(
                Routes.kAddVendorOffersScreen,
              )
                  .then((value) async {
                if (value != null && value == true) {
                  await context.read<MyOffersListCubit>().updateTabIndex(1);
                }

                refreshPage();
              });
            },
            backgroundColor: Colors.transparent,
            icon: SVGAssets.plusCircleIcon.toSvg(context: context),
            label: Row(
              children: [
                Text(
                  appStrings(context).lblAddOffer,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.white, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void refreshPage() {
    MyOffersListCubit cubit = context.read<MyOffersListCubit>();
    Future.delayed(Duration.zero, () {
      cubit.currentPage = 1;
      cubit.totalPage = 1;
      cubit.hasShownSkeleton = false;
      cubit.refreshData(context);
    });
  }

  Future<void> buildBlocListener(
      BuildContext context, MyOffersListState state) async {
    if (state is MyOffersListLoading || state is DeleteOfferLoading) {
      OverlayLoadingProgress.start(context);
    }
    /*else if (state is MyOffersListSuccess) {
      OverlayLoadingProgress.stop();
    } */
    else if (state is NoMyOffersListFoundState) {
      OverlayLoadingProgress.stop();
    } else if (state is DeleteOfferSuccess) {
      OverlayLoadingProgress.stop();
      // MyOffersListCubit cubit = context.read<MyOffersListCubit>();
      // await cubit.refreshData(context);
      Utils.snackBar(
          context: context,
          message: appStrings(context).lblOfferRemovedSuccess);
    } else if (state is MyOffersListError) {
      OverlayLoadingProgress.stop();
      Utils.showErrorMessage(context: context, message: state.errorMessage);
    } else if (state is AddMyOffersError) {
      OverlayLoadingProgress.stop();
      Utils.showErrorMessage(context: context, message: state.errorMessage);
    }
  }
}
