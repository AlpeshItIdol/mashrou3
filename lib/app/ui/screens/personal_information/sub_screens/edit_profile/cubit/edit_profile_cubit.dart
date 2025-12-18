import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mashrou3/app/bloc/common_api_services/common_api_cubit.dart';
import 'package:mashrou3/app/model/city_list_response_model.dart';
import 'package:mashrou3/app/model/country_list_model.dart';

import '../../../../../../../config/network/network_constants.dart';
import '../../../../../../../config/resources/app_constants.dart';
import '../../../../../../../config/resources/app_strings.dart';
import '../../../../../../../config/utils.dart';
import '../../../../../../db/app_preferences.dart';
import '../../../../../../model/base/base_model.dart';
import '../../../../../../model/contact_number_model.dart';
import '../../../../../../model/country_request_mode.dart';
import '../../../../../../model/language_list_response_model.dart';
import '../../../../../../model/social_media_model.dart';
import '../../../../../../model/vendor_list_response.model.dart';
import '../../../../../../model/verify_response.model.dart';
import '../../../../../../repository/authentication_repository.dart';
import '../../../../../custom_widget/loader/overlay_loading_progress.dart';
import '../../../../authentication/component/bloc/country_selection_cubit.dart';
import '../../../../authentication/login/model/login_response.model.dart';
import '../../../cubit/personal_information_cubit.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  AuthenticationRepository repository;

  EditProfileCubit({required this.repository}) : super(EditProfileInitial());

  AppPreferences appPreferences = AppPreferences();

  TextEditingController mobileNumberCtl = TextEditingController();
  FocusNode mobileNumberFn = FocusNode();
  TextEditingController firstNameCtl = TextEditingController();
  FocusNode firstNameFn = FocusNode();
  TextEditingController lastNameCtl = TextEditingController();
  FocusNode lastNameFn = FocusNode();
  TextEditingController emailIdCtl = TextEditingController();
  FocusNode emailIdFn = FocusNode();
  TextEditingController facebookLinkCtl = TextEditingController();
  TextEditingController companyNameCtl = TextEditingController();
  FocusNode companyNameFn = FocusNode();
  TextEditingController descriptionCtl = TextEditingController();
  FocusNode descriptionFn = FocusNode();
  TextEditingController websiteLinkCtl = TextEditingController();
  FocusNode websiteLinkFn = FocusNode();
  FocusNode facebookLinkFn = FocusNode();
  TextEditingController instagramLinkCtl = TextEditingController();
  FocusNode instagramLinkFn = FocusNode();
  TextEditingController linkedInLinkCtl = TextEditingController();
  FocusNode linkedInLinkFn = FocusNode();
  TextEditingController twitterLinkCtl = TextEditingController();
  FocusNode twitterLinkFn = FocusNode();
  TextEditingController catalogLinkCtl = TextEditingController();
  FocusNode catalogLinkFn = FocusNode();
  TextEditingController virtualTourLinkCtl = TextEditingController();
  FocusNode virtualTourLinkFn = FocusNode();
  TextEditingController googleLocationCtl = TextEditingController();
  FocusNode googleLocationFn = FocusNode();
  TextEditingController uploadLogoCtl = TextEditingController();
  FocusNode uploadLogoFn = FocusNode();
  TextEditingController searchCtl = TextEditingController();
  FocusNode searchFn = FocusNode();

  var selectedUserId = "";
  var selectedUserRole = "";
  var selectedCountryId = "";
  var mobileNumberWithCountryCode = "";
  var countryCode = "+962";
  var countryCodeStr = "JO";

  LatLng locationLatLng = const LatLng(31.952775, 35.939847); // Downtown Amman

  bool isSelectedCountry = true;

  List<String> profileLinksList = [];
  List<TextEditingController> profileLinksControllers = [];
  List<Location> addressesList = [];
  List<TextEditingController> addressesControllers = [];
  List<FocusNode> addressesFns = [];
  List<VendorListData>? vendorList = [];
  List<VendorListData> selectedVendorList = [];
  List<CountryListData>? countryList = [];
  List<LanguageListData>? languageList = [];
  List<dynamic> documentsList = [];
  List<dynamic> companyLogo = [];
  List<String> httpCertificatesList = [];
  List<String> httpPortfolioList = [];

  CountryListData selectedCountryForFlag = AppConstants.defaultCountry;
  VendorListData selectedVendor = VendorListData();
  CountryListData selectedCountry = CountryListData();
  LanguageListData selectedLanguage = LanguageListData();
  CountryListData selectedAltMobileNoCountry = AppConstants.defaultCountry;
  Cities selectedCity = Cities();

  VerifyResponseData? userSavedData;

  /// Get data initial data
  ///
  Future<void> getData(BuildContext context) async {
    setDefaultData(context);
    selectedUserRole = await GetIt.I<AppPreferences>().getUserRole() ?? "";
    selectedUserId = await GetIt.I<AppPreferences>().getUserID() ?? "";
    selectedCountryId =
        await GetIt.I<AppPreferences>().getSelectedCountryID() ?? "";
    userSavedData =
        await appPreferences.getUserDetails() ?? VerifyResponseData();
    printf(userSavedData);

    OverlayLoadingProgress.start(context);
    await getCountryList(context);
    // await getCityList(context);
    OverlayLoadingProgress.stop();
    await setEditData(userSavedData ?? VerifyResponseData(), context);
  }

  void setDefaultData(BuildContext context) {
    firstNameCtl.text = "";
    lastNameCtl.text = "";
    emailIdCtl.text = "";
    mobileNumberCtl.text = "";
    profileLinksList.clear();
    addressesList.clear();
    profileLinksControllers.clear();
    addressesControllers.clear();

    selectedAltMobileNoCountry = AppConstants.defaultCountry;
    context.read<CountrySelectionCubit>().selectedAltMobileNoCountry =
        selectedAltMobileNoCountry;

    selectedCountry = countryList!.firstWhere(
        (country) => country.sId.toString() == "",
        orElse: () => AppConstants.defaultCountry);
    selectedCity = Cities();
    // Ensure at least one profile link is available
    if (profileLinksList.isEmpty) {
      profileLinksList
          .add(""); // Add an empty string for the initial text field
      profileLinksControllers
          .add(TextEditingController()); // Add a controller for it
    }
    emit(UserDetailsLoaded());
  }

  Future<void> setEditData(
      VerifyResponseData userDetailData, BuildContext context) async {
    if (userDetailData.users != null) {
      firstNameCtl.text = userDetailData.users?.firstName ?? "";
      lastNameCtl.text = userDetailData.users?.lastName ?? "";
      emailIdCtl.text = userDetailData.users?.email ?? "";
      mobileNumberCtl.text = userDetailData
          .users?.alternativeContactNumbers?.contactNumber
          ?.toString() ??
          '';

      httpCertificatesList.clear();
      httpPortfolioList.clear();

      httpCertificatesList
          .addAll(userSavedData?.users?.identityVerificationDoc ?? []);
      httpPortfolioList.addAll(userSavedData?.users?.portfolio ?? []);

      selectedAltMobileNoCountry = userDetailData
          .users?.alternativeContactNumbers !=
          null
          ? CountryListData(
          phoneCode:
          userDetailData.users?.alternativeContactNumbers?.phoneCode ??
              "",
          countryCode: countryList
              ?.firstWhere(
                (country) =>
            country.emoji ==
                userDetailData
                    .users?.alternativeContactNumbers?.emoji,
            orElse: () =>
                CountryListData(
                    emoji: "🇯🇴",
                    countryCode: "+962"), // Provide a fallback country
          )
              .countryCode ??
              "",
          emoji:
          userDetailData.users?.alternativeContactNumbers?.emoji ?? "")
          : AppConstants.defaultCountry;
      context
          .read<CountrySelectionCubit>()
          .selectedAltMobileNoCountry =
          selectedAltMobileNoCountry;

      // selectedAltMobileNoCountry =
      //     userDetailData.users?.alternativeContactNumbers != null
      //         ? CountryListData(
      //             phoneCode: userDetailData
      //                     .users?.alternativeContactNumbers?.phoneCode ??
      //                 "",
      //             countryCode: userDetailData
      //                     .users?.alternativeContactNumbers?.countryCode ??
      //                 "",
      //             emoji:
      //                 userDetailData.users?.alternativeContactNumbers?.emoji ??
      //                     "")
      //         : AppConstants.defaultCountry;
      // context.read<CountrySelectionCubit>().selectedAltMobileNoCountry =
      //     selectedAltMobileNoCountry;

      selectedCountry = countryList!.firstWhere(
              (country) =>
          country.sId.toString() ==
              userSavedData?.users?.country.toString(),
          orElse: () => AppConstants.defaultCountry);
      selectedCity = Cities(
          sId: userDetailData.users?.city?.sId,
          name: userDetailData.users?.city?.name);

      descriptionCtl.text = userDetailData.users?.companyDescription ?? "";
      companyNameCtl.text = userDetailData.users?.companyName ?? "";
      googleLocationCtl.text =
          userDetailData.users?.location?.first.address ?? "";
      websiteLinkCtl.text =
          userDetailData.users?.socialMediaLinks?.website ?? "";
      facebookLinkCtl.text =
          userDetailData.users?.socialMediaLinks?.facebook ?? "";
      instagramLinkCtl.text =
          userDetailData.users?.socialMediaLinks?.instagram ?? "";

      // if (userDetailData.users?.socialMediaLinks != null);
      final List<Location> addressListData =
          userDetailData.users?.location ?? [];

      addressesList.addAll(addressListData);
      // Ensure at least one profile link is available
      if (addressesList.isEmpty) {
        addressesList
            .add(Location()); // Add an empty string for the initial text field
        addressesControllers
            .add(TextEditingController()); // Add a controller for it
        addressesFns.add(FocusNode());
      } else {
        addressesControllers.addAll(
          addressListData
              .map((link) => TextEditingController(text: link.address))
              .toList(),
        );
      }

      if (selectedUserRole == AppStrings.owner) {
        linkedInLinkCtl.text =
            userDetailData.users?.socialMediaLinks?.linkedIn ?? "";

        // if (userDetailData.users?.socialMediaLinks != null);
        final List<String> profileLinks =
            userDetailData.users?.socialMediaLinks?.profileLink ?? [];

        if (profileLinks.isNotEmpty) {
          profileLinksList.clear();
          profileLinksControllers.clear();
          profileLinksList.addAll(profileLinks);
          profileLinksControllers.addAll(
            profileLinks
                .map((link) => TextEditingController(text: link))
                .toList(),
          );
        }
      }

      if (selectedUserRole == AppStrings.vendor) {
        twitterLinkCtl.text =
            userDetailData.users?.socialMediaLinks?.twitter ?? "";

        catalogLinkCtl.text =
            userDetailData.users?.socialMediaLinks?.catalog ?? "";

        virtualTourLinkCtl.text =
            userDetailData.users?.socialMediaLinks?.virtualTour ?? "";
        //
        // // if (userDetailData.users?.socialMediaLinks != null);
        // final List<Location> addressListData =
        //     userDetailData.users?.location ?? [];
        //
        // addressesList.addAll(addressListData);
        // // Ensure at least one profile link is available
        // if (addressesList.isEmpty) {
        //   addressesList.add(
        //       Location()); // Add an empty string for the initial text field
        //   addressesControllers
        //       .add(TextEditingController()); // Add a controller for it
        //   addressesFns.add(FocusNode());
        // } else {
        //   addressesControllers.addAll(
        //     addressListData
        //         .map((link) => TextEditingController(text: link.address))
        //         .toList(),
        //   );
        // }
      }
    }
    emit(UserDetailsLoaded());
  }

  void addProfileLink(String question) {
    if (profileLinksList.length < 3) {
      profileLinksList.add(question);
      profileLinksControllers.add(TextEditingController());
      emit(AddMoreProfileLinks(
        profileLinks: List.from(profileLinksList),
        profileLinksCtls: List.from(profileLinksControllers),
      ));
    }
  }

  void updateProfileLink(int index, String profileLink) {
    if (index >= 0 && index < profileLinksList.length) {
      profileLinksList[index] = profileLink;
      emit(AddMoreProfileLinks(
        profileLinks: List.from(profileLinksList),
        profileLinksCtls: List.from(profileLinksControllers),
      ));
    }
  }

  void deleteProfileLink(int index) {
    if (index >= 0 && index < profileLinksList.length) {
      profileLinksList.removeAt(index);
      profileLinksControllers.removeAt(index);
      emit(AddMoreProfileLinks(
        profileLinks: List.from(profileLinksList),
        profileLinksCtls: List.from(profileLinksControllers),
      ));
    }
  }

  void addAddress(Location location) {
    if (addressesList.length < 3) {
      addressesList.add(location);
      addressesControllers.add(TextEditingController());
      addressesFns.add(FocusNode());
      emit(AddMoreAddresses(
        addresses: List.from(addressesList),
        addressesCtls: List.from(addressesControllers),
        addressesFns: List.from(addressesFns),
      ));
    }
  }

  void updateAddress(int index, Location location) {
    if (index >= 0 && index < addressesList.length) {
      addressesList[index] = location;
      emit(AddMoreAddresses(
        addresses: List.from(addressesList),
        addressesCtls: List.from(addressesControllers),
        addressesFns: List.from(addressesFns),
      ));
    }
  }

  void deleteAddress(int index) {
    if (index >= 0 && index < addressesList.length) {
      addressesList.removeAt(index);
      addressesControllers.removeAt(index);
      addressesFns.removeAt(index);
      emit(AddMoreAddresses(
        addresses: List.from(addressesList),
        addressesCtls: List.from(addressesControllers),
        addressesFns: List.from(addressesFns),
      ));
    }
  }

  /// Country List API
  ///
  Future<void> getCountryList(BuildContext context) async {
    emit(EditProfileLoading());

    final model = CountryListRequestModel(
      searchQuery: "",
      // countryId: selectedCountry.sId.toString(),
    );

    final response = await context
        .read<CommonApiCubit>()
        .fetchCountryList(requestModel: model);

    if (response is String) {
      emit(EditProfileError(response));
    } else {
      countryList = response;
      printf("CountryList--------${countryList?.length}");
      emit(APISuccessForEditProfile());
    }
  }

  /// Method country selected
  ///
  void countrySelected({required bool value}) {
    isSelectedCountry = true;
    emit(SelectedCountry(value));
  }

  /// MULTIPART EDIT INFORMATION API
  ///
  Future<void> editProfileAPI(BuildContext context) async {
    emit(EditProfileLoading());
    var formData = FormData();

    // Initial mandatory fields
    formData = FormData.fromMap({
      NetworkParams.kUserType: selectedUserRole.trim(),
      NetworkParams.kFirstName: firstNameCtl.text.trim(),
      NetworkParams.kLastName: lastNameCtl.text.trim(),
      NetworkParams.kEmail: emailIdCtl.text.trim(),
      NetworkParams.kCity: json.encode(selectedCity.toJson()),
      NetworkParams.kPortfolio: json.encode(httpPortfolioList),
      NetworkParams.kIdentityVerificationDoc: json.encode(httpCertificatesList),
    });

    // Add alternative contact number as a MapEntry
    formData.fields.add(
      MapEntry(
        NetworkParams.kAlternativeContactNumbers,
        jsonEncode(ContactNumberModel(
          phoneCode: selectedAltMobileNoCountry.phoneCode,
          countryCode: selectedAltMobileNoCountry.countryCode,
          contactNumber: mobileNumberCtl.text.trim(),
          emoji: selectedAltMobileNoCountry.emoji,
        ).toJson()),
      ),
    );

    // Conditionally add fields based on user role
    if (selectedUserRole != AppStrings.visitor) {
      formData.fields.addAll([
        MapEntry(NetworkParams.kCompanyName, companyNameCtl.text.trim()),
        MapEntry(NetworkParams.kCompanyDescription, descriptionCtl.text.trim()),
      ]);
    }

    final socialMediaModel = selectedUserRole == AppStrings.owner
        ? SocialMediaModel(
            instagram: instagramLinkCtl.text,
            facebook: facebookLinkCtl.text,
            linkedIn: linkedInLinkCtl.text,
            website: websiteLinkCtl.text,
            profileLink: profileLinksList.isEmpty
                ? []
                : profileLinksList.where((link) => link.isNotEmpty).toList(),
          )
        : selectedUserRole == AppStrings.vendor
            ? SocialMediaModel(
                instagram: instagramLinkCtl.text,
                facebook: facebookLinkCtl.text,
                twitter: twitterLinkCtl.text,
                catalog: catalogLinkCtl.text,
                website: websiteLinkCtl.text,
                virtualTour: virtualTourLinkCtl.text,
              )
            : SocialMediaModel(
                instagram: instagramLinkCtl.text,
                facebook: facebookLinkCtl.text,
                twitter: twitterLinkCtl.text,
                catalog: catalogLinkCtl.text,
                website: websiteLinkCtl.text,
              );

    formData.fields.addAll([
      MapEntry(
        NetworkParams.kSocialMediaLinks,
        jsonEncode(socialMediaModel.toJson()),
      ),
      MapEntry(
        NetworkParams.kLocation,
        jsonEncode(
          addressesList.map((location) {
            return Location(
              latitude: location.latitude,
              longitude: location.longitude,
              address: location.address,
            ).toJson();
          }).toList(),
        ),
      )
    ]);

    printf("FormData-----$formData");

    final editInformationResponse =
        await repository.updateProfile(data: formData, userId: selectedUserId);

    if (editInformationResponse is FailedResponse) {
      emit(EditProfileError(editInformationResponse.errorMessage));
    } else if (editInformationResponse is SuccessResponse) {
      VerifyResponseModel response = editInformationResponse.data;

      final appPreferences = GetIt.I<AppPreferences>();
      final verifyResponseData = response;
      final user = response.verifyResponseData?.users;
      if (verifyResponseData.verifyResponseData != null && user != null) {
        // Set user details and role type
        await appPreferences
            .setUserDetails(verifyResponseData.verifyResponseData!);
      }

      PersonalInformationCubit personalInformationCubit =
          context.read<PersonalInformationCubit>();

      await personalInformationCubit.getData(context);
      emit(EditProfileSuccess(model: response));
    }
  }
}
