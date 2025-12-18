part of 'visit_request_cubit.dart';

abstract class VisitRequestState extends Equatable {
  const VisitRequestState();
}

class VisitRequestInitial extends VisitRequestState {
  @override
  List<Object> get props => [];
}

class VisitRequestLoading extends VisitRequestState {
  @override
  List<Object> get props => [];
}

class VisitRequestSuccess extends VisitRequestState {
  final SendVisitRequestResponseModel model;

  const VisitRequestSuccess({required this.model});

  @override
  List<Object> get props => [model];
}

class VisitRequestDateState extends VisitRequestState {
  final String selectedDate;

  const VisitRequestDateState({required this.selectedDate});

  VisitRequestDateState copyWith({String? selectedDate}) {
    return VisitRequestDateState(
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }

  @override
  List<Object> get props => [selectedDate];
}

class GetSearchUpdate extends VisitRequestState {
  @override
  List<Object> get props => [];
}

class SearchInit extends VisitRequestState {
  @override
  List<Object> get props => [];
}

class SetSearchUpdate extends VisitRequestState {
  @override
  List<Object> get props => [];
}

class VisitRequestError extends VisitRequestState {
  final String errorMessage;

  const VisitRequestError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
