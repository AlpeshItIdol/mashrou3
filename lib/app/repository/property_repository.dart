import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mashrou3/app/model/base/base_model.dart';
import 'package:mashrou3/app/model/base/base_request_model.dart';
import 'package:mashrou3/app/model/property/add_edit_property_response_model.dart';
import 'package:mashrou3/app/model/property/property_amenities_response_model.dart';
import 'package:mashrou3/app/model/property/property_category_response_model.dart';
import 'package:mashrou3/app/model/property/property_list_data_request_model.dart';
import 'package:mashrou3/app/model/property/property_list_response_model.dart';
import 'package:mashrou3/app/model/property/property_living_space_fields_response_model.dart';
import 'package:mashrou3/app/model/property/property_neighbourhood_response_model.dart';
import 'package:mashrou3/app/model/property/address_location_response_model.dart';
import 'package:mashrou3/app/navigation/routes.dart';
import 'package:mashrou3/app/ui/owner_screens/add_edit_property/model/category_item_data_response_model.dart';
import 'package:mashrou3/app/ui/owner_screens/add_edit_property/model/sub_category_response_model.dart';
import 'package:mashrou3/app/ui/screens/finance_request/model/finance_request_list_response.dart';
import 'package:mashrou3/app/ui/screens/ratings/model/add_rating_review_request_model.dart';
import 'package:mashrou3/app/ui/screens/ratings/model/add_rating_review_response_model.dart';
import 'package:mashrou3/app/ui/screens/ratings/model/review_list_request_model.dart';
import 'package:mashrou3/app/ui/screens/ratings/model/review_list_response_model.dart';
import 'package:mashrou3/config/network/dio_config.dart';
import 'package:mashrou3/config/network/network_constants.dart';
import 'package:mashrou3/config/utils.dart';
import 'package:mashrou3/utils/app_localization.dart';

import '../model/common_only_message_response_model.dart';
import '../model/offers/finance_request_details_model.dart';
import '../model/property/add_to_fav_request_model.dart';
import '../model/property/currency_list_response_model.dart';
import '../model/property/delete_property_in_review_request_model.dart';
import '../model/property/delete_property_request_model.dart';
import '../model/property/property_detail_request_model.dart';
import '../model/property/property_detail_response_model.dart';
import '../model/property/property_view_count_request_model.dart';
import '../model/property/property_view_count_response_model.dart';
import '../model/property/send_visit_request_request_model.dart';
import '../model/property/send_visit_request_response_model.dart';
import '../model/property/sold_out_property_request_model.dart';
import '../ui/owner_screens/dashboard/sub_screens/in_review/model/in_review_list_request_model.dart';
import '../ui/owner_screens/dashboard/sub_screens/in_review/model/in_review_list_response_model.dart';
import '../ui/owner_screens/visit_requests_list/model/visit_request_approve_request.model.dart';
import '../ui/owner_screens/visit_requests_list/model/visit_request_reject_request.model.dart';
import '../ui/owner_screens/visit_requests_list/model/visit_requests_list_request.model.dart';
import '../ui/owner_screens/visit_requests_list/model/visit_requests_list_response.model.dart';
import '../ui/screens/recently_visited_properties/model/properties_with_offers_response.model.dart';
import '../ui/screens/recently_visited_properties/model/recently_visited_response.model.dart';

abstract class PropertyRepository {
  Future<ResponseBaseModel> getPropertyCategories();

  Future<ResponseBaseModel> getPropertySubCategories(
      {required String categoryId});

  Future<ResponseBaseModel> getPropertyCategoryData(
      {required String categoryId});

  Future<ResponseBaseModel> getPropertyAmenities();

  Future<ResponseBaseModel> getPropertyNeighbourhood();
  Future<ResponseBaseModel> getAddressLocation({
    int page = 1,
    int limit = 100,
    String search = "",
    bool isAll = true,
  });

  Future<ResponseBaseModel> getPropertyList({
    required PropertyListDataRequestModel requestModel,
  });

  Future<ResponseBaseModel> getVisitRequestsList({
    required VisitRequestsListRequestModel requestModel,
  });

  Future<ResponseBaseModel> getRecentlyVisitedList({
    required VisitRequestsListRequestModel requestModel,
  });

  Future<ResponseBaseModel> getPropertiesWithOffersList({
    required VisitRequestsListRequestModel requestModel,
  });

  Future<ResponseBaseModel> getInReviewList({
    required InReviewListDataRequestModel requestModel,
  });

  Future<ResponseBaseModel> getPropertyLivingSpaceData({
    required String propertyCategoryId,
  });

  Future<ResponseBaseModel> getPropertyViewCount({
    required PropertyViewCountRequestModel requestModel,
  });

  Future<ResponseBaseModel> getFurnishedType();

  Future<ResponseBaseModel> getFinanceRequestListVisitor(
      Map<String, dynamic>? queryParameters);

  Future<ResponseBaseModel> deletePropertyInReview({
    required DeletePropertyInReviewRequestModel requestModel,
  });

  Future<ResponseBaseModel> deleteProperty({
    required DeletePropertyRequestModel requestModel,
  });

  Future<ResponseBaseModel> addRemoveFavorite({
    required AddRemoveFavRequestModel requestModel,
  });

  Future<ResponseBaseModel> approveVisitRequest({
    required VisitRequestApproveRequestModel requestModel,
  });

  Future<ResponseBaseModel> rejectVisitRequest({
    required VisitRequestRejectRequestModel requestModel,
  });

  Future<ResponseBaseModel> soldOutProperty({
    required SoldOutPropertyRequestModel requestModel,
  });

  Future<ResponseBaseModel> sendVisitRequest({
    required SendVisitRequestRequestModel requestModel,
  });

  Future<ResponseBaseModel> addProperty({required FormData data});

  Future<ResponseBaseModel> editProperty(
      {required FormData data, required String propertyId});

  Future<ResponseBaseModel> editPropertyInReview(
      {required FormData data, required String propertyId});

  Future<ResponseBaseModel> getReviewPropertyDetails(
      {required String propertyId});

  Future<ResponseBaseModel> getPropertyDetails(
      {required String propertyId,
      required BuildContext context,
      bool isGuest = false,
      bool isVendor = false});

  Future<ResponseBaseModel> getReviews({
    required ReviewListRequestModel requestModel,
  });

  Future<ResponseBaseModel> addRatingReview({
    required AddRatingReviewRequestModel requestModel,
  });

  Future<ResponseBaseModel> getCurrencyList();

  Future<ResponseBaseModel> getFinanceRequestDetails({
    required String requestId,
    required BuildContext context
  });
}

class PropertyRepositoryImpl extends PropertyRepository {
  @override
  Future<ResponseBaseModel> getPropertyCategories() async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().postBaseAPIWithToken(
          url: NetworkAPIs.kPropertyCategories, data: {"pagination": false});
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          PropertyCategoryResponseModel propertyCategoryResponseModel =
              PropertyCategoryResponseModel.fromJson(response.data);
          return SuccessResponse(data: propertyCategoryResponseModel);
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
  Future<ResponseBaseModel> getPropertyCategoryData(
      {required String categoryId}) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().postBaseAPIWithToken(
          url: NetworkAPIs.kPropertyCategoryData,
          data: {NetworkParams.kCategoryId: categoryId});
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          CategoryItemDataResponseModel categoryItemDataResponseModel =
              CategoryItemDataResponseModel.fromJson(response.data);
          return SuccessResponse(data: categoryItemDataResponseModel);
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
  Future<ResponseBaseModel> getPropertySubCategories(
      {required String categoryId}) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().postBaseAPIWithToken(
          url: NetworkAPIs.kPropertySubCategories,
          data: {NetworkParams.kCategoryId: categoryId});
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          SubCategoryResponseModel subCategoryResponseModel =
              SubCategoryResponseModel.fromJson(response.data);
          return SuccessResponse(data: subCategoryResponseModel);
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
  Future<ResponseBaseModel> getPropertyAmenities() async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().postBaseAPI(
          url: NetworkAPIs.kPropertyAmenities,
          data: BaseRequestModel(
                  pagination: false, sortField: "createdAt", sortOrder: "desc")
              .toJson());
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          PropertyAmenitiesResponseModel propertyAmenitiesResponseModel =
              PropertyAmenitiesResponseModel.fromJson(response.data);
          return SuccessResponse(data: propertyAmenitiesResponseModel);
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
  Future<ResponseBaseModel> getPropertyNeighbourhood() async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().postBaseAPI(
        url: NetworkAPIs.kPropertyNeighbourhood,
      );
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          PropertyNeighbourhoodResponseModel
              propertyNeighbourhoodResponseModel =
              PropertyNeighbourhoodResponseModel.fromJson(response.data);
          return SuccessResponse(data: propertyNeighbourhoodResponseModel);
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
  Future<ResponseBaseModel> getAddressLocation({
    int page = 1,
    int limit = 100,
    String search = "",
    bool isAll = true,
  }) async {
    if (await Utils.isConnected()) {
      final requestData = {
        'page': page,
        'limit': limit,
        'search': search,
        'isAll': isAll,
      };
      final response = await GetIt.I<DioProvider>().postBaseAPIWithToken(
        url: NetworkAPIs.kAddressLocation,
        data: requestData,
      );
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          AddressLocationResponseModel addressLocationResponseModel =
              AddressLocationResponseModel.fromJson(response.data);
          return SuccessResponse(data: addressLocationResponseModel);
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
  Future<ResponseBaseModel> getPropertyList({
    required PropertyListDataRequestModel requestModel,
  }) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().postBaseAPIWithToken(
        url: NetworkAPIs.kPropertyList,
        data: requestModel.toJson(),
      );
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          PropertyListResponseModel responseModel =
              PropertyListResponseModel.fromJson(response.data);
          return SuccessResponse(data: responseModel);
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
  Future<ResponseBaseModel> getVisitRequestsList({
    required VisitRequestsListRequestModel requestModel,
  }) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().postBaseAPIWithToken(
        url: NetworkAPIs.kVisitRequestsList,
        data: requestModel.toJson(),
      );
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          VisitRequestsListResponseModel responseModel =
              VisitRequestsListResponseModel.fromJson(response.data);
          return SuccessResponse(data: responseModel);
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
  Future<ResponseBaseModel> getRecentlyVisitedList({
    required VisitRequestsListRequestModel requestModel,
  }) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().postBaseAPIWithToken(
        url: NetworkAPIs.kRecentVisitList,
        data: requestModel.toJson(),
      );
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          RecentlyVisitedListResponseModel responseModel =
              RecentlyVisitedListResponseModel.fromJson(response.data);
          return SuccessResponse(data: responseModel);
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
  Future<ResponseBaseModel> getPropertiesWithOffersList({
    required VisitRequestsListRequestModel requestModel,
  }) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().postBaseAPIWithToken(
        url: NetworkAPIs.kPropertiesWithOffersList,
        data: requestModel.toJson(),
      );
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          PropertiesWithOffersListResponseModel responseModel =
              PropertiesWithOffersListResponseModel.fromJson(response.data);
          return SuccessResponse(data: responseModel);
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
  Future<ResponseBaseModel> getInReviewList({
    required InReviewListDataRequestModel requestModel,
  }) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().postBaseAPIWithToken(
        url: NetworkAPIs.kInReviewList,
        data: requestModel.toJson(),
      );
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          InReviewListResponseModel responseModel =
              InReviewListResponseModel.fromJson(response.data);
          return SuccessResponse(data: responseModel);
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
  Future<ResponseBaseModel> getPropertyLivingSpaceData({
    required String propertyCategoryId,
  }) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().postBaseAPI(
          url: NetworkAPIs.kPropertyLivingSpace,
          data: {NetworkParams.kCategoryId: propertyCategoryId});
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          PropertyLivingSpaceFieldsResponseModel
              propertyLivingSpaceFieldsResponseModel =
              PropertyLivingSpaceFieldsResponseModel.fromJson(response.data);
          return SuccessResponse(data: propertyLivingSpaceFieldsResponseModel);
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
  Future<ResponseBaseModel> getPropertyViewCount({
    required PropertyViewCountRequestModel requestModel,
  }) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().postBaseAPI(
        url: NetworkAPIs.kPropertyViewCount,
        data: requestModel.toJson(),
      );
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          PropertyViewCountResponseModel responseModel =
              PropertyViewCountResponseModel.fromJson(response.data);
          return SuccessResponse(data: responseModel);
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
  Future<ResponseBaseModel> addProperty({required FormData data}) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().postBaseAPIWithToken(
        url: NetworkAPIs.kAddProperty,
        data: data,
      );
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          AddEditPropertyResponseModel responseModel =
              AddEditPropertyResponseModel.fromJson(response.data);
          return SuccessResponse(data: responseModel);
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
  Future<ResponseBaseModel> editProperty(
      {required FormData data, required String propertyId}) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().putBaseAPIWithToken(
        url: NetworkAPIs.kEditProperty,
        data: data,
        id: propertyId,
      );
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          AddEditPropertyResponseModel responseModel =
              AddEditPropertyResponseModel.fromJson(response.data);
          return SuccessResponse(data: responseModel);
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
  Future<ResponseBaseModel> editPropertyInReview(
      {required FormData data, required String propertyId}) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().putBaseAPIWithToken(
        url: NetworkAPIs.kEditReviewProperty,
        data: data,
        id: propertyId,
      );
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          AddEditPropertyResponseModel responseModel =
              AddEditPropertyResponseModel.fromJson(response.data);
          return SuccessResponse(data: responseModel);
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
  Future<ResponseBaseModel> getFurnishedType() async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>()
          .postBaseAPI(url: NetworkAPIs.kFurnishedType);
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          PropertyCategoryResponseModel furnishedStatusResponseModel =
              PropertyCategoryResponseModel.fromJson(response.data);
          return SuccessResponse(data: furnishedStatusResponseModel);
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
  Future<ResponseBaseModel> getFinanceRequestListVisitor(
      Map<String, dynamic>? queryParameters) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().postBaseAPIWithToken(
          url: NetworkAPIs.kFinanceRequestList, data: queryParameters);
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          FinanceRequestListResponse financeRequestListResponse =
              FinanceRequestListResponse.fromJson(response.data);
          return SuccessResponse(data: financeRequestListResponse);
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
  Future<ResponseBaseModel> addRemoveFavorite({
    required AddRemoveFavRequestModel requestModel,
  }) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().postBaseAPIWithToken(
        url: NetworkAPIs.kAddRemoveFav,
        data: requestModel.toJson(),
      );
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          CommonOnlyMessageResponseModel responseModel =
              CommonOnlyMessageResponseModel.fromJson(response.data);
          return SuccessResponse(data: responseModel);
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
  Future<ResponseBaseModel> approveVisitRequest({
    required VisitRequestApproveRequestModel requestModel,
  }) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().postBaseAPIWithToken(
        url: NetworkAPIs.kApproveVisitRequest,
        data: requestModel.toJson(),
      );
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          CommonOnlyMessageResponseModel responseModel =
              CommonOnlyMessageResponseModel.fromJson(response.data);
          return SuccessResponse(data: responseModel);
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
  Future<ResponseBaseModel> rejectVisitRequest({
    required VisitRequestRejectRequestModel requestModel,
  }) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().postBaseAPIWithToken(
        url: NetworkAPIs.kApproveVisitRequest,
        data: requestModel.toJson(),
      );
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          CommonOnlyMessageResponseModel responseModel =
              CommonOnlyMessageResponseModel.fromJson(response.data);
          return SuccessResponse(data: responseModel);
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
  Future<ResponseBaseModel> soldOutProperty({
    required SoldOutPropertyRequestModel requestModel,
  }) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().postBaseAPIWithToken(
        url: NetworkAPIs.kSoldOutProperty,
        data: requestModel.toJson(),
      );
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          CommonOnlyMessageResponseModel responseModel =
              CommonOnlyMessageResponseModel.fromJson(response.data);
          return SuccessResponse(data: responseModel);
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
  Future<ResponseBaseModel> sendVisitRequest({
    required SendVisitRequestRequestModel requestModel,
  }) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().postBaseAPIWithToken(
        url: NetworkAPIs.kSendVisitRequest,
        data: requestModel.toJson(),
      );
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          SendVisitRequestResponseModel responseModel =
              SendVisitRequestResponseModel.fromJson(response.data);
          return SuccessResponse(data: responseModel);
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
  Future<ResponseBaseModel> getReviewPropertyDetails(
      {required String propertyId}) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().postBaseAPIWithToken(
        url: NetworkAPIs.kGetReviewPropertyDetails + propertyId,
      );
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          PropertyDetailsResponseModel responseModel =
              PropertyDetailsResponseModel.fromJson(response.data);
          return SuccessResponse(data: responseModel);
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
  Future<ResponseBaseModel> getPropertyDetails({
    required String propertyId,
    required BuildContext context,
    bool isGuest = false,
    bool isVendor = false,
  }) async {
    if (await Utils.isConnected()) {
      final response = isGuest
          ? await GetIt.I<DioProvider>().postBaseAPI(
              url: NetworkAPIs.kGetPropertyDetails + propertyId,
              data: isGuest
                  ? PropertyListDataRequestModel(
                      skipLogin: true,
                    ).toJson()
                  : null,
            )
          : isVendor
              ? await GetIt.I<DioProvider>().postBaseAPIWithToken(
                  url: NetworkAPIs.kGetPropertyDetails + propertyId,
                  data: PropertyDetailsRequestModel(
                    withOffers: true,
                  ).toJson(),
                )
              : await GetIt.I<DioProvider>().postBaseAPIWithToken(
                  url: NetworkAPIs.kGetPropertyDetails + propertyId,
                );
      if (response.data != null) {
        if (response.statusCode == 404) {
          context.pushNamed(Routes.kPropertyNotFound);
          return FailedResponse(
              errorMessage: appStrings(context).textPropertyNotFound ?? "");
        } else if (response.statusCode == 200 || response.statusCode == 201) {
          PropertyDetailsResponseModel responseModel =
              PropertyDetailsResponseModel.fromJson(response.data);
          return SuccessResponse(data: responseModel);
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
  Future<ResponseBaseModel> deleteProperty({
    required DeletePropertyRequestModel requestModel,
  }) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().deleteBaseAPIWithToken(
        url: NetworkAPIs.kDeleteProperty,
        data: requestModel.toJson(),
      );
      if (response.data != null) {
        if (response.statusCode == 200) {
          CommonOnlyMessageResponseModel responseModel =
              CommonOnlyMessageResponseModel.fromJson(response.data);
          return SuccessResponse(data: responseModel);
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
  Future<ResponseBaseModel> deletePropertyInReview({
    required DeletePropertyInReviewRequestModel requestModel,
  }) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().deleteBaseAPIWithToken(
        url: NetworkAPIs.kDeleteReviewProperty,
        data: requestModel.toJson(),
      );
      if (response.data != null) {
        if (response.statusCode == 200) {
          CommonOnlyMessageResponseModel responseModel =
              CommonOnlyMessageResponseModel.fromJson(response.data);
          return SuccessResponse(data: responseModel);
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
  Future<ResponseBaseModel> getReviews({
    required ReviewListRequestModel requestModel,
  }) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().postBaseAPIWithToken(
        url: NetworkAPIs.kViewReview,
        data: requestModel.toJson(),
      );
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          ReviewListResponseModel responseModel =
              ReviewListResponseModel.fromJson(response.data);
          return SuccessResponse(data: responseModel);
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
  Future<ResponseBaseModel> addRatingReview({
    required AddRatingReviewRequestModel requestModel,
  }) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().postBaseAPIWithToken(
        url: NetworkAPIs.kAddRatingReview,
        data: requestModel.toJson(),
      );
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          AddRatingReviewResponseModel responseModel =
              AddRatingReviewResponseModel.fromJson(response.data);
          return SuccessResponse(data: responseModel);
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
  Future<ResponseBaseModel> getCurrencyList() async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>()
          .getBaseAPI(url: NetworkAPIs.kCurrencyList);
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          CurrencyListResponseModel responseModel =
              CurrencyListResponseModel.fromJson(response.data);
          return SuccessResponse(data: responseModel);
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
  Future<ResponseBaseModel> getFinanceRequestDetails({
    required String requestId,
    required BuildContext context
  }) async {
    if (await Utils.isConnected()) {
      final response = await GetIt.I<DioProvider>().getBaseAPIWithToken(
        url: "${NetworkAPIs.kAddFinanceRequestDetails}/$requestId",
      );
      if (response.data != null) {
        if (response.statusCode == 404) {
          context.pushNamed(Routes.kPropertyNotFound);
          return FailedResponse(
              errorMessage: appStrings(context).textPropertyNotFound ?? "");
        } else if (response.statusCode == 200 || response.statusCode == 201) {
          FinanceRequestDetailsModel responseModel =
          FinanceRequestDetailsModel.fromJson(response.data);
          return SuccessResponse(data: responseModel);
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
