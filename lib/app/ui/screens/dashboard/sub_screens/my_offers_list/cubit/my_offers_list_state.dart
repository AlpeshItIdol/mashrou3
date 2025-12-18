part of 'my_offers_list_cubit.dart';

abstract class MyOffersListState extends Equatable {
  const MyOffersListState();
}

class MyOffersListInitial extends MyOffersListState {
  @override
  List<Object> get props => [];
}

class MyOffersMoreListLoading extends MyOffersListState {
  @override
  List<Object> get props => [];
}

class MyOffersListLoading extends MyOffersListState {
  @override
  List<Object> get props => [];
}

class NoMyOffersListFoundState extends MyOffersListState {
  @override
  List<Object> get props => [];
}
class DeleteOfferLoading extends MyOffersListState {
  @override
  List<Object> get props => [];
}
class DeleteOfferSuccess extends MyOffersListState {

  DeleteOfferSuccess();

  @override
  List<Object> get props => [];
}

// class MyOffersListSuccess extends MyOffersListState {
//   bool isLastPage;
//   int currentKey;
//   List<Bank> banksList;
//
//   MyOffersListSuccess(
//       this.isLastPage, this.currentKey, this.banksList);
//
//   @override
//   List<Object> get props => [isLastPage, currentKey, banksList];
// }
//
// class MyOffersListSuccess extends MyOffersListState {
//   final MyOffersListResponseModel model;
//
//   const MyOffersListSuccess({required this.model});
//
//   @override
//   List<Object> get props => [model];
// }

class AddMyOffersLoading extends MyOffersListState {
  @override
  List<Object> get props => [];
}

class NoAddMyOffersFoundState extends MyOffersListState {
  @override
  List<Object> get props => [];
}

class TabUpdateState extends MyOffersListState {
  @override
  List<Object> get props => [];
}

class NoDraftOffersFoundState extends MyOffersListState {
  @override
  List<Object> get props => [];
}

class AddMyOffersError extends MyOffersListState {
  final String errorMessage;


  const AddMyOffersError({required this.errorMessage});

  @override
  List<Object> get props => [];
}

class AddMyOffersSuccess extends MyOffersListState {
  bool isLastPage;
  int currentKey;
  List<OfferData> addMyOffers;

  AddMyOffersSuccess(
      this.isLastPage, this.currentKey, this.addMyOffers);

  @override
  List<Object> get props => [isLastPage, currentKey, addMyOffers];
}

class DraftOffersSuccess extends MyOffersListState {
  bool isLastPage;
  int currentKey;
  List<OfferData> AddMyOffers;

  DraftOffersSuccess(
      this.isLastPage, this.currentKey, this.AddMyOffers);

  @override
  List<Object> get props => [isLastPage, currentKey, AddMyOffers];
}

class GetSearchUpdate extends MyOffersListState {
  @override
  List<Object> get props => [];
}

class SearchInit extends MyOffersListState {
  @override
  List<Object> get props => [];
}

class SetSearchUpdate extends MyOffersListState {
  @override
  List<Object> get props => [];
}

class MyOffersListError extends MyOffersListState {
  final String errorMessage;

  const MyOffersListError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class SuffixBoolChangedStateInitial extends MyOffersListState {
  @override
  List<Object> get props => [];
}

class SuffixBoolChangedState extends MyOffersListState {
  bool showBool;

  SuffixBoolChangedState({required this.showBool});

  @override
  List<Object> get props => [this.showBool];
}
