import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mashrou3/app/model/property/contact_now_model.dart';
import 'package:mashrou3/app/model/property/property_list_data_request_model.dart';
import 'package:mashrou3/app/model/property/property_list_response_model.dart';
import 'package:mashrou3/app/repository/property_repository.dart';
import 'package:mashrou3/app/ui/screens/filter/model/filter_request_model.dart';
import 'package:mashrou3/config/utils.dart';

import '../../../../../../../config/resources/app_constants.dart';
import '../../../../../../../config/resources/app_strings.dart';
import '../../../../../../bloc/common_api_services/common_api_cubit.dart';
import '../../../../../../db/app_preferences.dart';
import '../../../../../../model/base/base_model.dart';
import '../../../../../../model/common_only_message_response_model.dart';
import '../../../../../../model/property/add_to_fav_request_model.dart';
import '../../../../../../model/property/property_category_response_model.dart';
import '../../../../../../model/property/sort_by_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required this.propertyRepository}) : super(HomeInitial());
  PropertyRepository propertyRepository;

  int selectedSortIndex = 0;
  int selectedItemIndex = 0;
  String searchText = "";
  int totalPage = 1;
  int totalEstates = 0;
  bool isFavorite = false;
  bool isSelectedForCheckbox = false;
  bool isBtnSelectPropertiesTapped = false;
  bool isBtnSelectProperty = false;
  bool isBtnSelectAllPropertiesTapped = false;
  bool isVendor = false;
  bool isVisitor = false;

  String? selectedCategoryId;
  static const int PER_PAGE_SIZE = 5;
  int itemsPerPage = 10; // Default items per page
  List<PropertyData> selectedPropertyList = [];
  List<PropertyData> allProperties = [];
  List<SortByModel> sortOptions = [];
  List<ContactNowModel> contactNowOptions = [];
  FilterRequestModel? filterRequestModel;

  var isGuest = false;
  var selectedRole = "";

  var selectedUserId = "";
  var selectedUserRole = "";

  Future<void> getData(BuildContext context) async {
    selectedUserId = await GetIt.I<AppPreferences>().getUserID();
    selectedUserRole = await GetIt.I<AppPreferences>().getUserRole() ?? "";
    isGuest = await GetIt.I<AppPreferences>().getIsGuestUser();
    selectedSortIndex = 0;
    selectedRole = await GetIt.I<AppPreferences>().getUserRole() ?? "";
    isVendor = selectedRole == AppStrings.vendor;
    isVisitor = selectedRole == AppStrings.visitor;
    searchText = "";
    if (!context.mounted) return;
    sortOptions = await Utils.getSortOptionsList(context);
    contactNowOptions = await Utils.getContactNowList(context);
  }

  void updateSelectedCategoryId(String? categoryId) {
    selectedCategoryId = categoryId;
    emit(PropertyCategoryUpdated(categoryId: categoryId ?? ""));
  }

  void updateFilterRequestModel(FilterRequestModel? filterModel) {
    filterRequestModel = filterModel;
    emit(PropertyFilterModelUpdate(filterModel ?? FilterRequestModel()));
  }

  void resetPropertyList() {
    totalPage = 1;
    isFavorite = false;
    isSelectedForCheckbox = false;
    isBtnSelectPropertiesTapped = false;
    isBtnSelectAllPropertiesTapped = false;
    if (selectedRole == AppStrings.vendor) {
      isVendor = true;
    } else {
      isVendor = false;
    }
    isVisitor = selectedRole == AppStrings.visitor;
    emit(PropertyListReset());
  }

  void updateItemsPerPage(int newItemsPerPage) {
    if (itemsPerPage != newItemsPerPage) {
      itemsPerPage = newItemsPerPage;
      // Reset pagination when items per page changes
      totalPage = 1;
      emit(ItemsPerPageUpdated(itemsPerPage: itemsPerPage));
    }
  }

  /// Property list API
  Future<void> getPropertyList({
    int pageKey = 0,
  }) async {
    emit(PropertyListLoading());
    final selectedSortOption = selectedSortIndex >= 0 && selectedSortIndex < sortOptions.length ? sortOptions[selectedSortIndex] : null;

    final sortField = selectedSortOption?.sortField;
    final sortOrder = selectedSortOption?.sortOrder;
    
    // Only set category from selectedCategoryId if filterRequestModel doesn't already have a category
    if (filterRequestModel != null) {
      if (filterRequestModel!.category == null || filterRequestModel!.category!.isEmpty) {
        filterRequestModel!.category = selectedCategoryId;
      }
    }

    final requestModel = PropertyListDataRequestModel(
      sortField: sortField,
      sortOrder: sortOrder,
      search: searchText,
      filter: filterRequestModel ?? FilterRequestModel(category: selectedCategoryId),
      skipLogin: isGuest ? true : false,
      itemsPerPage: itemsPerPage,
      page: pageKey,
    );

    final response = await propertyRepository.getPropertyList(requestModel: requestModel);
    if (response is SuccessResponse && response.data is PropertyListResponseModel) {
      PropertyListResponseModel propertyListResponse = response.data as PropertyListResponseModel;
      var responseList = <PropertyData>[];
      var supportData = propertyListResponse.data?.support ?? Support();
      // Update pagination details
      totalPage = propertyListResponse.data?.pageCount ?? 1;
      totalEstates = propertyListResponse.data?.documentCount ?? 0;
      responseList = propertyListResponse.data?.propertyData ?? [];
      bool isLastPage = responseList.length != itemsPerPage;

      if (responseList.isEmpty) {
        emit(NoPropertyFoundState());
      } else {
        emit(PropertyListSuccess(isLastPage, pageKey, responseList));
      }
      await GetIt.I<AppPreferences>().setSupportDetails(supportData);
    } else if (response is FailedResponse) {
      emit(PropertyListError(errorMessage: response.errorMessage));
    }
  }

  void refreshData() {
    emit(PropertyListRefresh());
  }

  /// Add To Fav Property API
  Future<void> addRemoveFavorite({
    required String propertyId,
    required bool isFav,
  }) async {
    emit(PropertyAddFavLoadState());
    // hasShownSkeleton = false;

    final requestModel = AddRemoveFavRequestModel(
      isFavorite: isFav,
      propertyId: propertyId,
    );

    final response = await propertyRepository.addRemoveFavorite(requestModel: requestModel);

    // hasShownSkeleton = true;

    if (response is SuccessResponse && response.data is CommonOnlyMessageResponseModel) {
      CommonOnlyMessageResponseModel addToFavResponse = response.data as CommonOnlyMessageResponseModel;

      emit(AddedToFavorite(addToFavResponse.message ?? ""));
    } else if (response is FailedResponse) {
      emit(PropertyAddFavError(errorMessage: response.errorMessage));
    }
  }

  List<PropertyCategoryData>? propertyCategoryList = [];

  /// Property Category List API
  ///
  Future<void> getPropertyCategoryList(BuildContext context) async {
    emit(HomeLoading());

    final response = await context.read<CommonApiCubit>().fetchPropertyCategoryList(context);

    if (response is String) {
      emit(HomeError(errorMessage: response));
    } else {
      propertyCategoryList = response;
      emit(APISuccess());
      AppConstants.setPropertyCategory(context, propertyCategoryList);
      emit(PropertyCategoryListUpdate());
    }
  }

  // Add method to toggle the state
  Future<void> toggleSelectProperties() async {
    emit(ToggleSelectPropertiesInit());
    printf("New");
    isBtnSelectPropertiesTapped = !isBtnSelectPropertiesTapped;
    emit(ToggleSelectPropertiesUpdate()); // Emit a new state to notify listeners
  }

  // Method to toggle select all properties
  Future<void> toggleSelectAllProperties(PagingController controller) async {
    emit(ToggleSelectAllPropertiesInit());
    printf("New");
    if (isBtnSelectAllPropertiesTapped) {
      // If already selected, deselect all properties
      selectedPropertyList.clear();
    } else {
      // If not selected, add all properties to the selected list
      // selectedPropertyList.addAll(filteredPropertyList ?? []);
      selectedPropertyList.addAll(
        (controller.itemList as List<PropertyData>).where((item) => !selectedPropertyList.contains(item)).toList(),
      );
    }

    // Toggle the selection state
    isBtnSelectAllPropertiesTapped = !isBtnSelectAllPropertiesTapped;
    printf("selectedAllPropertyList----${selectedPropertyList.length}");
    emit(ToggleSelectAllPropertiesUpdate(isBtnSelectAllPropertiesTapped)); // Emit a new state to notify listeners
  }

  void togglePropertySelection(PropertyData property, bool isSelected, PagingController controller) {
    if (isSelected) {
      selectedPropertyList.add(property);
    } else {
      selectedPropertyList.remove(property);
    }

    // Update 'Select All' state dynamically
    isBtnSelectAllPropertiesTapped = selectedPropertyList.length == (controller.itemList?.length ?? 0);

    printf("selectedPropertyList----${selectedPropertyList.length}");
    emit(ToggleSelectAllPropertiesUpdate(isBtnSelectAllPropertiesTapped));
  }

  // Add method to toggle the state
  bool toggleCheckbox({required bool isSelected}) {
    emit(ToggleSelectPropertiesInit());
    printf("New");
    isSelected = !isSelected;
    emit(ToggleSelectPropertiesUpdate());
    return isSelected;
  }
}
