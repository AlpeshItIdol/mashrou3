import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:mashrou3/app/model/base/base_model.dart';
import 'package:mashrou3/app/repository/property_repository.dart';

import '../../../../../../../config/resources/app_constants.dart';
import '../../../../../../../config/resources/app_strings.dart';
import '../../../../../../../config/utils.dart';
import '../../../../../../../utils/app_localization.dart';
import '../../../../../../../utils/ui_components.dart';
import '../../../../../../db/app_preferences.dart';
import '../../../../../../model/property/send_visit_request_request_model.dart';
import '../../../../../../model/property/send_visit_request_response_model.dart';
import '../../../../../../model/verify_response.model.dart';

part 'visit_request_state.dart';

class VisitRequestCubit extends Cubit<VisitRequestState> {
  PropertyRepository repository;

  VisitRequestCubit({required this.repository}) : super(VisitRequestInitial());

  final formKey = GlobalKey<FormState>();

  TextEditingController dateCtl = TextEditingController();
  TextEditingController timeCtl = TextEditingController();
  TextEditingController noteCtl = TextEditingController();
  FocusNode noteFn = FocusNode();

  String userName = "";
  String userRoleType = AppStrings.visitor;
  VerifyResponseData? userSavedData;

  var selectedDate = "";
  var selectedTime = "";
  var selectedTimeForVisit = TimeOfDay.now();
  var selectedDateForVisit = DateTime.now();

  List<String> searchHistory = [];

  /// Get data from shared preference
  ///
  Future<void> getData(BuildContext context) async {
    selectedTime = "";
    selectedTimeForVisit = TimeOfDay.now();

    timeCtl.clear();
    noteCtl.clear();
    dateCtl.clear();
    dateCtl = TextEditingController(
        text: UIComponent.formatDate(
            DateTime.now().toString(), AppConstants.dateFormatDdMMYyyy));
    selectedDate = dateCtl.text;
    userSavedData = await GetIt.I<AppPreferences>().getUserDetails() ??
        VerifyResponseData();
  }

  /// Send Visit Request API
  Future<void> sendVisitRequest({
    required String propertyId,
  }) async {
    emit(VisitRequestLoading());

    String visitDate = selectedDate;
    String visitTime = selectedTime;
    visitTime = visitTime.replaceAll("ص", "AM").replaceAll("م", "PM");
    DateTime parsedDate = DateFormat("dd/MM/yyyy").parse(visitDate);
    DateTime parsedTime = DateFormat("h:mm a").parse(visitTime);
    String formattedDate = DateFormat("yyyy-MM-dd").format(parsedDate);
    String formattedTime = DateFormat("HH:mm").format(parsedTime);

    // Pass formatted values to the request model
    final requestModel = SendVisitRequestRequestModel(
        propertyId: propertyId,
        visitDate: formattedDate,
        visitTime: formattedTime,
        note: noteCtl.text);

    final response =
        await repository.sendVisitRequest(requestModel: requestModel);

    if (response is SuccessResponse &&
        response.data is SendVisitRequestResponseModel) {
      SendVisitRequestResponseModel apiResponse =
          response.data as SendVisitRequestResponseModel;

      emit(VisitRequestSuccess(model: apiResponse));
    } else if (response is FailedResponse) {
      emit(VisitRequestError(errorMessage: response.errorMessage));
    }
  }

  void updateSelectedDate(String date) {
    selectedDate = date;
    dateCtl.text = date;
    emit(VisitRequestDateState(selectedDate: dateCtl.text));
  }

  /// Method Validation
  ///
  bool validate(BuildContext context) {
    if (selectedDate.isEmpty) {
      Utils.showErrorMessage(
          context: context, message: appStrings(context).dateEmptyError);
      return false;
    }

    if (selectedTime.isEmpty) {
      Utils.showErrorMessage(
          context: context, message: appStrings(context).timeEmptyError);
      return false;
    }
    return true;
  }

  bool validateDateTime({
    required BuildContext context,
    required String visitDate,
    required String visitTime,
  }) {
    // Current DateTime
    DateTime now = DateTime.now();

    visitTime = visitTime.replaceAll("ص", "AM").replaceAll("م", "PM");
    DateTime parsedDate = DateFormat("dd/MM/yyyy").parse(visitDate);
    DateTime parsedTime = DateFormat("h:mm a").parse(visitTime);

    // Combine the parsed date with the parsed time
    DateTime combinedDateTime = DateTime(
      parsedDate.year,
      parsedDate.month,
      parsedDate.day,
      parsedTime.hour,
      parsedTime.minute,
    );

    if (combinedDateTime.isBefore(now)) {
      Utils.snackBar(
        context: context,
        message: appStrings(context).timeInPastError,
      );
      return false;
    }

    return true;
  }
}
