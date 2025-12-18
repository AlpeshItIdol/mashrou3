import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mashrou3/app/navigation/routes.dart';
import 'package:mashrou3/app/ui/custom_widget/app_bar_mixin.dart';
import 'package:mashrou3/app/ui/custom_widget/common_row_bottons.dart';
import 'package:mashrou3/app/ui/custom_widget/loader/overlay_loading_progress.dart';
import 'package:mashrou3/app/ui/screens/property_details/cubit/property_details_cubit.dart';
import 'package:mashrou3/app/ui/screens/ratings/component/review_item_widget.dart';
import 'package:mashrou3/app/ui/screens/ratings/cubit/add_rating_cubit.dart';
import 'package:mashrou3/app/ui/screens/ratings/cubit/view_review_cubit.dart';
import 'package:mashrou3/app/ui/screens/ratings/model/review_list_response_model.dart';
import 'package:mashrou3/config/resources/app_assets.dart';
import 'package:mashrou3/config/resources/app_colors.dart';
import 'package:mashrou3/config/utils.dart';
import 'package:mashrou3/utils/app_localization.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:mashrou3/utils/ui_components.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../db/app_preferences.dart';
import '../../../model/verify_response.model.dart';

class ViewReviewScreen extends StatefulWidget {
  final String propertyId;
  final String? isAddReviewVisible;
  final String? userAddedRating;

  const ViewReviewScreen(
      {super.key,
      required this.propertyId,
      this.isAddReviewVisible,
      this.userAddedRating});

  @override
  State<ViewReviewScreen> createState() => _ViewReviewScreenState();
}

class _ViewReviewScreenState extends State<ViewReviewScreen> with AppBarMixin {
  var userAddedReview = false;

  @override
  void initState() {
    super.initState();
    context.read<ViewReviewCubit>().getData(context, widget.propertyId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ViewReviewCubit, ViewReviewState>(
        listener: buildBlocListener,
        builder: (context, state) {
          return Scaffold(
              appBar: buildAppBar(
                context: context,
                requireLeading: true,
                title: appStrings(context).reviews,
              ),
              body: _buildBlocConsumer,
              bottomNavigationBar: BlocListener<AddRatingCubit, AddRatingState>(
                listener: (context, state) {},
                child: BlocConsumer<ViewReviewCubit, ViewReviewState>(
                  listener: (context, state) {},
                  builder: (context, state) =>
                      UIComponent.bottomSheetWithButtonWithGradient(
                          context: context,
                          onTap: widget.userAddedRating == "true" ||
                              userAddedReview
                              ? () {}
                              : () {
                            ViewReviewCubit cubit =
                            context.read<ViewReviewCubit>();
                            final user = cubit.userSavedData?.users;

                            if (user != null &&
                                user.firstName != null &&
                                user.firstName!.isNotEmpty) {
                              context
                                  .pushNamed(Routes.kAddRatingScreen,
                                  extra: widget.propertyId)
                                  .then((value) async {
                                if (value != null && value == true) {
                                  context.read<ViewReviewCubit>().getData(
                                      context, widget.propertyId);
                                  userAddedReview = true;
                                } else {
                                  userAddedReview = false;
                                }
                              });
                            } else {
                              _showBottomSheet(context);
                            }
                          },
                          isShadowNeeded: true,
                          enabled: widget.userAddedRating == "true" ||
                              userAddedReview
                              ? false
                              : true,
                          buttonTitle: appStrings(context).addReview),
                ),
              )
                  .showIf(
                  widget.isAddReviewVisible == "true" || userAddedReview)
                  .hideIf(context
                  .read<PropertyDetailsCubit>()
                  .myPropertyDetails
                  .isSoldOut ??
                  false));
        });
  }

  Widget get _buildBlocConsumer {
    return BlocConsumer<ViewReviewCubit, ViewReviewState>(
      listener: buildBlocListener,
      builder: (context, state) {
        ViewReviewCubit cubit = context.read<ViewReviewCubit>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: _buildContent(context, cubit, state)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContent(
      BuildContext context, ViewReviewCubit cubit, ViewReviewState state) {
    if (state is ViewReviewInitial) {
      return Container();
    }

    if (state is NoReviewsFoundState) {
      return Center(
        child: UIComponent.noDataWidgetWithInfo(
          title: appStrings(context).emptyReviews,
          info: widget.isAddReviewVisible == "true"
              ? appStrings(context).emptyReviewsInfo
              : "",
          context: context,
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (!cubit.isLoadingMore &&
            scrollInfo.metrics.pixels >=
                scrollInfo.metrics.maxScrollExtent - 20) {
          cubit.loadMoreReviews(context);
        }
        return false;
      },
      child: Skeletonizer(
        enabled: !cubit.hasShownSkeleton &&
            (state is ReviewsLoading || cubit.isLoadingMore),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemBuilder: (context, index) {
            if (cubit.filteredReviewList?.isEmpty ?? true) {
              return UIComponent.getReviewSkeleton();
            }

            if (index == cubit.filteredReviewList!.length) {
              return const Center(
                  child: CircularProgressIndicator(
                strokeWidth: 3,
                color: AppColors.colorPrimary,
              ));
            }

            ReviewData data = cubit.filteredReviewList?[index] ?? ReviewData();

            return ReviewItemWidget(
              data: data,
            );
          },
          itemCount: (cubit.filteredReviewList?.length ?? 0) +
              (cubit.isLoadingMore ? 1 : 0),
          separatorBuilder: (context, index) {
            return Divider(
              height: 1,
              color: AppColors.greyE8.adaptiveColor(context,
                  lightModeColor: AppColors.greyE8,
                  darkModeColor: AppColors.grey50),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Build bloc listener widget.
  Future<void> buildBlocListener(
      BuildContext context, ViewReviewState state) async {
    if (state is ReviewsListError) {
      OverlayLoadingProgress.stop();
      Utils.showErrorMessage(
          context: context,
          message: state.errorMessage.contains('No internet')
              ? appStrings(context).noInternetConnection
              : state.errorMessage);
    }
  }

  void _showBottomSheet(BuildContext context) {
    UIComponent.showCustomBottomSheet(
        context: context,
        builder: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                decoration: BoxDecoration(
                  color: AppColors.colorPrimaryShade,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsetsDirectional.all(14),
                child: SVGAssets.userIcon
                    .toSvg(context: context, height: 30, width: 30)),
            12.verticalSpace,
            Text(
              appStrings(context).lblCompleteProfileToContinue,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            8.verticalSpace,
            Text(
              appStrings(context).textPleaseAddDetails,
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
            20.verticalSpace,
            ButtonRow(
              leftButtonText: appStrings(context).cancel,
              rightButtonText: appStrings(context).btnContinue,
              onLeftButtonTap: () {
                context.pop();
              },
              onRightButtonTap: () {
                context.pop();
                context
                    .pushNamed(Routes.kPersonalInformationScreen)
                    .then((value) async {
                  if (!context.mounted) return;
                  context.read<ViewReviewCubit>().userSavedData =
                      await GetIt.I<AppPreferences>().getUserDetails() ??
                          VerifyResponseData();
                });
              },
              rightButtonBorderColor: AppColors.colorPrimary,
              leftButtonBgColor: Theme.of(context).cardColor,
              leftButtonBorderColor: Theme.of(context).primaryColor,
              leftButtonTextColor: Theme.of(context).primaryColor,
              rightButtonGradientColor: AppColors.primaryGradient,
              rightButtonTextColor: AppColors.white.forLightMode(context),
              isLeftButtonGradient: false,
              isRightButtonGradient: true,
              isLeftButtonBorderRequired: true,
              isRightButtonBorderRequired: true,
              padding: const EdgeInsetsDirectional.all(0),
            ),
          ],
        ));
  }
}
