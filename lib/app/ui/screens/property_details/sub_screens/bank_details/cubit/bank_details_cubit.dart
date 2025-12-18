import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashrou3/app/model/property/add_finance_request_request_model.dart';

import '../../../../../../../config/utils.dart';
import '../../../../../../model/base/base_model.dart';
import '../../../../../../model/property/add_finance_request_response_model.dart';
import '../../../../../../model/property/bank_view_count_request_model.dart';
import '../../../../../../model/property/bank_view_count_response_model.dart';
import '../../../../../../model/property/contact_now_model.dart';
import '../../../../../../repository/bank_management_repository.dart';
import '../model/bank_details_response_model.dart';
import '../model/bank_property_offers_response_model.dart';

part 'bank_details_state.dart';

class BankDetailsCubit extends Cubit<BankDetailsState> {
  BankManagementRepository repository;

  BankDetailsCubit({required this.repository}) : super(BankDetailsInitial());

  final searchFormKey = GlobalKey<FormState>();

  final TextEditingController searchCtl = TextEditingController();

  var bankDetails = BankDetailsData();
  var sid = "";
  var isForVendor = false;
  String? offerId = "";

  bool isSelected = false;
  bool hasShownSkeleton = false;

  List<ContactNowModel> contactNowOptions = [];
  List<BankPropertyOffersData>? offers = [];

  /// Get data from shared preference
  ///
  Future<void> getData(BuildContext context, String propertyId,String vendorId, String bankId, bool isVendor) async {
    isSelected = false;
    hasShownSkeleton = false;
    isForVendor = isVendor;
    offers?.clear();
    await getBankViewCount(bankId: bankId);
    if(isVendor) {
      // Get vendor bank property offers
      await getVendorBankPropertyOffers(vendorId: vendorId, bankId: bankId, context: context);
    } else {
      await getBankPropertyOffers(propertyId: propertyId, bankId: bankId, context: context);
    }
    if (!context.mounted) return;
    await getBankDetails(context: context, bankId: bankId);
    if (!context.mounted) return;
    contactNowOptions = await Utils.getContactNowList(context);
    emit(GetSearchUpdate());
  }

  /// Bank view count API
  ///
  Future<void> getBankViewCount({
    required String bankId,
  }) async {
    emit(BankDetailsLoading());

    final requestModel = BankViewCountRequestModel(
      bankId: bankId,
    );

    final response = await repository.getBankViewCount(requestModel: requestModel);

    if (response is SuccessResponse && response.data is BankViewCountResponseModel) {
      BankViewCountResponseModel responseModel = response.data as BankViewCountResponseModel;

      emit(BankViewCountSuccess());
    } else if (response is FailedResponse) {
      emit(BankDetailsError(response.errorMessage));
    }
  }

  /// Bank Details API
  ///
  Future<void> getBankDetails({
    required String bankId,
    required BuildContext context,
  }) async {
    emit(BankDetailsLoading());

    final response = await repository.getBankDetails(bankId: bankId);

    hasShownSkeleton = true;

    if (response is SuccessResponse && response.data is BankDetailsResponseModel) {
      BankDetailsResponseModel responseModel = response.data as BankDetailsResponseModel;

      bankDetails = responseModel.data ?? BankDetailsData();
      bankDetails.offersList ??= [];

      bankDetails.offersList?.addAll(offers ?? []);

      printf(bankDetails);
      if (!context.mounted) return;

      emit(BankDetailsSuccess(model: responseModel ?? BankDetailsResponseModel()));
    } else if (response is FailedResponse) {
      emit(BankDetailsError(response.errorMessage));
    }
  }

  /// Send Finance Request API
  ///
  Future<void> sendFinanceRequest({
    required String propertyId,
    required String bankId,
    required BuildContext context,
  }) async {
    emit(BankDetailsLoading());
    print("offerId $offerId");

    // Pass formatted values to the request model
    final requestModel = AddFinanceRequestRequestModel(
        propertyId: propertyId, bankId: bankId, );

    final response = await repository.addFinanceRequest(requestModel: requestModel);

    if (response is SuccessResponse && response.data is AddFinanceRequestResponseModel) {
      offerId = "";
      AddFinanceRequestResponseModel responseModel = response.data as AddFinanceRequestResponseModel;

      emit(AddFinanceRequestSuccess(model: responseModel ?? AddFinanceRequestResponseModel()));
    } else if (response is FailedResponse) {
      emit(BankDetailsError(response.errorMessage));
    }
  }

  /// Send Finance Request API
  ///
  Future<void> getBankPropertyOffers({
    required String propertyId,
    required String bankId,
    required BuildContext context,
  }) async {
    emit(BankDetailsLoading());

    // Pass formatted values to the request model
    final requestModel = AddFinanceRequestRequestModel(
      propertyId: propertyId,
      bankId: bankId,
    );

    final response = await repository.bankPropertyOffers(requestModel: requestModel);

    if (response is SuccessResponse && response.data is BankPropertyOffersResponseModel) {
      BankPropertyOffersResponseModel responseModel = response.data as BankPropertyOffersResponseModel;

      offers?.addAll(responseModel.data ?? []);

      emit(BankPropertyOffersSuccess(model: responseModel ?? BankPropertyOffersResponseModel()));
    } else if (response is FailedResponse) {
      emit(BankDetailsError(response.errorMessage));
    }
  }

  /// Send Finance Request API
  ///
  Future<void> getVendorBankPropertyOffers({
    required String vendorId,
    required String bankId,
    required BuildContext context,
  }) async {
    emit(BankDetailsLoading());

    // Pass formatted values to the request model
    final requestModel = AddFinanceRequestRequestModel(
      vendorId: vendorId,
      bankId: bankId,
    );

    final response = await repository.vendorBankPropertyOffers(requestModel: requestModel);

    if (response is SuccessResponse && response.data is BankPropertyOffersResponseModel) {
      BankPropertyOffersResponseModel responseModel = response.data as BankPropertyOffersResponseModel;

      offers?.addAll(responseModel.data ?? []);

      emit(BankPropertyOffersSuccess(model: responseModel ?? BankPropertyOffersResponseModel()));
    } else if (response is FailedResponse) {
      emit(BankDetailsError(response.errorMessage));
    }
  }
}
