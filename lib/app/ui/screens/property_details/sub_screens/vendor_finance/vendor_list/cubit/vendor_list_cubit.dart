import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mashrou3/app/model/base/base_model.dart';
import 'package:mashrou3/app/repository/offers_management_repository.dart';
import 'package:mashrou3/app/ui/custom_widget/toggle_widget/toggle_cubit.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/vendor_finance/model/vendor_category_list_response.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/vendor_finance/model/vendor_list_response_model.dart';
import 'package:mashrou3/config/network/network_constants.dart';
import 'package:mashrou3/config/resources/app_constants.dart';
import 'package:mashrou3/config/services/property_vendor_finance_service.dart';

part 'vendor_list_state.dart';

class VendorListCubit extends Cubit<VendorListState> {
  OffersManagementRepository repository;

  VendorListCubit({required this.repository}) : super(VendorListInitial());
  bool showSuffixIcon = false;
  bool hasShownSkeleton = false;
  int selectedItemIndex = 0;
  String? selectedCategoryId;
  List<VendorCategoryData>? vendorCategoryList = [];
  List<VendorUserData>? vendorList = [];
  List<VendorUserData>? filteredVendorList = [];
  TextEditingController searchCtl = TextEditingController(text: "");
  static const int PER_PAGE_SIZE = 10;
  int totalVendor = 0;
  int totalPage = 1;
  final PropertyVendorFinanceService service = GetIt.instance<PropertyVendorFinanceService>();

  void showHideSuffix(bool showBool) {
    emit(SuffixBoolChangedStateInitial());
    emit(SuffixBoolChangedState(showBool: showSuffixIcon));
  }

  void updateSelectedCategoryId(String? categoryId) {
    selectedCategoryId = categoryId;
    emit(VendorCategoryUpdated(
      categoryId: categoryId ?? "",
      index: selectedItemIndex,
    ));
  }

  void getSelectedCategoryIndex(String? categoryId) {
    selectedCategoryId = categoryId;

    int selectedIndex = AppConstants.vendorCategory.indexWhere(
      (item) => item.sId == categoryId,
    );

    selectedItemIndex = selectedIndex;
    emit(VendorCategoryUpdated(
      categoryId: categoryId ?? "",
      index: selectedIndex,
    ));
  }

  Future<void> getData(BuildContext context) async {
    vendorList = [];
    vendorCategoryList = [];
    hasShownSkeleton = false;
    await getCategoryList(context);
  }

  resetDataAndRefresh() async {
    resetList();
    emit(VendorRefreshLoading());
  }

  Future<void> getCategoryList(BuildContext context) async {
    final propertyId = service.getPropertyId() ?? "";
    final response = await repository.getVendorCategoryList(searchText: searchCtl.text.trim(), propertyId: propertyId);
    emit(VendorCategoriesLoading());
    hasShownSkeleton = true;
    if (response is SuccessResponse && response.data is VendorCategoryListResponse) {
      VendorCategoryListResponse responseModel = response.data as VendorCategoryListResponse;
      // Handle both paginated and non-paginated responses
      if (responseModel.dataList != null) {
        vendorCategoryList = responseModel.dataList ?? [];
      } else if (responseModel.data?.vendorData != null) {
        vendorCategoryList = responseModel.data?.vendorData ?? [];
      } else {
        vendorCategoryList = [];
      }
      AppConstants.setVendorCategory(context, vendorCategoryList);
      getSelectedCategoryIndex(GetIt.I<PropertyVendorFinanceService>().getVendorCatId());
      await context.read<ToggleCubit>().updateVendorCategories(AppConstants.vendorCategory, selectedItemIndex);
      emit(VendorCategoriesSuccess());
    } else if (response is FailedResponse) {
      emit(VendorCategoriesError(errorMessage: response.errorMessage));
    }
  }

  Future<void> getVendorList({
    required BuildContext context,
    int pageKey = 0,
    required String id,
  }) async {
    emit(VendorListLoading());
    var propertyId = service.getPropertyId();
    // Make API call
    final response = await repository.getVendorList(
      searchText: searchCtl.text.trim(),
      queryParameters: {
        NetworkParams.kVendorCategory: selectedItemIndex == 0 ? "" : selectedCategoryId,
        NetworkParams.kPropertyId: propertyId,
        NetworkParams.kPage: pageKey.toString(),
        NetworkParams.kItemPerPage: PER_PAGE_SIZE.toString(),
        NetworkParams.kSortOrder: "desc",
        NetworkParams.kSortField: "createdAt",
      },
    );

    if (response is SuccessResponse && response.data is VendorListResponseModel) {
      VendorListResponseModel responseModel = response.data as VendorListResponseModel;
      final responseList = responseModel.data?.user ?? [];

      bool isLastPage = responseList.length != PER_PAGE_SIZE;
      totalVendor = responseModel.data?.documentCount ?? 0;
      if (responseList.isEmpty) {
        emit(NoVendorListFound());
      } else {
        emit(VendorListSuccess(isLastPage, pageKey, responseList));
      }
    } else if (response is FailedResponse) {
      emit(NoVendorListFound());
      emit(VendorListError(
        errorMessage: response.errorMessage,
      ));
    }
  }

  void resetList() {
    vendorList = [];
    vendorCategoryList = [];
    filteredVendorList = [];
    totalPage = 1;
  }
}
