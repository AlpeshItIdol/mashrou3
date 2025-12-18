abstract class NetworkConstants {
  // static const kServerURL = "http://192.168.37.70:8000/api/";
  // static const kServerURL = "http://172.16.1.237:8000/api/";

  /// Staging
  // static const kServerURL = "https://devapigateway.devhostserver.com/api/";

  /// Staging 2
  // static const kServerURL = "https://apigateway.devhostserver.com/api/";

  ///Live
  static const kServerURL = "https://api.mashrou3.com/api/";

  // static const kServerURL = "https://devapigateway.devhostserver.com/api/";

  //   /// Staging 2
  //   // static const kServerURL = "https://apigateway.devhostserver.com/api/";
  //
  //   ///Live
  //   // static const kServerURL = "https://api.mashrou3.com/api/";
  //
  //   ///Local
  //   // static const kServerURL = "http://172.16.0.241:8000/api/";
  //
  //   static const kProduction = "$kServerURL/$kApiVersion";
  //
  //   static const kDevelopment = "$kServerURL/$kApiVersion";
  //
  //   static const kApiVersion = "v1/";
  //
  //   static const facebookMashrou3 =
  //       "https://www.facebook.com/profile.php?id=61575665194530";
  //   static const linkedInMashrou3 =
  //       "https://www.linkedin.com/company/mashrou3/about/?viewAsMember=true";
  //   static const instagramMashrou3 =
  //       "https://www.instagram.com/mashrou3d?igsh=N2xndmZxMWdiM3Rr&utm_source=ig_contact_invite";
  //
  //   //Offer actions
  //   static const kActionOfferApply = "add";
  //   static const kActionOfferRemove = "remove";

  ///Local
  // static const kServerURL = "http://172.16.0.241:8000/api/";

  static const kProduction = "$kServerURL/$kApiVersion";

  static const kDevelopment = "$kServerURL/$kApiVersion";

  static const kApiVersion = "v1/";

  static const facebookMashrou3 =
      "https://www.facebook.com/profile.php?id=61575665194530";
  static const linkedInMashrou3 =
      "https://www.linkedin.com/company/mashrou3/about/?viewAsMember=true";
  static const instagramMashrou3 =
      "https://www.instagram.com/mashrou3d?igsh=N2xndmZxMWdiM3Rr&utm_source=ig_contact_invite";

  //Offer actions
  static const kActionOfferApply = "add";
  static const kActionOfferRemove = "remove";
}

abstract class NetworkAPIs {
  // Login
  static const kLogin = "auth/login";

  // Login
  static const kLogout = "auth/logout";

  // Resend
  static const kResendOtp = "auth/resend-otp";

  // Register
  static const kRegister = "users/signUp";

  // Register
  static const kSignUpVerifyOTP = "users/verify-user";

  // Complete Profile
  static const kCompleteProfile = "users/update-user/";

  // Complete Profile
  static const kUpdateProfile = "users/update-profile/";

  // Delete Profile
  static const kDeleteProfile = "users/delete-account/";

  // Update Lang
  static const kUpdateLang = "users/update-language";

  // User Flag Details
  static const kUserFlagDetails = "users/get-flag/";

  // User Details
  static const kUserDetails = "users/get-user/";

  // Country List
  // static const kCountryList = "users/country-list";
  static const kCountryList = "country-management/country-listing";

  // City List
  // static const kCityList = "users/city-list";
  static const kCityList = "country-management/city-list";

  // City List
  static const kLanguageList = "users/language-list";

  static const kAllNotification =
      "notification/list?pagination=true&filter=All";

  static const kMarkAsReadNotification = "notification/read/";

  // property-categories
  static const kPropertyCategories = "property-category/list";

  // property-sub-categories
  static const kPropertySubCategories = "property-sub-category/list";

  // property-category-data
  static const kPropertyCategoryData = "property/category-data";

  // property-neighbourhood
  static const kPropertyNeighbourhood =
      "property/list-neighbourhood-categories";

  // property-amenity
  static const kPropertyAmenities = "property-amenity/list";

  // property-list
  static const kPropertyList = "property/list";

  // address-location
  static const kAddressLocation = "address-location/list";

  // property-list
  static const kVisitRequestsList = "request-management/list";

  // property-list
  static const kRecentVisitList = "property/recent-list";

  // Properties-With-Offers-list
  static const kPropertiesWithOffersList = "property-offer/applied-property";

  // property-living space
  static const kPropertyLivingSpace = "property/living-space";

  // add property
  static const kAddProperty = "property/add";

  // property view count
  static const kPropertyViewCount = "property/count";

  // bank view count
  static const kBankViewCount = "users/bank-count";

  //  property details
  static const kGetPropertyDetails = "property/get-property/";

  // add-fav
  static const kAddRemoveFav = "property/add-favorite";

  // sold-out-property
  static const kSoldOutProperty = "property/sold-out";

  // edit property
  static const kEditProperty = "property/update/";

  static const kEditReviewProperty = "property-review/update/";

  // delete property
  static const kDeleteProperty = "property/delete";

  // delete review property
  static const kDeleteReviewProperty = "property-review/delete";

  //furnished-type
  static const kFurnishedType = "property/furnished-type";

  //review-list
  static const kInReviewList = "property-review/list";

  //  review property details
  static const kGetReviewPropertyDetails = "property-review/";

  //  review property details
  static const kSendVisitRequest = "request-management/visit-request";

  //  review property details
  static const kApproveVisitRequest = "request-management/request";

  //finance-request-list
  static const kFinanceRequestList = "finance-request/finance-list-visitor";

  //filter-status-list
  static const kFilterStatusList = "property-management/filter/list";

  //filter-status-list
  static const kCurrencyList = "property/list-currency";

  //rating-review-add
  static const kAddRatingReview = "review-management/add-review";

  //view reviews
  static const kViewReview = "/review-management/get-review";

  //bank list
  static const kBanksList = "users/bank-list";

  // bank listing from memu
  static const kBanksMenuList = "bank-management/bank-list";

  //Vendor Category List
  static const kVendorCategoryList = "/vendor/vendor-list";

  //Vendor Category List For Property
  static const kVendorCategoryListForProperty = "/property-offer/category-list";

  //Vendor List
  static const kVendorList = "/users/vendor-offer-list";

  //Offers list
  static const kMyOffersList = "/property-offer/vendor-offer";

  // Draft vendor offer
  static const kMyReviewOffers = "/property-offer-review/list";

  // apply Offer
  static const kApplyMyOffer = "/property-offer/apply-offer";

  // apply vendor Offer
  static const kApplyVendorOffer = "/property-offer/apply-vendor-offer";

  // apply Offer
  static const kOffersListForProperty = "/property-offer/list";

  // price calculations
  static const kPriceCalculations = "/vendor-offer-management/price-calculations";

  // Add new vendor Offer
  static const kAddVendorOffer = "/property-offer/create-offer";
  static const kDeleteOffer = "/property-offer";
  static const kDeleteDraftOffer = "/property-offer-review";
  static const kUpdateOffer = "/property-offer/update";
  static const kUpdateDraftOffer = "/property-offer-review";
  static const kPropertyOffer = "/property-offer";
  static const kPropertyDraftOffer = "/property-offer-review";

  //  bank details
  static const kGetBankDetails = "users/get-bank/";

  //  add finance request
  static const kAddFinanceRequest = "finance-request/add";

  ///Finance Request Details
  static const kAddFinanceRequestDetails = "finance-request/detail";

  //  bank Property Offer
  static const kBankPropertyOffer = "bank-offer/property-offer";

  // vendor bank Property Offer
  static const kVendorBankPropertyOffer = "bank-vendor-offer/vendor-offer";

  // Notifications
  static const kNotifications = "notification/list";

  // Read Notification
  static const kReadNotification = "notification/read";

  // Save FCM Token
  static const kUpdateFCMToken = "users/update-fcm";

  static const kVendorPropertyOfferList =
      "property-offer/vendor-offer-property";
  static const kVBankOfferList =
      "users/bank-list";
// User Vendor List
  static const userVenderListCategories = "vendor/list";
  static const userVenderList = "users/vendor-list-sequence";


}

abstract class NetworkParams {
  static const kEmail = "email";
  static const kPassword = "password";
  static const kLimit = "limit";
  static const kCompanyLogo = "companyLogo";
  static const kConnectedBank = "connectedBank";
  static const kIdentityVerificationDoc = "identityVerificationDoc";
  static const kPortfolio = "portfolio";
  static const kUserType = "userType";
  static const kFirstName = "firstName";
  static const kLastName = "lastName";
  static const kLanguage = "language";
  static const kCity = "city";
  static const kCompanyName = "companyName";
  static const kCompanyDescription = "companyDescription";
  static const kVendorCategory = "vendorCategory";
  static const kSocialMediaLinks = "socialMediaLinks";
  static const kAlternativeContactNumbers = "alternativeContactNumbers";
  static const kLocation = "location";
  static const kNeighborLocation = "neighborLocation";
  static const kCategoryId = "categoryId";
  static const kSubCategoryId = "subCategoryId";
  static const kId = "id";
  static const kTitle = "title";
  static const kPrice = "price";
  static const kDescription = "description";
  static const kCost = "cost";
  static const kCountry = "country";
  static const kArea = "area";
  static const kFurnishedType = "furnishedType";
  static const kUnderConstruction = "underConstruction";
  static const kContactNumber = "contactNumber";
  static const kAlternateContactNumber = "alternateContactNumber";
  static const kVideoLink = "videoLink";
  static const kLocationKeys = "locationKeys";
  static const kVirtualTour = "virtualTour";
  static const kPropertyFiles = "propertyFiles";
  static const kPropertyThumbnail = "thumbnail";
  static const kNeighborhoodType = "neighborhoodType";
  static const kPropertyLocation = "propertyLocation";
  static const kLivingSpace = "livingSpace";
  static const kLivingSpaceId = "livingSpaceId";
  static const kValue = "value";
  static const kAmenities = "amenities";
  static const kDocuments = "documents";
  static const kVendorId = "vendorId";
  static const kPropertyId = "propertyId";
  static const kSortField = "sortField";
  static const kSortOrder = "sortOrder";
  static const kPage = "page";
  static const kItemPerPage = "itemsPerPage";
  static const kAction = "action";
  static const kValueAction = "onlyLogo";
}
