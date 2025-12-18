import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mashrou3/app/model/property/contact_now_model.dart';
import 'package:mashrou3/app/repository/property_repository.dart';
import 'package:mashrou3/app/ui/screens/filter/model/filter_request_model.dart';
import 'package:mashrou3/config/resources/app_strings.dart';
import 'package:mashrou3/config/utils.dart';

import '../../../../../../../config/resources/app_constants.dart';
import '../../../../bloc/common_api_services/common_api_cubit.dart';
import '../../../../db/app_preferences.dart';
import '../../../../model/base/base_model.dart';
import '../../../../model/common_only_message_response_model.dart';
import '../../../../model/property/add_to_fav_request_model.dart';
import '../../../../model/property/property_category_response_model.dart';
import '../../../../model/property/sort_by_model.dart';
import '../../../owner_screens/visit_requests_list/model/visit_requests_list_request.model.dart';
import '../../../owner_screens/visit_requests_list/model/visit_requests_list_response.model.dart';

part 'requested_properties_state.dart';

class RequestedPropertiesCubit extends Cubit<RequestedPropertiesState> {
  RequestedPropertiesCubit({required this.propertyRepository})
      : super(RequestedPropertiesInitial());
  PropertyRepository propertyRepository;

  int selectedItemIndex = 0;
  String searchText = "";
  int totalProperties = 0;
  int currentPage = 1;
  int totalPage = 1;
  bool isLoadingMore = false;
  bool hasShownSkeleton = false;
  bool isFavorite = false;
  String? selectedCategoryId;
  static const int PER_PAGE_SIZE = 5;
  List<VisitRequestData>? requestedPropertiesList = [];
  List<VisitRequestData>? filteredRequestedPropertiesList = [];
  List<SortByModel> sortOptions = [];
  List<ContactNowModel> contactNowOptions = [];
  FilterRequestModel? filterRequestModel;
  bool isVendor = false;
  var selectedRole = "";

  var isGuest = false;

  Future<void> getData(BuildContext context) async {
    isGuest = await GetIt.I<AppPreferences>().getIsGuestUser();
    resetPropertyList();
    selectedRole = await GetIt.I<AppPreferences>().getUserRole() ?? "";
    isVendor = selectedRole == AppStrings.vendor;
    searchText = "";
    if (!context.mounted) return;
    sortOptions = await Utils.getSortOptionsList(context);
    if (!context.mounted) return;
    contactNowOptions = await Utils.getContactNowList(context);
    await getVisitRequestsList();
  }

  void updateSelectedCategoryId(String? categoryId) {
    selectedCategoryId = categoryId;
    emit(PropertyCategoryUpdated(categoryId: categoryId ?? ""));
  }

  void updateFilterRequestModel(FilterRequestModel? filterModel) {
    filterRequestModel = filterModel;
    emit(RequestedPropertiesFilterModelUpdate(
        filterModel ?? FilterRequestModel()));
  }

  void resetPropertyList() {
    requestedPropertiesList = [];
    filteredRequestedPropertiesList = [];
    currentPage = 1;
    totalPage = 1;
    hasShownSkeleton = false;
  }

  /// Visit Requested Properties list API
  Future<void> getVisitRequestsList({
    bool hasMoreData = false,
  }) async {
    isLoadingMore = true;
    if (hasMoreData) {
      isLoadingMore = false;
      if (isLoadingMore || currentPage > totalPage) return;
      emit(RequestedPropertiesMoreListLoading());
    } else {
      emit(RequestedPropertiesLoading());
    }

    const sortField = 'createdAt';
    const sortOrder = 'desc';

    filterRequestModel?.category = selectedCategoryId;
    final requestModel = VisitRequestsListRequestModel(
      sortField: sortField,
      sortOrder: sortOrder,
      search: "",
      filter: filterRequestModel ??
          FilterRequestModel(category: selectedCategoryId),
      itemsPerPage: PER_PAGE_SIZE,
      page: currentPage,
    );

    final response = await propertyRepository.getVisitRequestsList(
        requestModel: requestModel);
    isLoadingMore = false;

    hasShownSkeleton = true;

    if (response is SuccessResponse &&
        response.data is VisitRequestsListResponseModel) {
      VisitRequestsListResponseModel visitRequestsListResponse =
          response.data as VisitRequestsListResponseModel;

      totalPage = visitRequestsListResponse.data?.pageCount ?? 1;
      requestedPropertiesList
          ?.addAll(visitRequestsListResponse.data?.data ?? []);
      filteredRequestedPropertiesList =
          List.from(requestedPropertiesList ?? []);

      if (filteredRequestedPropertiesList?.isEmpty ?? true) {
        emit(NoRequestedPropertiesFoundState());
      } else {
        emit(RequestedPropertiesListSuccess(
            hasMoreData, currentPage, requestedPropertiesList ?? []));
      }
    } else if (response is FailedResponse) {
      emit(NoRequestedPropertiesFoundState());
      emit(RequestedPropertiesError(errorMessage: response.errorMessage));
    }
  }

  /// Add To Fav Property API
  Future<void> addRemoveFavorite({
    required String propertyId,
    required bool isFav,
  }) async {
    emit(RequestedPropertiesLoading());

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
      emit(RequestedPropertiesListError(errorMessage: response.errorMessage));
    }
  }

  List<PropertyCategoryData>? propertyCategoryList = [];

  /// Property Category List API
  ///
  Future<void> getPropertyCategoryList(BuildContext context) async {
    emit(RequestedPropertiesLoading());

    final response =
        await context.read<CommonApiCubit>().fetchPropertyCategoryList(context);

    if (response is String) {
      emit(RequestedPropertiesError(errorMessage: response));
    } else {
      propertyCategoryList = response;
      emit(APISuccess());
      AppConstants.setPropertyCategory(context, propertyCategoryList);
      emit(PropertyCategoryListUpdate());
    }
  }

  // Load more properties
  void loadMoreProperties(int index, BuildContext context) {
    if (currentPage < totalPage) {
      currentPage++;
      getVisitRequestsList(hasMoreData: true);
    }
  }
}
