import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mashrou3/app/bloc/common_api_services/common_api_cubit.dart';
import 'package:mashrou3/app/ui/screens/filter/model/filter_request_model.dart';

import '../../../../../../../config/resources/app_constants.dart';
import '../../../../../../../config/utils.dart';
import '../../../../../../db/app_preferences.dart';
import '../../../../../../model/base/base_model.dart';
import '../../../../../../model/common_only_message_response_model.dart';
import '../../../../../../model/property/add_to_fav_request_model.dart';
import '../../../../../../model/property/property_category_response_model.dart';
import '../../../../../../model/property/property_list_data_request_model.dart';
import '../../../../../../model/property/property_list_response_model.dart';
import '../../../../../../model/property/sort_by_model.dart';
import '../../../../../../repository/property_repository.dart';

part 'owner_home_state.dart';

class OwnerHomeCubit extends Cubit<OwnerHomeState> {
  OwnerHomeCubit({required this.propertyRepository})
      : super(OwnerHomeInitial());
  PropertyRepository propertyRepository;

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
  List<PropertyData>? propertyList = [];
  List<PropertyData>? filteredPropertyList = [];
  List<SortByModel> sortOptions = [];

  var isGuest = false;
  var isSoldOut = false;
  var selectedCategoryId = "";
  FilterRequestModel? filterRequestModel;
  List<PropertyCategoryData>? propertyCategoryList = [];

  Future<void> getData(BuildContext context) async {
    isGuest = await GetIt.I<AppPreferences>().getIsGuestUser();
    propertyList = [];
    filteredPropertyList = [];
    searchText = "";
    selectedSortIndex = 0;
    if (!context.mounted) return;
    sortOptions = await Utils.getSortOptionsList(context);

    if (!context.mounted) return;
    await Future.wait([
      // getLatLng(context),
      getPropertyList(),
      getPropertyCategoryList(context),
    ]);
  }

  void toggleSoldOut(bool val) {
    isSoldOut = val;
    emit(SoldOutLoadedState(isSoldOut));
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
    propertyList = [];
    filteredPropertyList = [];
    currentPage = 1;
    totalPage = 1;
    hasShownSkeleton = false;
    emit(PropertyListLoading());
  }

  /// Property list API
  Future<void> getPropertyList({
    bool hasMoreData = false,
    String? id,
    bool isSoldOut = false,
    FilterRequestModel? filterData,
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
    filterRequestModel?.isSoldOut = isSoldOut.toString();

    final requestModel = PropertyListDataRequestModel(
      sortField: sortField,
      sortOrder: sortOrder,
      search: searchText,
      filter: filterRequestModel ??
          FilterRequestModel(
              category: selectedCategoryId, isSoldOut: isSoldOut.toString()),
      skipLogin: isGuest ? true : false,
      itemsPerPage: PER_PAGE_SIZE,
      page: currentPage,
    );

    final response =
        await propertyRepository.getPropertyList(requestModel: requestModel);
    isLoadingMore = false;

    hasShownSkeleton = true;

    if (response is SuccessResponse &&
        response.data is PropertyListResponseModel) {
      PropertyListResponseModel propertyListResponse =
          response.data as PropertyListResponseModel;

      // Update pagination details
      totalPage = propertyListResponse.data?.pageCount ?? 1;

      // Add new data to the existing list without duplicates
      final newProperties = propertyListResponse.data?.propertyData ?? [];

      // Avoid adding duplicate properties based on unique ID or other identifying properties
      final existingIds =
          propertyList?.map((property) => property.sId).toSet() ?? {};
      final uniqueProperties = newProperties
          .where((property) => !existingIds.contains(property.sId))
          .toList();

      propertyList?.addAll(uniqueProperties);
      filteredPropertyList = List.from(propertyList ?? []);

      // totalPage = propertyListResponse.data?.pageCount ?? 1;
      // propertyList?.addAll(propertyListResponse.data?.propertyData ?? []);
      // filteredPropertyList = List.from(propertyList ?? []);

      if (filteredPropertyList?.isEmpty ?? true) {
        emit(NoPropertyFoundState());
      } else {
        emit(PropertyListSuccess(hasMoreData, currentPage, propertyList ?? []));
      }
    } else if (response is FailedResponse) {
      emit(NoPropertyFoundState());
      emit(PropertyListError(errorMessage: response.errorMessage));
    }
  }

  // /// Property list API
  // Future<void> getPropertyList({
  //   bool hasMoreData = false,
  //   bool isAll = true,
  //   String? id,
  //   int selectedSortOptionIndex = 0,
  // }) async {
  //   if (isLoadingMore || currentPage > totalPage) return;
  //   isLoadingMore = true;
  //   if (hasMoreData) {
  //     emit(PropertyMoreListLoading());
  //   } else {
  //     emit(PropertyListLoading());
  //   }
  //
  //   // Get the selected sort option or use default values if no selection is made
  //   final selectedSortOption = selectedSortOptionIndex >= 0 &&
  //       selectedSortOptionIndex < sortOptions.length
  //       ? sortOptions[selectedSortOptionIndex]
  //       : null; // Default to null if the index is out of bounds
  //
  //   // If no valid sort option is selected, use default values
  //   final sortField = selectedSortOption?.sortField ?? 'createdAt';
  //   final sortOrder = selectedSortOption?.sortOrder ?? 'desc';
  //
  //   final requestModel = isAll
  //       ? PropertyListDataRequestModel(
  //     sortField: sortField,
  //     sortOrder: sortOrder,
  //     skipLogin: isGuest ? true : false,
  //     itemsPerPage: PER_PAGE_SIZE,
  //     page: currentPage,
  //   )
  //       : PropertyListDataRequestModel(
  //     sortField: sortField,
  //     sortOrder: sortOrder,
  //     filter: Filter(category: id),
  //     skipLogin: isGuest ? true : false,
  //     itemsPerPage: PER_PAGE_SIZE,
  //     page: currentPage,
  //   );
  //
  //   // final requestModel = isAll
  //   //     ? PropertyListDataRequestModel(
  //   //         sortField: "createdAt",
  //   //         sortOrder: "desc",
  //   //         skipLogin: isGuest ? true : false,
  //   //         itemsPerPage: PER_PAGE_SIZE,
  //   //         page: currentPage,
  //   //       )
  //   //     : PropertyListDataRequestModel(
  //   //         sortField: "createdAt",
  //   //         sortOrder: "desc",
  //   //         filter: Filter(category: id),
  //   //         skipLogin: isGuest ? true : false,
  //   //         itemsPerPage: PER_PAGE_SIZE,
  //   //         page: currentPage,
  //   //       );
  //
  //   final response =
  //   await propertyRepository.getPropertyList(requestModel: requestModel);
  //   isLoadingMore = false;
  //   hasShownSkeleton = true;
  //   if (response is SuccessResponse &&
  //       response.data is PropertyListResponseModel) {
  //     PropertyListResponseModel propertyListResponse =
  //     response.data as PropertyListResponseModel;
  //
  //     totalPage = propertyListResponse.data?.pageCount ?? 1;
  //     propertyList?.addAll(propertyListResponse.data?.propertyData ?? []);
  //     filteredPropertyList = List.from(propertyList ?? []);
  //
  //     if (filteredPropertyList?.isEmpty ?? true) {
  //       emit(NoPropertyFoundState());
  //     } else {
  //       emit(PropertyListSuccess(hasMoreData, currentPage, propertyList ?? []));
  //     }
  //   } else if (response is FailedResponse) {
  //     emit(PropertyListError(errorMessage: response.errorMessage));
  //   }
  // }
  //

  /// Add To Fav Property API
  Future<void> addRemoveFavorite({
    required String propertyId,
    required bool isFav,
  }) async {
    emit(PropertyListLoading());

    final requestModel = AddRemoveFavRequestModel(
      isFavorite: isFav,
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

  // Load more properties
  void loadMoreProperties(BuildContext context) {
    if (currentPage < totalPage) {
      currentPage++;
      getPropertyList(hasMoreData: true, filterData: filterRequestModel);
    }
  }

  /// Property Category List API
  ///
  Future<void> getPropertyCategoryList(BuildContext context) async {
    emit(OwnerHomeLoading());

    final response =
        await context.read<CommonApiCubit>().fetchPropertyCategoryList(context);

    if (response is String) {
      emit(OwnerHomeError(errorMessage: response));
    } else {
      propertyCategoryList = response;
      emit(APISuccess());
      AppConstants.setPropertyCategory(context, propertyCategoryList);
      emit(PropertyCategoryListUpdate());
    }
  }
}
