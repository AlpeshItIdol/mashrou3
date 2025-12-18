import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mashrou3/app/model/property/sort_by_model.dart';
import 'package:mashrou3/app/repository/property_repository.dart';
import 'package:mashrou3/app/ui/screens/filter/model/filter_request_model.dart';
import 'package:mashrou3/config/resources/app_strings.dart';
import 'package:mashrou3/config/utils.dart';

import '../../../../../../../config/resources/app_constants.dart';
import '../../../../bloc/common_api_services/common_api_cubit.dart';
import '../../../../db/app_preferences.dart';
import '../../../../model/base/base_model.dart';
import '../../../../model/property/property_category_response_model.dart';
import '../../../../model/property/property_detail_response_model.dart';
import '../../../owner_screens/visit_requests_list/model/visit_requests_list_request.model.dart';
import '../model/properties_with_offers_response.model.dart';
import '../model/recently_visited_response.model.dart';

part 'recently_visited_properties_state.dart';

class RecentlyVisitedPropertiesCubit
    extends Cubit<RecentlyVisitedPropertiesState> {
  RecentlyVisitedPropertiesCubit({required this.propertyRepository})
      : super(RecentlyVisitedPropertiesInitial());
  PropertyRepository propertyRepository;
  final TextEditingController searchCtl = TextEditingController();
  int selectedItemIndex = 0;
  String searchText = "";
  int selectedSortIndex = 0;
  int totalProperties = 0;
  int totalPage = 1;
  bool isPropertiesWithOffers = false;
  bool isFavorite = false;
  String? selectedCategoryId;
  static const int PER_PAGE_SIZE = 10;
  FilterRequestModel? filterRequestModel;
  bool showSuffixIcon = false;
  var isGuest = false;
  bool isVendor = false;
  var selectedRole = "";
  List<SortByModel> sortOptions = [];
  
  // Selection state for remove offer flow
  bool isBtnSelectPropertiesTapped = false;
  bool isSelectedForCheckbox = false;
  bool isBtnSelectAllPropertiesTapped = false;
  List<PropertyDetailData> selectedPropertyList = [];

  Future<void> getData(BuildContext context) async {
    isGuest = await GetIt.I<AppPreferences>().getIsGuestUser();
    selectedRole = await GetIt.I<AppPreferences>().getUserRole() ?? "";
    isVendor = selectedRole == AppStrings.vendor;
    searchText = "";
    showSuffixIcon = false;
    totalPage = 1;
    if (!context.mounted) return;
    filterRequestModel = FilterRequestModel();
    sortOptions = await Utils.getSortOptionsList(context);
    sortOptions.removeRange(sortOptions.length - 2, sortOptions.length);
  }

  void updateSelectedCategoryId(String? categoryId) {
    selectedCategoryId = categoryId;
    emit(PropertyCategoryUpdated(categoryId: categoryId ?? ""));
  }

  void updateFilterRequestModel(FilterRequestModel? filterModel) {
    filterRequestModel = filterModel;
    emit(RecentlyVisitedPropertiesFilterModelUpdate(
        filterModel ?? FilterRequestModel()));
  }

  Future<void> getList({
    int pageKey = 0,
    bool isPropertiesWithOffers = false,
  }) async {
    emit(RecentlyVisitedPropertiesLoading());
    const defaultSortField = 'createdAt';
    const defaultSortOrder = 'desc';

    filterRequestModel?.category = selectedCategoryId;
    final requestModel = VisitRequestsListRequestModel(
      sortField: defaultSortField,
      sortOrder: defaultSortOrder,
      search: "",
      filter: FilterRequestModel(category: selectedCategoryId),
      itemsPerPage: PER_PAGE_SIZE,
      page: pageKey,
    );

    final selectedSortOption =
        selectedSortIndex >= 0 && selectedSortIndex < sortOptions.length
            ? sortOptions[selectedSortIndex]
            : null;
    var sortField = selectedSortOption?.sortField ?? defaultSortField;
    var sortOrder = selectedSortOption?.sortOrder ?? defaultSortOrder;
    filterRequestModel?.category = selectedCategoryId;

    final requestModelWithOffers = VisitRequestsListRequestModel(
      sortField: sortField,
      sortOrder: sortOrder,
      search: searchCtl.text.trim(),
      page: pageKey,
      filter: filterRequestModel ??
          FilterRequestModel(
            category: selectedCategoryId,
          ),
      itemsPerPage: PER_PAGE_SIZE,
    );

    final response = isPropertiesWithOffers
        ? await propertyRepository.getPropertiesWithOffersList(
            requestModel: requestModelWithOffers)
        : await propertyRepository.getRecentlyVisitedList(
            requestModel: requestModel);

    if (response is SuccessResponse) {
      var responseList = <PropertyDetailData>[];
      if (isPropertiesWithOffers &&
          response.data is PropertiesWithOffersListResponseModel) {
        PropertiesWithOffersListResponseModel responseModel =
            response.data as PropertiesWithOffersListResponseModel;
        responseList = responseModel.data?.offerAppliedProperty ?? [];

        totalPage = responseModel.data?.pageCount ?? 1;
      } else if (response.data is RecentlyVisitedListResponseModel) {
        RecentlyVisitedListResponseModel recentlyVisitedListResponse =
            response.data as RecentlyVisitedListResponseModel;
        responseList = recentlyVisitedListResponse.data?.recentViewedData ?? [];
        totalPage = recentlyVisitedListResponse.data?.pageCount ?? 1;
      }

      bool isLastPage = responseList.length != PER_PAGE_SIZE;

      if (responseList.isEmpty) {
        emit(NoRecentlyVisitedPropertiesFoundState());
      } else {
        emit(RecentlyVisitedPropertiesListSuccess(
            isLastPage, pageKey, responseList));
      }
    } else if (response is FailedResponse) {
      emit(RecentlyVisitedPropertiesError(errorMessage: response.errorMessage));
    }
  }

  List<PropertyCategoryData>? propertyCategoryList = [];

  /// Property Category List API
  ///
  Future<void> getPropertyCategoryList(BuildContext context) async {
    emit(RecentlyVisitedPropertiesLoading());

    final response =
        await context.read<CommonApiCubit>().fetchPropertyCategoryList(context);

    if (response is String) {
      emit(RecentlyVisitedPropertiesError(errorMessage: response));
    } else {
      propertyCategoryList = response;
      emit(APISuccess());
      AppConstants.setPropertyCategory(context, propertyCategoryList);
      emit(PropertyCategoryListUpdate());
    }
  }

  void showHideSuffix(bool showBool) {
    emit(SuffixBoolChangedStateInitial());
    emit(SuffixBoolChangedState(showBool: showSuffixIcon));
  }

  // Add method to toggle the state
  Future<void> toggleSelectProperties() async {
    emit(ToggleSelectPropertiesInit());
    isBtnSelectPropertiesTapped = !isBtnSelectPropertiesTapped;
    emit(ToggleSelectPropertiesUpdate());
  }

  // Method to toggle select all properties
  Future<void> toggleSelectAllProperties(List<PropertyDetailData> allProperties) async {
    emit(ToggleSelectAllPropertiesInit());
    if (isBtnSelectAllPropertiesTapped) {
      // If already selected, deselect all properties
      selectedPropertyList.clear();
    } else {
      // If not selected, add all properties to the selected list
      selectedPropertyList.clear();
      selectedPropertyList.addAll(allProperties);
    }

    // Toggle the selection state
    isBtnSelectAllPropertiesTapped = !isBtnSelectAllPropertiesTapped;
    printf("selectedAllPropertyList----${selectedPropertyList.length}");
    emit(ToggleSelectAllPropertiesUpdate(isBtnSelectAllPropertiesTapped));
  }

  void togglePropertySelection(PropertyDetailData property, bool isSelected, List<PropertyDetailData> allProperties) {
    if (isSelected) {
      selectedPropertyList.add(property);
    } else {
      selectedPropertyList.remove(property);
    }

    // Update 'Select All' state dynamically
    isBtnSelectAllPropertiesTapped = selectedPropertyList.length == allProperties.length;

    printf("selectedPropertyList----${selectedPropertyList.length}");
    emit(ToggleSelectAllPropertiesUpdate(isBtnSelectAllPropertiesTapped));
  }
}
