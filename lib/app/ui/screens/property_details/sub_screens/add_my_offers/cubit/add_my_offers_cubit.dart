import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mashrou3/app/model/offers/my_offers_list_request.model.dart';
import 'package:mashrou3/app/model/verify_response.model.dart';

import '../../../../../../../config/utils.dart';
import '../../../../../../db/app_preferences.dart';
import '../../../../../../model/base/base_model.dart';
import '../../../../../../model/offers/my_offers_list_response_model.dart';
import '../../../../../../model/offers/offers_list_for_property_response.model.dart';
import '../../../../../../repository/offers_management_repository.dart';
import '../model/apply_offer_request.model.dart';
import '../model/apply_offer_response_model.dart';

part 'add_my_offers_state.dart';

class AddMyOffersCubit extends Cubit<AddMyOffersState> {
  OffersManagementRepository repository;

  AddMyOffersCubit({required this.repository}) : super(AddMyOffersInitial());

  var selectedLanguage = 'en';

  int currentPage = 1;
  int totalPage = 1;

  bool isLoadingMore = false;
  bool hasShownSkeleton = false;
  bool isSelectedAnyOffer = false;

  static const int PER_PAGE_SIZE = 5;
  VerifyResponseData? userSavedData;
  List<OfferData>? myOffersList = [];
  List<OfferData> selectedOffersList = [];
  List<OfferData>? filteredAddMyOffers = [];
  List<String> offersIds = [];
  var companyLogo = "";

  /// Get data from shared preference
  ///
  Future<void> getData(BuildContext context, List<OfferData> offersList) async {
    myOffersList?.clear();
    selectedOffersList.clear();
    offersIds.clear();
    filteredAddMyOffers?.clear();
    currentPage = 1;
    totalPage = 1;
    userSavedData = await GetIt.I<AppPreferences>().getUserDetails() ?? VerifyResponseData();
    isLoadingMore = false;
    hasShownSkeleton = false;
    selectedLanguage = await GetIt.I<AppPreferences>().getLanguageCode() ?? 'en';
    await setDefaultData(offersList);
    await getAddMyOffers();
  }

  Future<void> setDefaultData(List<OfferData> offersList) async {
    selectedOffersList.addAll(offersList ?? []);
    companyLogo = userSavedData?.users?.companyLogo ?? "";
    // Add sId values to offersIds
    offersIds.addAll(selectedOffersList
        .where((offer) => offer.sId != null) // Ensure sId is not null
        .map((offer) => offer.sId!) // Extract non-null sId
        .toList());
    isSelectedAnyOffer = offersIds.isNotEmpty;

    printf("isSelectedAnyOfferEdit----$isSelectedAnyOffer");
    printf("OfferIdsLengthForEdit----${offersIds.length}");
    emit(ToggleIsSelectedAnyOfferUpdate(isSelectedAnyOffer));
  }

  /// My Offers list API
  Future<void> getAddMyOffers({
    bool hasMoreData = false,
    String searchText = "",
  }) async {
    isLoadingMore = true;
    if (hasMoreData) {
      isLoadingMore = false;
      if (isLoadingMore || currentPage > totalPage) return;
      emit(MyOffersMoreListLoading());
    } else {
      emit(AddMyOffersLoading());
    }

    const sortField = 'createdAt';
    const sortOrder = 'desc';

    final requestModel = MyOffersListRequestModel(
      sortField: sortField,
      sortOrder: sortOrder,
      itemsPerPage: PER_PAGE_SIZE,
      page: currentPage,
    );

    final response = await repository.getMyOffersList(
      requestModel: requestModel,
    );
    isLoadingMore = false;
    companyLogo = userSavedData?.users?.companyLogo ?? "";
    hasShownSkeleton = true;

    if (response is SuccessResponse && response.data is MyOffersListResponseModel) {
      MyOffersListResponseModel visitRequestsListResponse = response.data as MyOffersListResponseModel;

      totalPage = visitRequestsListResponse.data?.pageCount ?? 1;
      myOffersList?.addAll(visitRequestsListResponse.data?.offerData ?? []);
      filteredAddMyOffers = List.from(myOffersList ?? []);

      if (filteredAddMyOffers?.isEmpty ?? true) {
        emit(NoAddMyOffersFoundState());
      } else {
        emit(MyOffersListSuccess(hasMoreData, currentPage, myOffersList ?? []));
      }
    } else if (response is FailedResponse) {
      emit(NoAddMyOffersFoundState());
      emit(AddMyOffersError(errorMessage: response.errorMessage));
    }
  }

  // Load more properties
  void loadMoreMyOffers(int index, BuildContext context) {
    if (currentPage < totalPage) {
      currentPage++;
      getAddMyOffers(hasMoreData: true);
    }
  }

  Future<void> toggleOfferSelection({required String id, required bool isSelected}) async {
    emit(ToggleIsSelectedAnyOfferInit());

    if (isSelected) {
      offersIds.remove(id);
    } else {
      offersIds.add(id);
    }

    isSelectedAnyOffer = offersIds.isNotEmpty;

    printf("isSelectedAnyOffer----$isSelectedAnyOffer");
    printf("OfferIdsLength----${offersIds.length}");
    emit(ToggleIsSelectedAnyOfferUpdate(isSelectedAnyOffer));
  }

  /// Apply My Offers  API
  Future<void> applyMyOffers({
    required List<String> propertyId,
    required bool isMultiple,
    required String? action,
  }) async {
    emit(AddMyOffersLoading());

    final requestModel = ApplyOfferRequestModel(propertyIds: propertyId, offersIds: offersIds, isMultiple: isMultiple, action: action);

    final response = await repository.applyOffer(
      requestModel: requestModel,
    );

    if (response is SuccessResponse && response.data is ApplyOfferResponseModel) {
      ApplyOfferResponseModel responseModel = response.data as ApplyOfferResponseModel;
      emit(ApplyMyOffersSuccess(model: responseModel));
    } else if (response is FailedResponse) {
      emit(AddMyOffersError(errorMessage: response.errorMessage));
    }
  }
}
