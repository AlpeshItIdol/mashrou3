import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mashrou3/app/db/app_preferences.dart';
import 'package:mashrou3/app/navigation/route_arguments.dart';
import 'package:mashrou3/app/navigation/routes.dart';
import 'package:mashrou3/app/ui/custom_widget/carousel_full_screen.dart';
import 'package:mashrou3/app/ui/custom_widget/city_list/city_list_screen.dart';
import 'package:mashrou3/app/ui/custom_widget/html_viewer.dart';
import 'package:mashrou3/app/ui/owner_screens/add_edit_property/add_edit_property_screen_1.dart';
import 'package:mashrou3/app/ui/owner_screens/add_edit_property/add_edit_property_screen_2.dart';
import 'package:mashrou3/app/ui/owner_screens/add_edit_property/add_edit_property_screen_3.dart';
import 'package:mashrou3/app/ui/owner_screens/dashboard/owner_dashboard_screen.dart';
import 'package:mashrou3/app/ui/owner_screens/owner_filter/in_review_filter_screen.dart';
import 'package:mashrou3/app/ui/owner_screens/owner_filter/owner_filter_screen.dart';
import 'package:mashrou3/app/ui/owner_screens/owner_property_details/owner_property_details_screen.dart';
import 'package:mashrou3/app/ui/screens/app_prefereces/app_preferences_screen.dart';
import 'package:mashrou3/app/ui/screens/cms/cms_screen.dart';
import 'package:mashrou3/app/ui/screens/dashboard/dashboard_screen.dart';
import 'package:mashrou3/app/ui/screens/dashboard/sub_screens/add_offer/add_vendor_offer.screen.dart';
import 'package:mashrou3/app/ui/screens/filter/fav_filter_screen.dart';
import 'package:mashrou3/app/ui/screens/filter/filter_screen.dart';
import 'package:mashrou3/app/ui/screens/finance_request/finance_request_screen.dart';
import 'package:mashrou3/app/ui/screens/property_details/property_details_screen.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/vendor_finance/vendor_categories/vendor_categories_screen.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/vendor_finance/vendor_details/subscreen/offer_detail/offer_detail_screen.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/vendor_finance/vendor_details/subscreen/offer_list/offer_listing_screen.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/vendor_finance/vendor_details/vendor_details_screen.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/vendor_finance/vendor_finance_request/finance_request_details_screen.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/vendor_finance/vendor_list/vendor_list_screen.dart';
import 'package:mashrou3/app/ui/screens/ratings/add_rating_screen.dart';
import 'package:mashrou3/app/ui/screens/ratings/view_review_screen.dart';
import 'package:mashrou3/app/ui/screens/search_bar/search.bar.screen.dart';
import 'package:mashrou3/app/ui/screens/unknown/loading_screen.dart';
import 'package:mashrou3/app/ui/screens/banks_offer/banks_offer_screen.dart';
import 'package:mashrou3/app/ui/screens/vendors/vendors_detail_screen.dart';
import 'package:mashrou3/app/ui/screens/web_view/webview_screen.dart';
import 'package:mashrou3/config/resources/app_constants.dart';
import 'package:mashrou3/config/resources/app_strings.dart';

import '../model/offers/my_offers_list_response_model.dart';
import '../ui/owner_screens/visit_requests_list/visit.requests.list.screen.dart';
import '../ui/screens/authentication/login/login.screen.dart';
import '../ui/screens/authentication/otp_verification/otp.verification.screen.dart';
import '../ui/screens/authentication/register/complete_profile/complete.profile.screen.dart';
import '../ui/screens/authentication/register/complete_profile/complete.profile2.screen.dart';
import '../ui/screens/authentication/register/complete_profile/complete.profile3.screen.dart';
import '../ui/screens/authentication/register/register_step1/register.step1.screen.dart';
import '../ui/screens/authentication/register/register_step2/register.step2.screen.dart';
import '../ui/screens/authentication/register/register_step3/register.step3.screen.dart';
import '../ui/screens/authentication/register/undergoing_verification/undergoing.verification.screen.dart';
import '../ui/screens/authentication/welcome.screen.dart';
import '../ui/screens/dashboard/sub_screens/my_offers_list/my_offers_list_screen.dart';
import '../ui/screens/personal_information/personal.information.screen.dart';
import '../ui/screens/personal_information/sub_screens/add_edit_certificates/add.edit.certificates.screen.dart';
import '../ui/screens/personal_information/sub_screens/edit_profile/edit.profile.screen.dart';
import '../ui/screens/personal_information/sub_screens/view_all_certificates/view.all.certificates.screen.dart';
import '../ui/screens/profile_detail/profile.detail.screen.dart';
import '../ui/screens/property_details/sub_screens/add_my_offers/add.my.offers.screen.dart';
import '../ui/screens/property_details/sub_screens/add_my_offers/offer_pricing_screen.dart';
import '../ui/screens/property_details/sub_screens/add_my_offers/pricing_calculation_results_screen.dart';
import '../ui/screens/property_details/sub_screens/add_my_offers/model/price_calculations_response_model.dart';
import '../ui/screens/property_details/sub_screens/bank_details/bank_details_screen.dart';
import '../ui/screens/property_details/sub_screens/banks_list/banks_list_screen.dart';
import '../ui/screens/property_details/sub_screens/vendor_finance/model/vendor_list_response_model.dart';
import '../ui/screens/property_details/sub_screens/visit_request/visit.request.screen.dart';
import '../ui/screens/property_not_found/property.not.found.screen.dart';
import '../ui/screens/recently_visited_properties/recently.visited.properties.screen.dart';
import '../ui/screens/requested_properties/requested.properties.screen.dart';
import '../ui/screens/splash/splash.screen.dart';
import '../ui/screens/subscription_information/subscription_information.dart';
import '../ui/screens/unknown/invalid.screen.dart';
import '../ui/screens/vendors/model/vendors_sequence_response.dart';
import '../ui/screens/vendors/vendors_list_screen.dart';

class AppRouter {
  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    initialLocation: RoutePaths.kSplashPath,
    debugLogDiagnostics: true,
    navigatorKey: rootNavigatorKey,
    routes: [
      /// Screen : Splash Screen
      GoRoute(
        name: Routes.kSplashScreen,
        path: RoutePaths.kSplashPath,
        builder: (BuildContext context, GoRouterState state) {
          return SplashScreen();
        },
      ),

      /// Screen : Welcome Screen
      GoRoute(
          name: Routes.kWelcomeScreen,
          path: RoutePaths.kWelcomePath,
          builder: (BuildContext context, GoRouterState state) => const WelcomeScreen()),

      /// Screen : Login Screen
      GoRoute(
          name: Routes.kLoginScreen,
          path: RoutePaths.kLoginPath,
          builder: (BuildContext context, GoRouterState state) => const LoginScreen()),

      /// Screen : OTP Screen
      GoRoute(
          name: Routes.kOtpVerificationScreen,
          path: RoutePaths.kOtpVerificationPath,
          builder: (BuildContext context, GoRouterState state) {
            String? pageExtra = state.extra as String? ?? "";
            return OtpVerificationScreen(
              mobileNumber: pageExtra,
            );
          }),

      /// Screen : RegisterStep1 Screen
      GoRoute(
          name: Routes.kRegisterStep1Screen,
          path: RoutePaths.kRegisterStep1Path,
          builder: (BuildContext context, GoRouterState state) => const RegisterStep1Screen()),

      /// Screen : RegisterStep2 Screen
      GoRoute(
          name: Routes.kRegisterStep2Screen,
          path: RoutePaths.kRegisterStep2Path,
          builder: (BuildContext context, GoRouterState state) => const RegisterStep2Screen()),

      /// Screen : RegisterStep3 Screen
      GoRoute(
          name: Routes.kRegisterStep3Screen,
          path: RoutePaths.kRegisterStep3Path,
          builder: (BuildContext context, GoRouterState state) {
            String? pageExtra = state.extra as String? ?? "";
            return RegisterStep3Screen(
              mobileNumber: pageExtra,
            );
          }),

      /// Screen : Dashboard Screen
      GoRoute(
          name: Routes.kDashboard,
          path: RoutePaths.kDashboardPath,
          builder: (BuildContext context, GoRouterState state) => const DashboardScreen()),

      /// Screen : Complete Profile Screen
      GoRoute(
          name: Routes.kCompleteProfileScreen,
          path: RoutePaths.kCompleteProfilePath,
          builder: (BuildContext context, GoRouterState state) => const CompleteProfileScreen()),

      /// Screen : Complete Profile2 Screen
      GoRoute(
          name: Routes.kCompleteProfile2Screen,
          path: RoutePaths.kCompleteProfile2Path,
          builder: (BuildContext context, GoRouterState state) => const CompleteProfile2Screen()),

      /// Screen : Complete Profile3 Screen
      GoRoute(
          name: Routes.kCompleteProfile3Screen,
          path: RoutePaths.kCompleteProfile3Path,
          builder: (BuildContext context, GoRouterState state) => const CompleteProfile3Screen()),

      /// Screen : Undergoing Verification Screen
      GoRoute(
          name: Routes.kUndergoingVerificationScreen,
          path: RoutePaths.kUndergoingVerificationPath,
          builder: (BuildContext context, GoRouterState state) => const UndergoingVerificationScreen()),

      /// Screen : Owner Dashboard Screen
      GoRoute(
          name: Routes.kOwnerDashboard,
          path: RoutePaths.kOwnerDashboardPath,
          builder: (BuildContext context, GoRouterState state) => const OwnerDashboardScreen()),

      GoRoute(
          name: Routes.kPropertyDetailScreen,
          path: RoutePaths.kPropertyDetailPath,
          builder: (BuildContext context, GoRouterState state) {
            String? vendorId = state.pathParameters[RouteArguments.vendorId];
            // Read optional isForVendor from query params and keep as String ("true"/"false")
            final String isForVendor = (state.uri.queryParameters[RouteArguments.isForVendor] ?? "false");
            String? sId = state.pathParameters[RouteArguments.propertyId];
            String? propertyLat = state.pathParameters[RouteArguments.propertyLat];
            String? propertyLng = state.pathParameters[RouteArguments.propertyLng];
            final isFromVisitReq = state.uri.queryParameters[RouteArguments.isFromVisitReq] == "true";
            final rejectReason = Uri.decodeComponent(state.uri.queryParameters[RouteArguments.rejectReason] ?? "");
            LatLng? location;
            final latitude = double.tryParse(propertyLat ?? "0.00");
            final longitude = double.tryParse(propertyLng ?? "0.00");

            if (latitude != null && longitude != null) {
              location = LatLng(latitude, longitude);
            } else {
              debugPrint('Invalid coordinates');
            }
            print("Parsed rejectReason: $rejectReason"); // D
            return PropertyDetailsScreen(
              sId: sId ?? "",
              propertyLatLng: location ?? const LatLng(0.00, 0.00),
              rejectReason: rejectReason,
              isFromVisitReq: isFromVisitReq.toString(), vendorId: vendorId ?? "", isFromVendor: isForVendor,
            );
          }),

      GoRoute(
          name: Routes.kOwnerPropertyDetailScreen,
          path: RoutePaths.kOwnerPropertyDetailPath,
          builder: (BuildContext context, GoRouterState state) {
            final pageExtra = state.extra as bool;
            String? sId = state.pathParameters[RouteArguments.propertyId];
            String? propertyLat = state.pathParameters[RouteArguments.propertyLat];
            String? propertyLng = state.pathParameters[RouteArguments.propertyLng];

            LatLng? location;
            final latitude = double.tryParse(propertyLat ?? "0.00");
            final longitude = double.tryParse(propertyLng ?? "0.00");

            if (latitude != null && longitude != null) {
              location = LatLng(latitude, longitude);
            } else {
              debugPrint('Invalid coordinates');
            }

            return OwnerPropertyDetailsScreen(
              sId: sId ?? "",
              propertyLatLng: location ?? const LatLng(0.00, 0.00),
              isForInReview: pageExtra,
            );
          }),

      GoRoute(
          name: Routes.kFilterScreen,
          path: RoutePaths.kFilterPath,
          builder: (BuildContext context, GoRouterState state) => const FilterScreen()),

      GoRoute(
          name: Routes.kOwnerFilterScreen,
          path: RoutePaths.kOwnerFilterPath,
          builder: (BuildContext context, GoRouterState state) => const OwnerFilterScreen()),

      GoRoute(
          name: Routes.kFavFilterScreen,
          path: RoutePaths.kFavFilterPath,
          builder: (BuildContext context, GoRouterState state) => const FavFilterScreen()),

      GoRoute(
          name: Routes.kInReviewFilterScreen,
          path: RoutePaths.kInReviewFilterPath,
          builder: (BuildContext context, GoRouterState state) => const InReviewFilterScreen()),

      GoRoute(
          name: Routes.kAddEditPropertyScreen1,
          path: RoutePaths.kAddEditPropertyScreen1Path,
          builder: (BuildContext context, GoRouterState state) {
            final pageExtra = state.extra as bool;
            String? sId = state.pathParameters[RouteArguments.id];
            return AddEditPropertyScreen1(
              sId: sId ?? "",
              isForInReview: pageExtra,
            );
          }),

      GoRoute(
          name: Routes.kAddEditPropertyScreen2,
          path: RoutePaths.kAddEditPropertyScreen2Path,
          builder: (BuildContext context, GoRouterState state) => const AddEditPropertyScreen2()),

      GoRoute(
          name: Routes.kAddEditPropertyScreen3,
          path: RoutePaths.kAddEditPropertyScreen3Path,
          builder: (BuildContext context, GoRouterState state) => const AddEditPropertyScreen3()),

      GoRoute(
          name: Routes.kAppPreferencesScreen,
          path: RoutePaths.kAppPreferencesScreenPath,
          builder: (BuildContext context, GoRouterState state) => const AppPreferencesScreen()),

      GoRoute(
          name: Routes.kVisitRequest,
          path: RoutePaths.kVisitRequestPath,
          builder: (BuildContext context, GoRouterState state) => VisitRequestScreen(
                propertyId: state.extra as String,
              )),

      GoRoute(
          name: Routes.kVisitRequestsList,
          path: RoutePaths.kVisitRequestsListPath,
          builder: (BuildContext context, GoRouterState state) => const VisitRequestsScreen()),

      GoRoute(
          name: Routes.kRequestedPropertiesList,
          path: RoutePaths.kRequestedPropertiesListPath,
          builder: (BuildContext context, GoRouterState state) => RequestedPropertiesScreen()),

      GoRoute(
          name: Routes.kRecentlyVisitedPropertiesList,
          path: RoutePaths.kRecentlyVisitedPropertiesListPath,
          builder: (BuildContext context, GoRouterState state) => RecentlyVisitedPropertiesScreen(
                isPropertiesWithOffers: state.extra as bool,
              )),

      GoRoute(
          name: Routes.kAddRatingScreen,
          path: RoutePaths.kAddRatingPath,
          builder: (BuildContext context, GoRouterState state) => AddRatingScreen(
                propertyId: state.extra as String,
              )),

      GoRoute(
          name: Routes.kViewReviewScreen,
          path: RoutePaths.kViewReviewPath,
          builder: (BuildContext context, GoRouterState state) {
            String? isReviewVisible = state.pathParameters[RouteArguments.isReviewVisible];
            String? userAddedRating = state.pathParameters[RouteArguments.userAddedRating];
            return ViewReviewScreen(
                propertyId: state.extra as String, isAddReviewVisible: isReviewVisible, userAddedRating: userAddedRating);
          }),

      GoRoute(
          name: Routes.kPersonalInformationScreen,
          path: RoutePaths.kPersonalInformationPath,
          builder: (BuildContext context, GoRouterState state) => PersonalInformationScreen()),

      GoRoute(
          name: Routes.kProfileDetailScreen,
          path: RoutePaths.kProfileDetailPath,
          builder: (BuildContext context, GoRouterState state) => ProfileDetailScreen(
                userId: state.extra as String,
              )),

      GoRoute(
          name: Routes.kPropertyNotFound,
          path: RoutePaths.kPropertyNotFoundPath,
          builder: (BuildContext context, GoRouterState state) => const PropertyNotFoundScreen()),

      GoRoute(
          name: Routes.kAddEditCertificatesScreen,
          path: RoutePaths.kAddEditCertificatesPath,
          builder: (BuildContext context, GoRouterState state) {
            String? isForPortfolio = state.pathParameters[RouteArguments.isForPortfolio];
            String? isForEdit = state.pathParameters[RouteArguments.isForEdit];

            return AddEditCertificatesScreen(
              certificatesList: state.extra as List ?? [],
              isForPortfolio: isForPortfolio,
              isForEdit: isForEdit,
            );
          }),

      GoRoute(
          name: Routes.kViewAllCertificatesScreen,
          path: RoutePaths.kViewAllCertificatesPath,
          builder: (BuildContext context, GoRouterState state) {
            String? isForPortfolio = state.pathParameters[RouteArguments.isForPortfolio];
            String? isForPropertyDetail = state.pathParameters[RouteArguments.isForPropertyDetail];
            return ViewAllCertificatesScreen(
              certificatesList: state.extra as List,
              isForPortfolio: isForPortfolio ?? "false",
              isForPropertyDetail: isForPropertyDetail ?? "false",
            );
          }),

      /// Screen : CMS
      GoRoute(
          name: Routes.kCmsScreen,
          path: RoutePaths.kCmsPath,
          builder: (BuildContext context, GoRouterState state) {
            final pageExtra = state.extra as String;

            return CmsScreen(
              licenseUrl: pageExtra,
            );
          }),

      GoRoute(
          name: Routes.kBanksOffer,
          path: RoutePaths.kBanksOffer,
          builder: (BuildContext context, GoRouterState state) {
            // extra may contain licenceUrl from drawer, not used here
            return  const BanksOfferScreen();
          }),
      GoRoute(
          name: Routes.kDrawerVendorList,
          path: RoutePaths.kDrawerVendorList,
          builder: (BuildContext context, GoRouterState state) {
            // extra may contain licenceUrl from drawer, not used here
            // final pageExtra = state.extra as String;
            return  const VendorsListScreen();
          }),
      GoRoute(
          name: Routes.kDrawerVendorDetail,
          path: RoutePaths.kDrawerVendorDetail,
          builder: (BuildContext context, GoRouterState state) {
            // extra may contain licenceUrl from drawer, not used here
            final vendorData = state.extra as VendorSequenceUser;
            return  VendorsDetailScreen(items: vendorData,);
          }),

      GoRoute(
        name: Routes.kBanksListScreen,
        path: '/bank-management/bank-list',
        builder: (context, state) {
          return const BanksListScreen();
        },
      ),

      GoRoute(
          name: Routes.kMyOffersListScreen,
          path: RoutePaths.kMyOffersListPath,
          builder: (BuildContext context, GoRouterState state) => const MyOffersListScreen()),

      GoRoute(
        name: Routes.kAddMyOffersListScreen,
        path: RoutePaths.kAddMyOffersListPath,
        builder: (BuildContext context, GoRouterState state) {
          final propertyId = state.extra as List<String>;

          String? isFromDelete = state.pathParameters[RouteArguments.isFromDelete];
          String? isMultiple = state.pathParameters[RouteArguments.isMultiple];

          // Parse offersList from state.pathParameters
          List<OfferData> offersList = [];
          final offersListString = state.pathParameters[RouteArguments.offersList];
          if (offersListString != null) {
            try {
              offersList = (jsonDecode(offersListString) as List<dynamic>).map((e) => OfferData.fromJson(e)).toList();
            } catch (e) {
              debugPrint('Error parsing offersList: $e');
            }
          }

          return AddMyOffersScreen(
            propertyId: propertyId,
            offersList: offersList,
            isMultiple: isMultiple ?? "false",
            isFromDelete: isFromDelete ?? "false",
          );
        },
      ),

      GoRoute(
        name: Routes.kOfferPricingScreen,
        path: RoutePaths.kOfferPricingPath,
        builder: (BuildContext context, GoRouterState state) {
          final data = state.extra as Map<String, dynamic>;
          return OfferPricingScreen(
            propertyIds: data['propertyIds'] as List<String>? ?? [],
            offersIds: data['offersIds'] as List<String>? ?? [],
            isMultiple: data['isMultiple'] as bool? ?? false,
            isAllProperty: data['isAllProperty'] as bool? ?? false,
          );
        },
      ),

      GoRoute(
        name: Routes.kPricingCalculationResultsScreen,
        path: RoutePaths.kPricingCalculationResultsPath,
        builder: (BuildContext context, GoRouterState state) {
          final data = state.extra as Map<String, dynamic>;
          return PricingCalculationResultsScreen(
            pricingData: data['pricingData'] as PriceCalculationsResponseModel,
            propertyIds: data['propertyIds'] as List<String>? ?? [],
            offersIds: data['offersIds'] as List<String>? ?? [],
            isMultiple: data['isMultiple'] as bool? ?? false,
            isAllProperty: data['isAllProperty'] as bool? ?? false,
            offerType: data['offerType'] as String?,
            startDate: data['startDate'] as String?,
            endDate: data['endDate'] as String?,
          );
        },
      ),

      GoRoute(
        name: Routes.kBankDetailsScreen,
        path: RoutePaths.kBankDetailsPath,
        builder: (context, state) {
          final propertyId = state.pathParameters[RouteArguments.propertyId] ?? "0";
          final vendorId = state.pathParameters[RouteArguments.vendorId] ?? "0";
          final isForVendor = state.pathParameters[RouteArguments.isForVendor] == 'true';
          final pageExtra = state.extra as String;
          return BankDetailsScreen(
            propertyId: propertyId,
            vendorId: vendorId,
            isForVendor: isForVendor, sId: pageExtra,
          );
        },
      ),

      /// Screen : Edit Profile Screen
      GoRoute(
          name: Routes.kEditProfileScreen,
          path: RoutePaths.kEditProfilePath,
          builder: (BuildContext context, GoRouterState state) => const EditProfileScreen()),

      GoRoute(
          name: Routes.kCityListScreen,
          path: RoutePaths.kCityListPath,
          builder: (BuildContext context, GoRouterState state) => CityListScreen(
                countryId: state.extra as String,
              )),

      GoRoute(
          name: Routes.kSearch,
          path: RoutePaths.kSearchPath,
          builder: (BuildContext context, GoRouterState state) {
            final pageExtra = state.extra ?? "";

            return SearchBarScreen(
              searchText: pageExtra as String,
            );
          }),

      GoRoute(
          name: Routes.kVendorCategoriesScreen,
          path: RoutePaths.kVendorCategoriesPath,
          builder: (BuildContext context, GoRouterState state) {
            final pageExtra = state.extra;
            // If extra is a Map, extract propertyId and vendorId
            if (pageExtra is Map) {
              return VendorCategoriesScreen(
                propertyId: pageExtra['propertyId'] as String? ?? "",
                vendorId: pageExtra['vendorId'] as String? ?? "",
              );
            }
            // Fallback: if extra is just a String, treat it as propertyId
            return VendorCategoriesScreen(
              propertyId: (pageExtra as String?) ?? "",
              vendorId: state.uri.queryParameters[RouteArguments.vendorId] ?? "",
            );
          }),

      GoRoute(
          name: Routes.kVendorList,
          path: RoutePaths.kVendorListPath,
          builder: (BuildContext context, GoRouterState state) => const VendorListScreen()),

      GoRoute(
          name: Routes.kVendorDetailScreen,
          path: RoutePaths.kVendorDetailPath,
          builder: (BuildContext context, GoRouterState state) {
            final pageExtra = state.extra;
            final String vendorUserId = pageExtra is String 
                ? pageExtra 
                : (pageExtra is Map && pageExtra.containsKey('vendorId'))
                    ? (pageExtra['vendorId']?.toString() ?? "")
                    : "";
            final isFromFinanceReq = state.uri.queryParameters[RouteArguments.isFromFinanceReq] == "true";
            return VendorDetailsScreen(
              vendorUserId: vendorUserId,
              isFromFinanceReq: isFromFinanceReq,
            );
          }),

      GoRoute(
        name: Routes.kOfferListScreen,
        path: RoutePaths.kOfferListPath,
        builder: (BuildContext context, GoRouterState state) {
          // Parse offersList from state.pathParameters
          List<OfferData> offersList = [];
          final offersListString = state.pathParameters[RouteArguments.offersList];
          if (offersListString != null) {
            try {
              offersList = (jsonDecode(offersListString) as List<dynamic>).map((e) => OfferData.fromJson(e)).toList();
            } catch (e) {
              debugPrint('Error parsing offersList: $e');
            }
          }
          String? propertyId = state.pathParameters[RouteArguments.propertyId];
          String? vendorId = state.pathParameters[RouteArguments.vendorId];
          return OfferListingScreen(
            offersList: offersList,
          );
        },
      ),

      GoRoute(
          name: Routes.kOfferDetailScreen,
          path: RoutePaths.kOfferDetailPath,
          builder: (BuildContext context, GoRouterState state) {
            String? offerId = state.pathParameters[RouteArguments.offerId];
            String? isDraftOffer = state.pathParameters[RouteArguments.isDraftOffer];
            
            // Debug logging
            debugPrint('OfferDetailScreen Route - offerId: $offerId, isDraftOffer: $isDraftOffer');
            debugPrint('Path parameters: ${state.pathParameters}');
            debugPrint('Query parameters: ${state.uri.queryParameters}');
            
            // Validate offerId
            if (offerId == null || offerId.isEmpty) {
              debugPrint('ERROR: offerId is null or empty in route!');
            }
            
            // vendorId can come from extra or queryParameters for navigation back to vendor details
            final pageExtra = state.extra;
            String? vendorId;
            if (pageExtra is String) {
              vendorId = pageExtra;
            } else if (pageExtra is Map) {
              vendorId = pageExtra['vendorId'] as String?;
            }
            vendorId ??= state.uri.queryParameters[RouteArguments.vendorId];
            
            // bankId, propertyId, isForVendor from queryParameters for navigation back to bank details
            String? bankId = state.uri.queryParameters[RouteArguments.bankId];
            String? propertyId = state.uri.queryParameters[RouteArguments.propertyId];
            String? isForVendor = state.uri.queryParameters[RouteArguments.isForVendor];
            String? isFromVendor = state.uri.queryParameters[RouteArguments.isFromVendor];

            return OfferDetailScreen(
              offerId: offerId ?? "",
              isDraftOffer: isDraftOffer ?? "false",
              vendorId: vendorId,
              bankId: bankId,
              propertyId: propertyId,
              isForVendor: isForVendor,
              isFromVendor:isFromVendor
            );
          }),

      GoRoute(
          name: Routes.kAddVendorOffersScreen,
          path: RoutePaths.kAddVendorOfferListPath,
          builder: (BuildContext context, GoRouterState state) {
            final OfferData pageExtra = state.extra as OfferData? ?? OfferData();
            return AddVendorOfferScreen(
              offerDataModel: pageExtra,
            );
          }),

      /// Screen : Finance Request
      GoRoute(
          name: Routes.kFinanceRequestScreen,
          path: RoutePaths.kFinanceRequestPath,
          builder: (BuildContext context, GoRouterState state) {
            // final pageExtra = state.extra as String;

            return const FinanceRequestScreen();
          }),

      GoRoute(
          name: Routes.kHTMLViewer,
          path: RoutePaths.kHTMLViewerPath,
          builder: (BuildContext context, GoRouterState state) {
            final pageExtra = state.extra as String;

            return HtmlViewer(
              htmlData: pageExtra,
            );
          }),

      GoRoute(
          name: Routes.kWebViewScreen,
          path: RoutePaths.kWebViewPath,
          builder: (BuildContext context, GoRouterState state) {
            final pageExtra = state.extra as String;
            String? title = state.pathParameters[RouteArguments.title];

            return WebViewScreen(
              title: title ?? "",
              url: pageExtra,
            );
          }),

      // Screen : Carousel Screen
      GoRoute(
          name: Routes.kCarouselFullScreen,
          path: RoutePaths.kCarouselFullPath,
          builder: (BuildContext context, GoRouterState state) {
            String? index = state.pathParameters[RouteArguments.index];
            return CarouselFullScreen(imageList: state.extra as List<String>, index: index.toString());
          }),

      //Screen : Finance Request Details
      GoRoute(
          name: Routes.kFinanceRequestDetailsScreen,
          path: RoutePaths.kFinanceRequestDetailsPath,
          builder: (BuildContext context, GoRouterState state) {
            String? sId = state.pathParameters[RouteArguments.requestId];
            return FinanceRequestDetailsScreen(
              sId: sId ?? "",
            );
          }),

      //Screen : Not subscribed screen
      GoRoute(
          name: Routes.kSubscriptionInformation,
          path: RoutePaths.kSubscriptionInformation,
          builder: (BuildContext context, GoRouterState state) {
            return const SubscriptionInformation();
          }),
    ],
    errorBuilder: (context, state) {
      final matchedLocation = state.matchedLocation;
      final uri = state.uri;
      print("state ${state.matchedLocation}");
      if (matchedLocation.trim().isNotEmpty) {
        return LoadingScreen(
          matchedPath: matchedLocation.trim(),
          fullURI: uri,
        );
      }
      return const InvalidScreen();
    },
  );

  // Navigate to specific screen
  static void navigateToScreen(
      {required BuildContext? context, required String redirectURL, bool isFromNotification = false, bool isAppOpened = false}) async {
    int delay800Millis = isFromNotification ? 0 : 800;

    try {
      var userRole = await GetIt.I<AppPreferences>().getUserRole() ?? "";

      if ((redirectURL ?? '').isNotEmpty) {
        final splitData = redirectURL.split("/");

        if (redirectURL.contains(AppConstants.viewPropertyDetails)) {
          // Navigate to view property.
          Future.delayed(Duration(milliseconds: delay800Millis), () {
            AppRouter.goToPropertyDetail(
              isAppOpened: isAppOpened || isFromNotification,
              propertyID: splitData.last,
              isFromDeepLink: true,
              isOwner: userRole == AppStrings.owner,
            );
          });
        } else if (redirectURL.contains(AppConstants.viewPropertyDetails)) {
          // Navigate to view property.
          Future.delayed(Duration(milliseconds: delay800Millis), () {
            AppRouter.goToPropertyDetail(
              isAppOpened: isAppOpened || isFromNotification,
              propertyID: splitData.last,
              isFromDeepLink: true,
              isOwner: userRole == AppStrings.owner,
            );
          });
        } else {
          goToInvalidScreen();
        }
      }
    } catch (ex) {
      Future.delayed(Duration(milliseconds: delay800Millis), () {
        AppRouter.goToSignIn();
      });
    }
  }

  static void goToInvalidScreen() {
    router.goNamed(Routes.k404Screen);
  }

  /// Navigate to visitor property details
  static void goToVisitorPropertyDetail({required String propertyID}) {
    router.goNamed(Routes.kPropertyDetailScreen, pathParameters: {
      RouteArguments.propertyId: propertyID,
      RouteArguments.propertyLat: "0.00",
      RouteArguments.propertyLng: "0.00",
    });
  }

  /// Navigate to property details
  static void goToPropertyDetail(
      {required String propertyID,
      bool isAppOpened = false,
      bool isForReview = false,
      bool isFromNotification = false,
      bool isFromDeepLink = false,
      required bool isOwner}) {
    final extraData = {
      RouteArguments.propertyId: propertyID,
    };
    if (isOwner) {
      if (isFromDeepLink) {
        router.goNamed(Routes.kOwnerPropertyDetailScreen, extra: isForReview, pathParameters: {
          RouteArguments.propertyId: propertyID,
          RouteArguments.propertyLat: "0.00",
          RouteArguments.propertyLng: "0.00",
        });
      } else {
        router.pushNamed(Routes.kOwnerPropertyDetailScreen, extra: isForReview, pathParameters: {
          RouteArguments.propertyId: propertyID,
          RouteArguments.propertyLat: "0.00",
          RouteArguments.propertyLng: "0.00",
        });
      }
    } else {
      if (isFromNotification) {
        router.pushReplacementNamed(Routes.kPropertyDetailScreen, extra: extraData);
        return;
      }
      if (isAppOpened) {
        router.pushNamed(Routes.kPropertyDetailScreen, extra: extraData);
        return;
      }
      router.goNamed(Routes.kPropertyDetailScreen, pathParameters: {
        RouteArguments.propertyId: propertyID,
        RouteArguments.propertyLat: "0.00",
        RouteArguments.propertyLng: "0.00",
      });
    }
  }

  static List<String> getAllRoutes() {
    final buildContext = router.routerDelegate.navigatorKey.currentContext;
    return GoRouter.of(buildContext!).routerDelegate.currentConfiguration.matches.map((e) => e.matchedLocation).toList();
  }

  /// Navigate to property visit request
  static void goToVisitRequests({bool isOwner = false, String propertyId = ''}) {
    final routes = getAllRoutes();
    if (!isOwner) {
      bool alreadyOpen = routes.toList().firstWhereOrNull((element) => element == RoutePaths.kRequestedPropertiesListPath) != null;
      if (alreadyOpen) {
        router.pushReplacementNamed(Routes.kRequestedPropertiesList, extra: propertyId);
      } else {
        router.pushNamed(Routes.kRequestedPropertiesList, extra: propertyId);
      }
    } else {
      bool alreadyOpen = routes.toList().firstWhereOrNull((element) => element == RoutePaths.kVisitRequestsListPath) != null;
      if (alreadyOpen) {
        router.pushReplacementNamed(Routes.kVisitRequestsList, extra: propertyId);
      } else {
        router.pushNamed(Routes.kVisitRequestsList, extra: propertyId);
      }
    }
  }

  /// Navigate to vendor finance request list
  static void goToVendorFinanceRequests() {
    final routes = getAllRoutes();
    {
      bool alreadyOpen = routes.toList().firstWhereOrNull((element) => element == RoutePaths.kFinanceRequestPath) != null;
      if (alreadyOpen) {
        router.pushReplacementNamed(
          Routes.kFinanceRequestScreen,
        );
      } else {
        router.pushNamed(
          Routes.kFinanceRequestScreen,
        );
      }
    }
  }

  /// Navigate to offer detail
  static void goToOffer({String offerId = "", bool isRejected = false}) {
    final routes = getAllRoutes();

    bool alreadyOpen = routes.toList().firstWhereOrNull((element) => element == RoutePaths.kOfferDetailPath) != null;
    if (alreadyOpen) {
      router.pushReplacementNamed(
        Routes.kOfferDetailScreen,
        extra: offerId.trim(),
        pathParameters: {
          RouteArguments.isDraftOffer: isRejected.toString(),
        },
      );
    } else {
      router.pushNamed(
        Routes.kOfferDetailScreen,
        extra: offerId.trim(),
        pathParameters: {
          RouteArguments.isDraftOffer: isRejected.toString(),
        },
      );
    }
  }

  /// Navigate to Finance request detail
  static void goToFinanceRequestDetails({String financeRequestId = ""}) {
    final routes = getAllRoutes();

    bool alreadyOpen = routes.toList().firstWhereOrNull((element) => element == RoutePaths.kFinanceRequestDetailsPath) != null;
    if (alreadyOpen) {
      router.pushReplacementNamed(
        Routes.kFinanceRequestDetailsScreen,
        pathParameters: {
          RouteArguments.requestId: financeRequestId,
        },
      );
    } else {
      router.pushNamed(
        Routes.kFinanceRequestDetailsScreen,
        pathParameters: {
          RouteArguments.requestId: financeRequestId,
        },
      );
    }
  }

  static void goToSignIn() {
    router.goNamed(Routes.kLoginScreen);
  }
}
