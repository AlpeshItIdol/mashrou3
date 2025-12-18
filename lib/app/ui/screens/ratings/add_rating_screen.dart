import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashrou3/app/ui/custom_widget/app_bar_mixin.dart';
import 'package:mashrou3/app/ui/custom_widget/custom_rating_bar.dart';
import 'package:mashrou3/app/ui/custom_widget/loader/overlay_loading_progress.dart';
import 'package:mashrou3/app/ui/custom_widget/text_form_fields/my_text_form_field.dart';
import 'package:mashrou3/app/ui/screens/ratings/cubit/add_rating_cubit.dart';
import 'package:mashrou3/app/ui/screens/ratings/cubit/rating_update_cubit.dart';
import 'package:mashrou3/config/utils.dart';
import 'package:mashrou3/utils/app_localization.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:mashrou3/utils/input_formatters.dart';
import 'package:mashrou3/utils/ui_components.dart';
import 'package:mashrou3/utils/validators.dart';

class AddRatingScreen extends StatefulWidget {
  final String propertyId;

  const AddRatingScreen({super.key, required this.propertyId});

  @override
  State<AddRatingScreen> createState() => _AddRatingScreenState();
}

class _AddRatingScreenState extends State<AddRatingScreen> with AppBarMixin {
  int storedRating = 0;

  @override
  void initState() {
    context.read<AddRatingCubit>().resetData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddRatingCubit, AddRatingState>(
        listener: buildBlocListener,
        builder: (context, state) {
          return Scaffold(
              appBar: buildAppBar(
                context: context,
                requireLeading: true,
                title: appStrings(context).yourReviews,
              ),
              body: SingleChildScrollView(
                child: _buildBlocConsumer,
              ),
              bottomNavigationBar: BlocBuilder<AddRatingCubit, AddRatingState>(
                builder: (context, state) =>
                    UIComponent.bottomSheetWithButtonWithGradient(
                        context: context,
                        onTap: () async {
                          if (storedRating == 0) {
                            Utils.showErrorMessage(
                                context: context,
                                message:
                                    appStrings(context).emptyRatingValidation);
                          } else {
                            await context.read<AddRatingCubit>().addReviewAPI(
                                propertyID: widget.propertyId,
                                rating: storedRating);
                          }
                        },
                        isShadowNeeded: true,
                        buttonTitle: appStrings(context).addReview),
              ));
        });
  }

  Widget get _buildBlocConsumer {
    return BlocConsumer<AddRatingCubit, AddRatingState>(
      listener: buildBlocListener,
      builder: (context, state) {
        AddRatingCubit cubit = context.read<AddRatingCubit>();
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.verticalSpace,
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 4.0),
                child: Text(
                  appStrings(context).reviewThisProperty,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              12.verticalSpace,
              BlocConsumer<RatingUpdateCubit, int?>(
                listener: (context, state) {},
                builder: (context, state) {
                  return CustomRatingBar(
                    totalStars: 5,
                    onRatingUpdated: (i) {
                      handleRatingUpdate(i);
                    },
                    value: state ?? 0,
                  );
                },
              ),
              28.verticalSpace,
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 4.0),
                child: Text(
                  appStrings(context).comment,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              MyTextFormField(
                controller: cubit.commentCtl,
                focusNode: cubit.commentFn,
                isMandatory: false,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                onFieldSubmitted: (v) {},
                inputFormatters: [
                  InputFormatters().emojiRestrictInputFormatter,
                ],
                maxLines: null,
                minLines: 8,
                readOnly: false,
                obscureText: false,
                validator: (value) {
                  return validateNotes(context, value);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Build bloc listener widget.
  Future<void> buildBlocListener(
      BuildContext context, AddRatingState state) async {
    if (state is AddRatingReviewLoading) {
      OverlayLoadingProgress.start(context);
    } else if (state is AddRatingReviewSuccess) {
      /// TODO: ADDED DEBOUNCER TO DELAY BEFORE STATE AGAIN UPDATED
      ///
      context.read<AddRatingCubit>().debouncer?.cancel();
      context.read<AddRatingCubit>().debouncer =
          Timer(const Duration(milliseconds: 500), () {
        printf("AddRatingReviewSuccess state emitted");
        OverlayLoadingProgress.stop();
        context.read<AddRatingCubit>().resetData(context);
        Navigator.of(context).pop(true);
        Utils.snackBar(context: context, message: state.message);
      });
    } else if (state is AddRatingReviewError) {
      OverlayLoadingProgress.stop();
      Utils.showErrorMessage(
          context: context,
          message: state.errorMessage.contains('No internet')
              ? appStrings(context).noInternetConnection
              : state.errorMessage);
    }
  }

  void handleRatingUpdate(int rating) {
    RatingUpdateCubit cubit = context.read<RatingUpdateCubit>();
    cubit.updateRating(rating);
    storedRating = rating;
  }
}
