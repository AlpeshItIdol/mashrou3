// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get_it/get_it.dart';
// import 'package:mashrou3/app/repository/bank_offer_repository.dart';
//
// // import '../../../property_details/sub_screens/banks_list/model/banks_list_response_model.dart';
// import '../../../../model/base/base_model.dart';
// import '../models/banks_offer_list_model.dart';
//
// part 'banks_offer_list_state.dart';
//
//
// class BanksOfferListCubit extends Cubit<BanksOfferListState> {
//   BanksOfferListCubit({required this.repository}) : super(BankOffersListInitial());
//
//   final BankOfferListRepository repository;
//
//   static const int PER_PAGE_SIZE = 10;
//   int currentPage = 1;
//   bool isLoadingMore = false;
//   bool hasShownSkeleton = false;
//   String searchText = "";
//
//   List<BankUserList> banksOffers = [];
//
//   Future<void> refresh() async {
//     emit(BankOffersRefreshLoading());
//     currentPage = 1;
//     banksOffers.clear();
//     await getBankOffersList();
//   }
//
//   Future<void> getBankOffersList({bool hasMoreData = false}) async {
//     if (!hasMoreData) {
//       emit(BankOffersListLoading());
//     }
//     isLoadingMore = true;
//
//     final Map<String, dynamic> queryParams = {
//       'page': currentPage,
//       'itemsPerPage': PER_PAGE_SIZE,
//       'sortField': 'createdAt',
//       'sortOrder': 'desc',
//     };
//
//     final response = await repository.getBanksOfferList(
//       queryParameters: queryParams,
//       searchText: searchText,
//     );
//
//     if (response is SuccessResponse) {
//       final BankOffersListResponse data = response.data as BankOffersListResponse;
//       final List<BankUserList> pageItems = data.data?.bank ?? [];
//       final bool isLastPage = pageItems.length < PER_PAGE_SIZE;
//
//       if (currentPage == 1) {
//         banksOffers = pageItems;
//       } else {
//         banksOffers.addAll(pageItems);
//       }
//
//       if (banksOffers.isEmpty) {
//         emit(NoBankOffersFoundState());
//       } else {
//         emit(BankOffersListSuccess(banksOffers, isLastPage, currentPage));
//         if (!isLastPage) {
//           currentPage += 1;
//         }
//       }
//     } else if (response is FailedResponse) {
//       emit(BankOffersListError(response.errorMessage));
//     }
//
//     isLoadingMore = false;
//   }
// }

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mashrou3/app/repository/bank_offer_repository.dart';

import '../../../../model/base/base_model.dart';
import '../models/banks_offer_list_model.dart';

part 'banks_offer_list_state.dart';

class BanksOfferListCubit extends Cubit<BanksOfferListState> {
  BanksOfferListCubit({required this.repository}) : super(BankOffersListInitial());

  /// Repository responsible for fetching bank offers list
  final BankOfferListRepository repository;

  static const int PER_PAGE_SIZE = 10;
  int currentPage = 1;
  bool isLoadingMore = false;
  String _searchQuery = "";

  List<BankUserList> banksOffers = [];

  Future<void> refresh([String? searchQuery]) async {
    emit(BankOffersRefreshLoading());
    currentPage = 1;
    banksOffers.clear();
    _searchQuery = searchQuery ?? "";
    await getBankOffersList();
  }

  Future<void> getBankOffersList({bool hasMoreData = false}) async {
    if (!hasMoreData && currentPage == 1) {
      emit(BankOffersListLoading());
    }
    isLoadingMore = true;

    final Map<String, dynamic> queryParams = {
      'page': currentPage,
      'itemsPerPage': PER_PAGE_SIZE,
      'sortField': 'createdAt',
      'sortOrder': 'desc',
    };

    final response = await repository.getBanksOfferList(
      queryParameters: queryParams,
      searchText: _searchQuery,
    );

    if (response is SuccessResponse) {
      final BankOffersListResponse data = response.data as BankOffersListResponse;
      final List<BankUserList> pageItems = data.data?.bank ?? [];

      final bool hasMoreData = pageItems.length == PER_PAGE_SIZE;

      if (currentPage == 1) {
        banksOffers = pageItems;
      } else {
        banksOffers.addAll(pageItems);
      }

      if (banksOffers.isEmpty) {
        emit(NoBankOffersFoundState());
      } else {
        emit(BankOffersListSuccess(offers: banksOffers, hasMoreData: hasMoreData));
        if (hasMoreData) {
          currentPage++;
        }
      }
    } else if (response is FailedResponse) {
      emit(BankOffersListError(response.errorMessage, isFirstFetch: currentPage == 1));
    }

    isLoadingMore = false;
  }
}
