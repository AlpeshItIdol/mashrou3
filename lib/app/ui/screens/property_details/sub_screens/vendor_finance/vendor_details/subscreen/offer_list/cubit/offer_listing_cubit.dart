import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mashrou3/app/repository/offers_management_repository.dart';

import '../../../../../../../../../../config/resources/app_strings.dart';
import '../../../../../../../../../db/app_preferences.dart';
import '../../../../../../../../../model/verify_response.model.dart';
import '../../../cubit/vendor_detail_cubit.dart';

part 'offer_listing_state.dart';

class OfferListingCubit extends Cubit<OfferListingState> {
  OffersManagementRepository offerRepository;

  OfferListingCubit({required this.offerRepository})
      : super(OfferListingInitial());

  VerifyResponseData? userSavedData;

  var selectedRole = '';
  var selectedUserId = "";
  var companyLogo = "";
  bool isVendor = false;

  /// Get data initial data
  ///
  Future<void> getData(BuildContext context) async {
    userSavedData = await GetIt.I<AppPreferences>().getUserDetails() ??
        VerifyResponseData();
    selectedRole = await GetIt.I<AppPreferences>().getUserRole() ?? "";
    selectedUserId = await GetIt.I<AppPreferences>().getUserID();
    isVendor = selectedRole == AppStrings.vendor;

    if (isVendor) {
      companyLogo = userSavedData?.users?.companyLogo ?? "";
    } else {
      companyLogo =
          context.read<VendorDetailCubit>().detailData.companyLogo ?? "";
    }
    emit(DataLoaded());
  }
}
