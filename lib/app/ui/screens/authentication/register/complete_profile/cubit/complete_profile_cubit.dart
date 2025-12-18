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
import 'package:mashrou3/app/model/location_model.dart';
import 'package:mashrou3/app/repository/bank_management_repository.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/banks_list/model/banks_list_response_model.dart';

import '../../../../../../../config/network/network_constants.dart';
import '../../../../../../../config/resources/app_constants.dart';
import '../../../../../../../config/resources/app_strings.dart';
import '../../../../../../../config/utils.dart';
import '../../../../../../../utils/location_manager.dart';
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

part 'complete_profile_state.dart';

class CompleteProfileCubit extends Cubit<CompleteProfileState> {
  AuthenticationRepository repository;
  BankManagementRepository bankManagementRepository;

  CompleteProfileCubit({
    required this.repository,
    required this.bankManagementRepository,
  }) : super(CompleteProfileInitial());

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
  bool isSelected = false;
  var selectedUserId = "";
  var selectedUserRole = "";
  var selectedCountryId = "";
  var mobileNumberWithCountryCode = "";
  var countryCode = "+962";
  var countryCodeStr = "JO";

  double latitude = AppConstants.defaultLatLng.latitude;

  double longitude = AppConstants.defaultLatLng.longitude;

  LatLng locationLatLng = AppConstants.defaultLatLng;

  bool isSelectedCountry = true;

  int totalCity = 0;
  int currentPage = 1;
  int totalPage = 1;
  bool isLoadingMore = false;
  static const int PER_PAGE_SIZE = 5;
  List<Cities>? filteredCitiesList = [];

  List<String> profileLinksList = [];
  List<TextEditingController> profileLinksControllers = [];
  List<VendorListData>? vendorList = [];
  List<VendorListData> selectedVendorList = [];
  List<CountryListData>? countryList = [];
  List<LanguageListData>? languageList = [];

  List<dynamic> documentsList = [];
  List<dynamic> portfolioList = [];
  List<dynamic> companyLogo = [];

  CountryListData selectedCountryForFlag = AppConstants.defaultCountry;
  VendorListData selectedVendor = VendorListData();
  BankUser selectedBanks = BankUser();
  CountryListData selectedCountry = CountryListData();
  CountryListData selectedAltMobileNoCountry = AppConstants.defaultCountry;
  LanguageListData selectedLanguage = LanguageListData();

  Cities selectedCity = Cities();
  VerifyResponseData? userSavedData;

  /// Get data initial data
  ///
  Future<void> getData(BuildContext context) async {
    selectedUserRole = await GetIt.I<AppPreferences>().getUserRole() ?? "";
    selectedUserId = await GetIt.I<AppPreferences>().getUserID();
    selectedCountryId = await GetIt.I<AppPreferences>().getSelectedCountryID();
    userSavedData = await appPreferences.getUserDetails() ?? VerifyResponseData();
    printf(userSavedData);
    selectedCountry = CountryListData();
    selectedCity = Cities();
    selectedVendor = VendorListData();
    selectedBanks = BankUser();
    mobileNumberCtl.clear();
    uploadLogoCtl.clear();
    googleLocationCtl.clear();
    catalogLinkCtl.clear();
    virtualTourLinkCtl.clear();
    twitterLinkCtl.clear();
    linkedInLinkCtl.clear();
    instagramLinkCtl.clear();
    websiteLinkCtl.clear();
    descriptionCtl.clear();
    companyNameCtl.clear();
    facebookLinkCtl.clear();
    emailIdCtl.clear();
    lastNameCtl.clear();
    firstNameCtl.clear();

    profileLinksList.clear();
    companyLogo.clear();
    documentsList.clear();
    portfolioList.clear();
    languageList?.clear();
    countryList?.clear();
    selectedVendorList.clear();
    vendorList?.clear();
    profileLinksControllers.clear();

    selectedVendor = VendorListData();
    selectedBanks = BankUser();
    selectedCountry = CountryListData();
    selectedLanguage = LanguageListData();
    selectedAltMobileNoCountry = AppConstants.defaultCountry;

    selectedCity = Cities();

    // Ensure at least one profile link is available
    if (profileLinksList.isEmpty) {
      profileLinksList.add(""); // Add an empty string for the initial text field
      profileLinksControllers.add(TextEditingController()); // Add a controller for it
    }

    if (!context.mounted) return;
    OverlayLoadingProgress.start(context);
    if (selectedUserRole == AppStrings.vendor) {
      await getVendorList(context);
    }
    if (!context.mounted) return;
    await getCountryList(context);

    OverlayLoadingProgress.stop();
  }

  Future<void> getLocation(BuildContext context) async {
    if (latitude == AppConstants.defaultLatLng.latitude && longitude == AppConstants.defaultLatLng.longitude) {
      await getLatLng(context);
    }
  }

  Future<void> getLatLng(BuildContext context) async {
    var position = await LocationManager.fetchLocation(context: context);
    if (position != null) {
      latitude = position.latitude;
      longitude = position.longitude;

      printf('Latitude: $latitude, Longitude: $longitude');
      locationLatLng = LatLng(latitude, longitude);
    } else {
      printf('Failed to fetch location.');
    }
    emit(CompleteProfileLocationSet());
  }

  /// Vendor List API
  ///
  Future<void> getVendorList(BuildContext context) async {
    emit(CompleteProfileLoading());

    final response = await context.read<CommonApiCubit>().fetchVendorList();

    if (response is String) {
      emit(CompleteProfileError(response));
    } else {
      vendorList = response;
      printf("CountryList--------${vendorList?.length}");
      emit(APISuccess());
    }
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

  /// Country List API
  ///
  Future<void> getCountryList(BuildContext context) async {
    emit(CompleteProfileLoading());

    final model = CountryListRequestModel(
      searchQuery: "",
      // countryId: selectedCountry.sId.toString(),
    );

    final response = await context.read<CommonApiCubit>().fetchCountryList(requestModel: model);

    if (response is String) {
      emit(CompleteProfileError(response));
    } else {
      countryList = response;
      printf("CountryList--------${countryList?.length}");
      emit(APISuccess());
    }
  }

  /// Language List API
  ///
  Future<void> getLanguageList(BuildContext context) async {
    emit(CompleteProfileLoading());

    final response = await context.read<CommonApiCubit>().fetchLanguageList();

    if (response is String) {
      emit(CompleteProfileError(response));
    } else {
      languageList = response;
      printf("LanguageList--------${languageList?.length}");
      emit(APISuccess());
    }
  }

  void updateCompanyLogo() {
    debugPrint("image---------$companyLogo");

    emit(CompanyLogoLoaded());
  }

  void updateAttachments(List<dynamic> documents, BuildContext context) {
    printf('Attachments ${documents.length}');
    // if (documents.isNotEmpty) {
    //   emit(AddEditPropertyInitial());
    //
    // portfolioList.addAll(documents);
    // }
    emit(AttachmentLoaded());
  }

  /// Method country selected
  ///
  void countrySelected({required bool value}) {
    isSelectedCountry = true;
    emit(SelectedCountry(value));
  }

  /// MULTIPART CREATE PROJECT API
  ///
  Future<void> completeProfileAPI() async {
    emit(CompleteProfileAPILoading());
    var formData = FormData();
    List<dynamic> httpDocumentsList = [];
    List<dynamic> httpPortfolioList = [];
    List<dynamic> httpCompanyLogo = [];
    if (documentsList.isNotEmpty) {
      httpDocumentsList = documentsList.where((item) => item.startsWith('http')).toList();
    }
    if (selectedUserRole == AppStrings.vendor) {
      if (portfolioList.isNotEmpty) {
        httpPortfolioList = portfolioList.where((item) => item.startsWith('http')).toList();
      }
    }
    if (companyLogo.isNotEmpty) {
      httpCompanyLogo = companyLogo.where((item) => item.startsWith('http')).toList();
    }

    List<String?> vendorIds = selectedVendorList.map((vendor) => vendor.sId).toList();

    formData = FormData.fromMap({
      NetworkParams.kUserType: selectedUserRole.trim(),
      NetworkParams.kFirstName: firstNameCtl.text.trim(),
      NetworkParams.kLastName: lastNameCtl.text.trim(),
      NetworkParams.kEmail: emailIdCtl.text.trim(),
      NetworkParams.kCompanyName: companyNameCtl.text.trim(),
      NetworkParams.kCompanyDescription: descriptionCtl.text.trim(),
      NetworkParams.kLanguage: selectedLanguage.langShortName,
      NetworkParams.kCity: json.encode(selectedCity.toJson()),
      NetworkParams.kVendorCategory: vendorIds,
      NetworkParams.kIdentityVerificationDoc: json.encode(httpDocumentsList),
      NetworkParams.kCompanyLogo: json.encode(httpCompanyLogo),
    });

    // Conditionally add fields based on user role
    if (selectedUserRole != AppStrings.vendor) {
      formData.fields.addAll([
        MapEntry(NetworkParams.kVirtualTour, virtualTourLinkCtl.text.trim()),
      ]);
    }

    printf("FormData-----$formData");

    if (companyLogo.isNotEmpty) {
      dynamic multipartFile = "";
      if (!companyLogo.first.startsWith('http')) {
        multipartFile = await MultipartFile.fromFile(companyLogo.first);
        formData.files.add(MapEntry(NetworkParams.kCompanyLogo, multipartFile));
      } else {
        multipartFile = companyLogo.first;
        formData.fields.add(MapEntry(NetworkParams.kCompanyLogo, multipartFile));
      }
    } else {
      formData.fields.add(const MapEntry(NetworkParams.kCompanyLogo, ""));
    }

    if (documentsList.isNotEmpty) {
      for (var file in documentsList) {
        if (!file.startsWith('http') && file.length > 2) {
          final multipartFile = await MultipartFile.fromFile(file);
          formData.files.add(MapEntry(NetworkParams.kIdentityVerificationDoc, multipartFile));
        }
      }
    }

    if (selectedUserRole == AppStrings.vendor) {
      if (portfolioList.isNotEmpty) {
        for (var file in portfolioList) {
          if (!file.startsWith('http') && file.length > 2) {
            final multipartFile = await MultipartFile.fromFile(file);
            formData.files.add(MapEntry(NetworkParams.kPortfolio, multipartFile));
          }
        }
      }
    }

    final socialMediaModel = selectedUserRole == AppStrings.owner
        ? SocialMediaModel(
            instagram: instagramLinkCtl.text,
            facebook: facebookLinkCtl.text,
            linkedIn: linkedInLinkCtl.text,
            website: websiteLinkCtl.text,
            profileLink: profileLinksList.isEmpty || profileLinksList.every((link) => link.isEmpty) ? [] : profileLinksList,
          )
        : selectedUserRole == AppStrings.vendor
            ? SocialMediaModel(
                instagram: instagramLinkCtl.text,
                facebook: facebookLinkCtl.text,
                twitter: twitterLinkCtl.text,
                catalog: catalogLinkCtl.text,
                virtualTour: virtualTourLinkCtl.text,
                website: websiteLinkCtl.text,
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
          jsonEncode(LocationModel(
            latitude: locationLatLng.latitude,
            longitude: locationLatLng.longitude,
            address: googleLocationCtl.text,
          ).toJson())),
      MapEntry(
          NetworkParams.kAlternativeContactNumbers,
          jsonEncode(ContactNumberModel(
            phoneCode: selectedAltMobileNoCountry.phoneCode,
            countryCode: selectedAltMobileNoCountry.countryCode,
            contactNumber: mobileNumberCtl.text.trim(),
            emoji: selectedAltMobileNoCountry.emoji,
          ).toJson())),
    ]);

    printf(formData);
    final createProjectResponse = await repository.completeProfile(data: formData, userId: selectedUserId);

    if (createProjectResponse is FailedResponse) {
      emit(CompleteProfileError(createProjectResponse.errorMessage));
    } else if (createProjectResponse is SuccessResponse) {
      VerifyResponseModel response = createProjectResponse.data;
      emit(CompleteProfileSuccess(model: response));
    }
  }
}
