import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mashrou3/app/db/app_preferences.dart';
import 'package:mashrou3/app/model/base/base_model.dart';
import 'package:mashrou3/app/repository/property_repository.dart';
import 'package:mashrou3/app/ui/screens/ratings/cubit/rating_update_cubit.dart';
import 'package:mashrou3/app/ui/screens/ratings/model/add_rating_review_request_model.dart';
import 'package:mashrou3/app/ui/screens/ratings/model/add_rating_review_response_model.dart';

part 'add_rating_state.dart';

class AddRatingCubit extends Cubit<AddRatingState> {
  AddRatingCubit({required this.propertyRepository})
      : super(AddRatingInitial());
  PropertyRepository propertyRepository;

  TextEditingController commentCtl = TextEditingController();
  FocusNode commentFn = FocusNode();

  Timer? debouncer;

  void resetData(BuildContext context) {
    commentCtl.clear();
    context.read<RatingUpdateCubit>().selectDefaultRating();
    emit(AddRatingInitial());
  }

  Future<void> addReviewAPI({
    required String propertyID,
    required int rating,
  }) async {
    emit(AddRatingReviewLoading());
    var userId = await GetIt.I<AppPreferences>().getUserID();
    final requestModel = AddRatingReviewRequestModel(
        userId: userId,
        propertyId: propertyID,
        comment: commentCtl.text.trim(),
        rating: rating);

    final response =
        await propertyRepository.addRatingReview(requestModel: requestModel);

    if (response is SuccessResponse &&
        response.data is AddRatingReviewResponseModel) {
      AddRatingReviewResponseModel addToFavResponse =
          response.data as AddRatingReviewResponseModel;

      emit(AddRatingReviewSuccess(message: addToFavResponse.message ?? ""));
    } else if (response is FailedResponse) {
      emit(AddRatingReviewError(errorMessage: response.errorMessage));
    }
  }
}
