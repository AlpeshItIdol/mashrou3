part of 'offer_detail_cubit.dart';

sealed class OfferDetailState extends Equatable {
  const OfferDetailState();
}

final class OfferDetailInitial extends OfferDetailState {
  @override
  List<Object> get props => [];
}

final class OfferDetailLoading extends OfferDetailState {
  @override
  List<Object> get props => [];
}

final class OfferDetailLoaded extends OfferDetailState {
  @override
  List<Object> get props => [];
}

class OfferDetailSuccess extends OfferDetailState {
  final OfferData model;

  const OfferDetailSuccess({required this.model});

  @override
  List<Object> get props => [model];
}

class OfferDetailFailure extends OfferDetailState {
  final String errorMessage;

  const OfferDetailFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class OfferDetailBanksListSuccess extends OfferDetailState {
  final List<BankUser> banks;

  const OfferDetailBanksListSuccess({required this.banks});

  @override
  List<Object> get props => [banks];
}
