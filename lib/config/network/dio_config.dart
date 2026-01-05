import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mashrou3/app/db/app_preferences.dart';
import 'package:mashrou3/app/navigation/app_router.dart';
import 'package:mashrou3/app/navigation/routes.dart';
import 'package:mashrou3/app/ui/owner_screens/dashboard/cubit/owner_dashboard_cubit.dart';
import 'package:mashrou3/app/ui/owner_screens/dashboard/sub_screens/home/cubit/owner_home_cubit.dart';
import 'package:mashrou3/app/ui/owner_screens/dashboard/sub_screens/in_review/cubit/in_review_cubit.dart';
import 'package:mashrou3/app/ui/screens/dashboard/sub_screens/favourite/cubit/favourite_cubit.dart';
import 'package:mashrou3/app/ui/screens/dashboard/sub_screens/home/cubit/home_cubit.dart';
import 'package:mashrou3/app/ui/screens/filter/model/filter_request_model.dart';
import 'package:mashrou3/config/resources/app_strings.dart';
import 'package:mashrou3/config/services/push_notification_service.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../app/db/session_tracker.dart';
import '../flavor_config.dart';
import '../utils.dart';

class DioProvider {
  static final DioProvider _instance = DioProvider._internal();

  static DioProvider get instance => _instance;

  factory DioProvider() => _instance;

  DioProvider._internal();

  late Dio mDio;

  AppPreferences appPreferences = AppPreferences();
  var fcmToken = '';

  Future<String> getAuthToken() async {
    String token = await appPreferences.getApiToken();
    printf("Auth token: $token");
    return token;
  }

  Future<String> getLangCode() async {
    String? selectedLanguage = await appPreferences.getLanguageCode();
    return selectedLanguage ?? 'en';
  }

  void initialise() {
    mDio = Dio(
      BaseOptions(
          baseUrl: FlavorConfig.instance.values.baseUrl,
          connectTimeout: const Duration(seconds: 59),
          receiveTimeout: const Duration(seconds: 60),
          receiveDataWhenStatusError: true,
          headers: {
            'Content-Type': 'application/json',
            'accept': 'application/json',
            // 'device ': 'mobile',
            // 'lang ': getLangCode(),
          }),
    );

    if(kDebugMode) {
      mDio.interceptors.add(PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          request: true));
    }
  }

  /// Get base API.
  Future<Response> getBaseAPI(
      {required String url, Map<String, dynamic>? queryParams}) async {
    try {
      Options requestOptions = Options(
        headers: {
          "lang": await getLangCode(),
        },
      );
      return await mDio.get(url,
          queryParameters: queryParams, options: requestOptions);
    } on DioException catch (ex) {
      if (ex.type == DioExceptionType.badResponse) {
        // Parse the response data to get the message string
        String message =
            ex.response?.data['message'] ?? 'Unknown error occurred';
        // printf(" Message-----------${message}");

        return Response(
            data: message,
            statusMessage: message,
            statusCode: ex.response?.statusCode ?? 500,
            requestOptions: RequestOptions());
      } else if (ex.type == DioExceptionType.connectionError) {
        // OverlayLoadingProgress.stop();
        // Parse the response data to get the message string
        String message = AppStrings.noInternetFoundTitle;
        // Handle 401 Unauthorized
        if (ex.response?.statusCode == 401) {
          await _handleLogout();
        }
        return Response(
            data: message,
            statusMessage: message,
            statusCode: ex.response?.statusCode ?? 500,
            requestOptions: RequestOptions());
      } else if (ex.type == DioExceptionType.unknown) {
        // Parse the response data to get the message string
        String message = AppStrings.somethingWentWrongTitle;
        // printf(" Message-----------${message}");

        return Response(
            data: message,
            statusMessage: message,
            statusCode: ex.response?.statusCode ?? 500,
            requestOptions: RequestOptions());
      } else if (ex.type == DioExceptionType.connectionTimeout) {
        return Response(
            data: AppStrings.connectionTimeoutMessage,
            statusMessage: AppStrings.connectionTimeoutMessage,
            statusCode: 500,
            requestOptions: RequestOptions());
      }
      return Response(
          data: ex.message,
          statusMessage: ex.message,
          statusCode: 500,
          requestOptions: RequestOptions());
    }
  }

  /// Post base API.
  Future<Response> postBaseAPI({required String url, dynamic data}) async {
    try {
      Options requestOptions = Options(
        headers: {
          "lang": await getLangCode(),
        },
      );
      return await mDio.post(url, data: data, options: requestOptions);
    } on DioException catch (ex) {
      // OverlayLoadingProgress.stop();
      if (ex.type == DioExceptionType.badResponse) {
        // Parse the response data to get the message string
        String message =
            ex.response?.data['message'] ?? 'Unknown error occurred';
        // printf(" Message-----------${message}");
        // Handle 401 Unauthorized
        if (ex.response?.statusCode == 401) {
          await _handleLogout();
        }
        return Response(
            data: message,
            statusMessage: message,
            statusCode: ex.response?.statusCode ?? 500,
            requestOptions: RequestOptions());
      } else if (ex.type == DioExceptionType.connectionError) {
        // Parse the response data to get the message string
        String message = AppStrings.noInternetFoundTitle;
        // printf(" Message-----------${message}");

        return Response(
            data: message,
            statusMessage: message,
            statusCode: ex.response?.statusCode ?? 500,
            requestOptions: RequestOptions());
      } else if (ex.type == DioExceptionType.unknown) {
        // Parse the response data to get the message string
        String message = AppStrings.somethingWentWrongTitle;
        // printf(" Message-----------${message}");

        return Response(
            data: message,
            statusMessage: message,
            statusCode: ex.response?.statusCode ?? 500,
            requestOptions: RequestOptions());
      } else if (ex.type == DioExceptionType.connectionTimeout) {
        return Response(
            data: AppStrings.connectionTimeoutMessage,
            statusMessage: AppStrings.connectionTimeoutMessage,
            statusCode: 500,
            requestOptions: RequestOptions());
      }
      return Response(
          data: ex.message,
          statusMessage: ex.message,
          statusCode: 500,
          requestOptions: RequestOptions());
    }
  }

  /// POST base API with Token.
  Future<Response> postBaseAPIWithToken(
      {required String url,
      dynamic data,
      BuildContext? context,
      Map<String, dynamic>? queryParameters,
      bool? isExceptionNeeded = false}) async {
    try {
      // Create RequestOptions and set the headers, including the API token
      Options requestOptions = Options(
        headers: {
          "Authorization": "Bearer ${await getAuthToken()}",
          "lang": await getLangCode(),
          "device": "mobile",
        },
      );
      return await mDio.post(
        url,
        data: data,
        options: requestOptions,
      );
    } on DioException catch (ex) {
      // OverlayLoadingProgress.stop();
      if (ex.type == DioExceptionType.badResponse) {
        // Parse the response data to get the message string
        String message =
            ex.response?.data['message'] ?? 'Unknown error occurred';
        // Handle 401 Unauthorized
        if (ex.response?.statusCode == 401) {
          await _handleLogout();
        }
        return Response(
            data: isExceptionNeeded ?? false ? ex.response?.data : message,
            statusMessage: message,
            statusCode: ex.response?.statusCode ?? 500,
            requestOptions: RequestOptions());
      } else if (ex.type == DioExceptionType.connectionTimeout) {
        return Response(
            data: AppStrings.connectionTimeoutMessage,
            statusMessage: AppStrings.connectionTimeoutMessage,
            statusCode: 500,
            requestOptions: RequestOptions());
      } else if (ex.type == DioExceptionType.connectionError) {
        // Parse the response data to get the message string
        String message = AppStrings.noInternetFoundTitle;
        return Response(
            data: message,
            statusMessage: message,
            statusCode: ex.response?.statusCode ?? 500,
            requestOptions: RequestOptions());
      } else if (ex.type == DioExceptionType.unknown) {
        // Parse the response data to get the message string
        String message = AppStrings.somethingWentWrongTitle;
        // printf(" Message-----------${message}");

        return Response(
            data: message,
            statusMessage: message,
            statusCode: ex.response?.statusCode ?? 500,
            requestOptions: RequestOptions());
      } else {
        return Response(
            data: ex.message,
            statusMessage: ex.message,
            statusCode: 500,
            requestOptions: RequestOptions());
      }
    }
  }

  /// POST base API with Token.
  Future<Response> getBaseAPIWithTokenAndRequestParam(
      {required String url,
      dynamic data,
      String? search,
      Map<String, dynamic>? dataOption,
      Map<String, dynamic>? queryParameters,
      bool? isExceptionNeeded = false}) async {
    try {

      Options requestOptions = Options(
        headers: {
          "Authorization": "Bearer ${await getAuthToken()}",
          "lang": await getLangCode(),
        },
      );

      String fullUrl = "$url?search=${search ?? ""}";

      if (queryParameters != null && queryParameters.isNotEmpty) {
        // Convert all query parameter values to strings to avoid type errors
        final Map<String, String> stringQueryParams = queryParameters.map(
          (key, value) => MapEntry(
            key,
            value is Iterable
                ? value.map((e) => e.toString()).join(',')
                : value.toString(),
          ),
        );
        final queryString = Uri(queryParameters: stringQueryParams).query;
        fullUrl = "$fullUrl&$queryString";
      }

      return await mDio.get(
        fullUrl,
        data: data,
        options: requestOptions,
      );
    } on DioException catch (ex) {
      if (ex.type == DioExceptionType.badResponse) {
        // Parse the response data to get the message string
        String message =
            ex.response?.data['message'] ?? 'Unknown error occurred';
        // Handle 401 Unauthorized
        if (ex.response?.statusCode == 401) {
          await _handleLogout();
        }
        return Response(
            data: isExceptionNeeded ?? false ? ex.response?.data : message,
            statusMessage: message,
            statusCode: ex.response?.statusCode ?? 500,
            requestOptions: RequestOptions());
      } else if (ex.type == DioExceptionType.connectionTimeout) {
        return Response(
            data: AppStrings.connectionTimeoutMessage,
            statusMessage: AppStrings.connectionTimeoutMessage,
            statusCode: 500,
            requestOptions: RequestOptions());
      } else if (ex.type == DioExceptionType.connectionError) {
        // Parse the response data to get the message string
        String message = AppStrings.noInternetFoundTitle;
        return Response(
            data: message,
            statusMessage: message,
            statusCode: ex.response?.statusCode ?? 500,
            requestOptions: RequestOptions());
      } else if (ex.type == DioExceptionType.unknown) {
        // Parse the response data to get the message string
        String message = AppStrings.somethingWentWrongTitle;
        // printf(" Message-----------${message}");

        return Response(
            data: message,
            statusMessage: message,
            statusCode: ex.response?.statusCode ?? 500,
            requestOptions: RequestOptions());
      } else {
        return Response(
            data: ex.message,
            statusMessage: ex.message,
            statusCode: 500,
            requestOptions: RequestOptions());
      }
    }
  }

  /// GET base API with token.
  Future<Response> getBaseAPIWithToken(
      {required String url, Map<String, dynamic>? queryParams}) async {
    try {
      // Create RequestOptions and set the headers, including the API token
      Options requestOptions = Options(
        headers: {
          "Authorization": "Bearer ${await getAuthToken()}",
          // 'device ': 'mobile',
          "lang": await getLangCode(),
        },
      );
      return await mDio.get(
        url,
        queryParameters: queryParams,
        options: requestOptions,
      );
    } on DioException catch (ex) {
      // OverlayLoadingProgress.stop();
      if (ex.type == DioExceptionType.badResponse) {
        // Parse the response data to get the message string
        String message =
            ex.response?.data?['message'] ?? 'Unknown error occurred';
        // printf(" Message-----------${message}");
        // Handle 401 Unauthorized
        if (ex.response?.statusCode == 401) {
          await _handleLogout();
        }
        return Response(
            data: message,
            statusMessage: message,
            statusCode: ex.response?.statusCode ?? 500,
            requestOptions: RequestOptions());
      } else if (ex.type == DioExceptionType.connectionError) {
        // Parse the response data to get the message string
        String message = AppStrings.noInternetFoundTitle;
        // printf(" Message-----------${message}");

        return Response(
            data: message,
            statusMessage: message,
            statusCode: ex.response?.statusCode ?? 500,
            requestOptions: RequestOptions());
      } else if (ex.type == DioExceptionType.unknown) {
        // Parse the response data to get the message string
        String message = AppStrings.somethingWentWrongTitle;
        // printf(" Message-----------${message}");

        return Response(
            data: message,
            statusMessage: message,
            statusCode: ex.response?.statusCode ?? 500,
            requestOptions: RequestOptions());
      } else if (ex.type == DioExceptionType.unknown) {
        // Parse the response data to get the message string
        String message = AppStrings.somethingWentWrongTitle;
        // printf(" Message-----------${message}");

        return Response(
            data: message,
            statusMessage: message,
            statusCode: ex.response?.statusCode ?? 500,
            requestOptions: RequestOptions());
      } else if (ex.type == DioExceptionType.connectionTimeout) {
        return Response(
            data: AppStrings.connectionTimeoutMessage,
            statusMessage: AppStrings.connectionTimeoutMessage,
            statusCode: 500,
            requestOptions: RequestOptions());
      }
      return Response(
          data: ex.message,
          statusMessage: ex.message,
          statusCode: 500,
          requestOptions: RequestOptions());
    }
  }

  /// PATCH base API with Token.
  Future<Response> patchBaseAPIWithToken(
      {required String url,
      dynamic data,
      Map<String, dynamic>? queryParameters,
      required String id}) async {
    try {
      // Create RequestOptions and set the headers, including the API token
      Options requestOptions = Options(
        headers: {
          "Authorization": "Bearer ${await getAuthToken()}",
        },
      );
      return await mDio.patch(
        url + id,
        data: data,
        options: requestOptions,
      );
    } on DioException catch (ex) {
      // OverlayLoadingProgress.stop();
      if (ex.type == DioExceptionType.badResponse) {
        // Parse the response data to get the message string
        String message =
            ex.response?.data['message'] ?? 'Unknown error occurred';
        // printf(" Message-----------${message}");
        // Handle 401 Unauthorized
        if (ex.response?.statusCode == 401) {
          await _handleLogout();
        }
        return Response(
            data: message,
            statusMessage: message,
            statusCode: ex.response?.statusCode ?? 500,
            requestOptions: RequestOptions());
      } else if (ex.type == DioExceptionType.connectionError) {
        // Parse the response data to get the message string
        String message = AppStrings.noInternetFoundTitle;
        // printf(" Message-----------${message}");

        return Response(
            data: message,
            statusMessage: message,
            statusCode: ex.response?.statusCode ?? 500,
            requestOptions: RequestOptions());
      } else if (ex.type == DioExceptionType.unknown) {
        // Parse the response data to get the message string
        String message = AppStrings.somethingWentWrongTitle;
        // printf(" Message-----------${message}");

        return Response(
            data: message,
            statusMessage: message,
            statusCode: ex.response?.statusCode ?? 500,
            requestOptions: RequestOptions());
      } else if (ex.type == DioExceptionType.connectionTimeout) {
        return Response(
            data: AppStrings.connectionTimeoutMessage,
            statusMessage: AppStrings.connectionTimeoutMessage,
            statusCode: 500,
            requestOptions: RequestOptions());
      }
      return Response(
          data: ex.message,
          statusMessage: ex.message,
          statusCode: 500,
          requestOptions: RequestOptions());
    }
  }

  /// PUT base API with Token.
  Future<Response> putBaseAPIWithToken(
      {required String url,
      dynamic data,
      Map<String, dynamic>? queryParameters,
      String? id}) async {
    try {
      // Create RequestOptions and set the headers, including the API token
      Options requestOptions = Options(
        headers: {
          "Authorization": "Bearer ${await getAuthToken()}",
          "lang": await getLangCode(),
        },
      );
      return await mDio.put(
        id != null ? url + id : url,
        data: data,
        options: requestOptions,
      );
    } on DioException catch (ex) {
      // OverlayLoadingProgress.stop();
      if (ex.type == DioExceptionType.badResponse) {
        // Parse the response data to get the message string
        String message =
            (ex.response?.data['message'] ?? 'Unknown error occurred')
                .toString();
        // printf(" Message-----------${message}");
        // Handle 401 Unauthorized
        if (ex.response?.statusCode == 401) {
          await _handleLogout();
        }
        return Response(
            data: message,
            statusMessage: message,
            statusCode: ex.response?.statusCode ?? 500,
            requestOptions: RequestOptions());
      } else if (ex.type == DioExceptionType.connectionError) {
        // Parse the response data to get the message string
        String message = AppStrings.noInternetFoundTitle;
        // printf(" Message-----------${message}");

        return Response(
            data: message,
            statusMessage: message,
            statusCode: ex.response?.statusCode ?? 500,
            requestOptions: RequestOptions());
      } else if (ex.type == DioExceptionType.unknown) {
        // Parse the response data to get the message string
        String message = AppStrings.somethingWentWrongTitle;
        // printf(" Message-----------${message}");

        return Response(
            data: message,
            statusMessage: message,
            statusCode: ex.response?.statusCode ?? 500,
            requestOptions: RequestOptions());
      } else if (ex.type == DioExceptionType.connectionTimeout) {
        return Response(
            data: AppStrings.connectionTimeoutMessage,
            statusMessage: AppStrings.connectionTimeoutMessage,
            statusCode: 500,
            requestOptions: RequestOptions());
      }
      return Response(
          data: ex.message,
          statusMessage: ex.message,
          statusCode: 500,
          requestOptions: RequestOptions());
    }
  }

  /// PUT base API with Token.
  Future<Response> putBaseAPIWithToken2({
    required String url,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      // Create RequestOptions and set the headers, including the API token
      Options requestOptions = Options(
        headers: {
          "Authorization": "Bearer ${await getAuthToken()}",
          "lang": await getLangCode(),
        },
      );
      return await mDio.put(
        url,
        data: data,
        options: requestOptions,
      );
    } on DioException catch (ex) {
      // OverlayLoadingProgress.stop();
      if (ex.type == DioExceptionType.badResponse) {
        // Parse the response data to get the message string
        String message =
            ex.response?.data['message'] ?? 'Unknown error occurred';
        // printf(" Message-----------${message}");
        // Handle 401 Unauthorized
        if (ex.response?.statusCode == 401) {
          await _handleLogout();
        }
        return Response(
            data: message,
            statusMessage: message,
            statusCode: ex.response?.statusCode ?? 500,
            requestOptions: RequestOptions());
      } else if (ex.type == DioExceptionType.connectionError) {
        // Parse the response data to get the message string
        String message = AppStrings.noInternetFoundTitle;
        // printf(" Message-----------${message}");

        return Response(
            data: message,
            statusMessage: message,
            statusCode: ex.response?.statusCode ?? 500,
            requestOptions: RequestOptions());
      } else if (ex.type == DioExceptionType.unknown) {
        // Parse the response data to get the message string
        String message = AppStrings.somethingWentWrongTitle;
        // printf(" Message-----------${message}");

        return Response(
            data: message,
            statusMessage: message,
            statusCode: ex.response?.statusCode ?? 500,
            requestOptions: RequestOptions());
      } else if (ex.type == DioExceptionType.connectionTimeout) {
        return Response(
            data: AppStrings.connectionTimeoutMessage,
            statusMessage: AppStrings.connectionTimeoutMessage,
            statusCode: 500,
            requestOptions: RequestOptions());
      }
      return Response(
          data: ex.message,
          statusMessage: ex.message,
          statusCode: 500,
          requestOptions: RequestOptions());
    }
  }

  /// DELETE base API with token.
  Future<Response> deleteBaseAPIWithToken({
    required String url,
    dynamic data,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      // Create RequestOptions and set the headers, including the API token
      Options requestOptions = Options(
        headers: {
          "Authorization": "Bearer ${await getAuthToken()}",
          "lang": await getLangCode(),
        },
      );
      return await mDio.delete(
        url,
        queryParameters: queryParams,
        data: data,
        options: requestOptions,
      );
    } on DioException catch (ex) {
      // OverlayLoadingProgress.stop();
      if (ex.type == DioExceptionType.badResponse) {
        // Parse the response data to get the message string
        String message =
            ex.response?.data['message'] ?? 'Unknown error occurred';
        // printf(" Message-----------${message}");
        // Handle 401 Unauthorized
        if (ex.response?.statusCode == 401) {
          await _handleLogout();
        }
        return Response(
            data: message,
            statusMessage: message,
            statusCode: ex.response?.statusCode ?? 500,
            requestOptions: RequestOptions());
      } else if (ex.type == DioExceptionType.connectionError) {
        // Parse the response data to get the message string
        String message = AppStrings.noInternetFoundTitle;
        // printf(" Message-----------${message}");

        return Response(
            data: message,
            statusMessage: message,
            statusCode: ex.response?.statusCode ?? 500,
            requestOptions: RequestOptions());
      } else if (ex.type == DioExceptionType.unknown) {
        // Parse the response data to get the message string
        String message = AppStrings.somethingWentWrongTitle;
        // printf(" Message-----------${message}");

        return Response(
            data: message,
            statusMessage: message,
            statusCode: ex.response?.statusCode ?? 500,
            requestOptions: RequestOptions());
      } else if (ex.type == DioExceptionType.unknown) {
        // Parse the response data to get the message string
        String message = AppStrings.somethingWentWrongTitle;
        // printf(" Message-----------${message}");

        return Response(
            data: message,
            statusMessage: message,
            statusCode: ex.response?.statusCode ?? 500,
            requestOptions: RequestOptions());
      } else if (ex.type == DioExceptionType.connectionTimeout) {
        return Response(
            data: AppStrings.connectionTimeoutMessage,
            statusMessage: AppStrings.connectionTimeoutMessage,
            statusCode: 500,
            requestOptions: RequestOptions());
      }
      return Response(
          data: ex.message,
          statusMessage: ex.message,
          statusCode: 500,
          requestOptions: RequestOptions());
    }
  }

  Future<void> _handleLogout() async {
    BuildContext? context = AppRouter.rootNavigatorKey.currentContext;
    context?.read<HomeCubit>().filterRequestModel = FilterRequestModel();
    context?.read<FavouriteCubit>().filterRequestModel = FilterRequestModel();
    context?.read<OwnerHomeCubit>().filterRequestModel = FilterRequestModel();
    context?.read<InReviewCubit>().filterRequestModel = FilterRequestModel();
    await SessionTracker().onLogout();
    await GetIt.I<AppPreferences>().clearData();
    await NotificationService().cancelAllNotifications();

    context?.read<OwnerDashboardCubit>().searchText = "";
    context?.read<OwnerHomeCubit>().searchText = "";
    context?.goNamed(Routes.kLoginScreen);
  }
}
