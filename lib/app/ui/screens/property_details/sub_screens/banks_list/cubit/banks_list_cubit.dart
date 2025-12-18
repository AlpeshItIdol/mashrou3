import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashrou3/config/network/network_constants.dart';

import '../../../../../../model/base/base_model.dart';
import '../../../../../../repository/bank_management_repository.dart';
import '../model/banks_list_response_model.dart';

part 'banks_list_state.dart';

class BanksListCubit extends Cubit<BanksListState> {
  BankManagementRepository repository;

  BanksListCubit({required this.repository}) : super(BanksListInitial());

  final TextEditingController searchCtl = TextEditingController();

  bool showSuffixIcon = false;
  bool hasShownSkeleton = false;

  int totalBanks = 0;
  bool isFavorite = false;
  static const int PER_PAGE_SIZE = 10;
  List<BankUser>? banksList = [];
  List<BankUser>? filteredBanksList = [];

  /// Get data from shared preference
  ///
  Future<void> getData(BuildContext context) async {
    searchCtl.clear();
    banksList?.clear();
    filteredBanksList?.clear();
    showSuffixIcon = false;
    hasShownSkeleton = false;
    emit(GetSearchUpdate());
  }

  /// Banks list API
  Future<void> getBanksList({
    int pageKey = 0,
    String vendorId = "",
    bool isForVendor = false,
    String propertyId = "",
  }) async {
    emit(BanksListLoading());

    final queryParameters = {
      NetworkParams.kPage: pageKey.toString(),
      NetworkParams.kItemPerPage: PER_PAGE_SIZE.toString(),
      NetworkParams.kSortOrder: "desc",
      NetworkParams.kSortField: "createdAt",
    };

    if (isForVendor) {
      if (vendorId.isNotEmpty && vendorId != "0") {
        queryParameters[NetworkParams.kVendorId] = vendorId;
      }
      if (propertyId.isNotEmpty && propertyId != "0") {
        queryParameters[NetworkParams.kPropertyId] = propertyId;
      }
    } else {
      if (propertyId.isNotEmpty && propertyId != "0") {
        queryParameters[NetworkParams.kPropertyId] = propertyId;
      }
    }

    final response = await repository.getBanksList(
      searchText: searchCtl.text.trim(),
      queryParameters: queryParameters,
    );

    if (response is SuccessResponse &&
        response.data is BanksListResponseModel) {
      BanksListResponseModel visitRequestsListResponse =
      response.data as BanksListResponseModel;
      final responseList = visitRequestsListResponse.data?.bankUser ?? [];

      bool isLastPage = responseList.length != PER_PAGE_SIZE;
      totalBanks = visitRequestsListResponse.data?.documentCount ?? 0;

      if (responseList.isEmpty) {
        emit(NoBanksListFoundState());
      } else {
        emit(BanksListSuccess(isLastPage, pageKey, responseList));
      }
    } else if (response is FailedResponse) {
      emit(NoBanksListFoundState());
      emit(BanksListError(errorMessage: response.errorMessage));
    }
  }



  /// Banks list API for side menu drawer
  Future<void> getFromMenuBanksList({
    int pageKey = 0,
  }) async {
    emit(BanksListLoading());

    final queryParameters = {
      NetworkParams.kPage: pageKey.toString(),
      NetworkParams.kItemPerPage: PER_PAGE_SIZE.toString(),
      NetworkParams.kSortOrder: "desc",
      NetworkParams.kSortField: "createdAt",
    };

    try {
      final response = await repository.getMenuBankList(
        searchText: searchCtl.text.trim(),
        queryParameters: queryParameters,
      );

      if (response is SuccessResponse &&
          response.data is BanksListResponseModel) {
        BanksListResponseModel banksListResponse =
            response.data as BanksListResponseModel;
        final responseList = banksListResponse.data?.bankUser ?? [];

        bool isLastPage = responseList.length < PER_PAGE_SIZE;
        totalBanks = banksListResponse.data?.documentCount ?? 0;

        // Update the banks list
        if (pageKey == 0 || pageKey == 1) {
          banksList = responseList;
        } else {
          banksList?.addAll(responseList);
        }
        filteredBanksList = List.from(banksList ?? []);

        if (responseList.isEmpty && (banksList?.isEmpty ?? true)) {
          emit(NoBanksListFoundState());
        } else {
          emit(BanksListSuccess(isLastPage, pageKey, responseList));
        }
      } else if (response is FailedResponse) {
        emit(NoBanksListFoundState());
        emit(BanksListError(errorMessage: response.errorMessage));
      } else {
        emit(BanksListError(errorMessage: "Unknown error occurred"));
      }
    } catch (e) {
      emit(BanksListError(errorMessage: e.toString()));
    }
  }

  void showHideSuffix(bool showBool) {
    emit(SuffixBoolChangedStateInitial());
    emit(SuffixBoolChangedState(showBool: showSuffixIcon));
  }
}
