import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mashrou3/app/db/app_preferences.dart';
import 'package:mashrou3/app/model/base/base_model.dart';
import 'package:mashrou3/app/model/verify_response.model.dart';
import 'package:mashrou3/app/repository/property_repository.dart';
import 'package:mashrou3/app/ui/screens/ratings/model/review_list_request_model.dart';
import 'package:mashrou3/app/ui/screens/ratings/model/review_list_response_model.dart';

part 'view_review_state.dart';

class ViewReviewCubit extends Cubit<ViewReviewState> {
  ViewReviewCubit({required this.propertyRepository})
      : super(ViewReviewInitial());
  PropertyRepository propertyRepository;

  int totalVisitRequests = 0;
  int currentPage = 1;
  int totalPage = 1;
  bool isLoadingMore = false;
  bool hasShownSkeleton = false;
  bool isFavorite = false;
  static const int pagePerSize = 10;
  String propertyID = "";
  List<ReviewData>? reviewList = [];
  List<ReviewData>? filteredReviewList = [];
  VerifyResponseData? userSavedData;

  /// Get data
  ///
  Future<void> getData(BuildContext context, String id) async {
    userSavedData = await GetIt.I<AppPreferences>().getUserDetails() ??
        VerifyResponseData();
    propertyID = id;
    reviewList = [];
    isLoadingMore = false;
    currentPage = 1;
    filteredReviewList = [];
    await getReviewsList();
  }

  Future<void> getReviewsList({
    bool hasMoreData = false,
  }) async {
    isLoadingMore = true;
    if (hasMoreData) {
      isLoadingMore = false;
      if (isLoadingMore || currentPage > totalPage) return;
      emit(ReviewsMoreListLoading());
    } else {
      emit(ReviewsLoading());
    }

    const sortField = 'createdAt';
    const sortOrder = 'desc';

    final requestModel = ReviewListRequestModel(
        sortField: sortField,
        sortOrder: sortOrder,
        itemsPerPage: pagePerSize,
        page: currentPage,
        id: propertyID);

    final response =
        await propertyRepository.getReviews(requestModel: requestModel);
    isLoadingMore = false;

    hasShownSkeleton = true;

    if (response is SuccessResponse &&
        response.data is ReviewListResponseModel) {
      ReviewListResponseModel reviewListResponseModel =
          response.data as ReviewListResponseModel;

      totalPage = reviewListResponseModel.data?.pageCount ?? 1;
      reviewList?.addAll(reviewListResponseModel.data?.data ?? []);
      filteredReviewList = List.from(reviewList ?? []);

      if (filteredReviewList?.isEmpty ?? true) {
        emit(NoReviewsFoundState());
      } else {
        emit(ReviewsListSuccess(hasMoreData, currentPage,
            (reviewList ?? <ReviewData>[]).cast<ReviewData>()));
      }
    } else if (response is FailedResponse) {
      emit(NoReviewsFoundState());
      emit(ReviewsListError(errorMessage: response.errorMessage));
    }
  }

  // Load more properties
  void loadMoreReviews(BuildContext context) {
    if (currentPage < totalPage) {
      currentPage++;
      getReviewsList(hasMoreData: true);
    }
  }
}
