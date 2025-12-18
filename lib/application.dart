import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mashrou3/app/bloc/common_api_services/common_api_cubit.dart';
import 'package:mashrou3/app/repository/filter_repository.dart';
import 'package:mashrou3/app/repository/notification_repository.dart';
import 'package:mashrou3/app/repository/property_repository.dart';
import 'package:mashrou3/app/ui/custom_widget/city_list/cubit/city_list_cubit.dart';
import 'package:mashrou3/app/ui/custom_widget/file_picker_widget/cubit/file_picker_cubit.dart';
import 'package:mashrou3/app/ui/custom_widget/toggle_widget/toggle_cubit.dart';
import 'package:mashrou3/app/ui/owner_screens/add_edit_property/cubit/add_edit_property_cubit.dart';
import 'package:mashrou3/app/ui/owner_screens/dashboard/cubit/owner_dashboard_cubit.dart';
import 'package:mashrou3/app/ui/owner_screens/owner_filter/cubit/in_review_filter_cubit.dart';
import 'package:mashrou3/app/ui/owner_screens/owner_filter/cubit/owner_filter_cubit.dart';
import 'package:mashrou3/app/ui/owner_screens/owner_property_details/cubit/owner_property_details_cubit.dart';
import 'package:mashrou3/app/ui/owner_screens/visit_requests_list/cubit/visit_requests_list_cubit.dart';
import 'package:mashrou3/app/ui/screens/app_prefereces/cubit/app_preferences_cubit.dart';
import 'package:mashrou3/app/ui/screens/authentication/component/bloc/country_selection_cubit.dart';
import 'package:mashrou3/app/ui/screens/authentication/component/bloc/select_country_cubit.dart';
import 'package:mashrou3/app/ui/screens/authentication/otp_verification/cubit/otp_verification_cubit.dart';
import 'package:mashrou3/app/ui/screens/cms/cubit/cms_cubit.dart';
import 'package:mashrou3/app/ui/screens/connectivity/cubit/connectivity_cubit.dart';
import 'package:mashrou3/app/ui/screens/dashboard/cubit/dashboard_cubit.dart';
import 'package:mashrou3/app/ui/screens/dashboard/sub_screens/my_offers_list/cubit/my_offers_list_cubit.dart';
import 'package:mashrou3/app/ui/screens/filter/cubit/filter_cubit.dart';
import 'package:mashrou3/app/ui/screens/finance_request/cubit/finance_request_cubit.dart';
import 'package:mashrou3/app/ui/screens/property_details/cubit/property_details_cubit.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/add_my_offers/cubit/add_my_offers_cubit.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/bank_details/cubit/bank_details_cubit.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/vendor_finance/vendor_categories/cubit/vendor_categories_cubit.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/vendor_finance/vendor_details/cubit/vendor_detail_cubit.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/vendor_finance/vendor_details/subscreen/offer_detail/cubit/offer_detail_cubit.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/vendor_finance/vendor_details/subscreen/offer_list/cubit/offer_listing_cubit.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/vendor_finance/vendor_list/cubit/vendor_list_cubit.dart';
import 'package:mashrou3/app/ui/screens/banks_offer/cubit/banks_offer_list_cubit.dart';
import 'package:mashrou3/app/ui/screens/ratings/cubit/add_rating_cubit.dart';
import 'package:mashrou3/app/ui/screens/ratings/cubit/rating_update_cubit.dart';
import 'package:mashrou3/app/ui/screens/ratings/cubit/view_review_cubit.dart';
import 'package:mashrou3/app/ui/screens/search_bar/cubit/search_bar_cubit.dart';
import 'package:mashrou3/app/ui/screens/web_view/cubit/web_view_cubit.dart';
import 'package:mashrou3/config/services/property_vendor_finance_service.dart';
import 'package:mashrou3/l10n/app_localizations.dart';

import 'app/bloc/application_cubit.dart';
import 'app/bloc/common_api_services/common_api_services.dart';
import 'app/db/app_preferences.dart';
import 'app/navigation/app_router.dart';
import 'app/repository/authentication_repository.dart';
import 'app/repository/bank_management_repository.dart';
import 'app/repository/bank_offer_repository.dart';
import 'app/repository/common_api_repository.dart';
import 'app/repository/drawer_vendor_list_repository.dart';
import 'app/repository/offers_management_repository.dart';
import 'app/repository/vendors_repository.dart';
import 'app/storage/app_storage.dart';
import 'app/ui/custom_widget/bottom_navigation_widget/bottom_navigation_cubit.dart';
import 'app/ui/custom_widget/side_drawer_widget/side_drawer_cubit.dart';
import 'app/ui/owner_screens/dashboard/sub_screens/home/cubit/owner_home_cubit.dart';
import 'app/ui/owner_screens/dashboard/sub_screens/in_review/cubit/in_review_cubit.dart';
import 'app/ui/screens/authentication/component/otp_widget/bloc/otp_input_section_cubit.dart';
import 'app/ui/screens/authentication/login/cubit/login_cubit.dart';
import 'app/ui/screens/authentication/register/complete_profile/cubit/complete_profile_cubit.dart';
import 'app/ui/screens/authentication/register/register_step1/cubit/register_step1_cubit.dart';
import 'app/ui/screens/authentication/register/register_step2/cubit/register_step2_cubit.dart';
import 'app/ui/screens/authentication/register/register_step3/cubit/register_step3_cubit.dart';
import 'app/ui/screens/authentication/register/undergoing_verification/cubit/undergoing_verification_cubit.dart';
import 'app/ui/screens/dashboard/sub_screens/add_offer/cubit/add_vendor_cubit.dart';
import 'app/ui/screens/dashboard/sub_screens/favourite/cubit/favourite_cubit.dart';
import 'app/ui/screens/dashboard/sub_screens/home/cubit/home_cubit.dart';
import 'app/ui/screens/dashboard/sub_screens/notification/cubit/notification_cubit.dart';
import 'app/ui/screens/filter/cubit/fav_filter_cubit.dart';
import 'app/ui/screens/personal_information/cubit/personal_information_cubit.dart';
import 'app/ui/screens/personal_information/sub_screens/add_edit_certificates/cubit/add_edit_certificates_cubit.dart';
import 'app/ui/screens/personal_information/sub_screens/edit_profile/cubit/edit_profile_cubit.dart';
import 'app/ui/screens/personal_information/sub_screens/view_all_certificates/cubit/view_all_certificates_cubit.dart';
import 'app/ui/screens/profile_detail/cubit/profile_detail_cubit.dart';
import 'app/ui/screens/property_details/sub_screens/banks_list/cubit/banks_list_cubit.dart';
import 'app/ui/screens/property_details/sub_screens/visit_request/cubit/visit_request_cubit.dart';
import 'app/ui/screens/property_not_found/cubit/property_not_found_cubit.dart';
import 'app/ui/screens/recently_visited_properties/cubit/recently_visited_properties_cubit.dart';
import 'app/ui/screens/requested_properties/cubit/requested_properties_cubit.dart';
import 'app/ui/screens/splash/cubit/splash_cubit.dart';
import 'app/ui/screens/subscription_information/cubit/subscription_information_cubit.dart';
import 'app/ui/screens/vendors/cubit/drawer_vendors_list_cubit.dart';
import 'app/ui/screens/vendors/cubit/vendors_list_cubit.dart';
import 'config/firebase/firebase_options.dart';
import 'config/flavor_config.dart';
import 'config/network/app_connectivity.dart';
import 'config/network/dio_config.dart';
import 'config/resources/app_constants.dart';
import 'config/resources/app_themes.dart';

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<Application> createState() => _ApplicationState();
}

// 99925222648
class _ApplicationState extends State<Application> {
  final AppConnectivity _connectivity = AppConnectivity.instance;
  Map _source = {ConnectivityResult.none: false};

  @override
  void initState() {
    super.initState();
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _source = source);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isNetworkAvailable =
        _source.keys.toList()[0] != ConnectivityResult.none;
    return FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, _) {
          return FutureBuilder(
              future: setupLocator(),
              builder: (context, _) {
                return MultiBlocProvider(
                    providers: [
                      BlocProvider(
                          create: (BuildContext context) => ApplicationCubit()),
                      BlocProvider(
                        create: (BuildContext context) => ConnectivityCubit(),
                      ),
                      BlocProvider(
                        create: (BuildContext context) => WebViewCubit(),
                      ),
                      BlocProvider(
                          create: (BuildContext context) => SplashCubit(
                                repository: GetIt.I<AuthenticationRepository>(),
                              )),
                      BlocProvider(
                          create: (BuildContext context) =>
                              CountrySelectionCubit()),
                      BlocProvider(
                          create: (BuildContext context) =>
                              SelectCountryCubit()),
                      BlocProvider(
                          create: (BuildContext context) => CommonApiCubit(
                                commonApiService: GetIt.I<CommonApiService>(),
                              )),
                      BlocProvider(
                          create: (BuildContext context) => LoginCubit(
                                repository: GetIt.I<AuthenticationRepository>(),
                                commonApiRepository:
                                    GetIt.I<CommonApiRepository>(),
                              )),
                      BlocProvider(
                          create: (BuildContext context) =>
                              OtpInputSectionCubit()),
                      BlocProvider(
                          create: (BuildContext context) =>
                              ToggleCubit(AppConstants.propertyCategory)),
                      BlocProvider(
                          create: (BuildContext context) => RegisterStep1Cubit(
                              repository: GetIt.I<AuthenticationRepository>())),
                      BlocProvider(
                          create: (BuildContext context) => RegisterStep2Cubit(
                              repository: GetIt.I<AuthenticationRepository>())),
                      BlocProvider(
                          create: (BuildContext context) => RegisterStep3Cubit(
                              repository: GetIt.I<AuthenticationRepository>())),
                      BlocProvider(
                          create: (BuildContext context) =>
                              OtpVerificationCubit(
                                  repository:
                                      GetIt.I<AuthenticationRepository>())),
                      BlocProvider(
                          create: (BuildContext context) =>
                              CompleteProfileCubit(
                                repository: GetIt.I<AuthenticationRepository>(),
                                bankManagementRepository:
                                    GetIt.I<BankManagementRepository>(),
                              )),
                      BlocProvider(
                          create: (BuildContext context) => EditProfileCubit(
                              repository: GetIt.I<AuthenticationRepository>())),
                      BlocProvider(
                          create: (BuildContext context) =>
                              UndergoingVerificationCubit(
                                  repository:
                                      GetIt.I<AuthenticationRepository>())),
                      BlocProvider(
                          create: (BuildContext context) => DashboardCubit(
                              repository: GetIt.I<AuthenticationRepository>(),
                              commonApiRepository:
                                  GetIt.I<CommonApiRepository>(),
                              notificationRepository:
                                  GetIt.I<NotificationRepository>())),
                      BlocProvider(
                          create: (BuildContext context) => OwnerDashboardCubit(
                              notificationRepository:
                                  GetIt.I<NotificationRepository>(),
                              commonApiRepository:
                                  GetIt.I<CommonApiRepository>(),
                              authRepository:
                                  GetIt.I<AuthenticationRepository>())),
                      BlocProvider(
                          create: (BuildContext context) =>
                              RatingUpdateCubit()),
                      BlocProvider(
                          create: (BuildContext context) => BottomNavCubit()),
                      BlocProvider(
                          create: (BuildContext context) => FilePickerCubit()),
                      BlocProvider(
                          create: (BuildContext context) => CityListCubit()),
                      BlocProvider(
                          create: (BuildContext context) => CmsCubit()),
                      BlocProvider(
                          create: (BuildContext context) => HomeCubit(
                              propertyRepository:
                                  GetIt.I<PropertyRepository>())),
                      BlocProvider(
                          create: (BuildContext context) =>
                              RequestedPropertiesCubit(
                                  propertyRepository:
                                      GetIt.I<PropertyRepository>())),
                      BlocProvider(
                          create: (BuildContext context) =>
                              RecentlyVisitedPropertiesCubit(
                                  propertyRepository:
                                      GetIt.I<PropertyRepository>())),
                      BlocProvider(
                          create: (BuildContext context) =>
                              PersonalInformationCubit(
                                  repository:
                                      GetIt.I<AuthenticationRepository>())),
                      BlocProvider(
                          create: (BuildContext context) => ProfileDetailCubit(
                              repository: GetIt.I<AuthenticationRepository>(),
                              propertyRepository: GetIt.I<PropertyRepository>())),
                      BlocProvider(
                          create: (BuildContext context) =>
                              AddEditCertificatesCubit(
                                  repository:
                                      GetIt.I<AuthenticationRepository>())),
                      BlocProvider(
                          create: (BuildContext context) =>
                              ViewAllCertificatesCubit(
                                  repository:
                                      GetIt.I<AuthenticationRepository>())),
                      BlocProvider(
                          create: (BuildContext context) =>
                              PropertyDetailsCubit(
                                propertyRepository:
                                    GetIt.I<PropertyRepository>(),
                                offersManagementRepository:
                                    GetIt.I<OffersManagementRepository>(),
                              )),
                      BlocProvider(
                          create: (BuildContext context) =>
                              OwnerPropertyDetailsCubit(
                                  propertyRepository:
                                      GetIt.I<PropertyRepository>())),
                      BlocProvider(
                          create: (BuildContext context) =>
                              PropertyNotFoundCubit()),
                      BlocProvider(
                          create: (BuildContext context) => OwnerHomeCubit(
                              propertyRepository:
                                  GetIt.I<PropertyRepository>())),
                      BlocProvider(
                          create: (BuildContext context) => FavouriteCubit(
                              propertyRepository:
                                  GetIt.I<PropertyRepository>())),
                      BlocProvider(
                          create: (BuildContext context) => MyOffersListCubit(
                              repository:
                                  GetIt.I<OffersManagementRepository>())),
                      BlocProvider(
                          create: (BuildContext context) => AddMyOffersCubit(
                              repository:
                                  GetIt.I<OffersManagementRepository>())),
                      BlocProvider(
                          create: (BuildContext context) => VisitRequestCubit(
                              repository: GetIt.I<PropertyRepository>())),
                      BlocProvider(
                          create: (BuildContext context) => VisitRequestsCubit(
                              repository: GetIt.I<PropertyRepository>())),
                      BlocProvider(
                          create: (BuildContext context) => FinanceRequestCubit(
                              repository: GetIt.I<PropertyRepository>())),
                      BlocProvider(
                          create: (BuildContext context) => InReviewCubit(
                              propertyRepository:
                                  GetIt.I<PropertyRepository>())),
                      BlocProvider(
                          create: (BuildContext context) => SearchBarCubit(
                              repository: GetIt.I<PropertyRepository>())),
                      BlocProvider(
                          create: (BuildContext context) => BanksListCubit(
                              repository: GetIt.I<BankManagementRepository>())),
                      BlocProvider(
                          create: (BuildContext context) => BanksOfferListCubit(
                              repository: GetIt.I<BankManagementRepository>())),
                      BlocProvider(
                          create: (BuildContext context) => DrawerVendorsListCubit(
                              repository: GetIt.I<DrawerVendorListRepository>())),
                      BlocProvider(
                          create: (BuildContext context) => VendorsListCubit(
                              repository: GetIt.I<VendorsRepository>())),
                      BlocProvider(
                          create: (BuildContext context) => BankDetailsCubit(
                              repository: GetIt.I<BankManagementRepository>())),
                      BlocProvider(
                          create: (BuildContext context) => SideDrawerCubit()),
                      BlocProvider(
                          create: (BuildContext context) =>
                              AppPreferencesCubit()),
                      BlocProvider(
                          create: (BuildContext context) =>
                              AddEditPropertyCubit(
                                  propertyRepository:
                                      GetIt.I<PropertyRepository>())),
                      BlocProvider(
                          create: (BuildContext context) => NotificationCubit(
                              notificationRepository:
                                  GetIt.I<NotificationRepository>())),
                      BlocProvider(
                          create: (BuildContext context) => FilterCubit(
                              filterRepository: GetIt.I<FilterRepository>(),
                              propertyRepository:
                                  GetIt.I<PropertyRepository>())),
                      BlocProvider(
                          create: (BuildContext context) => FavFilterCubit(
                              filterRepository: GetIt.I<FilterRepository>(),
                              propertyRepository:
                                  GetIt.I<PropertyRepository>())),
                      BlocProvider(
                          create: (BuildContext context) => OwnerFilterCubit(
                              filterRepository: GetIt.I<FilterRepository>(),
                              propertyRepository:
                                  GetIt.I<PropertyRepository>())),
                      BlocProvider(
                          create: (BuildContext context) => InReviewFilterCubit(
                              filterRepository: GetIt.I<FilterRepository>(),
                              propertyRepository:
                                  GetIt.I<PropertyRepository>())),
                      BlocProvider(
                          create: (BuildContext context) => AddRatingCubit(
                              propertyRepository:
                                  GetIt.I<PropertyRepository>())),
                      BlocProvider(
                          create: (BuildContext context) => ViewReviewCubit(
                              propertyRepository:
                                  GetIt.I<PropertyRepository>())),
                      BlocProvider(
                          create: (BuildContext context) => AddVendorOfferCubit(
                              repository:
                                  GetIt.I<OffersManagementRepository>())),
                      BlocProvider(
                          create: (BuildContext context) =>
                              VendorCategoriesCubit(
                                  repository:
                                      GetIt.I<OffersManagementRepository>())),
                      BlocProvider(
                          create: (BuildContext context) => VendorListCubit(
                              repository:
                                  GetIt.I<OffersManagementRepository>())),
                      BlocProvider(
                          create: (BuildContext context) => OfferListingCubit(
                              offerRepository:
                                  GetIt.I<OffersManagementRepository>())),
                      BlocProvider(
                          create: (BuildContext context) => OfferDetailCubit(
                              offerRepository:
                                  GetIt.I<OffersManagementRepository>())),
                      BlocProvider(
                          create: (BuildContext context) =>
                              SubscriptionInformationCubit(
                                  repository:
                                      GetIt.I<AuthenticationRepository>())),
                      BlocProvider(
                          create: (BuildContext context) => VendorDetailCubit(
                              repository: GetIt.I<AuthenticationRepository>(),
                              offerRepository:
                                  GetIt.I<OffersManagementRepository>(),
                              bankManagementRepository:
                                  GetIt.I<BankManagementRepository>())),
                    ],
                    child: BlocProvider(
                      create: (_) =>
                          AppPreferencesCubit()..initializePreferences(),
                      child: BlocBuilder<SideDrawerCubit, SideDrawerState>(
                        builder: (context, _) {
                          final appPreferencesCubit =
                              context.watch<AppPreferencesCubit>();
                          final isDarkMode =
                              appPreferencesCubit.isDarkModeEnabled;
                          final isArabic = appPreferencesCubit.isArabicSelected;

                          final themeMode =
                              isDarkMode ? ThemeMode.dark : ThemeMode.light;
                          final appLocale = isArabic
                              ? const Locale('ar')
                              : const Locale('en');
                          final mediaQueryData = MediaQuery.of(context);
                          final scale = mediaQueryData.textScaler
                              .clamp(minScaleFactor: 1.0, maxScaleFactor: 1.3);
                          AppConstants.appContext = context;
                          return MaterialApp.router(
                            builder: (context, child) {
                              return MediaQuery(
                                data:
                                    mediaQueryData.copyWith(textScaler: scale),
                                child: child!,
                              );
                            },
                            localizationsDelegates:
                                AppLocalizations.localizationsDelegates,
                            supportedLocales: AppLocalizations.supportedLocales,
                            locale: appLocale,
                            theme: AppThemes.main(isDark: false),
                            darkTheme: AppThemes.main(isDark: true),
                            themeMode: themeMode,
                            routeInformationParser:
                                AppRouter.router.routeInformationParser,
                            routerDelegate: AppRouter.router.routerDelegate,
                            routeInformationProvider:
                                AppRouter.router.routeInformationProvider,
                            debugShowCheckedModeBanner: false,
                            title: FlavorConfig.instance.name,
                          );
                        },
                      ),
                    ));
              });
        });
  }

  /// Setup locator
  Future<void> setupLocator() async {
    GetIt getIt = GetIt.I;

    if (!GetIt.instance.isRegistered<AuthenticationRepository>()) {
      getIt.registerSingleton<AuthenticationRepository>(
          AuthenticationRepositoryImpl());
    }

    if (!GetIt.instance.isRegistered<PropertyRepository>()) {
      getIt.registerSingleton<PropertyRepository>(PropertyRepositoryImpl());
    }

    if (!GetIt.instance.isRegistered<FilterRepository>()) {
      getIt.registerSingleton<FilterRepository>(FilterRepositoryImpl());
    }

    if (!GetIt.instance.isRegistered<NotificationRepository>()) {
      getIt.registerSingleton<NotificationRepository>(
          NotificationRepositoryImpl());
    }

    if (!GetIt.instance.isRegistered<BankManagementRepository>()) {
      getIt.registerSingleton<BankManagementRepository>(
          BankManagementRepositoryImpl());
    }

    if (!GetIt.instance.isRegistered<OffersManagementRepository>()) {
      getIt.registerSingleton<OffersManagementRepository>(
          OffersManagementRepositoryImpl());
    }

    if (!GetIt.instance.isRegistered<VendorsRepository>()) {
      getIt.registerSingleton<VendorsRepository>(VendorsRepositoryImpl());
    }

    if (!GetIt.instance.isRegistered<BankOfferListRepository>()) {
      getIt.registerSingleton<BankOfferListRepository>(
          BankOfferListRepositoryImpl());
    }

    getIt.registerSingleton<PropertyVendorFinanceService>(
        PropertyVendorFinanceService());

    getIt.registerSingleton<CommonApiRepository>(CommonApiRepositoryImpl());

    GetIt.I.registerSingleton<CommonApiService>(CommonApiService(
      commonApiRepository: GetIt.I<CommonApiRepository>(),
    ));
    // getIt.registerSingleton<DatabaseHelper>(DatabaseHelper());
    getIt.registerSingleton<DioProvider>(DioProvider());
    getIt.registerSingleton<AppStorage>(AppStorage());

    // Initialise database
    // getIt<DatabaseHelper>().initialiseDb();

    if (!GetIt.instance.isRegistered<AppPreferences>()) {
      getIt.registerSingleton<AppPreferences>(AppPreferences());
    }

    /// Initialise dio provider
    getIt<DioProvider>().initialise();
  }

  void setStatusBarColor(BuildContext context, bool isDarkMode) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: isDarkMode ? Colors.black : Colors.white,
        statusBarIconBrightness:
            isDarkMode ? Brightness.light : Brightness.dark,
      ),
    );
  }
}
