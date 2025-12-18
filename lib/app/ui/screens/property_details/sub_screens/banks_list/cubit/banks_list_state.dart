part of 'banks_list_cubit.dart';

abstract class BanksListState extends Equatable {
  const BanksListState();
}

class BanksListInitial extends BanksListState {
  @override
  List<Object> get props => [];
}

class BankListRefresh extends BanksListState {
  @override
  List<Object> get props => [];
}

class BanksListLoading extends BanksListState {
  @override
  List<Object> get props => [];
}

class NoBanksListFoundState extends BanksListState {
  @override
  List<Object> get props => [];
}

class BanksListSuccess extends BanksListState {
  bool isLastPage;
  int currentKey;
  List<BankUser> banksList;

  BanksListSuccess(
      this.isLastPage, this.currentKey, this.banksList);

  @override
  List<Object> get props => [isLastPage, currentKey, banksList];
}
//
// class BanksListSuccess extends BanksListState {
//   final BanksListResponseModel model;
//
//   const BanksListSuccess({required this.model});
//
//   @override
//   List<Object> get props => [model];
// }

class GetSearchUpdate extends BanksListState {
  @override
  List<Object> get props => [];
}

class SearchInit extends BanksListState {
  @override
  List<Object> get props => [];
}

class SetSearchUpdate extends BanksListState {
  @override
  List<Object> get props => [];
}

class BanksListError extends BanksListState {
  final String errorMessage;

  const BanksListError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class SuffixBoolChangedStateInitial extends BanksListState {
  @override
  List<Object> get props => [];
}

class SuffixBoolChangedState extends BanksListState {
  bool showBool;

  SuffixBoolChangedState({required this.showBool});

  @override
  List<Object> get props => [this.showBool];
}
