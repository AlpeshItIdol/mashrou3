import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:mashrou3/app/repository/offers_management_repository.dart';
import '../../../../../../model/base/base_model.dart';
import '../model/price_calculations_request.model.dart';
import '../model/price_calculations_response_model.dart';

part 'offer_pricing_state.dart';

class OfferPricingCubit extends Cubit<OfferPricingState> {
  OffersManagementRepository repository;

  OfferPricingCubit({required this.repository}) : super(OfferPricingInitial());

  String? selectedOfferType; // "lifetime" or "timed"
  DateTime? startDate;
  DateTime? endDate;
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  void setOfferType(String? type) {
    selectedOfferType = type;
    if (type == "lifetime") {
      // Clear dates when lifetime is selected
      startDate = null;
      endDate = null;
      startDateController.clear();
      endDateController.clear();
    }
    emit(OfferPricingTypeChanged(selectedOfferType));
  }

  void setStartDate(DateTime date) {
    startDate = date;
    startDateController.text = DateFormat('yyyy-MM-dd').format(date);
    emit(OfferPricingDateChanged());
  }

  void setEndDate(DateTime date) {
    endDate = date;
    endDateController.text = DateFormat('yyyy-MM-dd').format(date);
    emit(OfferPricingDateChanged());
  }

  Future<void> getPriceCalculations({
    required List<String> propertyIds,
    bool isAllProperty = false,
  }) async {
    emit(OfferPricingLoading());

    if (selectedOfferType == null) {
      emit(OfferPricingError(errorMessage: "Please select an offer type"));
      return;
    }

    if (selectedOfferType == "timed") {
      if (startDate == null || endDate == null) {
        emit(OfferPricingError(errorMessage: "Please select both start and end dates"));
        return;
      }
      if (endDate!.isBefore(startDate!)) {
        emit(OfferPricingError(errorMessage: "End date must be after start date"));
        return;
      }
    }

    final requestModel = PriceCalculationsRequestModel(
      offerType: selectedOfferType,
      type: "vendor",
      isAllProperty: isAllProperty,
      propertyIds: isAllProperty ? null : propertyIds, // Don't send propertyIds when isAllProperty is true
      startDate: selectedOfferType == "timed" ? DateFormat('yyyy-MM-dd').format(startDate!) : null,
      endDate: selectedOfferType == "timed" ? DateFormat('yyyy-MM-dd').format(endDate!) : null,
    );

    final response = await repository.getPriceCalculations(
      requestModel: requestModel,
    );

    if (response is SuccessResponse && response.data is PriceCalculationsResponseModel) {
      PriceCalculationsResponseModel responseModel = response.data as PriceCalculationsResponseModel;
      emit(OfferPricingSuccess(model: responseModel));
    } else if (response is FailedResponse) {
      emit(OfferPricingError(errorMessage: response.errorMessage));
    }
  }

  @override
  Future<void> close() {
    startDateController.dispose();
    endDateController.dispose();
    return super.close();
  }

  void updateItemsPerPage(String newItemsPerPage) {
    selectedOfferType = newItemsPerPage;
    emit(state);
  }


}

