import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mashrou3/app/db/app_preferences.dart';
import 'package:mashrou3/app/repository/property_repository.dart';
import 'package:mashrou3/config/resources/app_assets.dart';
import 'package:mashrou3/utils/app_localization.dart';

import '../../../../../config/resources/app_strings.dart';
import '../../../../../config/utils.dart';
import '../../../../model/base/base_model.dart';
import '../../../../model/common_only_message_response_model.dart';
import '../../../../model/offers/my_offers_list_response_model.dart';
import '../../../../model/offers/offers_list_for_property_request.model.dart';
import '../../../../model/offers/offers_list_for_property_response.model.dart';
import '../../../../model/property/add_to_fav_request_model.dart';
import '../../../../model/property/contact_now_model.dart';
import '../../../../model/property/get_finance_model.dart';
import '../../../../model/property/property_detail_response_model.dart';
import '../../../../model/property/property_view_count_request_model.dart';
import '../../../../model/property/property_view_count_response_model.dart';
import '../../../../model/verify_response.model.dart';
import '../../../../repository/offers_management_repository.dart';
import '../../dashboard/sub_screens/add_offer/model/add_vendor_response_model.dart' as detailModel;

part 'property_details_state.dart';

class PropertyDetailsCubit extends Cubit<PropertyDetailsState> {
  PropertyDetailsCubit({required this.propertyRepository, required this.offersManagementRepository}) : super(PropertyDetailsInitial());
  PropertyRepository propertyRepository;
  OffersManagementRepository offersManagementRepository;

  var myPropertyDetails = PropertyDetailData();
  var sid = "";
  var selectedLanguage = 'en';
  var selectedRole = "";
  var selectedUserId = "";
  var selectedUserRole = "";
  UserDetailsData detailData = UserDetailsData();
  VerifyResponseData? userSavedData;

  bool isGuest = false;
  bool isVendor = false;
  bool isCountClicked = false;

  List<GetFinanceModel> getFinanceOptions = [];
  List<ContactNowModel> contactNowOptions = [];
  List<detailModel.OfferData> offersList = [];

  /// Get data initial data
  ///
  Future<void> getData(BuildContext context, String sID) async {
    selectedUserId = await GetIt.I<AppPreferences>().getUserID();
    selectedUserRole = await GetIt.I<AppPreferences>().getUserRole() ?? "";
    userSavedData = VerifyResponseData();
    userSavedData = await GetIt.I<AppPreferences>().getUserDetails() ?? VerifyResponseData();
    selectedLanguage = await GetIt.I<AppPreferences>().getLanguageCode() ?? 'en';
    myPropertyDetails = PropertyDetailData();
    offersList.clear();
    isGuest = await GetIt.I<AppPreferences>().getIsGuestUser();
    selectedRole = await GetIt.I<AppPreferences>().getUserRole() ?? "";
    isVendor = selectedRole == AppStrings.vendor;
    if (!isCountClicked) {
      await getPropertyViewCount(propertyId: sID);
      isCountClicked = true;
    }
    if (!context.mounted) return;
    await getPropertyDetails(propertyId: sID, context: context);
    if (!context.mounted) return;
    getFinanceOptions = await getFinanceOptionsList(context);

    if (!context.mounted) return;
    contactNowOptions = await Utils.getContactNowList(context);
  }

  Future<List<GetFinanceModel>> getFinanceOptionsList(BuildContext context) async {
    return [
      GetFinanceModel(
          title: appStrings(context).textForRealEstate, icon: SVGAssets.realEstateIcon, isEnable: myPropertyDetails.bankOffer ?? true),
      GetFinanceModel(
          title: appStrings(context).textSelectVendor, icon: SVGAssets.userVendorIcon, isEnable: myPropertyDetails.vendorOffer ?? true),
    ];
  }

  /// Property Details API
  Future<void> getPropertyDetails({
    required BuildContext context,
    required String propertyId,
  }) async {
    emit(PropertyDetailsAPILoading());
    final response = isVendor
        ? await propertyRepository.getPropertyDetails(context: context, propertyId: propertyId, isVendor: isVendor)
        : isGuest
            ? await propertyRepository.getPropertyDetails(context: context, propertyId: propertyId, isGuest: isGuest)
            : await propertyRepository.getPropertyDetails(context: context, propertyId: propertyId);

    if (response is SuccessResponse && response.data is PropertyDetailsResponseModel) {
      PropertyDetailsResponseModel responseModel = response.data as PropertyDetailsResponseModel;
      offersList.addAll(responseModel.data?.offers ?? []);

      emit(PropertyDetailsSuccess(model: responseModel.data ?? PropertyDetailData()));
      myPropertyDetails = responseModel.data ?? PropertyDetailData();
    } else if (response is FailedResponse) {
      emit(PropertyDetailsFailure(response.errorMessage));
    }
  }

  /// Add Remove Favorite Property API
  ///
  Future<void> addRemoveFavorite({
    required String propertyId,
    required bool isFav,
    required BuildContext context,
  }) async {
    emit(PropertyDetailsLoading());

    final requestModel = AddRemoveFavRequestModel(
      isFavorite: isFav ? true : false,
      propertyId: propertyId,
    );

    final response = await propertyRepository.addRemoveFavorite(requestModel: requestModel);

    if (response is SuccessResponse && response.data is CommonOnlyMessageResponseModel) {
      CommonOnlyMessageResponseModel addToFavResponse = response.data as CommonOnlyMessageResponseModel;

      emit(AddedToFavoriteForPropertyDetail(addToFavResponse.message ?? ""));
    } else if (response is FailedResponse) {
      emit(PropertyDetailsError(errorMessage: response.errorMessage));
    }
  }

  /// Property view count API
  ///
  Future<void> getPropertyViewCount({
    required String propertyId,
  }) async {
    emit(PropertyDetailsLoading());

    final requestModel = PropertyViewCountRequestModel(
      propertyId: propertyId,
    );

    final response = await propertyRepository.getPropertyViewCount(requestModel: requestModel);

    if (response is SuccessResponse && response.data is PropertyViewCountResponseModel) {
      PropertyViewCountResponseModel responseModel = response.data as PropertyViewCountResponseModel;

      emit(PropertyViewCountSuccess());
    } else if (response is FailedResponse) {
      emit(PropertyDetailsError(errorMessage: response.errorMessage));
    }
  }

  /// Offers List API
  Future<void> getOffersList({
    required String propertyId,
  }) async {
    emit(PropertyDetailsLoading());

    final requestModel = OffersListForPropertyRequestModel(
      propertyId: propertyId,
    );

    final response = await offersManagementRepository.getOffersListForProperty(
      requestModel: requestModel,
    );

    if (response is SuccessResponse && response.data is OffersListForPropertyResponseModel) {
      OffersListForPropertyResponseModel responseModel = response.data as OffersListForPropertyResponseModel;
      offersList.addAll(responseModel.offersListData ?? []);
      emit(OffersListSuccess(model: responseModel));
    } else if (response is FailedResponse) {
      emit(PropertyDetailsError(errorMessage: response.errorMessage));
    }
  }
}
