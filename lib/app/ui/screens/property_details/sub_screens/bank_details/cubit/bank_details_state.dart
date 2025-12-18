part of 'bank_details_cubit.dart';

abstract class BankDetailsState extends Equatable {
  const BankDetailsState();
}

class BankDetailsInitial extends BankDetailsState {
  @override
  List<Object> get props => [];
}

class BankDetailsLoading extends BankDetailsState {
  @override
  List<Object> get props => [];
}

class BankViewCountSuccess extends BankDetailsState {
  @override
  List<Object> get props => [];
}

class BankDetailsSuccess extends BankDetailsState {
  final BankDetailsResponseModel model;

  const BankDetailsSuccess({required this.model});

  @override
  List<Object> get props => [model];
}

class AddFinanceRequestSuccess extends BankDetailsState {
  final AddFinanceRequestResponseModel model;

  const AddFinanceRequestSuccess({required this.model});

  @override
  List<Object> get props => [model];
}

class BankPropertyOffersSuccess extends BankDetailsState {
  final BankPropertyOffersResponseModel model;

  const BankPropertyOffersSuccess({required this.model});

  @override
  List<Object> get props => [model];
}

class GetSearchUpdate extends BankDetailsState {
  @override
  List<Object> get props => [];
}

class SearchInit extends BankDetailsState {
  @override
  List<Object> get props => [];
}

class SetSearchUpdate extends BankDetailsState {
  @override
  List<Object> get props => [];
}

class BankDetailsError extends BankDetailsState {
  final String errorMessage;

  const BankDetailsError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class SuffixBoolChangedStateInitial extends BankDetailsState {
  @override
  List<Object> get props => [];
}

class SuffixBoolChangedState extends BankDetailsState {
  bool showBool;

  SuffixBoolChangedState({required this.showBool});

  @override
  List<Object> get props => [this.showBool];
}
