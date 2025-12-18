part of 'add_my_offers_cubit.dart';

abstract class AddMyOffersState extends Equatable {
  const AddMyOffersState();
}

class AddMyOffersInitial extends AddMyOffersState {
  @override
  List<Object> get props => [];
}

class MyOffersMoreListLoading extends AddMyOffersState {
  @override
  List<Object> get props => [];
}

class AddMyOffersLoading extends AddMyOffersState {
  @override
  List<Object> get props => [];
}

class NoAddMyOffersFoundState extends AddMyOffersState {
  @override
  List<Object> get props => [];
}

class MyOffersListSuccess extends AddMyOffersState {
  bool isLastPage;
  int currentKey;
  List<OfferData> AddMyOffers;

  MyOffersListSuccess(this.isLastPage, this.currentKey, this.AddMyOffers);

  @override
  List<Object> get props => [isLastPage, currentKey, AddMyOffers];
}

class ApplyMyOffersSuccess extends AddMyOffersState {
  final ApplyOfferResponseModel model;

  const ApplyMyOffersSuccess({required this.model});

  @override
  List<Object> get props => [model];
}

class ToggleIsSelectedAnyOfferInit extends AddMyOffersState {
  @override
  List<Object> get props => [];
}

class ToggleIsSelectedAnyOfferUpdate extends AddMyOffersState {
  final bool isSelectedAnyOffer;

  const ToggleIsSelectedAnyOfferUpdate(this.isSelectedAnyOffer);

  @override
  List<Object> get props => [isSelectedAnyOffer];
}

class AddMyOffersError extends AddMyOffersState {
  final String errorMessage;

  const AddMyOffersError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class OffersListSuccess extends AddMyOffersState {
  final OffersListForPropertyResponseModel model;

  const OffersListSuccess({required this.model});

  @override
  List<Object> get props => [model];
}
