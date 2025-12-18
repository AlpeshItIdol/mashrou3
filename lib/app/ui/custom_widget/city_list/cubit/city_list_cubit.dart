import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashrou3/app/bloc/common_api_services/common_api_cubit.dart';
import 'package:mashrou3/app/model/city_list_response_model.dart';

import '../../../../model/base/base_model.dart';
import '../../../../model/city_list_request.model.dart';

part 'city_list_state.dart';

class CityListCubit extends Cubit<CityListState> {
  CityListCubit() : super(CityListInitial());

  static const int PER_PAGE_SIZE = 50;

  var selectedCountryId = "";

  bool showSuffixIcon = false;
  TextEditingController searchCtl = TextEditingController(text: "");

  void showHideSuffix(bool showBool) {
    emit(SuffixBoolChangedStateInitial());
    emit(SuffixBoolChangedState(showBool: showSuffixIcon));
  }

  /// Refresh all projects
  Future<void> refreshAll() async {
    emit(CityRefreshLoading());
  }

  /// City List API
  ///
  Future<void> getCityListWithPagination({
    required BuildContext context,
    int pageKey = 0,
    required String id,
  }) async {
    emit(CityListLoading());

    final requestModel = CityListRequestModel(
      pagination: true,
      search: searchCtl.text.trim(),
      countryId: id.toString(),
      itemsPerPage: PER_PAGE_SIZE,
      page: pageKey,
    );

    final response = await context
        .read<CommonApiCubit>()
        .fetchCityListWithPagination(requestModel: requestModel);

    if (response is CityListResponseModel) {
      CityListResponseModel cityListResponse = response;
      final responseList = cityListResponse.cityListData?.cities ?? [];

      bool isLastPage = responseList.length != PER_PAGE_SIZE;

      if (responseList.isEmpty) {
        emit(NoCityListFoundState());
      } else {
        emit(CityListSuccess(responseList, isLastPage, pageKey));
      }
    } else if (response is FailedResponse) {
      emit(NoCityListFoundState());
      emit(CityListError(response.errorMessage));
    }
  }
}
