import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mashrou3/app/ui/custom_widget/app_bar_mixin.dart';
import 'package:mashrou3/app/ui/screens/authentication/component/otp_widget/bloc/otp_input_section_cubit.dart';
import 'package:mashrou3/config/resources/app_assets.dart';
import 'package:mashrou3/utils/extensions.dart';

import '../../../../../../config/resources/app_colors.dart';
import '../../../../../../config/resources/app_constants.dart';
import '../../../../../../config/utils.dart';
import '../../../../../../utils/app_localization.dart';
import '../../../../../../utils/input_formatters.dart';
import '../../../../../../utils/ui_components.dart';
import '../../../../../../utils/validators.dart';
import '../../../../../db/app_preferences.dart';
import '../../../../../model/verify_response.model.dart';
import '../../../../../navigation/routes.dart';
import '../../../../custom_widget/common_row_bottons.dart';
import '../../../../custom_widget/loader/overlay_loading_progress.dart';
import '../../../../custom_widget/text_form_fields/my_text_form_field.dart';
import 'cubit/visit_request_cubit.dart';

class VisitRequestScreen extends StatefulWidget {
  final String propertyId;

  const VisitRequestScreen({super.key, required this.propertyId});

  @override
  State<VisitRequestScreen> createState() => _VisitRequestScreenState();
}

class _VisitRequestScreenState extends State<VisitRequestScreen>
    with AppBarMixin {
  @override
  void initState() {
    context.read<VisitRequestCubit>().getData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VisitRequestCubit, VisitRequestState>(
        listener: buildBlocListener,
        builder: (context, state) {
          return Scaffold(
              appBar: buildAppBar(
                context: context,
                requireLeading: true,
                title: appStrings(context).lblVisitRequest,
              ),
              // body:
              body: SingleChildScrollView(
                child: _buildBlocConsumer,
              ),
              bottomNavigationBar:
                  BlocBuilder<VisitRequestCubit, VisitRequestState>(
                builder: (context, state) =>
                    UIComponent.bottomSheetWithButtonWithGradient(
                        context: context,
                        onTap: () {
                          VisitRequestCubit cubit =
                              context.read<VisitRequestCubit>();
                          final user = cubit.userSavedData?.users;

                          if (user != null &&
                              user.firstName != null &&
                              user.firstName!.isNotEmpty) {
                            onSendRequestClick(context);
                          } else {
                            _showBottomSheet(context);
                          }
                        },
                        isShadowNeeded: true,
                        buttonTitle: appStrings(context).btnSendRequest),
              ));
        });
  }

  /// Build bloc consumer widget.
  ///
  Widget get _buildBlocConsumer {
    return BlocConsumer<VisitRequestCubit, VisitRequestState>(
      listener: buildBlocListener,
      builder: (context, state) {
        VisitRequestCubit cubit = context.read<VisitRequestCubit>();
        return SingleChildScrollView(
          child: Form(
            key: cubit.formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  16.verticalSpace,

                  /// Date widget
                  ///
                  MyTextFormField(
                    fieldName: appStrings(context).lblSelectDate,
                    controller: cubit.dateCtl,
                    isMandatory: true,
                    suffixIcon: SVGAssets.calender1Icon
                        .toSvg(height: 22, width: 22, context: context),
                    keyboardType: TextInputType.name,
                    fieldHint: appStrings(context).lblSelectDate,
                    onFieldSubmitted: (v) {},
                    readOnly: true,
                    onTap: () async {
                      String pickedDate = await UIComponent.chooseDate(
                          context,
                          appStrings(context).lblSelectDate,
                          cubit.dateCtl,
                          AppConstants.dateFormatDdMMYyyy,
                          DateFormat(AppConstants.dateFormatDdMMYyyy)
                              .parseStrict(cubit.dateCtl.text),
                          firstDate: DateTime.now());

                      cubit.updateSelectedDate(pickedDate);
                    },
                    obscureText: false,
                    validator: (value) {
                      return validateLocation(context, value);
                    },
                  ),

                  12.verticalSpace,

                  /// Time widget
                  ///
                  MyTextFormField(
                    fieldName: appStrings(context).lblSelectTime,
                    controller: cubit.timeCtl,
                    isMandatory: true,
                    fieldHint: appStrings(context).lblSelectTime,
                    suffixIcon: SVGAssets.clockRoundIcon
                        .toSvg(height: 22, width: 22, context: context),
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (v) {
                      // FocusScope.of(context)
                      //     .requestFocus(cubit.instagramLinkFn);
                    },
                    readOnly: true,
                    onTap: () async {
                      cubit.selectedTimeForVisit = TimeOfDay.now();
                      cubit.selectedTime = await UIComponent.chooseTime(
                        context,
                        appStrings(context).lblSelectTime,
                        cubit.timeCtl,
                        cubit.selectedTimeForVisit,
                        cubit.selectedDate,
                      );
                      printf('Time selected: ${cubit.selectedTime}');
                    },
                    obscureText: false,
                    validator: (value) {
                      return null;
                    },
                  ),

                  12.verticalSpace,

                  /// Notes widget
                  ///
                  ///
                  MyTextFormField(
                    fieldName: appStrings(context).lblNotes,
                    controller: cubit.noteCtl,
                    focusNode: cubit.noteFn,
                    isMandatory: false,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    onFieldSubmitted: (v) {
                    },
                    inputFormatters: [
                      InputFormatters().emojiRestrictInputFormatter,
                    ],
                    maxLines: null,
                    minLines: 5,
                    readOnly: false,
                    obscureText: false,
                    validator: (value) {
                      return null;
                    },
                  ),

                  22.verticalSpace,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> onSendRequestClick(BuildContext context) async {
    VisitRequestCubit cubit = context.read<VisitRequestCubit>();
    if (cubit.formKey.currentState!.validate() &&
        cubit.validate(context) &&
        cubit.validateDateTime(
          context: context,
          visitDate: cubit.selectedDate,
          visitTime: cubit.selectedTime,
        )) {
      cubit.sendVisitRequest(propertyId: widget.propertyId);
    }
  }

  /// Build bloc listener widget.
  Future<void> buildBlocListener(
      BuildContext context, VisitRequestState state) async {
    if (state is VisitRequestLoading) {
      OverlayLoadingProgress.start(context);
    } else if (state is VisitRequestSuccess) {
      OverlayLoadingProgress.stop();
      Navigator.pop(context);
      Utils.snackBar(context: context, message: state.model.message ?? "");
    } else if (state is VisitRequestError) {
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
                  context.read<VisitRequestCubit>().userSavedData =
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
