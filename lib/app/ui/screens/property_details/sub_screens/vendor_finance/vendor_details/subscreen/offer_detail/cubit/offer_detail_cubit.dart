import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mashrou3/app/bloc/application_cubit.dart';
import 'package:mashrou3/app/model/base/base_model.dart';
import 'package:mashrou3/app/model/offers/my_offers_list_response_model.dart';
import 'package:mashrou3/app/repository/offers_management_repository.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/vendor_finance/model/offer_detail_data_response_model.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/vendor_finance/vendor_details/cubit/vendor_detail_cubit.dart';

import '../../../../../../../../../../config/resources/app_strings.dart';
import '../../../../../../../../../db/app_preferences.dart';
import '../../../../../../../../../model/verify_response.model.dart';
import '../../../../../../../../../repository/bank_management_repository.dart';
import '../../../../../banks_list/model/banks_list_response_model.dart';

part 'offer_detail_state.dart';

class OfferDetailCubit extends Cubit<OfferDetailState> {
  OffersManagementRepository offerRepository;

  OfferDetailCubit({required this.offerRepository})
      : super(OfferDetailInitial());
  var detailData = OfferData();
  VerifyResponseData? userSavedData;

  var selectedLanguage = 'en';

  var selectedRole = '';
  var companyLogo = "";
  bool isVendor = false;
  List<BankUser> banksForProperty = [];

  /// Get data initial data
  ///
  Future<void> getData(
      String id, String isDraftOffer, BuildContext context) async {
    userSavedData = await GetIt.I<AppPreferences>().getUserDetails() ??
        VerifyResponseData();
    selectedRole = await GetIt.I<AppPreferences>().getUserRole() ?? "";
    isVendor = selectedRole == AppStrings.vendor;

    if (isVendor) {
      companyLogo = userSavedData?.users?.companyLogo ?? "";
    } else {
      companyLogo =
          context.read<VendorDetailCubit>().detailData.companyLogo ?? "";
    }

    selectedLanguage =
        await GetIt.I<AppPreferences>().getLanguageCode() ?? 'en';
    bool isDraft = isDraftOffer.toLowerCase() == 'true';
    await getOfferDetailsById(id, isDraft);

    emit(OfferDetailLoaded());
  }

  Future<void> getOfferDetailsById(String id, bool isDraftOffer) async {
    // Validate offerId before making API call
    if (id.isEmpty) {
      emit(OfferDetailFailure("Offer ID is required but was not provided."));
      return;
    }
    
    emit(OfferDetailLoading());
    final response = await offerRepository.getOfferById(
        feedId: id, isDraftOffer: isDraftOffer);

    if (response is SuccessResponse && response.data is SingleOfferResponse) {
      SingleOfferResponse responseModel = response.data as SingleOfferResponse;
      detailData = responseModel.data ?? OfferData();
      emit(OfferDetailSuccess(model: responseModel.data ?? OfferData()));
    } else if (response is FailedResponse) {
      emit(OfferDetailFailure(response.errorMessage));
    }
  }

  /// Banks list API for property (getBankOfferList)
  Future<void> getBankOfferList({
    required String propertyId,
    int page = 1,
    int itemsPerPage = 10,
  }) async {
    emit(OfferDetailLoading());
    final Map<String, dynamic> queryParameters = {
      'page': page.toString(),
      'itemsPerPage': itemsPerPage.toString(),
      'sortOrder': 'desc',
      'sortField': 'createdAt',
      'propertyId': propertyId,
    };

    final response = await GetIt.I<BankManagementRepository>().getBanksList(
      queryParameters: queryParameters,
      searchText: "",
    );

    if (response is SuccessResponse && response.data is BanksListResponseModel) {
      final BanksListResponseModel data =
          response.data as BanksListResponseModel;
      banksForProperty = data.data?.bankUser ?? [];
      emit(OfferDetailBanksListSuccess(banks: banksForProperty));
    } else if (response is FailedResponse) {
      emit(OfferDetailFailure(response.errorMessage));
    } else {
      emit(OfferDetailFailure("Failed to fetch banks list."));
    }
  }

}
