import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashrou3/app/navigation/app_router.dart';
import 'package:mashrou3/config/utils.dart';
import 'package:mashrou3/utils/app_localization.dart';

import '../../../../../../../config/resources/app_constants.dart';
import '../../../../../../model/base/base_model.dart';
import '../../../../../../model/notification/notification_request_model.dart';
import '../../../../../../model/notification/notification_response_model.dart';
import '../../../../../../repository/notification_repository.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository notificationRepository;

  static const int PER_PAGE_SIZE = 20;

  int totalProperties = 0;
  int currentPage = 1;
  int totalPage = 1;
  bool isLoadingMore = false;
  bool isFirstPageLoading = true;
  bool isAPILoading = false;
  bool hasShownSkeleton = false;

  List<NotificationList>? propertyList = [];
  List<NotificationList>? filteredPropertyList = [];

  NotificationCubit({required this.notificationRepository}) : super(NotificationInitial());

  int selectedTagIndex = -1;

  /// Property list API
  Future<void> getNotificationList({
    bool hasMoreData = false,
  }) async {
    isLoadingMore = true;

    if (isAPILoading) {
      return;
    }
    isAPILoading = true;
    if (hasMoreData) {
      isLoadingMore = false;
      if (isLoadingMore || currentPage > totalPage) return;
      emit(NotificationMoreLoading());
    } else {
      emit(NotificationLoading());
    }

    if ((propertyList ?? []).isEmpty && currentPage != 1 && isFirstPageLoading) {
      currentPage = 1;
    }

    final requestModel = NotificationRequestModel(
      sortField: "createdAt",
      sortOrder: "desc",
      itemsPerPage: PER_PAGE_SIZE,
      page: currentPage,
    );

    final response = await notificationRepository.getNotificationByPage(requestModel: requestModel);
    isLoadingMore = false;
    hasShownSkeleton = true;
    isFirstPageLoading = false;
    isAPILoading = false;
    if (response is SuccessResponse && response.data is NotificationResponseModel) {
      NotificationResponseModel propertyListResponse = response.data as NotificationResponseModel;

      // Update pagination details
      totalPage = propertyListResponse.data?.pageCount ?? 1;

      // Add new data to the existing list without duplicates
      final newProperties = propertyListResponse.data?.notificationList ?? [];

      // Avoid adding duplicate properties based on unique ID or other identifying properties
      final existingIds = propertyList?.map((property) => property.sId).toSet() ?? {};
      final uniqueProperties = newProperties.where((property) => !existingIds.contains(property.sId)).toList();

      propertyList?.addAll(uniqueProperties);
      filteredPropertyList = List.from(propertyList ?? []);

      // totalPage = propertyListResponse.data?.pageCount ?? 1;
      // propertyList?.addAll(propertyListResponse.data?.notificationList ?? []);
      // filteredPropertyList = List.from(propertyList ?? []);

      if (filteredPropertyList?.isEmpty ?? true) {
        emit(NoNotificationAvailable());
      } else {
        emit(NotificationAvailable(hasMoreData, currentPage, propertyList ?? []));
      }
    } else if (response is FailedResponse) {
      emit(NotificationError(errorMessage: response.errorMessage));
    }
  }

  void resetNotificationProperties() {
    propertyList = [];
    filteredPropertyList = [];
    currentPage = 1;
    totalPage = 1;
    hasShownSkeleton = false;
  }

// Load more properties
  void loadMoreNotification(BuildContext context) {
    if (currentPage < totalPage) {
      currentPage++;
      getNotificationList(hasMoreData: true);
    }
  }

  /// On Notification Tap.
  void notificationTap({String notification = '', int indexToBeUpdate = -1, required BuildContext context}) async {
    print("notification $notification");
    // Read notification if its unread before moving to deep link.
    if (filteredPropertyList![indexToBeUpdate].isRead == false) {
      await readNotification(notification: notification, indexToBeUpdate: indexToBeUpdate);
    }

    // Move to specific screen.
    _redirectOnTap(filteredPropertyList![indexToBeUpdate], context);
  }

  /// On Tap, notification redirection
  void _redirectOnTap(NotificationList notificationObj, BuildContext context) {
    if (notificationObj.moduleName == "visitRequest") {
      // Handle Visit request redirection.
      AppRouter.goToVisitRequests(isOwner: notificationObj.notificationType == "requestCreated");
      return;
    }
    if (notificationObj.moduleName == "offerReviewRequest") {
      Uri uri = Uri.parse(notificationObj.mobileRedirect ?? "");
      final isVendor = uri.path.toLowerCase().contains(AppConstants.vendor.toLowerCase());
      if (isVendor) {
        String offerId = uri.path.split("/").last;
        AppRouter.goToOffer(offerId: offerId, isRejected: notificationObj.notificationType == "rejected");
        return;
      }
    }
    //Finance request Navigation
    if (notificationObj.moduleName == "finance" && notificationObj.notificationType =="vendorFinance") {
      AppRouter.goToFinanceRequestDetails(financeRequestId: notificationObj.notificationData?.financeOfferId ?? "");
      return;
    }
    if ((notificationObj.mobileRedirect ?? "").isNotEmpty) {
      Uri uri = Uri.parse(notificationObj.mobileRedirect ?? "");
      // Navigate to property details.
      if (uri.path.toLowerCase().contains(AppConstants.viewProperty.toLowerCase())) {
        String propertyId = uri.path.split("/").last;
        if (propertyId == "undefined" || propertyId.isEmpty) {
          Utils.showErrorMessage(context: context, message: appStrings(context).lblNoProperty);
          return;
        }
        final isOwner = uri.path.toLowerCase().contains(AppConstants.owner.toLowerCase());
        final isReview = notificationObj.notificationType == "rejected";
        AppRouter.goToPropertyDetail(propertyID: propertyId, isOwner: isOwner, isForReview: isReview);
        return;
      }
    }
  }

  /// Property list API
  Future<void> readNotification({
    String notification = '',
    int indexToBeUpdate = -1,
  }) async {
    emit(ReadNotificationLoading());

    final response = await notificationRepository.readNotification(notification);

    if (response is SuccessResponse) {
      filteredPropertyList?[indexToBeUpdate].isRead = true;
      propertyList?[indexToBeUpdate].isRead = true;
      emit(NotificationReadSuccessFully(indexToBeUpdate));
    } else if (response is FailedResponse) {
      emit(NotificationError(errorMessage: response.errorMessage));
    }
  }
}
