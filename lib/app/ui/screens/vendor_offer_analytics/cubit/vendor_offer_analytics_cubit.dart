import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mashrou3/app/model/base/base_model.dart';
import 'package:mashrou3/app/model/vendor_offer_analytics/vendor_offer_analytics_request_model.dart';
import 'package:mashrou3/app/model/vendor_offer_analytics/vendor_offer_analytics_response_model.dart';
import 'package:mashrou3/app/repository/common_api_repository.dart';

part 'vendor_offer_analytics_state.dart';

class VendorOfferAnalyticsCubit extends Cubit<VendorOfferAnalyticsState> {
  VendorOfferAnalyticsCubit({required this.repository}) : super(VendorOfferAnalyticsInitial());
  
  CommonApiRepository repository;
  int itemsPerPage = 10;
  String searchText = "";

  Future<void> getVendorOfferAnalytics({
    required int page,
    required String vendorId,
  }) async {
    emit(VendorOfferAnalyticsLoading());
    
    final requestModel = VendorOfferAnalyticsRequestModel(
      page: page,
      search: searchText,
      excel: false,
      tableType: "super_admin_vendor_offer",
      filter: AnalyticsFilter(userType: "vendor"),
      sortField: "createdAt",
      sortOrder: "desc",
      itemsPerPage: itemsPerPage,
      pagination: true,
      vendorId: vendorId,
    );

    final response = await repository.getVendorOfferAnalytics(requestModel: requestModel);

    if (response is SuccessResponse && response.data is VendorOfferAnalyticsResponseModel) {
      VendorOfferAnalyticsResponseModel responseModel = response.data as VendorOfferAnalyticsResponseModel;
      final offers = responseModel.data?.offers ?? [];
      final pageCount = responseModel.data?.pageCount ?? 1;
      final currentPage = responseModel.data?.page ?? 1;
      final documentCount = responseModel.data?.documentCount ?? 0;
      final isLastPage = page >= pageCount;

      if (offers.isEmpty) {
        emit(NoVendorOfferAnalyticsFound());
      } else {
        emit(VendorOfferAnalyticsSuccess(
          offers: offers,
          pageCount: pageCount,
          currentPage: currentPage,
          documentCount: documentCount,
          isLastPage: isLastPage,
        ));
      }
    } else if (response is FailedResponse) {
      emit(VendorOfferAnalyticsError(errorMessage: response.errorMessage));
    }
  }

  void updateItemsPerPage(int newItemsPerPage) {
    itemsPerPage = newItemsPerPage;
  }

  void updateSearchText(String text) {
    searchText = text;
  }

  void refresh() {
    emit(VendorOfferAnalyticsRefresh());
  }
}

