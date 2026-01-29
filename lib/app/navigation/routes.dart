import 'package:mashrou3/app/navigation/route_arguments.dart';

abstract class Routes {
  static const kSplashScreen = "splash";
  static const kWelcomeScreen = "welcome";
  static const kLoginScreen = "login";
  static const kRegisterStep1Screen = "registerStep1";
  static const kOtpVerificationScreen = "otpVerification";
  static const kRegisterStep2Screen = "registerStep2";
  static const kRegisterStep3Screen = "registerStep3";
  static const kCompleteProfileScreen = "completeProfile";
  static const kEditProfileScreen = "editProfile";
  static const kCompleteProfile2Screen = "completeProfile2";
  static const kCompleteProfile3Screen = "completeProfile3";
  static const kUndergoingVerificationScreen = "undergoingVerification";
  static const kVisitRequest = "visitRequest";
  static const kVisitRequestsList = "visitRequestsList";
  static const kRequestedPropertiesList = "requestedPropertiesList";
  static const kRecentlyVisitedPropertiesList = "recentlyVisitedPropertiesList";
  static const kAbout = "about";
  static const kSearch = "search";
  static const kDashboard = "dashboard";
  static const kOwnerDashboard = "owner-dashboard";
  static const kPropertyDetailScreen = "property-detail";
  static const kProfileDetailScreen = "profile-detail";
  static const kOwnerDetailsScreen = "owner-details";
  static const kFilterScreen = "filter";
  static const kFavFilterScreen = "fav-filter";
  static const kOwnerFilterScreen = "owner-filter";
  static const kInReviewFilterScreen = "in-review-filter";
  static const kPersonalInformationScreen = "personal-information";
  static const kAddEditCertificatesScreen = "add-edit-certificates";
  static const kViewAllCertificatesScreen = "view-all-certificates";
  static const kOwnerPropertyDetailScreen = "owner-property-detail";
  static const kAddEditPropertyScreen1 = "add-edit-property-1";
  static const kAddEditPropertyScreen2 = "add-edit-property-2";
  static const kAddEditPropertyScreen3 = "add-edit-property-3";
  static const kAppPreferencesScreen = "app-preferences";
  static const kAddRatingScreen = "add-rating";
  static const kViewReviewScreen = "view-review";
  static const kBanksListScreen = "banks-list";
  static const kMyOffersListScreen = "my-offers-list";
  static const kAddMyOffersListScreen = "add-my-offers-list";
  static const kOfferPricingScreen = "offer-pricing";
  static const kPricingCalculationResultsScreen = "pricing-calculation-results";
  static const kAddVendorOffersScreen = "add-vendor-offers";
  static const kBankDetailsScreen = "bank-details";
  static const kVendorCategoriesScreen = "vendor-categories";
  static const kCarouselFullScreen = "carousel-fullscreen";
  static const k404Screen = "invalid-screen";
  static const kCityListScreen = "city-list";
  static const kVendorList = "vendor-list";
  static const kVendorDetailScreen = "vendor-detail";
  static const kPropertyNotFound = "property-not-found";
  static const kWebViewScreen = "webview";
  static const kHTMLViewer = "html-viewer";
  static const kOfferListScreen = "offer-listing";
  static const kOfferDetailScreen = "offer-details";
  static const kCmsScreen = "cms-screen";
  static const kFinanceRequestScreen = "finance-request";
  static const kFinanceRequestDetailsScreen = "finance-request-details";
  static const kSubscriptionInformation = "user-subscription-information";
  static const kBanksOffer = "banks-offer";
  static const kDrawerVendorList = "drawervendor-list";
  static const kDrawerVendorDetail = "drawervendor-detail";
  static const kVendorOfferAnalytics = "vendor-offer-analytics";
  static const kOwnerOfferAnalytics = "owner-offer-analytics";

}

abstract class RoutePaths {
  static const kSplashPath = "/";
  static const kWelcomePath = "/welcome";
  static const kLoginPath = "/login";
  static const kRegisterStep1Path = "/register-step1";
  static const kOtpVerificationPath = "/otp-verification";
  static const kRegisterStep2Path = "/register-step2";
  static const kRegisterStep3Path = "/register-step3";
  static const kSearchPath = "/search";
  static const kAboutPath = "/about";
  static const kCompleteProfilePath = "/complete-profile";
  static const kEditProfilePath = "/edit-profile";
  static const kCompleteProfile2Path = "/complete-profile2";
  static const kCompleteProfile3Path = "/complete-profile3";
  static const kUndergoingVerificationPath = "/undergoing-verification";
  static const kChangeLogPath = "/change-log";
  static const kDashboardPath = "/dashboard";
  static const kOwnerDashboardPath = "/owner-dashboard";
  static const kVisitRequestPath = "/visit-request";
  static const kVisitRequestsListPath = "/visit-requests-list";
  static const kRequestedPropertiesListPath = "/requested-properties-list";
  static const kRecentlyVisitedPropertiesListPath =
      "/recently-visited-properties-list";
  static const kFilterPath = "/filter";
  static const kFavFilterPath = "/fav-filter";
  static const kOwnerFilterPath = "/owner-filter";
  static const kInReviewFilterPath = "/in-review-filter";
  static const kPersonalInformationPath = "/personal-information";
  static const kProfileDetailPath = "/profile-detail";
  static const kOwnerDetailsPath = "/property/details/owner-details/:${RouteArguments.userId}";
  static const kAddEditCertificatesPath =
      "/add-edit-certificates:${RouteArguments.isForPortfolio}/:${RouteArguments.isForEdit}";
  static const kViewAllCertificatesPath =
      "/view-all-certificates:${RouteArguments.isForPortfolio}/:${RouteArguments.isForPropertyDetail}";
  static const kPropertyNotFoundPath = "/property-not-found";
  static const kPropertyDetailPath =
      "/property-detail:${RouteArguments.propertyId}/:${RouteArguments.propertyLat}/:${RouteArguments.propertyLng}";
  static const kOwnerPropertyDetailPath =
      "/owner-property-detail:${RouteArguments.propertyId}/:${RouteArguments.propertyLat}/:${RouteArguments.propertyLng}";
  static const kAddEditPropertyScreen1Path =
      "/add-edit-property-1:${RouteArguments.id}";
  static const kAddEditPropertyScreen2Path = "/add-edit-property-2";
  static const kAddEditPropertyScreen3Path = "/add-edit-property-3";
  static const kAppPreferencesScreenPath = "/app-preferences";
  static const kAddRatingPath = "/add-rating";
  static const kVendorCategoriesPath = "/vendor-categories";
  static const kViewReviewPath =
      "/view-review:${RouteArguments.isReviewVisible}/:${RouteArguments.userAddedRating}";
  static const kBanksListPath =
      "/banks-list:${RouteArguments.propertyId}/:${RouteArguments.vendorId}";
  static const kBankDetailsPath =
      "/bank-details/:${RouteArguments.propertyId}/:${RouteArguments.vendorId}/:${RouteArguments.isForVendor}";
  static const kInvalidScreenPath = "/invalid";
  static const kMyOffersListPath = "/my-offers-list";
  static const kAddVendorOfferListPath = "/add-vendor-offer";
  static const kCityListPath = "/city-list";
  static const kVendorListPath = "/vendor-list";
  static const kVendorDetailPath = "/vendor-detail";
  static const kWebViewPath = "/webview:${RouteArguments.title}";
  static const kOfferListPath = "/offer-listing:${RouteArguments.offersList}";
  static const kOfferDetailPath =
      "/offer-details/:offerId/:${RouteArguments.isDraftOffer}";
  static const kHTMLViewerPath = "/html-viewer";
  static const kAddMyOffersListPath =
      "/add-my-offers-list:${RouteArguments.offersList}/:${RouteArguments.isMultiple}/:${RouteArguments.isFromDelete}";
  static const kOfferPricingPath = "/offer-pricing";
  static const kPricingCalculationResultsPath = "/pricing-calculation-results";
  static const kCarouselFullPath =
      "/carousel-fullscreen:${RouteArguments.index}";
  static const kCmsPath = "/cms-screen";
  static const kFinanceRequestPath = "/finance-request";
  static const kFinanceRequestDetailsPath = "/finance-request-details:${RouteArguments.requestId}";
  static const kSubscriptionInformation = "/subscription_information";
  static const kBanksOffer = "/banks-offer";
  static const kDrawerVendorList = "/drawervendor-list";
  static const kDrawerVendorDetail = "/drawervendor-detail";
  static const kVendorOfferAnalytics = "/vendor-offer-analytics";
  static const kOwnerOfferAnalytics = "/owner-offer-analytics";
}
