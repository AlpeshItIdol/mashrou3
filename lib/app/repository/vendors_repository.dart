import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:mashrou3/config/network/dio_config.dart';
import 'package:mashrou3/config/network/network_constants.dart';
import 'package:mashrou3/config/utils.dart';

import '../model/base/base_model.dart';
import '../ui/screens/property_details/sub_screens/vendor_finance/model/vendor_category_list_response.dart';
import '../ui/screens/vendors/model/vendors_sequence_response.dart';

abstract class VendorsRepository {
  Future<ResponseBaseModel> getVendorsSequence({
    required int page,
    required int itemsPerPage,
    String? search,
    String? vendorCategory,
  });

  Future<ResponseBaseModel> getVendorCategories({
    required int page,
    required int itemsPerPage,
    String? search,
    String sortField,
    String sortOrder,
  });
}

class VendorsRepositoryImpl extends VendorsRepository {
  @override
  Future<ResponseBaseModel> getVendorsSequence({
    required int page,
    required int itemsPerPage,
    String? search,
    String? vendorCategory,
  }) async {
    if (await Utils.isConnected()) {
      final payload = {
        NetworkParams.kPage: page,
        NetworkParams.kItemPerPage: itemsPerPage,
        if ((search ?? "").trim().isNotEmpty) "search": search!.trim(),
        if ((vendorCategory ?? "").trim().isNotEmpty) "vendorCategory": vendorCategory!.trim(),
      };
      debugPrint("payload"+payload.toString());
      final response = await GetIt.I<DioProvider>().postBaseAPIWithToken(
        url: NetworkAPIs.userVenderList,
        data: payload,
      );

      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          final model = VendorsSequenceResponse.fromJson(response.data);
          return SuccessResponse(data: model);
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

  @override
  Future<ResponseBaseModel> getVendorCategories({
    required int page,
    required int itemsPerPage,
    String? search,
    String sortField = 'createdAt',
    String sortOrder = 'desc',
  }) async {
    if (await Utils.isConnected()) {
      final payload = {
        NetworkParams.kPage: page,
        "search": search ?? "",
        NetworkParams.kSortField: sortField,
        NetworkParams.kSortOrder: sortOrder,
        NetworkParams.kItemPerPage: itemsPerPage,
        "pagination": true,
      };

      final response = await GetIt.I<DioProvider>().postBaseAPIWithToken(
        url: NetworkAPIs.userVenderListCategories,
        data: payload,
      );

      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          final model = VendorCategoryListResponse.fromJson(response.data);
          return SuccessResponse(data: model);
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


