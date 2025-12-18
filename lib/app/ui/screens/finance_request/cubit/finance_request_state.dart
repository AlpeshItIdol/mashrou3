part of 'finance_request_cubit.dart';

sealed class FinanceRequestState extends Equatable {
  const FinanceRequestState();
}

final class FinanceRequestInitial extends FinanceRequestState {
  @override
  List<Object> get props => [];
}

class FinanceRequestListRefresh extends FinanceRequestState {
  @override
  List<Object> get props => [];
}

class FinanceRequestListLoading extends FinanceRequestState {
  @override
  List<Object> get props => [];
}

class NoFinanceRequestListFoundState extends FinanceRequestState {
  @override
  List<Object> get props => [];
}

class FinanceRequestListSuccess extends FinanceRequestState {
  bool isLastPage;
  int currentKey;
  List<FinanceRequest> financeRequestList;

  FinanceRequestListSuccess(
      this.isLastPage, this.currentKey, this.financeRequestList);

  @override
  List<Object> get props => [isLastPage, currentKey, financeRequestList];
}

class FinanceRequestListError extends FinanceRequestState {
  final String errorMessage;

  const FinanceRequestListError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class FinanceRequestDetailsSuccess extends FinanceRequestState {
  final FinanceRequestDetailsData model;

  const FinanceRequestDetailsSuccess({required this.model});

  @override
  List<Object> get props => [model];
}

class FinanceRequestDetailsError extends FinanceRequestState {
  final String errorMessage;

  const FinanceRequestDetailsError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

