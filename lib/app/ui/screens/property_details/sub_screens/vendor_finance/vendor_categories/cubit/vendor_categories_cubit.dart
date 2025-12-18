import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mashrou3/app/model/base/base_model.dart';
import 'package:mashrou3/app/model/property/get_finance_model.dart';
import 'package:mashrou3/app/repository/offers_management_repository.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/vendor_finance/model/property_vendor_finance_data.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/vendor_finance/model/vendor_category_list_response.dart';
import 'package:mashrou3/config/services/property_vendor_finance_service.dart';
import 'package:mashrou3/config/utils.dart';

import '../../../../../../../model/complete_profile_response.model.dart';
import '../../../../../../../model/offers/my_offers_list_response_model.dart';
import '../../model/vendor_detail_response_model.dart';
import '../../vendor_details/cubit/vendor_detail_cubit.dart';

part 'vendor_categories_state.dart';

class VendorCategoriesCubit extends Cubit<VendorCategoriesState> {
  OffersManagementRepository repository;

  VendorCategoriesCubit({required this.repository}) : super(VendorCategoriesInitial());

  bool showSuffixIcon = false;
  bool hasShownSkeleton = false;
  List<GetFinanceModel> getPaymentMethods = [];
  List<VendorCategoryData>? vendorCategoryList = [];
  TextEditingController searchCtl = TextEditingController(text: "");
  final PropertyVendorFinanceService service = GetIt.instance<PropertyVendorFinanceService>();
  UserDetailsData detailData = UserDetailsData();
  List<OfferData> offersList = [];

  /// Set property Data
  Future<void> setPropertyData(PropertyVendorFinanceData data) async {
    if (data.propertyId != null) {
      service.setPropertyId(data.propertyId ?? "0");
    }
    if (data.vendorCategoryId != null) {
      service.setVendorCatId(data.vendorCategoryId ?? "0");
    }
    emit(
      VendorCategoriesDataLoaded(
        propertyVendorFinanceData: service.data,
      ),
    );
  }

  /// Update cash selection
  void updateCashSelection(bool isCashSelected) {
    service.updateCashSelection(isCashSelected);
    emit(
      VendorCategoriesDataLoaded(
        propertyVendorFinanceData: service.data,
      ),
    );
  }

  void showHideSuffix(bool showBool) {
    emit(SuffixBoolChangedStateInitial());
    emit(SuffixBoolChangedState(showBool: showSuffixIcon));
  }

  /// Get Data
  Future<void> getData(BuildContext context, {String? propertyId}) async {
    vendorCategoryList = [];
    hasShownSkeleton = false;
    detailData = UserDetailsData();
    await getCategoryList(propertyId ?? "");
    if (!context.mounted) return;
    getPaymentMethods = await Utils.getPaymentType(context);

    setPropertyData(PropertyVendorFinanceData(propertyId: propertyId));
  }

  /// Get Category List
  Future<void> getCategoryList(String propertyId) async {
    emit(VendorCategoriesLoading());

    final response = await repository.getVendorCategoryList(searchText: searchCtl.text.trim(), propertyId: propertyId);
    hasShownSkeleton = true;
    if (response is SuccessResponse && response.data is VendorCategoryListResponse) {
      VendorCategoryListResponse responseModel = response.data as VendorCategoryListResponse;
      // Handle both paginated and non-paginated responses
      if (responseModel.dataList != null) {
        vendorCategoryList?.addAll(responseModel.dataList ?? []);
      } else if (responseModel.data?.vendorData != null) {
        vendorCategoryList?.addAll(responseModel.data?.vendorData ?? []);
      }
      emit(VendorCategoriesSuccess());
    } else if (response is FailedResponse) {
      emit(VendorCategoriesError(errorMessage: response.errorMessage));
    }
  }
}
