import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashrou3/app/repository/property_repository.dart';
import 'package:mashrou3/app/ui/owner_screens/visit_requests_list/model/visit_request_reject_request.model.dart';

import '../../../../model/base/base_model.dart';
import '../../../../model/common_only_message_response_model.dart';
import '../model/visit_request_approve_request.model.dart';
import '../model/visit_requests_list_request.model.dart';
import '../model/visit_requests_list_response.model.dart';

part 'visit_requests_list_state.dart';

class VisitRequestsCubit extends Cubit<VisitRequestsState> {
  PropertyRepository repository;

  VisitRequestsCubit({required this.repository}) : super(VisitRequestsInitial());

  final formKey = GlobalKey<FormState>();

  TextEditingController noteCtl = TextEditingController();
  FocusNode noteFn = FocusNode();

  int totalVisitRequests = 0;
  int currentPage = 1;
  int totalPage = 1;
  bool isLoadingMore = false;
  bool hasShownSkeleton = false;
  bool isFavorite = false;
  static const int PER_PAGE_SIZE = 5;
  List<VisitRequestData>? visitRequestsList = [];
  List<VisitRequestData>? filteredVisitRequestsList = [];

  /// Get data from shared preference
  ///
  Future<void> getData(BuildContext context) async {
    resetData();
    if (!context.mounted) return;
    await Future.wait([
      getVisitRequestsList(),
    ]);
  }

  void resetData() {
    visitRequestsList = [];
    filteredVisitRequestsList = [];
    totalVisitRequests = 0;
    currentPage = 1;
    totalPage = 1;
    isLoadingMore = false;
    hasShownSkeleton = false;
  }

  /// Visit Requests list API
  Future<void> getVisitRequestsList({
    bool hasMoreData = false,
  }) async {
    isLoadingMore = true;
    if (hasMoreData) {
      isLoadingMore = false;
      if (isLoadingMore || currentPage > totalPage) return;
      emit(VisitRequestsMoreListLoading());
    } else {
      emit(VisitRequestsLoading());
    }

    const sortField = 'createdAt';
    const sortOrder = 'desc';

    final requestModel = VisitRequestsListRequestModel(
      sortField: sortField,
      sortOrder: sortOrder,
      search: "",
      itemsPerPage: PER_PAGE_SIZE,
      page: currentPage,
    );

    final response = await repository.getVisitRequestsList(requestModel: requestModel);
    isLoadingMore = false;

    hasShownSkeleton = true;

    if (response is SuccessResponse && response.data is VisitRequestsListResponseModel) {
      VisitRequestsListResponseModel visitRequestsListResponse = response.data as VisitRequestsListResponseModel;

      totalPage = visitRequestsListResponse.data?.pageCount ?? 1;
      visitRequestsList?.addAll(visitRequestsListResponse.data?.data ?? []);
      filteredVisitRequestsList = List.from(visitRequestsList ?? []);

      if (filteredVisitRequestsList?.isEmpty ?? true) {
        emit(NoVisitRequestsFoundState());
      } else {
        emit(VisitRequestsListSuccess(hasMoreData, currentPage, visitRequestsList ?? []));
      }
    } else if (response is FailedResponse) {
      emit(NoVisitRequestsFoundState());
      emit(VisitRequestsError(errorMessage: response.errorMessage));
    }
  }

  /// approve Visit Request API
  Future<void> approveVisitRequest({
    required String requestId,
  }) async {
    emit(VisitRequestsLoading());

    final requestModel = VisitRequestApproveRequestModel(
      action: "approved",
      requestId: requestId,
    );

    final response = await repository.approveVisitRequest(requestModel: requestModel);

    if (response is SuccessResponse && response.data is CommonOnlyMessageResponseModel) {
      CommonOnlyMessageResponseModel addToFavResponse = response.data as CommonOnlyMessageResponseModel;

      emit(VisitRequestApprovedRejectedState(addToFavResponse.message ?? ""));
    } else if (response is FailedResponse) {
      emit(VisitRequestsError(errorMessage: response.errorMessage));
    }
  }

  /// Reject Visit Request API
  Future<void> rejectVisitRequest({required String requestId, String? requestMessage}) async {
    emit(VisitRequestsLoading());

    final requestModel = VisitRequestRejectRequestModel(
      action: "rejected",
      requestId: requestId,
      message: requestMessage ?? noteCtl.text,
    );

    final response = await repository.rejectVisitRequest(requestModel: requestModel);

    if (response is SuccessResponse && response.data is CommonOnlyMessageResponseModel) {
      CommonOnlyMessageResponseModel addToFavResponse = response.data as CommonOnlyMessageResponseModel;

      emit(VisitRequestApprovedRejectedState(addToFavResponse.message ?? ""));
    } else if (response is FailedResponse) {
      emit(VisitRequestsError(errorMessage: response.errorMessage));
    }
  }

  // Load more properties
  void loadMoreVisitRequests(int index, BuildContext context) {
    if (currentPage < totalPage) {
      currentPage++;
      getVisitRequestsList(hasMoreData: true);
    }
  }
}
