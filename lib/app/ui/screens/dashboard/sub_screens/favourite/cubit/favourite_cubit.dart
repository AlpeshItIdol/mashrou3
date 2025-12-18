import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mashrou3/app/db/app_preferences.dart';
import 'package:mashrou3/app/model/base/base_model.dart';
import 'package:mashrou3/app/model/property/sort_by_model.dart';
import 'package:mashrou3/app/ui/screens/filter/model/filter_request_model.dart';
import 'package:mashrou3/config/resources/app_strings.dart';

import '../../../../../../../config/utils.dart';
import '../../../../../../model/common_only_message_response_model.dart';
import '../../../../../../model/property/add_to_fav_request_model.dart';
import '../../../../../../model/property/property_list_data_request_model.dart';
import '../../../../../../model/property/property_list_response_model.dart';
import '../../../../../../repository/property_repository.dart';

part 'favourite_state.dart';

class FavouriteCubit extends Cubit<FavouriteState> {
  PropertyRepository propertyRepository;

  FavouriteCubit({required this.propertyRepository})
      : super(FavouriteInitial());

  int selectedSortIndex = 0;
  int selectedItemIndex = 0;
  int totalProperties = 0;
  String searchText = "";
  int totalPage = 1;
  bool isFavorite = false;
  String? selectedCategoryId;
  List<SortByModel> sortOptions = [];
  static const int PER_PAGE_SIZE = 5;
  FilterRequestModel? filterRequestModel;
  bool isVendor = false;
  var selectedRole = "";

  Future<void> getData(BuildContext context) async {
    searchText = "";
    selectedSortIndex = 0;
    selectedRole = await GetIt.I<AppPreferences>().getUserRole() ?? "";
    isVendor = selectedRole == AppStrings.vendor;
  }

  Future<void> getSortData(BuildContext context) async {
    sortOptions = await Utils.getSortOptionsList(context);
  }

  void refreshData(BuildContext context) {
    if (sortOptions.isEmpty) {
      getSortData(context);
    }
  }

  void updateSelectedCategoryId(String? categoryId) {
    selectedCategoryId = categoryId;
    emit(FavCategoryUpdated(categoryId: categoryId ?? ""));
  }

  void updateFilterRequestModel(FilterRequestModel? filterModel) {
    filterRequestModel = filterModel;
    emit(FavFilterModelUpdate(filterModel ?? FilterRequestModel()));
  }

  void refreshPropertyFavList() {
    emit(PropertyFavListRefresh());
  }

  /// Property list API
  Future<void> getPropertyList({
    int pageKey = 0,
  }) async {
    emit(PropertyListLoading());

    final selectedSortOption =
        selectedSortIndex >= 0 && selectedSortIndex < sortOptions.length
            ? sortOptions[selectedSortIndex]
            : null;

    final sortField = selectedSortOption?.sortField;
    final sortOrder = selectedSortOption?.sortOrder;
    filterRequestModel?.category = selectedCategoryId;
    final requestModel = PropertyListDataRequestModel(
      sortField: sortField,
      sortOrder: sortOrder,
      search: searchText,
      filter: filterRequestModel ??
          FilterRequestModel(category: selectedCategoryId),
      skipLogin: false,
      itemsPerPage: PER_PAGE_SIZE,
      myFavorite: true,
      page: pageKey,
    );

    final response =
        await propertyRepository.getPropertyList(requestModel: requestModel);

    if (response is SuccessResponse &&
        response.data is PropertyListResponseModel) {
      PropertyListResponseModel propertyListResponse =
          response.data as PropertyListResponseModel;

      var responseList = <PropertyData>[];
      // Update pagination details
      totalPage = propertyListResponse.data?.pageCount ?? 1;

      responseList = propertyListResponse.data?.propertyData ?? [];
      bool isLastPage = responseList.length != PER_PAGE_SIZE;

      if (responseList.isEmpty) {
        emit(NoPropertyFavFoundState());
      } else {
        emit(PropertyFavListSuccess(isLastPage, pageKey, responseList));
      }
    } else if (response is FailedResponse) {
      emit(PropertyListError(errorMessage: response.errorMessage));
    }
  }

  /// Add To Fav Property API
  Future<void> addRemoveFavorite({
    required String propertyId,
    required bool isFav,
  }) async {
    emit(FavouriteLoading());

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
      emit(FavouriteError(errorMessage: response.errorMessage));
    }
  }
}
