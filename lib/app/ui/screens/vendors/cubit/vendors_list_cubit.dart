import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashrou3/app/model/base/base_model.dart';
import 'package:mashrou3/app/repository/vendors_repository.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/vendor_finance/model/vendor_category_list_response.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/vendor_finance/model/vendor_list_response_model.dart';
import 'package:mashrou3/app/ui/screens/vendors/model/vendors_sequence_response.dart';

part 'vendors_list_state.dart';

class VendorsListCubit extends Cubit<VendorsListState> {
  final VendorsRepository repository;
  VendorsListCubit({required this.repository}) : super(VendorsListInitial());

  static const int perPage = 10;
  static const int categoriesPerPage = 10;
  final TextEditingController searchCtl = TextEditingController();
  
  // For vendor categories
  List<VendorCategoryData> allCategories = [];
  int currentCategoryPage = 1;
  int totalCategoryPages = 1;
  bool isLoadingMoreCategories = false;
  String? selectedCategoryId; // null means "All" is selected
  bool categoriesLoaded = false;
  int selectedCategoryIndex = 0; // 0 means "All" is selected

  Future<void> fetchPage({required int page}) async {
    emit(VendorsListLoading());
    final response = await repository.getVendorsSequence(
      page: page,
      itemsPerPage: perPage,
      search: searchCtl.text.trim(),
      vendorCategory: selectedCategoryId,
    );

    if (response is SuccessResponse && response.data is VendorsSequenceResponse) {
      final model = response.data as VendorsSequenceResponse;
      final pageData = model.data;
      final users = (pageData?.users ?? []).map(_mapToVendorUserData).toList();
      final isLastPage = (pageData?.page ?? 1) >= (pageData?.pageCount ?? 1);
      if (users.isEmpty) {
        emit(VendorsListEmpty());
      } else {
        emit(VendorsListSuccess(
          isLastPage: isLastPage,
          currentKey: page,
          vendors: users,
          totalCount: pageData?.documentCount ?? users.length,
        ));
      }
    } else if (response is FailedResponse) {
      emit(VendorsListError(errorMessage: response.errorMessage));
    }
  }

  VendorSequenceUser _mapToVendorUserData(VendorSequenceUser user) {
    return VendorSequenceUser(
      id: user.id,
      firstName: user.firstName,
      lastName: user.lastName,
      contactNumber: user.contactNumber,
      phoneCode: user.phoneCode,
      email: user.email,
      userType: user.userType,
      isActive: user.isActive,
      profileComplete: user.profileComplete,
      createdAt: user.createdAt,
      companyLogo: user.companyLogo,
      companyName: user.companyName,
      fullName: user.fullName,
      country: user.country,
      vendorCategories: user.vendorCategories,
      portfolio: user.portfolio ?? [],
      identityVerificationDoc: user.identityVerificationDoc ?? [],
      location: user.location,
      city: user.city,
      companyDescription : user.companyDescription,
      socialMediaLinks : user.socialMediaLinks,
      connectedBank : user.connectedBank,
      alternativeContactNumbers : user.alternativeContactNumbers,
      sequence:user.sequence,

    );
  }

  // Fetch vendor categories with pagination
  Future<void> fetchVendorCategories({int page = 1, String? search}) async {
    if (page == 1) {
      if (!categoriesLoaded) {
        emit(VendorCategoriesLoading());
      }
      allCategories.clear();
      currentCategoryPage = 1;
    } else {
      isLoadingMoreCategories = true;
      // Re-emit current state with loading flag
      emit(VendorCategoriesSuccess(
        categories: List.from(allCategories),
        currentPage: currentCategoryPage,
        totalPages: totalCategoryPages,
        hasMorePages: true,
      ));
    }

    final response = await repository.getVendorCategories(
      page: page,
      itemsPerPage: categoriesPerPage,
      search: search,
      sortField: 'createdAt',
      sortOrder: 'desc',
    );

    if (response is SuccessResponse && response.data is VendorCategoryListResponse) {
      final model = response.data as VendorCategoryListResponse;
      final pageData = model.data;
      final categories = pageData?.vendorData ?? [];
      
      if (page == 1) {
        allCategories = categories;
      } else {
        allCategories.addAll(categories);
      }
      
      currentCategoryPage = pageData?.page ?? page;
      totalCategoryPages = pageData?.pageCount ?? 1;
      isLoadingMoreCategories = false;
      categoriesLoaded = true;

      if (allCategories.isEmpty) {
        emit(VendorCategoriesEmpty());
      } else {
        emit(VendorCategoriesSuccess(
          categories: List.from(allCategories),
          currentPage: currentCategoryPage,
          totalPages: totalCategoryPages,
          hasMorePages: currentCategoryPage < totalCategoryPages,
        ));
      }
    } else if (response is FailedResponse) {
      isLoadingMoreCategories = false;
      if (!categoriesLoaded) {
        emit(VendorCategoriesError(errorMessage: response.errorMessage));
      }
    }
  }

  // Load more categories for horizontal pagination
  Future<void> loadMoreCategories() async {
    if (!isLoadingMoreCategories && currentCategoryPage < totalCategoryPages) {
      await fetchVendorCategories(page: currentCategoryPage + 1);
    }
  }

  // Select category and refresh vendor list
  void selectCategory(String? categoryId, {int? index}) {
    selectedCategoryId = categoryId;
    if (index != null) {
      selectedCategoryIndex = index;
    }
    emit(VendorCategorySelected(categoryId: categoryId));
  }
  
  // Reset to "All" category
  void resetToAllCategories() {
    selectedCategoryId = null;
    selectedCategoryIndex = 0;
  }
}


