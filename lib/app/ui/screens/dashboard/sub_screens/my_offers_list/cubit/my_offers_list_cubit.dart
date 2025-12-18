import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mashrou3/app/db/app_preferences.dart';
import 'package:mashrou3/app/model/verify_response.model.dart';

import '../../../../../../model/base/base_model.dart';
import '../../../../../../model/offers/my_offers_list_request.model.dart';
import '../../../../../../model/offers/my_offers_list_response_model.dart';
import '../../../../../../repository/offers_management_repository.dart';

part 'my_offers_list_state.dart';

class MyOffersListCubit extends Cubit<MyOffersListState> {
  OffersManagementRepository repository;

  static const int kApprovedOffer = 0;
  static const int kDraftOffers = 1;

  MyOffersListCubit({required this.repository}) : super(MyOffersListInitial());

  final searchFormKey = GlobalKey<FormState>();

  final TextEditingController searchCtl = TextEditingController();

  bool showSuffixIcon = false;
  bool hasShownSkeleton = false;

  int totalVisitRequests = 0;
  int tabCurrentIndex = kApprovedOffer;
  int currentPage = 1;
  int totalPage = 1;
  bool isLoadingMore = false;
  bool isFavorite = false;
  static const int PER_PAGE_SIZE = 5;
  VerifyResponseData? userSavedData;
  List<OfferData>? myOffersList = [];
  List<OfferData>? myVendorList = [];
  List<OfferData>? filteredAddMyOffers = [];
  List<OfferData>? filteredVendorOffers = [];

  TabController? tabController;

  /// Get data from shared preference
  ///
  Future<void> getData(BuildContext context) async {
    userSavedData = await GetIt.I<AppPreferences>().getUserDetails() ??
        VerifyResponseData();
    searchCtl.clear();
    myOffersList?.clear();
    myVendorList?.clear();
    filteredAddMyOffers?.clear();
    filteredVendorOffers?.clear();
    showSuffixIcon = false;
    hasShownSkeleton = false;
    tabCurrentIndex = 0;
    currentPage = 1;
    totalPage = 1;
    if (tabCurrentIndex == 0) {
      await getAddMyOffers();
    } else {
      await getDraftOffersForUser();
    }
  }

  /// Get data from shared preference
  ///
  Future<void> refreshData(BuildContext context) async {
    myOffersList?.clear();
    myVendorList?.clear();
    filteredAddMyOffers?.clear();
    filteredVendorOffers?.clear();
    hasShownSkeleton = false;
    currentPage = 1;
    totalPage = 1;
    if (tabCurrentIndex == 0) {
      await getAddMyOffers();
    } else {
      await getDraftOffersForUser();
    }
  }

  void animateToCurrentTab(TabController controller) {
    tabController = controller;
    controller.animateTo(tabCurrentIndex);
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
        search: searchCtl.text.trim());

    final response = await repository.getMyOffersList(
      requestModel: requestModel,
    );
    isLoadingMore = false;

    hasShownSkeleton = true;

    userSavedData = await GetIt.I<AppPreferences>().getUserDetails() ??
        VerifyResponseData();

    if (response is SuccessResponse &&
        response.data is MyOffersListResponseModel) {
      MyOffersListResponseModel visitRequestsListResponse =
          response.data as MyOffersListResponseModel;

      // Update pagination details
      totalPage = visitRequestsListResponse.data?.pageCount ?? 1;

      // Add new data to the existing list without duplicates
      final newOffers = visitRequestsListResponse.data?.offerData ?? [];

      // Avoid adding duplicate offers based on unique ID or other identifying offers
      final existingIds = myOffersList?.map((offer) => offer.sId).toSet() ?? {};
      final uniqueOffers =
          newOffers.where((offer) => !existingIds.contains(offer.sId)).toList();

      myOffersList?.addAll(uniqueOffers);
      filteredAddMyOffers = List.from(myOffersList ?? []);

      // totalPage = visitRequestsListResponse.data?.pageCount ?? 1;
      // myOffersList?.addAll(visitRequestsListResponse.data?.offerData ?? []);
      // filteredAddMyOffers = List.from(myOffersList ?? []);

      if (filteredAddMyOffers?.isEmpty ?? true) {
        emit(NoAddMyOffersFoundState());
      } else {
        emit(AddMyOffersSuccess(hasMoreData, currentPage, myOffersList ?? []));
      }
    } else if (response is FailedResponse) {
      emit(NoAddMyOffersFoundState());
      emit(AddMyOffersError(errorMessage: response.errorMessage));
    }
  }

  Future<void> updateTabIndex(int index) async {
    tabCurrentIndex = index;

    animateToCurrentTab(tabController!);
    emit(TabUpdateState());
  }

  /// My Offers list API
  Future<void> getDraftOffersForUser({
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
        search: searchCtl.text.trim());

    final response = await repository.getDraftOffer(
      requestModel: requestModel,
    );
    isLoadingMore = false;

    hasShownSkeleton = true;


    if (response is SuccessResponse &&
        response.data is MyOffersListResponseModel) {
      MyOffersListResponseModel visitRequestsListResponse =
          response.data as MyOffersListResponseModel;

      // Update pagination details
      totalPage = visitRequestsListResponse.data?.pageCount ?? 1;

      // Add new data to the existing list without duplicates
      final newOffers = visitRequestsListResponse.data?.offerData ?? [];

      // Avoid adding duplicate offers based on unique ID or other identifying offers
      final existingIds = myVendorList?.map((offer) => offer.sId).toSet() ?? {};
      final uniqueOffers =
          newOffers.where((offer) => !existingIds.contains(offer.sId)).toList();

      myVendorList?.addAll(uniqueOffers);
      filteredVendorOffers = List.from(myVendorList ?? []);

      if (filteredVendorOffers?.isEmpty ?? true) {
        emit(NoDraftOffersFoundState());
      } else {
        emit(DraftOffersSuccess(hasMoreData, currentPage, myVendorList ?? []));
      }
    } else if (response is FailedResponse) {
      emit(NoAddMyOffersFoundState());
      emit(AddMyOffersError(errorMessage: response.errorMessage));
    }
  }

  // Load more offers
  Future<void> loadMoreMyOffers(int index, BuildContext context) async {
    if (currentPage < totalPage) {
      currentPage++;
      if (tabCurrentIndex == 0) {
        await getAddMyOffers(hasMoreData: true);
      } else {
        await getDraftOffersForUser(hasMoreData: true);
      }
    }
  }

  /// MULTIPART CREATE OFFER API
  ///
  Future<void> deleteOffer(String postId, int index) async {
    emit(DeleteOfferLoading());

    final deletePostResponse = tabCurrentIndex == kApprovedOffer
        ? await repository.deleteFeedPost(isDraftOffer: false, postId: postId)
        : await repository.deleteFeedPost(isDraftOffer: true, postId: postId);

    if (deletePostResponse is FailedResponse) {
      emit(AddMyOffersError(errorMessage: deletePostResponse.errorMessage));
    } else if (deletePostResponse is SuccessResponse) {
      emit(DeleteOfferSuccess());
      if (tabCurrentIndex == kApprovedOffer) {
        filteredAddMyOffers?.removeAt(index);
      } else {
        filteredVendorOffers?.removeAt(index);
      }
    }
  }

  void showHideSuffix(bool showBool) {
    emit(SuffixBoolChangedStateInitial());
    emit(SuffixBoolChangedState(showBool: showSuffixIcon));
  }
}
