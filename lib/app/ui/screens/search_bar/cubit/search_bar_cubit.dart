import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mashrou3/app/repository/property_repository.dart';

import '../../../../db/app_preferences.dart';

part 'search_bar_state.dart';

class SearchBarCubit extends Cubit<SearchBarState> {
  PropertyRepository repository;

  SearchBarCubit({required this.repository}) : super(SearchBarInitial());

  final searchFormKey = GlobalKey<FormState>();

  final TextEditingController searchCtl = TextEditingController();

  bool showSuffixIcon = false;

  List<String> searchHistory = [];

  /// Get data from shared preference
  ///
  Future<void> getData(BuildContext context, String? searchText) async {
    searchCtl.text = searchText ?? "";

    if (searchCtl.text != "") {
      showSuffixIcon = true;
      showHideSuffix(showSuffixIcon);
    } else {
      showSuffixIcon = false;
      showHideSuffix(showSuffixIcon);
    }
    await getSearchData();
  }

  Future<void> getSearchData() async {
    emit(SearchBarLoading());
    searchHistory = await GetIt.I<AppPreferences>().getSearchHistory();
    emit(GetSearchUpdate());
  }

  Future<void> saveSearchHistory(String searchTerm) async {
    emit(SearchInit());

    if (searchHistory.isNotEmpty) {
      if (!searchHistory.contains(searchTerm)) {
        await GetIt.I<AppPreferences>()
            .saveSearchHistory(searchTerm: searchTerm);
        searchHistory.add(searchTerm);
        await GetIt.I<AppPreferences>().saveSearchHistoryList(searchHistory);
      }
    } else {
      searchHistory.add(searchTerm);
      await GetIt.I<AppPreferences>().saveSearchHistoryList(searchHistory);
    }

    emit(SetSearchUpdate());
  }

  void showHideSuffix(bool showBool) {
    emit(SuffixBoolChangedStateInitial());
    emit(SuffixBoolChangedState(showBool: showSuffixIcon));
  }

  /// Remove a specific search term
  Future<void> removeSearchTerm(String searchTerm) async {
    emit(SearchInit());

    if (searchHistory.contains(searchTerm)) {
      searchHistory.remove(searchTerm);
      await GetIt.I<AppPreferences>().saveSearchHistoryList(searchHistory);
      emit(SetSearchUpdate());
    }
  }
}
