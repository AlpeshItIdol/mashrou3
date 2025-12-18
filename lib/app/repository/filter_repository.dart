import 'package:get_it/get_it.dart';
import 'package:mashrou3/app/ui/screens/filter/model/filter_status_list_response_model.dart';
import 'package:mashrou3/config/network/dio_config.dart';
import 'package:mashrou3/config/network/network_constants.dart';
import 'package:mashrou3/config/utils.dart';

import '../model/base/base_model.dart';

abstract class FilterRepository {
  Future<ResponseBaseModel> getFilterStatusList();
}

class FilterRepositoryImpl extends FilterRepository {
  @override
  Future<ResponseBaseModel> getFilterStatusList() async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>()
          .getBaseAPI(url: NetworkAPIs.kFilterStatusList);
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          FilterStatusListResponseModel filterStatusListResponseModel =
              FilterStatusListResponseModel.fromJson(response.data);
          return SuccessResponse(data: filterStatusListResponseModel);
        } else {
          return FailedResponse(errorMessage: response.statusMessage ?? "");
        }
      } else {
        return FailedResponse(errorMessage: response.statusMessage ?? "");
      }
    } else {
      return FailedResponse(errorMessage: "No internet connected!");
    }
  }
}
