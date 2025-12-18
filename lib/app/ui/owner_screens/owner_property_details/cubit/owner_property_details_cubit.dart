import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mashrou3/app/db/app_preferences.dart';
import 'package:mashrou3/app/repository/property_repository.dart';

import '../../../../../config/utils.dart';
import '../../../../model/base/base_model.dart';
import '../../../../model/common_only_message_response_model.dart';
import '../../../../model/property/contact_now_model.dart';
import '../../../../model/property/delete_property_in_review_request_model.dart';
import '../../../../model/property/delete_property_request_model.dart';
import '../../../../model/property/property_detail_response_model.dart';
import '../../../../model/property/sold_out_property_request_model.dart';
import '../../../screens/property_not_found/property.not.found.screen.dart';
import '../../dashboard/sub_screens/home/cubit/owner_home_cubit.dart';

part 'owner_property_details_state.dart';

class OwnerPropertyDetailsCubit extends Cubit<OwnerPropertyDetailsState> {
  OwnerPropertyDetailsCubit({required this.propertyRepository})
      : super(OwnerPropertyDetailsInitial());
  PropertyRepository propertyRepository;

  var myPropertyDetails = PropertyDetailData();

  List<ContactNowModel> contactNowOptions = [];
  List<PropertyAmenitiesData> livingSpace = [];
  var selectedLanguage = 'en';

  bool isLoginUserOwner = true;

  /// Get data initial data
  ///
  Future<void> getData(
      BuildContext context, String sID, bool isForInReview) async {
    myPropertyDetails = PropertyDetailData();
    contactNowOptions.clear();
    selectedLanguage =
        await GetIt.I<AppPreferences>().getLanguageCode() ?? 'en';
    Future.delayed(const Duration(milliseconds: 300), () async {
      if (!context.mounted) return;
      await getPropertyDetails(
          propertyId: sID, context: context, isForInReview: isForInReview);
    });

    if (!context.mounted) return;
    contactNowOptions = await Utils.getContactNowList(context) ?? [];
  }

  void emitInitialState() {
    emit(OwnerPropertyDetailsInitial());
  }

  /// Property Details API
  Future<void> getPropertyDetails({
    required String propertyId,
    required BuildContext context,
    required bool isForInReview,
  }) async {
    emit(OwnerPropertyDetailsLoading());
    isLoginUserOwner = true;

    final response = isForInReview
        ? await propertyRepository.getReviewPropertyDetails(
            propertyId: propertyId)
        : await propertyRepository.getPropertyDetails(
            context: context, propertyId: propertyId);

    if (response is SuccessResponse &&
        response.data is PropertyDetailsResponseModel) {
      PropertyDetailsResponseModel responseModel =
          response.data as PropertyDetailsResponseModel;
      if (!context.mounted) return;
      final loginUserId = await GetIt.I<AppPreferences>().getUserID() ?? "";
      if (responseModel.data?.createdBy == loginUserId) {
        emit(OwnerPropertyDetailsSuccess(
            model: responseModel.data ?? PropertyDetailData()));
      } else {
        isLoginUserOwner = false;
        emit(OwnerNotValidForProperty());
      }
      myPropertyDetails = responseModel.data ?? PropertyDetailData();

      livingSpace.add(PropertyAmenitiesData(
          name: myPropertyDetails.floorsData?.name,
          sId: myPropertyDetails.floorsData?.sId,
          amenityIcon: ""));
      if ((myPropertyDetails.mortgaged) == true) {
        livingSpace.add(
            PropertyAmenitiesData(name: "Mortgaged", sId: "", amenityIcon: ""));
      } else if ((myPropertyDetails.mortgaged) == false) {
      } else if ((myPropertyDetails.mortgaged) == null) {
        livingSpace.add(
            PropertyAmenitiesData(name: "Debt-free", sId: "", amenityIcon: ""));
      }
      livingSpace.add(PropertyAmenitiesData(
          name: myPropertyDetails.facadeData?.name,
          sId: myPropertyDetails.facadeData?.sId,
          amenityIcon: ""));

      livingSpace.add(PropertyAmenitiesData(
          name: myPropertyDetails.bathroomData?.name,
          sId: myPropertyDetails.bathroomData?.sId,
          amenityIcon: ""));

      livingSpace.add(PropertyAmenitiesData(
          name: myPropertyDetails.bedroomData?.name,
          sId: myPropertyDetails.bedroomData?.sId,
          amenityIcon: ""));

      livingSpace.add(PropertyAmenitiesData(
          name: myPropertyDetails.furnishedData?.name,
          sId: myPropertyDetails.furnishedData?.sId,
          amenityIcon: ""));
    } else if (response is FailedResponse) {
      if (response.errorMessage.contains('delete')) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PropertyNotFoundScreen(),
          ),
        );
        // context.pushNamed(NoConnectivityScreen());
      }
      emit(OwnerPropertyDetailsFailure(response.errorMessage));
    }
  }

  /// Delete Property API
  Future<void> deleteProperty({
    required List<String> propertyIds,
  }) async {
    emit(OwnerPropertyDetailsLoading());

    final requestModel = DeletePropertyRequestModel(
      propertyIds: propertyIds,
    );

    final response =
        await propertyRepository.deleteProperty(requestModel: requestModel);

    if (response is SuccessResponse &&
        response.data is CommonOnlyMessageResponseModel) {
      CommonOnlyMessageResponseModel deleteResponse =
          response.data as CommonOnlyMessageResponseModel;

      emit(DeletePropertySuccess(deleteResponse.message ?? ""));
    } else if (response is FailedResponse) {
      emit(OwnerPropertyDetailsError(errorMessage: response.errorMessage));
    }
  }

  /// Delete Property For In Review API
  Future<void> deletePropertyInReview({
    required List<String> propertyIds,
  }) async {
    emit(OwnerPropertyDetailsLoading());

    final requestModel = DeletePropertyInReviewRequestModel(
      propertyIds: propertyIds,
    );

    final response = await propertyRepository.deletePropertyInReview(
        requestModel: requestModel);

    if (response is SuccessResponse &&
        response.data is CommonOnlyMessageResponseModel) {
      CommonOnlyMessageResponseModel addToFavResponse =
          response.data as CommonOnlyMessageResponseModel;

      emit(DeletePropertySuccess(addToFavResponse.message ?? ""));
    } else if (response is FailedResponse) {
      emit(OwnerPropertyDetailsError(errorMessage: response.errorMessage));
    }
  }

  /// Sold Out Property API
  Future<void> soldOutProperty({
    required BuildContext context,
    required String propertyId,
  }) async {
    emit(OwnerPropertyDetailsLoading());

    final requestModel = SoldOutPropertyRequestModel(
      propertyId: propertyId,
    );

    final response =
        await propertyRepository.soldOutProperty(requestModel: requestModel);

    if (response is SuccessResponse &&
        response.data is CommonOnlyMessageResponseModel) {
      CommonOnlyMessageResponseModel soldOutResponse =
          response.data as CommonOnlyMessageResponseModel;

      OwnerHomeCubit homeCubit = context.read<OwnerHomeCubit>();
      homeCubit.propertyList = [];
      homeCubit.filteredPropertyList = [];
      homeCubit.currentPage = 1;
      homeCubit.totalPage = 1;
      homeCubit.hasShownSkeleton = false;
      await homeCubit.getPropertyList();

      emit(SoldOutPropertySuccess(soldOutResponse.message ?? ""));
    } else if (response is FailedResponse) {
      emit(OwnerPropertyDetailsError(errorMessage: response.errorMessage));
    }
  }
}
