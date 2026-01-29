import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mashrou3/app/model/base/base_model.dart';
import 'package:mashrou3/app/model/owner_offer_analytics/owner_offer_analytics_request_model.dart';
import 'package:mashrou3/app/model/owner_offer_analytics/owner_offer_analytics_response_model.dart';
import 'package:mashrou3/app/repository/common_api_repository.dart';

part 'owner_offer_analytics_state.dart';

class OwnerOfferAnalyticsCubit extends Cubit<OwnerOfferAnalyticsState> {
  OwnerOfferAnalyticsCubit({required this.repository})
      : super(OwnerOfferAnalyticsInitial());

  final CommonApiRepository repository;
  int itemsPerPage = 10;
  String searchText = "";

  Future<void> getOwnerOfferAnalytics({
    required int page,
    required String ownerId,
  }) async {
    emit(OwnerOfferAnalyticsLoading());

    final requestModel = OwnerOfferAnalyticsRequestModel(
      page: page,
      search: searchText,
      excel: false,
      tableType: "super_admin_property",
      filter: const {},
      sortField: "createdAt",
      sortOrder: "desc",
      itemsPerPage: itemsPerPage,
      pagination: true,
      ownerId: ownerId,
    );

    final response =
        await repository.getOwnerOfferAnalytics(requestModel: requestModel);

    if (response is SuccessResponse &&
        response.data is OwnerOfferAnalyticsResponseModel) {
      final OwnerOfferAnalyticsResponseModel responseModel =
          response.data as OwnerOfferAnalyticsResponseModel;
      final properties = responseModel.data?.properties ?? [];
      final pageCount = responseModel.data?.pageCount ?? 1;
      final currentPage = responseModel.data?.page ?? 1;
      final documentCount = responseModel.data?.documentCount ?? 0;
      final isLastPage = page >= pageCount;

      if (properties.isEmpty) {
        emit(NoOwnerOfferAnalyticsFound());
      } else {
        emit(OwnerOfferAnalyticsSuccess(
          properties: properties,
          pageCount: pageCount,
          currentPage: currentPage,
          documentCount: documentCount,
          isLastPage: isLastPage,
        ));
      }
    } else if (response is FailedResponse) {
      emit(OwnerOfferAnalyticsError(errorMessage: response.errorMessage));
    }
  }

  void updateItemsPerPage(int newItemsPerPage) {
    itemsPerPage = newItemsPerPage;
  }

  void updateSearchText(String text) {
    searchText = text;
  }

  void refresh() {
    emit(OwnerOfferAnalyticsRefresh());
  }
}


