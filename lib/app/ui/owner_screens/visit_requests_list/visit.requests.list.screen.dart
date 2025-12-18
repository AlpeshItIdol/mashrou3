import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mashrou3/app/ui/custom_widget/app_bar_mixin.dart';
import 'package:mashrou3/config/resources/app_colors.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../../config/utils.dart';
import '../../../../../../utils/app_localization.dart';
import '../../../../../../utils/input_formatters.dart';
import '../../../../../../utils/ui_components.dart';
import '../../../../../../utils/validators.dart';
import '../../custom_widget/common_row_bottons.dart';
import '../../custom_widget/loader/overlay_loading_progress.dart';
import '../../custom_widget/text_form_fields/my_text_form_field.dart';
import 'component/visit_requests_card.dart';
import 'cubit/visit_requests_list_cubit.dart';
import 'model/visit_requests_list_response.model.dart';

class VisitRequestsScreen extends StatefulWidget {
  const VisitRequestsScreen({super.key});

  @override
  State<VisitRequestsScreen> createState() => _VisitRequestsScreenState();
}

class _VisitRequestsScreenState extends State<VisitRequestsScreen>
    with AppBarMixin {
  @override
  void initState() {
    context.read<VisitRequestsCubit>().getData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    VisitRequestsCubit cubit = context.read<VisitRequestsCubit>();
    return BlocConsumer<VisitRequestsCubit, VisitRequestsState>(
        listener: buildBlocListener,
        builder: (context, state) {
          return Scaffold(
            appBar: buildAppBar(
              context: context,
              requireLeading: true,
              title: appStrings(context).lblVisitRequests,
            ),
            // body:
            body: _buildBlocConsumer,
          );
        });
  }

  Widget _buildVisitRequestsListContent(BuildContext context,
      VisitRequestsCubit cubit, VisitRequestsState state) {
    if (state is VisitRequestsInitial) {
      return Container();
    }

    if (state is NoVisitRequestsFoundState) {
      return Center(
        child: UIComponent.noDataWidgetWithInfo(
          title: appStrings(context).emptyVisitRequestsList,
          info: appStrings(context).emptyVisitRequestsListInfo,
          context: context,
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (!cubit.isLoadingMore &&
            scrollInfo.metrics.pixels >=
                scrollInfo.metrics.maxScrollExtent - 20) {
          cubit.loadMoreVisitRequests(1, context);
        }
        return false;
      },
      child: Skeletonizer(
        enabled: !cubit.hasShownSkeleton &&
            (state is VisitRequestsLoading || cubit.isLoadingMore),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemBuilder: (context, index) {
            if (cubit.filteredVisitRequestsList?.isEmpty ?? true) {
              return UIComponent.getSkeletonProperty();
            }

            if (index == cubit.filteredVisitRequestsList!.length) {
              return const Center(
                  child: CircularProgressIndicator(
                strokeWidth: 3,
                color: AppColors.colorPrimary,
              ));
            }

            VisitRequestData visitRequestsData =
                cubit.filteredVisitRequestsList?[index] ?? VisitRequestData();

            return VisitRequestsCard(
              name:"${visitRequestsData.firstName ?? ""} ${visitRequestsData.lastName ?? ""}"
                  .trim(),
              propertyName: visitRequestsData.property?.title ?? "-",
              note: visitRequestsData.visitReqData?.visitNote ?? "-",
              date: visitRequestsData.visitReqData?.visitDateTime ?? "-",
              time: visitRequestsData.visitReqData?.visitTime ?? "-",
              isResponded: visitRequestsData.isResponded ?? false,
              reqDenyReason: visitRequestsData.reqDenyReasons ?? "",
              btnText: visitRequestsData.reqStatus,
              onTapReject: () async {
                cubit.noteCtl.clear();
                UIComponent.showCustomBottomSheet(
                  horizontalPadding: 0,
                  verticalPadding: 8,
                  context: context,
                  builder: Form(
                    key: cubit.formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 83,
                          height: 5,
                          decoration: BoxDecoration(
                            color: AppColors.black14,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        24.verticalSpace,
                        Text(
                          appStrings(context).lblVisitRequestRejectionReason,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        12.verticalSpace,

                        /// Notes widget
                        ///
                        ///
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: MyTextFormField(
                            fieldName: appStrings(context).lblNotes,
                            controller: cubit.noteCtl,
                            focusNode: cubit.noteFn,
                            isMandatory: true,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            onFieldSubmitted: (v) {
                              // FocusScope.of(context).requestFocus(cubit.emailIdFn);
                            },
                            inputFormatters: [
                              InputFormatters().emojiRestrictInputFormatter,
                            ],
                            maxLines: null,
                            minLines: 5,
                            readOnly: false,
                            obscureText: false,
                            validator: (value) {
                              return validateNotes(context, value);
                            },
                          ),
                        ),
                        ButtonRow(
                          leftButtonText: appStrings(context).cancel,
                          rightButtonText: appStrings(context).btnSend,
                          onLeftButtonTap: () {
                            context.pop();
                          },
                          onRightButtonTap: () {
                            if (cubit.formKey.currentState!.validate()) {
                              Navigator.pop(context);
                              cubit
                                  .rejectVisitRequest(
                                      requestId: visitRequestsData.sId ?? "")
                                  .then((value) {
                                Future.delayed(Duration.zero, () async {
                                  cubit.visitRequestsList = [];
                                  cubit.filteredVisitRequestsList = [];
                                  cubit.currentPage = 1;
                                  cubit.totalPage = 1;
                                  cubit.hasShownSkeleton = false;
                                  // Close the bottom sheet after handling the action
                                  // Navigator.pop(context);

                                  await cubit.getVisitRequestsList();
                                  Utils.snackBar(
                                      context: context,
                                      message: appStrings(context)
                                          .textVisitRequestRejected);
                                });
                              });
                            }
                          },
                          leftButtonBgColor: Theme.of(context).cardColor,
                          leftButtonBorderColor: Theme.of(context).primaryColor,
                          leftButtonTextColor: Theme.of(context).primaryColor,
                          isLeftButtonGradient: false,
                          isLeftButtonBorderRequired: true,
                        ),
                        24.verticalSpace,
                      ],
                    ),
                  ),
                );
              },
              onTapApprove: () {
                cubit
                    .approveVisitRequest(requestId: visitRequestsData.sId ?? "")
                    .then((value) {
                  Future.delayed(Duration.zero, () {
                    cubit.visitRequestsList = [];
                    cubit.filteredVisitRequestsList = [];
                    cubit.currentPage = 1;
                    cubit.totalPage = 1;
                    cubit.hasShownSkeleton = false;
                    cubit.getVisitRequestsList();
                  });
                  Utils.snackBar(
                      context: context,
                      message: appStrings(context).textVisitRequestApproved);
                });
              },
            );
          },
          itemCount: (cubit.filteredVisitRequestsList?.length ?? 0) +
              (cubit.isLoadingMore ? 1 : 0),
          separatorBuilder: (context, index) => 12.verticalSpace,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Build bloc consumer widget.
  ///
  Widget get _buildBlocConsumer {
    return BlocConsumer<VisitRequestsCubit, VisitRequestsState>(
      listener: buildBlocListener,
      builder: (context, state) {
        VisitRequestsCubit cubit = context.read<VisitRequestsCubit>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child:
                        _buildVisitRequestsListContent(context, cubit, state)))
          ],
        );
      },
    );
  }

  /// Build bloc listener widget.
  Future<void> buildBlocListener(
      BuildContext context, VisitRequestsState state) async {
    if (state is VisitRequestsLoading) {
      OverlayLoadingProgress.start(context);
    } else if (state is VisitRequestsListSuccess) {
      OverlayLoadingProgress.stop();
    } else if (state is VisitRequestsListLoaded) {
      OverlayLoadingProgress.stop();
    } else if (state is VisitRequestsMoreListLoading) {
      OverlayLoadingProgress.stop();
    } else if (state is VisitRequestApprovedRejectedState) {
      OverlayLoadingProgress.stop();
      Utils.snackBar(context: context, message: state.successMessage);
    } else if (state is VisitRequestsError) {
      OverlayLoadingProgress.stop();
      Utils.showErrorMessage(
          context: context,
          message: state.errorMessage.contains('No internet')
              ? appStrings(context).noInternetConnection
              : state.errorMessage);
    }
  }
}
