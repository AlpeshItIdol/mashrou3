import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mashrou3/app/repository/authentication_repository.dart';

import '../../../../../config/resources/app_strings.dart';
import '../../../../db/app_preferences.dart';
import '../../../../model/base/base_model.dart';
import '../../../../model/common_only_message_response_model.dart';
import '../../../../model/property/add_to_fav_request_model.dart';
import '../../../../model/property/property_list_data_request_model.dart';
import '../../../../model/property/property_list_response_model.dart';
import '../../../../model/verify_response.model.dart';
import '../../../../repository/property_repository.dart';
import '../../../owner_screens/dashboard/sub_screens/home/cubit/owner_home_cubit.dart';
import '../../dashboard/sub_screens/home/cubit/home_cubit.dart' hide PropertyListLoading;
import '../../filter/model/filter_request_model.dart';
import '../../property_details/sub_screens/vendor_finance/model/vendor_detail_response_model.dart';

part 'profile_detail_state.dart';

class ProfileDetailCubit extends Cubit<ProfileDetailState> {
  ProfileDetailCubit({required this.repository, required this.propertyRepository})
      : super(ProfileDetailInitial());
  AuthenticationRepository repository;
  PropertyRepository propertyRepository;

  var selectedUserId = "";
  var selectedRole = "";
  var isBankRole = false;

  UserDetailsData detailData = UserDetailsData();

  VerifyResponseData? userSavedData;
  List<dynamic> profilePictureList = [];
  List<String> certificatesList = [];
  List<String> portfolioList = [];
  List<String> httpCertificatesList = [];
  List<String> httpPortfolioList = [];

  Future<void> getData(BuildContext context, {String? userId}) async {
    profilePictureList.clear();
    certificatesList.clear();
    userSavedData = VerifyResponseData();
    userSavedData = await GetIt.I<AppPreferences>().getUserDetails() ??
        VerifyResponseData();

    selectedUserId = await GetIt.I<AppPreferences>().getUserID();
    selectedRole = await GetIt.I<AppPreferences>().getUserRole() ?? "";
    Future.delayed(const Duration(milliseconds: 300), () async {
      await getProfileDetails(userId: userId ?? "");

      if (!context.mounted) return;
      profilePictureList = [detailData.companyLogo ?? ""];
      certificatesList.addAll(detailData.identityVerificationDoc ?? []);
    });
    emit(UserDetailsLoadedForProfileDetail());
  }

  Future<void> updateData() async {
    emit(UpdatedUserDetailsLoading());

    userSavedData = await GetIt.I<AppPreferences>().getUserDetails() ??
        VerifyResponseData();

    profilePictureList = [detailData.companyLogo ?? ""];
    emit(UpdatedUserDetailsLoaded());
  }

  void setEditData(BuildContext context) {
    profilePictureList.clear();
    certificatesList.clear();
    portfolioList.clear();
    if (userSavedData != null && userSavedData?.users != null) {
      httpCertificatesList.clear();
      httpPortfolioList.clear();

      httpCertificatesList.addAll(detailData.identityVerificationDoc ?? []);
      httpPortfolioList.addAll(detailData.portfolio ?? []);

      profilePictureList = [detailData.companyLogo ?? ""];
      certificatesList.addAll(detailData.identityVerificationDoc ?? []);
      if (selectedRole == AppStrings.vendor) {
        portfolioList.addAll(detailData.portfolio ?? []);
      }
    }
  }

  /// Details API
  Future<void> getProfileDetails({
    required String userId,
  }) async {
    emit(ProfileDetailLoading());

    final response = await repository.userDetails(userId: userId);

    if (response is SuccessResponse &&
        response.data is VendorDetailResponseModel) {
      VendorDetailResponseModel responseModel =
          response.data as VendorDetailResponseModel;
      detailData = responseModel.data ?? UserDetailsData();
      isBankRole = detailData.userType == "bank_admin";

      // detailData.offerData = offerDataList;
      emit(ProfileDetailSuccess(
          model: responseModel.data ?? UserDetailsData()));
    } else if (response is FailedResponse) {
      emit(ProfileDetailError(errorMessage: response.errorMessage));
    }
  }


  /// Property list API
  Future<void> getPropertyList({
    required String userId,
    int pageKey = 1,
  }) async {
    emit(PropertyListLoading());

    final requestModel = PropertyListDataRequestModel(
      page: pageKey,
      itemsPerPage: 10,
      sortField: "createdAt",
      sortOrder: "desc",
      search: "",
      myFavorite: false,
      userId: userId,
      filter: FilterRequestModel(isSoldOut: "false"),
      skipLogin: false,
    );

    final response = await propertyRepository.getPropertyList(requestModel: requestModel);

    if (response is SuccessResponse && response.data is PropertyListResponseModel) {
      PropertyListResponseModel propertyListResponse = response.data as PropertyListResponseModel;
      var responseList = <PropertyData>[];
      responseList = propertyListResponse.data?.propertyData ?? [];
      int totalPage = propertyListResponse.data?.pageCount ?? 1;
      bool isLastPage = pageKey >= totalPage;

      if (responseList.isEmpty) {
        emit(NoPropertyFoundState());
      } else {
        emit(PropertyListSuccess(isLastPage, pageKey, responseList));
      }
    } else if (response is FailedResponse) {
      emit(PropertyListError(errorMessage: response.errorMessage));
    }
  }

  /// Add To Fav Property API
  Future<void> addRemoveFavorite({
    required String propertyId,
    required bool isFav,
  }) async {
    final requestModel = AddRemoveFavRequestModel(
      isFavorite: isFav,
      propertyId: propertyId,
    );

    final response = await propertyRepository.addRemoveFavorite(requestModel: requestModel);

    if (response is SuccessResponse && response.data is CommonOnlyMessageResponseModel) {
      CommonOnlyMessageResponseModel addToFavResponse = response.data as CommonOnlyMessageResponseModel;
      emit(AddedToFavorite(addToFavResponse.message ?? ""));
    } else if (response is FailedResponse) {
      emit(PropertyAddFavError(errorMessage: response.errorMessage));
    }
  }
}
