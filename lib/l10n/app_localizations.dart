import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @helloWorld.
  ///
  /// In en, this message translates to:
  /// **'Hello World!'**
  String get helloWorld;

  /// No description provided for @otpValidateInfo.
  ///
  /// In en, this message translates to:
  /// **'Your One-Time Password (OTP) will be sent via WhatsApp, not SMS.'**
  String get otpValidateInfo;

  /// No description provided for @btnSendVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Send Verification Code'**
  String get btnSendVerificationCode;

  /// No description provided for @lblLets.
  ///
  /// In en, this message translates to:
  /// **'Let\'s'**
  String get lblLets;

  /// No description provided for @lblLogIn.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get lblLogIn;

  /// No description provided for @lblCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get lblCountry;

  /// No description provided for @lblCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get lblCity;

  /// No description provided for @lblMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get lblMobileNumber;

  /// No description provided for @lblMobileNo.
  ///
  /// In en, this message translates to:
  /// **'Mobile No.'**
  String get lblMobileNo;

  /// No description provided for @lblLoginScreenMessage.
  ///
  /// In en, this message translates to:
  /// **'A comprehensive real estate solutions through an integrated platforms in a one app.'**
  String get lblLoginScreenMessage;

  /// No description provided for @textDontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don’t have an account?'**
  String get textDontHaveAccount;

  /// No description provided for @textSearchCountry.
  ///
  /// In en, this message translates to:
  /// **'Search country'**
  String get textSearchCountry;

  /// No description provided for @textSignUpNow.
  ///
  /// In en, this message translates to:
  /// **'Sign Up Now'**
  String get textSignUpNow;

  /// No description provided for @textSkipLogin.
  ///
  /// In en, this message translates to:
  /// **'Skip Login'**
  String get textSkipLogin;

  /// No description provided for @textGuest.
  ///
  /// In en, this message translates to:
  /// **'Guest User'**
  String get textGuest;

  /// No description provided for @textVisitorUser.
  ///
  /// In en, this message translates to:
  /// **'Visitor User'**
  String get textVisitorUser;

  /// No description provided for @textVendorUser.
  ///
  /// In en, this message translates to:
  /// **'Vendor User'**
  String get textVendorUser;

  /// No description provided for @textOwnerUser.
  ///
  /// In en, this message translates to:
  /// **'Owner User'**
  String get textOwnerUser;

  /// No description provided for @textBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get textBack;

  /// No description provided for @textBackToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back To Login'**
  String get textBackToLogin;

  /// No description provided for @textCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get textCancel;

  /// No description provided for @textResendIn.
  ///
  /// In en, this message translates to:
  /// **'Resend in'**
  String get textResendIn;

  /// No description provided for @textNoData.
  ///
  /// In en, this message translates to:
  /// **'No Data'**
  String get textNoData;

  /// No description provided for @textErrorLoadingCities.
  ///
  /// In en, this message translates to:
  /// **'Error loading cities. Please try again.'**
  String get textErrorLoadingCities;

  /// No description provided for @textErrorLoadingMoreCities.
  ///
  /// In en, this message translates to:
  /// **'Error loading more cities.'**
  String get textErrorLoadingMoreCities;

  /// No description provided for @textClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get textClear;

  /// No description provided for @textChooseCountry.
  ///
  /// In en, this message translates to:
  /// **'Choose country'**
  String get textChooseCountry;

  /// No description provided for @btnVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get btnVerify;

  /// No description provided for @btnResend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get btnResend;

  /// No description provided for @lblWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get lblWelcome;

  /// No description provided for @lblAboard.
  ///
  /// In en, this message translates to:
  /// **'Aboard!'**
  String get lblAboard;

  /// No description provided for @lblComplete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get lblComplete;

  /// No description provided for @lblProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile!'**
  String get lblProfile;

  /// No description provided for @lblOtp.
  ///
  /// In en, this message translates to:
  /// **'OTP'**
  String get lblOtp;

  /// No description provided for @lblVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get lblVerificationCode;

  /// No description provided for @lblStartYourJourneyAs.
  ///
  /// In en, this message translates to:
  /// **'Start your journey as...'**
  String get lblStartYourJourneyAs;

  /// No description provided for @lblFirstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get lblFirstName;

  /// No description provided for @lblLastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lblLastName;

  /// No description provided for @lblEmailID.
  ///
  /// In en, this message translates to:
  /// **'Email ID'**
  String get lblEmailID;

  /// No description provided for @lblSelectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get lblSelectLanguage;

  /// No description provided for @lblSelectCountry.
  ///
  /// In en, this message translates to:
  /// **'Select Country'**
  String get lblSelectCountry;

  /// No description provided for @lblSelectCurrency.
  ///
  /// In en, this message translates to:
  /// **'Select Currency'**
  String get lblSelectCurrency;

  /// No description provided for @lblCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get lblCurrency;

  /// No description provided for @lblSelectCity.
  ///
  /// In en, this message translates to:
  /// **'Select City'**
  String get lblSelectCity;

  /// No description provided for @lblSelectVendor.
  ///
  /// In en, this message translates to:
  /// **'Select Vendor Type'**
  String get lblSelectVendor;

  /// No description provided for @lblSelectBank.
  ///
  /// In en, this message translates to:
  /// **'Select Bank'**
  String get lblSelectBank;

  /// No description provided for @lblCompanyName.
  ///
  /// In en, this message translates to:
  /// **'Company Name'**
  String get lblCompanyName;

  /// No description provided for @lblBankName.
  ///
  /// In en, this message translates to:
  /// **'Bank Name'**
  String get lblBankName;

  /// No description provided for @lblVendorType.
  ///
  /// In en, this message translates to:
  /// **'Vendor Type'**
  String get lblVendorType;

  /// No description provided for @lblBank.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get lblBank;

  /// No description provided for @lblAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get lblAddress;

  /// No description provided for @lblWebsite.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get lblWebsite;

  /// No description provided for @lblCatalog.
  ///
  /// In en, this message translates to:
  /// **'Catalog'**
  String get lblCatalog;

  /// No description provided for @lblSocialMedia.
  ///
  /// In en, this message translates to:
  /// **'Social Media'**
  String get lblSocialMedia;

  /// No description provided for @lblDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get lblDescription;

  /// No description provided for @lblWebsiteLink.
  ///
  /// In en, this message translates to:
  /// **'Website Link'**
  String get lblWebsiteLink;

  /// No description provided for @lblFacebookLink.
  ///
  /// In en, this message translates to:
  /// **'Facebook Link'**
  String get lblFacebookLink;

  /// No description provided for @lblInstagramLink.
  ///
  /// In en, this message translates to:
  /// **'Instagram Link'**
  String get lblInstagramLink;

  /// No description provided for @lblLinkedInLink.
  ///
  /// In en, this message translates to:
  /// **'LinkedIn Link'**
  String get lblLinkedInLink;

  /// No description provided for @lblTwitterLink.
  ///
  /// In en, this message translates to:
  /// **'X Link'**
  String get lblTwitterLink;

  /// No description provided for @lblCatalogLink.
  ///
  /// In en, this message translates to:
  /// **'Catalog Link'**
  String get lblCatalogLink;

  /// No description provided for @lbl3DVirtualTourLink.
  ///
  /// In en, this message translates to:
  /// **'3D Virtual Tour'**
  String get lbl3DVirtualTourLink;

  /// No description provided for @lblProfileLink.
  ///
  /// In en, this message translates to:
  /// **'Profile Link'**
  String get lblProfileLink;

  /// No description provided for @lblGoogleLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get lblGoogleLocation;

  /// No description provided for @lblUploadLogo.
  ///
  /// In en, this message translates to:
  /// **'Upload Logo'**
  String get lblUploadLogo;

  /// No description provided for @lblDocuments.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get lblDocuments;

  /// No description provided for @thumbnail.
  ///
  /// In en, this message translates to:
  /// **'Thumbnail'**
  String get thumbnail;

  /// No description provided for @lblViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get lblViewAll;

  /// No description provided for @lblAlternateMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Alternate Mobile Number'**
  String get lblAlternateMobileNumber;

  /// No description provided for @lblAlternateMobileNo.
  ///
  /// In en, this message translates to:
  /// **'Alternate Mobile No.'**
  String get lblAlternateMobileNo;

  /// No description provided for @lblLogoutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get lblLogoutConfirmation;

  /// No description provided for @btnNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get btnNext;

  /// No description provided for @btnDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get btnDone;

  /// No description provided for @btnLogOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get btnLogOut;

  /// No description provided for @btnSendRequest.
  ///
  /// In en, this message translates to:
  /// **'Send Request'**
  String get btnSendRequest;

  /// No description provided for @btnAddReview.
  ///
  /// In en, this message translates to:
  /// **'Add Review'**
  String get btnAddReview;

  /// No description provided for @textYourAccountIsCurrentlyUndergoingVerification.
  ///
  /// In en, this message translates to:
  /// **'Your account is currently undergoing verification.'**
  String get textYourAccountIsCurrentlyUndergoingVerification;

  /// No description provided for @textPleaseWaitForApproval.
  ///
  /// In en, this message translates to:
  /// **'Please wait for approval.'**
  String get textPleaseWaitForApproval;

  /// No description provided for @textPropertyNotFound.
  ///
  /// In en, this message translates to:
  /// **'Property Not Found!'**
  String get textPropertyNotFound;

  /// No description provided for @textThePropertyYouAreLookingFor.
  ///
  /// In en, this message translates to:
  /// **'The property you\'re looking for doesn\'t exist or is no longer available.'**
  String get textThePropertyYouAreLookingFor;

  /// No description provided for @textSetUpYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Set Up Your Account'**
  String get textSetUpYourAccount;

  /// No description provided for @textSetUpYourVisitorAccount.
  ///
  /// In en, this message translates to:
  /// **'Set Up Your Visitor Account'**
  String get textSetUpYourVisitorAccount;

  /// No description provided for @textSetUpYourVendorAccount.
  ///
  /// In en, this message translates to:
  /// **'Set Up Your Vendor Account'**
  String get textSetUpYourVendorAccount;

  /// No description provided for @textSetUpYourRealEstateOwnerAccount.
  ///
  /// In en, this message translates to:
  /// **'Set Up Your Real Estate Owner Account'**
  String get textSetUpYourRealEstateOwnerAccount;

  /// No description provided for @textFillYourDetails.
  ///
  /// In en, this message translates to:
  /// **'Fill in Your Details to Complete Your Profile'**
  String get textFillYourDetails;

  /// No description provided for @textHowDoYouWantToSignUp.
  ///
  /// In en, this message translates to:
  /// **'How do you want to sign up'**
  String get textHowDoYouWantToSignUp;

  /// No description provided for @textPleaseEnterOTP.
  ///
  /// In en, this message translates to:
  /// **'Please enter OTP to confirm your number'**
  String get textPleaseEnterOTP;

  /// No description provided for @textVisitor.
  ///
  /// In en, this message translates to:
  /// **'Visitor'**
  String get textVisitor;

  /// No description provided for @textVisitorDetails.
  ///
  /// In en, this message translates to:
  /// **'Discover freely, register smartly!'**
  String get textVisitorDetails;

  /// No description provided for @textVendor.
  ///
  /// In en, this message translates to:
  /// **'Vendors'**
  String get textVendor;

  /// No description provided for @textVendorDetails.
  ///
  /// In en, this message translates to:
  /// **'List fast, sell vast!'**
  String get textVendorDetails;

  /// No description provided for @textRealEstateOwner.
  ///
  /// In en, this message translates to:
  /// **'Real Estate Owner'**
  String get textRealEstateOwner;

  /// No description provided for @textRealEstateOwnerDetails.
  ///
  /// In en, this message translates to:
  /// **'Own, list, profit—your way!'**
  String get textRealEstateOwnerDetails;

  /// No description provided for @textRegisteredAndUnregistered.
  ///
  /// In en, this message translates to:
  /// **'Registered and unregistered users'**
  String get textRegisteredAndUnregistered;

  /// No description provided for @textSearchForABuilding.
  ///
  /// In en, this message translates to:
  /// **'Search for a building, street or ...'**
  String get textSearchForABuilding;

  /// No description provided for @lblHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get lblHome;

  /// No description provided for @lblFavourite.
  ///
  /// In en, this message translates to:
  /// **'Favourite'**
  String get lblFavourite;

  /// No description provided for @lblMyOffer.
  ///
  /// In en, this message translates to:
  /// **'My Offer'**
  String get lblMyOffer;

  /// No description provided for @lblMyOffers.
  ///
  /// In en, this message translates to:
  /// **'My Offers'**
  String get lblMyOffers;

  /// No description provided for @addOffer.
  ///
  /// In en, this message translates to:
  /// **'Add Offer'**
  String get addOffer;

  /// No description provided for @applyOffer.
  ///
  /// In en, this message translates to:
  /// **'Apply Offer'**
  String get applyOffer;

  /// No description provided for @removeOffer.
  ///
  /// In en, this message translates to:
  /// **'Remove Offer'**
  String get removeOffer;

  /// No description provided for @textAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get textAdd;

  /// No description provided for @lblPropertiesWithOffers.
  ///
  /// In en, this message translates to:
  /// **'Properties with Offers'**
  String get lblPropertiesWithOffers;

  /// No description provided for @lblNotification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get lblNotification;

  /// No description provided for @lblPropertyListing.
  ///
  /// In en, this message translates to:
  /// **'Property Listing'**
  String get lblPropertyListing;

  /// No description provided for @lblContactNow.
  ///
  /// In en, this message translates to:
  /// **'Contact Now'**
  String get lblContactNow;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @textFound.
  ///
  /// In en, this message translates to:
  /// **'Found'**
  String get textFound;

  /// No description provided for @btnBankProperty.
  ///
  /// In en, this message translates to:
  /// **'Bank Property'**
  String get btnBankProperty;

  /// No description provided for @textSelectProperties.
  ///
  /// In en, this message translates to:
  /// **'Select Properties'**
  String get textSelectProperties;

  /// No description provided for @textSelectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get textSelectAll;

  /// No description provided for @lblProperty.
  ///
  /// In en, this message translates to:
  /// **'property'**
  String get lblProperty;

  /// No description provided for @lblProperties.
  ///
  /// In en, this message translates to:
  /// **'properties'**
  String get lblProperties;

  /// No description provided for @textDirectCall.
  ///
  /// In en, this message translates to:
  /// **'Direct Call'**
  String get textDirectCall;

  /// No description provided for @textWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get textWhatsApp;

  /// No description provided for @textTextMessage.
  ///
  /// In en, this message translates to:
  /// **'Text Message'**
  String get textTextMessage;

  /// No description provided for @lblGetFinance.
  ///
  /// In en, this message translates to:
  /// **'Get Finance'**
  String get lblGetFinance;

  /// No description provided for @financeRequest.
  ///
  /// In en, this message translates to:
  /// **'Finance Request'**
  String get financeRequest;

  /// No description provided for @lblVendorOfferAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Vendor Offer Analytics'**
  String get lblVendorOfferAnalytics;

  /// No description provided for @lblOwnerOfferAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Owner Offer Analytics'**
  String get lblOwnerOfferAnalytics;

  /// No description provided for @textForRealEstate.
  ///
  /// In en, this message translates to:
  /// **'For Real Estate'**
  String get textForRealEstate;

  /// No description provided for @textSelectVendor.
  ///
  /// In en, this message translates to:
  /// **'Select Vendor'**
  String get textSelectVendor;

  /// No description provided for @lblSortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get lblSortBy;

  /// No description provided for @textNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get textNewest;

  /// No description provided for @textPriceLowToHigh.
  ///
  /// In en, this message translates to:
  /// **'Price - Low to High'**
  String get textPriceLowToHigh;

  /// No description provided for @textPriceHighToLow.
  ///
  /// In en, this message translates to:
  /// **'Price - High to Low'**
  String get textPriceHighToLow;

  /// No description provided for @textAscending.
  ///
  /// In en, this message translates to:
  /// **'Ascending'**
  String get textAscending;

  /// No description provided for @textDescending.
  ///
  /// In en, this message translates to:
  /// **'Descending'**
  String get textDescending;

  /// No description provided for @textNearest.
  ///
  /// In en, this message translates to:
  /// **'Nearest'**
  String get textNearest;

  /// No description provided for @textFurthest.
  ///
  /// In en, this message translates to:
  /// **'Furthest'**
  String get textFurthest;

  /// No description provided for @textAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get textAll;

  /// No description provided for @lblFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get lblFavorites;

  /// No description provided for @lblMyProperties.
  ///
  /// In en, this message translates to:
  /// **'My Properties'**
  String get lblMyProperties;

  /// No description provided for @lblRequestedProperties.
  ///
  /// In en, this message translates to:
  /// **'Requested Properties'**
  String get lblRequestedProperties;

  /// No description provided for @lblRecentlyVisitedProperties.
  ///
  /// In en, this message translates to:
  /// **'Recently Visited'**
  String get lblRecentlyVisitedProperties;

  /// No description provided for @textVisitRequestApproved.
  ///
  /// In en, this message translates to:
  /// **'Visit Request Approved !'**
  String get textVisitRequestApproved;

  /// No description provided for @textVisitRequestRejected.
  ///
  /// In en, this message translates to:
  /// **'Visit Request Rejected !'**
  String get textVisitRequestRejected;

  /// No description provided for @btnApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get btnApproved;

  /// No description provided for @btnPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get btnPending;

  /// No description provided for @btnRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get btnRejected;

  /// No description provided for @lblPersonalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get lblPersonalInformation;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @lblCertificates.
  ///
  /// In en, this message translates to:
  /// **'Certificates'**
  String get lblCertificates;

  /// No description provided for @lblEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get lblEdit;

  /// No description provided for @lblDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get lblDeleteAccount;

  /// No description provided for @lblConfirmAccountDeletion.
  ///
  /// In en, this message translates to:
  /// **'Confirm Account Deletion!'**
  String get lblConfirmAccountDeletion;

  /// No description provided for @textDeletingYourAccountWill.
  ///
  /// In en, this message translates to:
  /// **'Deleting your account will remove all your data permanently. This action cannot be undone.'**
  String get textDeletingYourAccountWill;

  /// No description provided for @lblBanks.
  ///
  /// In en, this message translates to:
  /// **'Banks'**
  String get lblBanks;

  /// No description provided for @lblBankDetails.
  ///
  /// In en, this message translates to:
  /// **'Bank Details'**
  String get lblBankDetails;

  /// No description provided for @lblOffers.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get lblOffers;

  /// No description provided for @noOffers.
  ///
  /// In en, this message translates to:
  /// **'There are no offers to display right now.Check back later to explore available options.'**
  String get noOffers;

  /// No description provided for @lblContactDetails.
  ///
  /// In en, this message translates to:
  /// **'Contact Details'**
  String get lblContactDetails;

  /// No description provided for @noContactDetails.
  ///
  /// In en, this message translates to:
  /// **'No contact numbers are currently available.Please check back later.'**
  String get noContactDetails;

  /// No description provided for @lblEditInformation.
  ///
  /// In en, this message translates to:
  /// **'Edit Information'**
  String get lblEditInformation;

  /// No description provided for @lblNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get lblNew;

  /// No description provided for @browse.
  ///
  /// In en, this message translates to:
  /// **'Browse'**
  String get browse;

  /// No description provided for @lblNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get lblNotifications;

  /// No description provided for @emptyNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notification available'**
  String get emptyNotifications;

  /// No description provided for @emptyNotificationsInfo.
  ///
  /// In en, this message translates to:
  /// **'There are no notifications at the moment. Check back later for updates or important alerts.'**
  String get emptyNotificationsInfo;

  /// No description provided for @textPleaseSelect.
  ///
  /// In en, this message translates to:
  /// **'Please select'**
  String get textPleaseSelect;

  /// No description provided for @textPleaseSelectAtLeastOne.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one'**
  String get textPleaseSelectAtLeastOne;

  /// No description provided for @maximumLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Maximum limit reached: You’re allowed to add up to 10 files only!'**
  String get maximumLimitReached;

  /// No description provided for @nearBy.
  ///
  /// In en, this message translates to:
  /// **'Nearby Places'**
  String get nearBy;

  /// No description provided for @findingPlace.
  ///
  /// In en, this message translates to:
  /// **'Finding place...'**
  String get findingPlace;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// No description provided for @results.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get results;

  /// No description provided for @result.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get result;

  /// No description provided for @unnamedLocation.
  ///
  /// In en, this message translates to:
  /// **'Unnamed location'**
  String get unnamedLocation;

  /// No description provided for @selectActionLocation.
  ///
  /// In en, this message translates to:
  /// **'Confirm Location'**
  String get selectActionLocation;

  /// No description provided for @offerTitleEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please enter an offer title'**
  String get offerTitleEmptyError;

  /// No description provided for @offerCostEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please enter an offer cost'**
  String get offerCostEmptyError;

  /// No description provided for @firstNameEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a first name'**
  String get firstNameEmptyError;

  /// No description provided for @lastNameEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a last name'**
  String get lastNameEmptyError;

  /// No description provided for @companyNameEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a company name'**
  String get companyNameEmptyError;

  /// No description provided for @websiteLinkEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a website link'**
  String get websiteLinkEmptyError;

  /// No description provided for @descriptionEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a note'**
  String get descriptionEmptyError;

  /// No description provided for @descriptionFieldEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a description'**
  String get descriptionFieldEmptyError;

  /// No description provided for @emailEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please enter an email address'**
  String get emailEmptyError;

  /// No description provided for @addressEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please enter an address'**
  String get addressEmptyError;

  /// No description provided for @passwordEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a password'**
  String get passwordEmptyError;

  /// No description provided for @languageEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please select a language'**
  String get languageEmptyError;

  /// No description provided for @cityEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please select a city'**
  String get cityEmptyError;

  /// No description provided for @vendorTypeEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please select a vendor type'**
  String get vendorTypeEmptyError;

  /// No description provided for @bankSelectionEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please select a bank'**
  String get bankSelectionEmptyError;

  /// No description provided for @locationEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please select a location'**
  String get locationEmptyError;

  /// No description provided for @logoEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please select a logo'**
  String get logoEmptyError;

  /// No description provided for @documentsEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please select a documents'**
  String get documentsEmptyError;

  /// No description provided for @countryNameEmptyValidationMsg.
  ///
  /// In en, this message translates to:
  /// **'Please select a country'**
  String get countryNameEmptyValidationMsg;

  /// No description provided for @confirmPasswordEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a confirm password'**
  String get confirmPasswordEmptyError;

  /// No description provided for @passwordNotMatchError.
  ///
  /// In en, this message translates to:
  /// **'Password doesn\'t match'**
  String get passwordNotMatchError;

  /// No description provided for @invalidEmailError.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get invalidEmailError;

  /// No description provided for @emptyOTPError.
  ///
  /// In en, this message translates to:
  /// **'OTP cannot be empty'**
  String get emptyOTPError;

  /// No description provided for @otpLengthError.
  ///
  /// In en, this message translates to:
  /// **'OTP must be 4 digits'**
  String get otpLengthError;

  /// No description provided for @countryCodeEmptyValidationMsg.
  ///
  /// In en, this message translates to:
  /// **'Please select country code'**
  String get countryCodeEmptyValidationMsg;

  /// No description provided for @phoneNumberEmptyErrorMsg.
  ///
  /// In en, this message translates to:
  /// **'Please enter mobile number'**
  String get phoneNumberEmptyErrorMsg;

  /// No description provided for @phoneNumberValidErrorMsg.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid mobile number'**
  String get phoneNumberValidErrorMsg;

  /// No description provided for @notesEmptyErrorMsg.
  ///
  /// In en, this message translates to:
  /// **'Please enter notes'**
  String get notesEmptyErrorMsg;

  /// No description provided for @currencyEmptyValidationMsg.
  ///
  /// In en, this message translates to:
  /// **'Please select currency'**
  String get currencyEmptyValidationMsg;

  /// No description provided for @offerSelectionErrorMsg.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one offer to proceed'**
  String get offerSelectionErrorMsg;

  /// No description provided for @certificateEmptyErrorMsg.
  ///
  /// In en, this message translates to:
  /// **'Please add at least one certificate to proceed'**
  String get certificateEmptyErrorMsg;

  /// No description provided for @portfolioEmptyErrorMsg.
  ///
  /// In en, this message translates to:
  /// **'Please add at least one portfolio to proceed'**
  String get portfolioEmptyErrorMsg;

  /// No description provided for @termsAgreementErrorMsg.
  ///
  /// In en, this message translates to:
  /// **'Please accept the terms and conditions to proceed'**
  String get termsAgreementErrorMsg;

  /// No description provided for @passwordInvalidError.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one uppercase letter, one lowercase letter, one digit, one special character, and be at least 8 characters long'**
  String get passwordInvalidError;

  /// No description provided for @emptyPropertyList.
  ///
  /// In en, this message translates to:
  /// **'The Property List is Empty.'**
  String get emptyPropertyList;

  /// No description provided for @emptyPropertyListInfo.
  ///
  /// In en, this message translates to:
  /// **'There are no properties to display right now. Check back later to explore available options.'**
  String get emptyPropertyListInfo;

  /// No description provided for @emptyVisitRequestsList.
  ///
  /// In en, this message translates to:
  /// **'The Visit Requests List is Empty.'**
  String get emptyVisitRequestsList;

  /// No description provided for @emptyVisitRequestsListInfo.
  ///
  /// In en, this message translates to:
  /// **'There are no visit requests to display right now. Check back later to explore available options.'**
  String get emptyVisitRequestsListInfo;

  /// No description provided for @emptyFinanceRequestsList.
  ///
  /// In en, this message translates to:
  /// **'The Finance Request List is Empty.'**
  String get emptyFinanceRequestsList;

  /// No description provided for @emptyFinanceRequestsListInfo.
  ///
  /// In en, this message translates to:
  /// **'There are no finance requests to display right now.'**
  String get emptyFinanceRequestsListInfo;

  /// No description provided for @emptyBanksList.
  ///
  /// In en, this message translates to:
  /// **'The Banks List is Empty.'**
  String get emptyBanksList;

  /// No description provided for @emptyBanksListInfo.
  ///
  /// In en, this message translates to:
  /// **'There are no banks to display right now. Check back later to explore available options.'**
  String get emptyBanksListInfo;

  /// No description provided for @emptyOffersList.
  ///
  /// In en, this message translates to:
  /// **'The Offers List is Empty.'**
  String get emptyOffersList;

  /// No description provided for @emptyOffersListInfo.
  ///
  /// In en, this message translates to:
  /// **'There are no offers to display right now.'**
  String get emptyOffersListInfo;

  /// No description provided for @lblApprovedProperties.
  ///
  /// In en, this message translates to:
  /// **'Approved Properties'**
  String get lblApprovedProperties;

  /// No description provided for @lblSoldOutProperties.
  ///
  /// In en, this message translates to:
  /// **'Sold Out Properties'**
  String get lblSoldOutProperties;

  /// No description provided for @inReview.
  ///
  /// In en, this message translates to:
  /// **'In Review'**
  String get inReview;

  /// No description provided for @textSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get textSearch;

  /// No description provided for @textRecentSearch.
  ///
  /// In en, this message translates to:
  /// **'Recent Searches'**
  String get textRecentSearch;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @recentlyVisited.
  ///
  /// In en, this message translates to:
  /// **'Recently Visited'**
  String get recentlyVisited;

  /// No description provided for @requestedProperties.
  ///
  /// In en, this message translates to:
  /// **'Requested Properties'**
  String get requestedProperties;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsAndConditions;

  /// No description provided for @appPreferences.
  ///
  /// In en, this message translates to:
  /// **'App Preferences'**
  String get appPreferences;

  /// No description provided for @switchToArabic.
  ///
  /// In en, this message translates to:
  /// **'Switch to Arabic'**
  String get switchToArabic;

  /// No description provided for @switchToDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Switch to dark mode'**
  String get switchToDarkMode;

  /// No description provided for @switchToLightMode.
  ///
  /// In en, this message translates to:
  /// **'Switch to light mode'**
  String get switchToLightMode;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @supportAndSocialMedia.
  ///
  /// In en, this message translates to:
  /// **'Support & Social Links'**
  String get supportAndSocialMedia;

  /// No description provided for @license.
  ///
  /// In en, this message translates to:
  /// **'Licence'**
  String get license;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;

  /// No description provided for @alert.
  ///
  /// In en, this message translates to:
  /// **'Alert!'**
  String get alert;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @selectLocation.
  ///
  /// In en, this message translates to:
  /// **'Select Location'**
  String get selectLocation;

  /// No description provided for @yourLocation.
  ///
  /// In en, this message translates to:
  /// **'Your location'**
  String get yourLocation;

  /// No description provided for @grantLocationToViewDistance.
  ///
  /// In en, this message translates to:
  /// **'(Grant location access)'**
  String get grantLocationToViewDistance;

  /// No description provided for @permissionDenied.
  ///
  /// In en, this message translates to:
  /// **'You have to open settings app and provide location permission manually.'**
  String get permissionDenied;

  /// No description provided for @wantToLogOut.
  ///
  /// In en, this message translates to:
  /// **'Want to log out?'**
  String get wantToLogOut;

  /// No description provided for @logoutInfo.
  ///
  /// In en, this message translates to:
  /// **'You will be signed out of your account and will need to log in again to access your information.'**
  String get logoutInfo;

  /// No description provided for @lblLogInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Log In to Continue'**
  String get lblLogInToContinue;

  /// No description provided for @textPleaseLogIn.
  ///
  /// In en, this message translates to:
  /// **'Please log in to access these feature.'**
  String get textPleaseLogIn;

  /// No description provided for @lblCompleteProfileToContinue.
  ///
  /// In en, this message translates to:
  /// **'Complete Profile to Continue'**
  String get lblCompleteProfileToContinue;

  /// No description provided for @textPleaseAddDetails.
  ///
  /// In en, this message translates to:
  /// **'Please add your details to access this feature and continue exploring our services.'**
  String get textPleaseAddDetails;

  /// No description provided for @rejectionReason.
  ///
  /// In en, this message translates to:
  /// **'Rejection Reason'**
  String get rejectionReason;

  /// No description provided for @readMore.
  ///
  /// In en, this message translates to:
  /// **'Read more'**
  String get readMore;

  /// No description provided for @readLess.
  ///
  /// In en, this message translates to:
  /// **'Read less'**
  String get readLess;

  /// No description provided for @lblVisitRequest.
  ///
  /// In en, this message translates to:
  /// **'Visit Request'**
  String get lblVisitRequest;

  /// No description provided for @lblVisitRequests.
  ///
  /// In en, this message translates to:
  /// **'Visit Requests'**
  String get lblVisitRequests;

  /// No description provided for @lblNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get lblNotes;

  /// No description provided for @lblNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get lblNote;

  /// No description provided for @rejectedReason.
  ///
  /// In en, this message translates to:
  /// **'Rejected Reason'**
  String get rejectedReason;

  /// No description provided for @lblDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get lblDate;

  /// No description provided for @lblVisitorName.
  ///
  /// In en, this message translates to:
  /// **'Visitor Name'**
  String get lblVisitorName;

  /// No description provided for @lblTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get lblTime;

  /// No description provided for @lblSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get lblSelectDate;

  /// No description provided for @lblSelectTime.
  ///
  /// In en, this message translates to:
  /// **'Select Time'**
  String get lblSelectTime;

  /// No description provided for @lblVisitRequestRejectionReason.
  ///
  /// In en, this message translates to:
  /// **'Visit request rejection reason'**
  String get lblVisitRequestRejectionReason;

  /// No description provided for @btnOptions.
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get btnOptions;

  /// No description provided for @btnApprove.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get btnApprove;

  /// No description provided for @btnReject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get btnReject;

  /// No description provided for @btnSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get btnSend;

  /// No description provided for @btnContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get btnContinue;

  /// No description provided for @textJoinedOn.
  ///
  /// In en, this message translates to:
  /// **'Joined on'**
  String get textJoinedOn;

  /// No description provided for @textReviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get textReviews;

  /// No description provided for @fullyBuilt.
  ///
  /// In en, this message translates to:
  /// **'Fully Built'**
  String get fullyBuilt;

  /// No description provided for @underConstruction.
  ///
  /// In en, this message translates to:
  /// **'Under Construction'**
  String get underConstruction;

  /// No description provided for @deleteProperty.
  ///
  /// In en, this message translates to:
  /// **'Delete Property'**
  String get deleteProperty;

  /// No description provided for @soldOut.
  ///
  /// In en, this message translates to:
  /// **'Sold Out'**
  String get soldOut;

  /// No description provided for @addProperty.
  ///
  /// In en, this message translates to:
  /// **'Add Property'**
  String get addProperty;

  /// No description provided for @editProperty.
  ///
  /// In en, this message translates to:
  /// **'Edit Property'**
  String get editProperty;

  /// No description provided for @generalInformation.
  ///
  /// In en, this message translates to:
  /// **'General Information'**
  String get generalInformation;

  /// No description provided for @propertyCategory.
  ///
  /// In en, this message translates to:
  /// **'Property Category'**
  String get propertyCategory;

  /// No description provided for @selectPropertyCategory.
  ///
  /// In en, this message translates to:
  /// **'Select Property Category'**
  String get selectPropertyCategory;

  /// No description provided for @propertySubCategory.
  ///
  /// In en, this message translates to:
  /// **'Property Sub Category'**
  String get propertySubCategory;

  /// No description provided for @selectSubPropertyCategory.
  ///
  /// In en, this message translates to:
  /// **'Select Property Sub Category'**
  String get selectSubPropertyCategory;

  /// No description provided for @dateEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please select a date'**
  String get dateEmptyError;

  /// No description provided for @timeEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please select a time'**
  String get timeEmptyError;

  /// No description provided for @propertyCategoryEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please select a property category'**
  String get propertyCategoryEmptyError;

  /// No description provided for @propertySubCategoryEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please select a property sub category'**
  String get propertySubCategoryEmptyError;

  /// No description provided for @propertyNeighbourhoodEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please select the neighbourhood type'**
  String get propertyNeighbourhoodEmptyError;

  /// No description provided for @propertyTitle.
  ///
  /// In en, this message translates to:
  /// **'Property Title'**
  String get propertyTitle;

  /// No description provided for @propertyTitleEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please provide a title for the property.'**
  String get propertyTitleEmptyError;

  /// No description provided for @propertyPrice.
  ///
  /// In en, this message translates to:
  /// **'Property Price'**
  String get propertyPrice;

  /// No description provided for @propertyPriceEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please provide the price of the property.'**
  String get propertyPriceEmptyError;

  /// No description provided for @propertyArea.
  ///
  /// In en, this message translates to:
  /// **'Property Area'**
  String get propertyArea;

  /// No description provided for @propertyAreaEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please specify the area of the property.'**
  String get propertyAreaEmptyError;

  /// No description provided for @videoLink.
  ///
  /// In en, this message translates to:
  /// **'Video Links'**
  String get videoLink;

  /// No description provided for @link.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get link;

  /// No description provided for @errorMaxVideos.
  ///
  /// In en, this message translates to:
  /// **'Only 3 videos are allowed'**
  String get errorMaxVideos;

  /// No description provided for @errorMaxLinks.
  ///
  /// In en, this message translates to:
  /// **'Only 3 links are allowed'**
  String get errorMaxLinks;

  /// No description provided for @errorMaxAddresses.
  ///
  /// In en, this message translates to:
  /// **'Only 3 addresses are allowed'**
  String get errorMaxAddresses;

  /// No description provided for @errorDuplicateLink.
  ///
  /// In en, this message translates to:
  /// **'Duplicate video links are not allowed'**
  String get errorDuplicateLink;

  /// No description provided for @propertyDescription.
  ///
  /// In en, this message translates to:
  /// **'Property Description'**
  String get propertyDescription;

  /// No description provided for @documents.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documents;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @propertyTitlePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter property title'**
  String get propertyTitlePlaceholder;

  /// No description provided for @pricePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter property price'**
  String get pricePlaceholder;

  /// No description provided for @areaPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter property area'**
  String get areaPlaceholder;

  /// No description provided for @mobileNumberPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number'**
  String get mobileNumberPlaceholder;

  /// No description provided for @altMobileNumberPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter your alternate mobile number'**
  String get altMobileNumberPlaceholder;

  /// No description provided for @threeDTourLinkPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter 3D tour link'**
  String get threeDTourLinkPlaceholder;

  /// No description provided for @videoTourLinkPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter video tour link'**
  String get videoTourLinkPlaceholder;

  /// No description provided for @descriptionPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter property description'**
  String get descriptionPlaceholder;

  /// No description provided for @locationInformation.
  ///
  /// In en, this message translates to:
  /// **'Location Information'**
  String get locationInformation;

  /// No description provided for @selectNeighborhood.
  ///
  /// In en, this message translates to:
  /// **'Select Neighbourhood'**
  String get selectNeighborhood;

  /// No description provided for @propertyNeighborhoodType.
  ///
  /// In en, this message translates to:
  /// **'Neighbourhood Type'**
  String get propertyNeighborhoodType;

  /// No description provided for @propertyNeighborhoodTypeEmptyError.
  ///
  /// In en, this message translates to:
  /// **'You must select at least one neighbourhood type.'**
  String get propertyNeighborhoodTypeEmptyError;

  /// No description provided for @propertyNeighborhood.
  ///
  /// In en, this message translates to:
  /// **'Property Neighbourhood'**
  String get propertyNeighborhood;

  /// No description provided for @locationTitle.
  ///
  /// In en, this message translates to:
  /// **'Location Title'**
  String get locationTitle;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @propertyLocationEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please select the property location'**
  String get propertyLocationEmptyError;

  /// No description provided for @propertyNearByLocationEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please enter the location title'**
  String get propertyNearByLocationEmptyError;

  /// No description provided for @propertyLocation.
  ///
  /// In en, this message translates to:
  /// **'Property Location'**
  String get propertyLocation;

  /// No description provided for @livingSpaceAmenities.
  ///
  /// In en, this message translates to:
  /// **'Living Space & Amenities'**
  String get livingSpaceAmenities;

  /// No description provided for @livingSpace.
  ///
  /// In en, this message translates to:
  /// **'Living Space'**
  String get livingSpace;

  /// No description provided for @amenities.
  ///
  /// In en, this message translates to:
  /// **'Amenities'**
  String get amenities;

  /// No description provided for @nearByFacilities.
  ///
  /// In en, this message translates to:
  /// **'Nearby facilities'**
  String get nearByFacilities;

  /// No description provided for @virtualTour.
  ///
  /// In en, this message translates to:
  /// **'3D virtual tour'**
  String get virtualTour;

  /// No description provided for @video.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get video;

  /// No description provided for @enterNoOf.
  ///
  /// In en, this message translates to:
  /// **'Enter no. of '**
  String get enterNoOf;

  /// No description provided for @bedrooms.
  ///
  /// In en, this message translates to:
  /// **'Bedrooms'**
  String get bedrooms;

  /// No description provided for @kitchen.
  ///
  /// In en, this message translates to:
  /// **'Kitchen'**
  String get kitchen;

  /// No description provided for @bathrooms.
  ///
  /// In en, this message translates to:
  /// **'Bathrooms'**
  String get bathrooms;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @threeDTour.
  ///
  /// In en, this message translates to:
  /// **'3D Virtual Tour'**
  String get threeDTour;

  /// No description provided for @furnished.
  ///
  /// In en, this message translates to:
  /// **'Furnished'**
  String get furnished;

  /// No description provided for @selectFurnished.
  ///
  /// In en, this message translates to:
  /// **'Select Furnished Status'**
  String get selectFurnished;

  /// No description provided for @underConstructionStatus.
  ///
  /// In en, this message translates to:
  /// **'Select Under Construction Status'**
  String get underConstructionStatus;

  /// No description provided for @bankLeaseCompany.
  ///
  /// In en, this message translates to:
  /// **'Bank/Leasing Company'**
  String get bankLeaseCompany;

  /// No description provided for @bankLeaseCompanyStatus.
  ///
  /// In en, this message translates to:
  /// **'Select Bank/Leasing Company Status'**
  String get bankLeaseCompanyStatus;

  /// No description provided for @sureYouWantToDelete.
  ///
  /// In en, this message translates to:
  /// **'Want to Delete Property?'**
  String get sureYouWantToDelete;

  /// No description provided for @sureYouWantToDeleteInfo.
  ///
  /// In en, this message translates to:
  /// **'You’re going to delete '**
  String get sureYouWantToDeleteInfo;

  /// No description provided for @wantToGoBackQuit.
  ///
  /// In en, this message translates to:
  /// **'Want to go back and quit?'**
  String get wantToGoBackQuit;

  /// No description provided for @wantToCancel.
  ///
  /// In en, this message translates to:
  /// **'Want to cancel and quit?'**
  String get wantToCancel;

  /// No description provided for @cancelPropertyInfo.
  ///
  /// In en, this message translates to:
  /// **'The property data will be erased and you will be redirected to home'**
  String get cancelPropertyInfo;

  /// No description provided for @yourFavoritesIsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your Favorites is Empty'**
  String get yourFavoritesIsEmpty;

  /// No description provided for @yourFavoritesIsEmptyData.
  ///
  /// In en, this message translates to:
  /// **'Add items that you like to your favorites. Review them anytime.'**
  String get yourFavoritesIsEmptyData;

  /// No description provided for @cancelText.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get cancelText;

  /// No description provided for @confirmText.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmText;

  /// No description provided for @errorInvalidText.
  ///
  /// In en, this message translates to:
  /// **'Provide valid time'**
  String get errorInvalidText;

  /// No description provided for @hourLabelText.
  ///
  /// In en, this message translates to:
  /// **'Select Hour'**
  String get hourLabelText;

  /// No description provided for @minuteLabelText.
  ///
  /// In en, this message translates to:
  /// **'Select Minute'**
  String get minuteLabelText;

  /// No description provided for @viewInMap.
  ///
  /// In en, this message translates to:
  /// **'View in map'**
  String get viewInMap;

  /// No description provided for @shareProjectMessage.
  ///
  /// In en, this message translates to:
  /// **'Hey! Check out this beautiful property.\n\nYou can find more details using the link below:'**
  String get shareProjectMessage;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @clearFilter.
  ///
  /// In en, this message translates to:
  /// **'Clear Filter'**
  String get clearFilter;

  /// No description provided for @applyFilter.
  ///
  /// In en, this message translates to:
  /// **'Apply Filter'**
  String get applyFilter;

  /// Text showing distance with a dynamic value
  ///
  /// In en, this message translates to:
  /// **'Up to {distance} Km away'**
  String upToDistance(int distance);

  /// No description provided for @countrySelection.
  ///
  /// In en, this message translates to:
  /// **'Country Selection'**
  String get countrySelection;

  /// No description provided for @citySelection.
  ///
  /// In en, this message translates to:
  /// **'City Selection'**
  String get citySelection;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @area.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get area;

  /// No description provided for @selectRadius.
  ///
  /// In en, this message translates to:
  /// **'Select Radius'**
  String get selectRadius;

  /// No description provided for @addressLocation.
  ///
  /// In en, this message translates to:
  /// **'Area Name'**
  String get addressLocation;

  /// No description provided for @selectAddressLocation.
  ///
  /// In en, this message translates to:
  /// **'Select Area Name'**
  String get selectAddressLocation;

  /// No description provided for @invalidValue.
  ///
  /// In en, this message translates to:
  /// **'Invalid value'**
  String get invalidValue;

  /// No description provided for @fromLessThanOrEqualToTo.
  ///
  /// In en, this message translates to:
  /// **'From value must be less than or equal to To value.'**
  String get fromLessThanOrEqualToTo;

  /// No description provided for @toGreaterThanOrEqualToFrom.
  ///
  /// In en, this message translates to:
  /// **'To value must be greater than or equal to From value.'**
  String get toGreaterThanOrEqualToFrom;

  /// No description provided for @mortgaged.
  ///
  /// In en, this message translates to:
  /// **'Mortgaged'**
  String get mortgaged;

  /// No description provided for @debtFree.
  ///
  /// In en, this message translates to:
  /// **'Debt-free'**
  String get debtFree;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @bank.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get bank;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get paymentMethod;

  /// No description provided for @txtPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get txtPaymentMethod;

  /// No description provided for @paymentMethodOption.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred payment option'**
  String get paymentMethodOption;

  /// No description provided for @vendorList.
  ///
  /// In en, this message translates to:
  /// **'Vendor List'**
  String get vendorList;

  /// No description provided for @selectBank.
  ///
  /// In en, this message translates to:
  /// **'Select Bank'**
  String get selectBank;

  /// No description provided for @offerListing.
  ///
  /// In en, this message translates to:
  /// **'Offer Listing'**
  String get offerListing;

  /// No description provided for @tAndCValidation.
  ///
  /// In en, this message translates to:
  /// **'Please accept the Terms and Conditions.'**
  String get tAndCValidation;

  /// No description provided for @addReview.
  ///
  /// In en, this message translates to:
  /// **'Add Review'**
  String get addReview;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @yourReviews.
  ///
  /// In en, this message translates to:
  /// **'Your Reviews'**
  String get yourReviews;

  /// No description provided for @comment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get comment;

  /// No description provided for @addYourComment.
  ///
  /// In en, this message translates to:
  /// **'Add your comment'**
  String get addYourComment;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @ago.
  ///
  /// In en, this message translates to:
  /// **'ago'**
  String get ago;

  /// No description provided for @minute.
  ///
  /// In en, this message translates to:
  /// **'minute'**
  String get minute;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// No description provided for @hour.
  ///
  /// In en, this message translates to:
  /// **'hour'**
  String get hour;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get hours;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get day;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'month'**
  String get month;

  /// No description provided for @months.
  ///
  /// In en, this message translates to:
  /// **'months'**
  String get months;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'year'**
  String get year;

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'years'**
  String get years;

  /// No description provided for @timeInPastError.
  ///
  /// In en, this message translates to:
  /// **'You cannot select a time in the past.'**
  String get timeInPastError;

  /// No description provided for @reviewThisProperty.
  ///
  /// In en, this message translates to:
  /// **'Review this property'**
  String get reviewThisProperty;

  /// No description provided for @noFileFound.
  ///
  /// In en, this message translates to:
  /// **'No file found'**
  String get noFileFound;

  /// No description provided for @emptyReviews.
  ///
  /// In en, this message translates to:
  /// **'No reviews available'**
  String get emptyReviews;

  /// No description provided for @emptyRatingValidation.
  ///
  /// In en, this message translates to:
  /// **'Please add ratings'**
  String get emptyRatingValidation;

  /// No description provided for @emptyReviewsInfo.
  ///
  /// In en, this message translates to:
  /// **'There are no reviews at the moment. Be the first to share your experience by adding a review.'**
  String get emptyReviewsInfo;

  /// No description provided for @agreeToTerms.
  ///
  /// In en, this message translates to:
  /// **'Agree to our {terms}{connector}{privacy}'**
  String agreeToTerms(Object connector, Object privacy, Object terms);

  /// No description provided for @terms.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get terms;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy;

  /// No description provided for @connector.
  ///
  /// In en, this message translates to:
  /// **'&'**
  String get connector;

  /// No description provided for @kindlyAgreeTerms.
  ///
  /// In en, this message translates to:
  /// **'Kindly agree to our Terms & Conditions.'**
  String get kindlyAgreeTerms;

  /// No description provided for @photoLibrary.
  ///
  /// In en, this message translates to:
  /// **'Photo Library'**
  String get photoLibrary;

  /// No description provided for @chooseFiles.
  ///
  /// In en, this message translates to:
  /// **'Choose Files'**
  String get chooseFiles;

  /// No description provided for @addedOn.
  ///
  /// In en, this message translates to:
  /// **'Added on '**
  String get addedOn;

  /// No description provided for @yourReviewListIsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your Review List is Empty.'**
  String get yourReviewListIsEmpty;

  /// No description provided for @yourReviewListIsEmptyData.
  ///
  /// In en, this message translates to:
  /// **'You currently have no items in review. Add properties to your review list.'**
  String get yourReviewListIsEmptyData;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @canNotMakeCall.
  ///
  /// In en, this message translates to:
  /// **'Sorry, can not make call at this number'**
  String get canNotMakeCall;

  /// No description provided for @selectPropertyError.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one property to proceed'**
  String get selectPropertyError;

  /// No description provided for @emptyLinkError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a link'**
  String get emptyLinkError;

  /// No description provided for @invalidUrlError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid URL'**
  String get invalidUrlError;

  /// No description provided for @invalidInstagramLinkError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid Instagram link'**
  String get invalidInstagramLinkError;

  /// No description provided for @invalidFacebookLinkError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid Facebook link'**
  String get invalidFacebookLinkError;

  /// No description provided for @invalidLinkedInLinkError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid LinkedIn link'**
  String get invalidLinkedInLinkError;

  /// No description provided for @invalidXLinkError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid X link'**
  String get invalidXLinkError;

  /// No description provided for @invalidCatalogLinkError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid Catalog link'**
  String get invalidCatalogLinkError;

  /// No description provided for @invalidProfileLinkError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid Profile link'**
  String get invalidProfileLinkError;

  /// No description provided for @lblNoNotification.
  ///
  /// In en, this message translates to:
  /// **'No notification available'**
  String get lblNoNotification;

  /// No description provided for @lblNoNotificationContent.
  ///
  /// In en, this message translates to:
  /// **'There are no notifications at the moment. Check back later for updates or important alerts.'**
  String get lblNoNotificationContent;

  /// No description provided for @lblAddOffer.
  ///
  /// In en, this message translates to:
  /// **'Add offer'**
  String get lblAddOffer;

  /// No description provided for @lblNoOfferTitle.
  ///
  /// In en, this message translates to:
  /// **'No offer available!'**
  String get lblNoOfferTitle;

  /// No description provided for @lblNoOfferContent.
  ///
  /// In en, this message translates to:
  /// **'There is no offers available for you. Keep eye on exiting offers.'**
  String get lblNoOfferContent;

  /// No description provided for @lblOfferTitle.
  ///
  /// In en, this message translates to:
  /// **'Offer Title'**
  String get lblOfferTitle;

  /// No description provided for @lblOfferArabicTitle.
  ///
  /// In en, this message translates to:
  /// **'Offer Title (Arabic)'**
  String get lblOfferArabicTitle;

  /// No description provided for @lblOfferTitleEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please provide a title for the offer.'**
  String get lblOfferTitleEmptyError;

  /// No description provided for @lblOfferCost.
  ///
  /// In en, this message translates to:
  /// **'Offer Cost'**
  String get lblOfferCost;

  /// No description provided for @lblOfferCostEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please provide the cost of the offer.'**
  String get lblOfferCostEmptyError;

  /// No description provided for @lblPortfolio.
  ///
  /// In en, this message translates to:
  /// **'Portfolio'**
  String get lblPortfolio;

  /// No description provided for @lblDescriptionArabic.
  ///
  /// In en, this message translates to:
  /// **'Description (Arabic)'**
  String get lblDescriptionArabic;

  /// No description provided for @lblDescriptionEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please provide the description.'**
  String get lblDescriptionEmpty;

  /// No description provided for @lblCreateOffers.
  ///
  /// In en, this message translates to:
  /// **'Create Offers'**
  String get lblCreateOffers;

  /// No description provided for @lblDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get lblDelete;

  /// No description provided for @lblUpdateOffer.
  ///
  /// In en, this message translates to:
  /// **'Update Offer'**
  String get lblUpdateOffer;

  /// No description provided for @lblDeleteOfferMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete this offer!'**
  String get lblDeleteOfferMessage;

  /// No description provided for @lblDeleteOfferDescMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this offer?'**
  String get lblDeleteOfferDescMessage;

  /// No description provided for @lblNoOwner.
  ///
  /// In en, this message translates to:
  /// **'You are not owner of this property.'**
  String get lblNoOwner;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get noInternetConnection;

  /// No description provided for @lblApprovedOffers.
  ///
  /// In en, this message translates to:
  /// **'Approved Offers'**
  String get lblApprovedOffers;

  /// No description provided for @lblPendingOffers.
  ///
  /// In en, this message translates to:
  /// **'Pending Offers'**
  String get lblPendingOffers;

  /// No description provided for @lblNoProperty.
  ///
  /// In en, this message translates to:
  /// **'Property detail not available!'**
  String get lblNoProperty;

  /// No description provided for @lblAddedNewProperty.
  ///
  /// In en, this message translates to:
  /// **'Added new property'**
  String get lblAddedNewProperty;

  /// No description provided for @lblRequestRejected.
  ///
  /// In en, this message translates to:
  /// **'Request rejected'**
  String get lblRequestRejected;

  /// No description provided for @lblRequestApproved.
  ///
  /// In en, this message translates to:
  /// **'Request approved'**
  String get lblRequestApproved;

  /// No description provided for @lblVisitRequestCreated.
  ///
  /// In en, this message translates to:
  /// **'Visit Request Created'**
  String get lblVisitRequestCreated;

  /// No description provided for @lblOfferRemovedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Offer deleted successfully!'**
  String get lblOfferRemovedSuccess;

  /// No description provided for @lblPropertyFinance.
  ///
  /// In en, this message translates to:
  /// **'Property Finance'**
  String get lblPropertyFinance;

  /// No description provided for @financeType.
  ///
  /// In en, this message translates to:
  /// **'Finance Type'**
  String get financeType;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @propertyFinance.
  ///
  /// In en, this message translates to:
  /// **'Property Finance'**
  String get propertyFinance;

  /// No description provided for @signUpDocumentLabel.
  ///
  /// In en, this message translates to:
  /// **'Please upload the following documents:'**
  String get signUpDocumentLabel;

  /// No description provided for @professionalLicence.
  ///
  /// In en, this message translates to:
  /// **'Professional License'**
  String get professionalLicence;

  /// No description provided for @commercialLicence.
  ///
  /// In en, this message translates to:
  /// **'Commercial License'**
  String get commercialLicence;

  /// No description provided for @vendorFinance.
  ///
  /// In en, this message translates to:
  /// **'Vendor Finance'**
  String get vendorFinance;

  /// Message displayed when the user exceeds the maximum file selection limit.
  ///
  /// In en, this message translates to:
  /// **'You can select only {maxAllowedFiles} files!!'**
  String selectOnlyMaxFiles(int maxAllowedFiles);

  /// Message displayed when the selected file exceeds the maximum allowed size.
  ///
  /// In en, this message translates to:
  /// **'Selected file is too large (max size: {maxSize} MB)'**
  String fileTooLarge(int maxSize);

  /// No description provided for @maxUpload.
  ///
  /// In en, this message translates to:
  /// **'Maximum {maxUploadVal} file upload.'**
  String maxUpload(Object maxUploadVal);

  /// Indicates the maximum number of uploads allowed
  ///
  /// In en, this message translates to:
  /// **'Maximum {maxUploadVal} files upload.'**
  String maxUploads(int maxUploadVal);

  /// No description provided for @policies_support.
  ///
  /// In en, this message translates to:
  /// **'Policies & Support'**
  String get policies_support;

  /// No description provided for @fileIsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Selected file is empty'**
  String get fileIsEmpty;

  /// No description provided for @selectOnlyOneImage.
  ///
  /// In en, this message translates to:
  /// **'You can select only 1 image'**
  String get selectOnlyOneImage;

  /// No description provided for @lblRequester.
  ///
  /// In en, this message translates to:
  /// **'Requester'**
  String get lblRequester;

  /// No description provided for @noItemsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No items available'**
  String get noItemsAvailable;

  /// No description provided for @lblSelectedOffer.
  ///
  /// In en, this message translates to:
  /// **'Selected Offer'**
  String get lblSelectedOffer;

  /// No description provided for @lblOtherDetails.
  ///
  /// In en, this message translates to:
  /// **'Other Details'**
  String get lblOtherDetails;

  /// No description provided for @lblNeighbourLocation.
  ///
  /// In en, this message translates to:
  /// **'Area Name'**
  String get lblNeighbourLocation;

  /// No description provided for @lblNeighbourLocations.
  ///
  /// In en, this message translates to:
  /// **'Area Names'**
  String get lblNeighbourLocations;

  /// No description provided for @lblNeighbourLocationPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter area name'**
  String get lblNeighbourLocationPlaceholder;

  /// No description provided for @errorDuplicateLocation.
  ///
  /// In en, this message translates to:
  /// **'Duplicate locations are not allowed'**
  String get errorDuplicateLocation;

  /// No description provided for @lblViewProperty.
  ///
  /// In en, this message translates to:
  /// **'View Property'**
  String get lblViewProperty;

  /// No description provided for @textSelected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get textSelected;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
