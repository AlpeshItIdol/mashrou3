import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashrou3/app/model/base/base_model.dart';

import '../../../../../../../config/utils.dart';
import '../../../../../../model/common_only_message_response_model.dart';
import '../../../../../../model/property/add_to_fav_request_model.dart';
import '../../../../../../model/property/sort_by_model.dart';
import '../../../../../../repository/property_repository.dart';
import '../../../../../screens/filter/model/filter_request_model.dart';
import '../model/in_review_list_request_model.dart';
import '../model/in_review_list_response_model.dart';

part 'in_review_state.dart';

class InReviewCubit extends Cubit<InReviewState> {
  PropertyRepository propertyRepository;

  InReviewCubit({required this.propertyRepository}) : super(InReviewInitial());

  var selectedCategoryId = "";
  String searchText = "";
  int selectedSortIndex = 0;
  int selectedItemIndex = 0;
  int totalProperties = 0;
  int currentPage = 1;
  int totalPage = 1;
  bool isLoadingMore = false;
  bool hasShownSkeleton = false;
  bool isFavorite = false;
  static const int PER_PAGE_SIZE = 5;
  List<SortByModel> sortOptions = [];
  List<PropertyReqData>? inReviewPropertyList = [];
  List<PropertyReqData>? filteredPropertyList = [];
  FilterRequestModel? filterRequestModel;

  Future<void> getData(BuildContext context) async {
    inReviewPropertyList = [];
    filteredPropertyList = [];
    currentPage = 1;
    selectedSortIndex = 0;
    await getPropertyList();
  }

  void updateSelectedCategoryId(String categoryId) {
    selectedCategoryId = categoryId;
    emit(PropertyCategoryUpdated(categoryId: categoryId ?? ""));
  }

  void updateFilterRequestModel(FilterRequestModel? filterModel) {
    filterRequestModel = filterModel;
    emit(PropertyFilterModelUpdate(filterModel ?? FilterRequestModel()));
  }

  void resetPropertyList() {
    inReviewPropertyList = [];
    filteredPropertyList = [];
    currentPage = 1;
    totalPage = 1;
    hasShownSkeleton = false;
  }

  Future<void> getSortData(BuildContext context) async {
    if (!context.mounted) return;
    sortOptions = await Utils.getSortOptionsList(context);
  }

  /// Property list API
  Future<void> getPropertyList({
    bool hasMoreData = false,
    String? id,
  }) async {
    isLoadingMore = true;
    if (hasMoreData) {
      isLoadingMore = false;
      if (isLoadingMore || currentPage > totalPage) return;
      emit(PropertyMoreListLoading());
    } else {
      emit(PropertyListLoading());
    }

    final selectedSortOption =
        selectedSortIndex >= 0 && selectedSortIndex < sortOptions.length
            ? sortOptions[selectedSortIndex]
            : null;

    final sortField = selectedSortOption?.sortField;
    final sortOrder = selectedSortOption?.sortOrder;
    filterRequestModel?.category = selectedCategoryId;
    final requestModel = InReviewListDataRequestModel(
      sortField: sortField,
      sortOrder: sortOrder,
      search: searchText,
      filter: filterRequestModel ??
          FilterRequestModel(category: selectedCategoryId),
      itemsPerPage: PER_PAGE_SIZE,
      page: currentPage,
    );

    final response =
        await propertyRepository.getInReviewList(requestModel: requestModel);
    isLoadingMore = false;
    hasShownSkeleton = true;
    if (response is SuccessResponse &&
        response.data is InReviewListResponseModel) {
      InReviewListResponseModel inReviewListResponse =
          response.data as InReviewListResponseModel;

      // Update pagination details
      totalPage = inReviewListResponse.data?.pageCount ?? 1;

      // Add new data to the existing list without duplicates
      final newProperties = inReviewListResponse.data?.propertyReqData ?? [];

      // Avoid adding duplicate properties based on unique ID or other identifying properties
      final existingIds =
          inReviewPropertyList?.map((property) => property.sId).toSet() ?? {};
      final uniqueProperties = newProperties
          .where((property) => !existingIds.contains(property.sId))
          .toList();

      inReviewPropertyList?.addAll(uniqueProperties);
      filteredPropertyList = List.from(inReviewPropertyList ?? []);

      // totalPage = inReviewListResponse.data?.pageCount ?? 1;
      // inReviewPropertyList
      //     ?.addAll(inReviewListResponse.data?.propertyReqData ?? []);
      // filteredPropertyList = List.from(inReviewPropertyList ?? []);

      if (filteredPropertyList?.isEmpty ?? true) {
        emit(NoPropertyFoundState());
      } else {
        emit(PropertyListSuccess(
            hasMoreData, currentPage, inReviewPropertyList ?? []));
      }
    } else if (response is FailedResponse) {
      emit(PropertyListError(errorMessage: response.errorMessage));
    }
  }

  // Load more properties
  void loadMoreProperties(int index, BuildContext context) {
    if (currentPage < totalPage) {
      currentPage++;
      getPropertyList(hasMoreData: true);
    }
  }

  /// Add To Fav Property API
  Future<void> addRemoveFavorite({
    required String propertyId,
    required bool isFav,
  }) async {
    emit(PropertyListLoading());

    final requestModel = AddRemoveFavRequestModel(
      isFavorite: isFav ? true : false,
      propertyId: propertyId,
    );

    final response =
        await propertyRepository.addRemoveFavorite(requestModel: requestModel);

    if (response is SuccessResponse &&
        response.data is CommonOnlyMessageResponseModel) {
      CommonOnlyMessageResponseModel addToFavResponse =
          response.data as CommonOnlyMessageResponseModel;

      emit(AddedToFavorite(addToFavResponse.message ?? ""));
    } else if (response is FailedResponse) {
      emit(PropertyListError(errorMessage: response.errorMessage));
    }
  }
}
