import 'dart:developer';

import 'package:get_it/get_it.dart';

import '../../config/network/dio_config.dart';
import '../../config/network/network_constants.dart';
import '../../config/utils.dart';
import '../model/base/base_model.dart';
import '../model/country_list_model.dart';
import '../model/notification/notification_request_model.dart';
import '../model/notification/notification_response_model.dart';

abstract class NotificationRepository {
  Future<ResponseBaseModel> getNotificationByPage(
      {required NotificationRequestModel requestModel});

  Future<ResponseBaseModel> readNotification(String notificationId);

  Future<ResponseBaseModel> saveFCMToken(String token);
}

class NotificationRepositoryImpl extends NotificationRepository {
  @override
  Future<ResponseBaseModel> getNotificationByPage(
      {required NotificationRequestModel requestModel}) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().postBaseAPIWithToken(
        url: NetworkAPIs.kNotifications,
        data: requestModel.toJson(),
      );
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          NotificationResponseModel countryListResponseModel =
              NotificationResponseModel.fromJson(response.data);
          return SuccessResponse(data: countryListResponseModel);
        } else {
          return FailedResponse(errorMessage: response.data.toString());
        }
      } else {
        return FailedResponse(errorMessage: response.statusMessage ?? "");
      }
    } else {
      return FailedResponse(errorMessage: "No internet connected!");
    }
  }

  @override
  Future<ResponseBaseModel> readNotification(String notificationId) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().postBaseAPIWithToken(
        url: NetworkAPIs.kReadNotification,
        data: {'notificationId': notificationId},
      );
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          CountryListResponseModel countryListResponseModel =
              CountryListResponseModel.fromJson(response.data);
          return SuccessResponse(data: countryListResponseModel);
        } else {
          return FailedResponse(errorMessage: response.data.toString());
        }
      } else {
        return FailedResponse(errorMessage: response.statusMessage ?? "");
      }
    } else {
      return FailedResponse(errorMessage: "No internet connected!");
    }
  }

  @override
  Future<ResponseBaseModel> saveFCMToken(String token) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().putBaseAPIWithToken2(
        url: NetworkAPIs.kUpdateFCMToken,
        data: {'FCMMobileToken': token},
      );
      log("response ${response.data}");
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          CountryListResponseModel countryListResponseModel =
              CountryListResponseModel.fromJson(response.data);
          return SuccessResponse(data: countryListResponseModel);
        } else {
          return FailedResponse(errorMessage: response.data.toString());
        }
      } else {
        return FailedResponse(errorMessage: response.statusMessage ?? "");
      }
    } else {
      return FailedResponse(errorMessage: "No internet connected!");
    }
  }
}
