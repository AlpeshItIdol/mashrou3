import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mashrou3/app/db/app_preferences.dart';
import 'package:mashrou3/app/model/base/base_model.dart';
import 'package:mashrou3/app/model/property/add_finance_request_request_model.dart';
import 'package:mashrou3/app/model/property/add_finance_request_response_model.dart';
import 'package:mashrou3/app/model/verify_response.model.dart';
import 'package:mashrou3/app/repository/authentication_repository.dart';
import 'package:mashrou3/app/repository/bank_management_repository.dart';
import 'package:mashrou3/app/repository/offers_management_repository.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/vendor_finance/model/property_vendor_offer_response_model.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/vendor_finance/model/vendor_detail_response_model.dart';
import 'package:mashrou3/config/services/property_vendor_finance_service.dart';

import '../../../../../../../../config/utils.dart';
import '../../../../../../../model/offers/my_offers_list_response_model.dart';
import '../../../../../../../model/property/contact_now_model.dart';
import '../../../bank_details/cubit/bank_details_cubit.dart';

part 'vendor_detail_state.dart';

class VendorDetailCubit extends Cubit<VendorDetailState> {
  AuthenticationRepository repository;
  OffersManagementRepository offerRepository;
  BankManagementRepository bankManagementRepository;
  OfferData? selectedOffer;

  VendorDetailCubit({required this.repository, required this.offerRepository, required this.bankManagementRepository})
      : super(VendorDetailInitial());
  UserDetailsData detailData = UserDetailsData();
  var selectedLanguage = 'en';
  var selectedPropertyId = '';
  List<OfferData>? offerDataList = [];

  List<ContactNowModel> contactNowOptions = [];

  var selectedUserId = "";
  var selectedUserRole = "";

  /// Get data initial data
  ///
  Future<void> getData(String? id, BuildContext context) async {
    selectedUserId = await GetIt.I<AppPreferences>().getUserID();
    selectedUserRole = await GetIt.I<AppPreferences>().getUserRole() ?? "";
    offerDataList = [];
    contactNowOptions = [];
    detailData = UserDetailsData();
    selectedLanguage = await GetIt.I<AppPreferences>().getLanguageCode() ?? 'en';
    selectedPropertyId = GetIt.I<PropertyVendorFinanceService>().data.propertyId ?? "";

    if (!context.mounted) return;
    contactNowOptions = await Utils.getContactNowList(context);

    if (id != null && id.isNotEmpty) {
      await getVendorOffers(vendorId: id, propertyId: selectedPropertyId, context: context);
      await getVendorDetails(userId: id);
      emit(VendorDetailLoaded());
    }
  }

  /// Details API
  Future<void> getVendorDetails({
    required String userId,
  }) async {
    emit(VendorDetailLoading());

    final response = await repository.userDetails(userId: userId);

    if (response is SuccessResponse && response.data is VendorDetailResponseModel) {
      VendorDetailResponseModel responseModel = response.data as VendorDetailResponseModel;
      detailData = responseModel.data ?? UserDetailsData();
      detailData.offerData = offerDataList;
      emit(VendorDetailSuccess(model: responseModel.data ?? UserDetailsData()));
    } else if (response is FailedResponse) {
      emit(VendorDetailFailure(response.errorMessage));
    }
  }

  Future<void> getVendorOffers({
    required String vendorId,
    required String propertyId,
    required BuildContext context,
  }) async {
    emit(VendorOffersLoading());

    final response = await offerRepository.getOfferByVendorPropertyId(vendorId: vendorId, propertyId: propertyId);

    if (response is SuccessResponse && response.data is PropertyVendorOfferResponseModel) {
      PropertyVendorOfferResponseModel responseModel = response.data as PropertyVendorOfferResponseModel;
      offerDataList = responseModel.data ?? [];
      if (offerDataList != null && offerDataList!.isNotEmpty) {
        selectedOffer = offerDataList![0];

        BankDetailsCubit bankDetailsCubit = context.read<BankDetailsCubit>();
        bankDetailsCubit.offerId = selectedOffer?.sId ?? "";
      }
      emit(VendorOffersSuccess(offerList: responseModel.data ?? []));
    } else if (response is FailedResponse) {
      emit(VendorOffersFailure(response.errorMessage));
    }
  }

  /// Send Finance Request API
  ///
  Future<void> sendFinanceRequest({
    required String propertyId,
    required String vendorId,
    required String offerId,
  }) async {
    emit(FinanceRequestLoading());

    final requestModel = AddFinanceRequestRequestModel(propertyId: propertyId, vendorId: vendorId, offerId: offerId);

    final response = await bankManagementRepository.addFinanceRequest(requestModel: requestModel);

    if (response is SuccessResponse && response.data is AddFinanceRequestResponseModel) {
      AddFinanceRequestResponseModel responseModel = response.data as AddFinanceRequestResponseModel;
      GetIt.I<PropertyVendorFinanceService>().clearData();
      emit(FinanceRequestSuccess(responseModel.message ?? ""));
    } else if (response is FailedResponse) {
      emit(FinanceRequestFailure(response.errorMessage));
    }
  }

  void selectOffer(BuildContext context, OfferData offer) {
    emit(VendorOfferSelectionReset()); // Emit a different state first
    selectedOffer = offer;
    BankDetailsCubit bankDetailsCubit = context.read<BankDetailsCubit>();
    bankDetailsCubit.offerId = selectedOffer?.sId ?? "";

    emit(VendorOfferSelectionChanged()); // Ensure UI updates
  }
}
