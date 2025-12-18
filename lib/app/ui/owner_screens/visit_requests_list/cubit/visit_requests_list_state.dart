part of 'visit_requests_list_cubit.dart';

abstract class VisitRequestsState extends Equatable {
  const VisitRequestsState();
}

class VisitRequestsInitial extends VisitRequestsState {
  @override
  List<Object> get props => [];
}

class VisitRequestsLoading extends VisitRequestsState {
  @override
  List<Object> get props => [];
}

class VisitRequestsListSuccess extends VisitRequestsState {
  bool isLastPage;
  int currentKey;
  List<VisitRequestData> visitRequestsList;

  VisitRequestsListSuccess(
      this.isLastPage, this.currentKey, this.visitRequestsList);

  @override
  List<Object> get props => [isLastPage, currentKey, visitRequestsList];
}

class VisitRequestsError extends VisitRequestsState {
  final String errorMessage;

  const VisitRequestsError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class NoVisitRequestsFoundState extends VisitRequestsState {
  @override
  List<Object> get props => [];
}

class VisitRequestsMoreListLoading extends VisitRequestsState {
  @override
  List<Object> get props => [];
}

class VisitRequestsListLoaded extends VisitRequestsState {
  @override
  List<Object> get props => [];
}

class GetSearchUpdate extends VisitRequestsState {
  @override
  List<Object> get props => [];
}

class SearchInit extends VisitRequestsState {
  @override
  List<Object> get props => [];
}

class SetSearchUpdate extends VisitRequestsState {
  @override
  List<Object> get props => [];
}

class VisitRequestApprovedRejectedState extends VisitRequestsState {
  final String successMessage;

  const VisitRequestApprovedRejectedState(this.successMessage);

  @override
  List<Object> get props => [successMessage];
}
