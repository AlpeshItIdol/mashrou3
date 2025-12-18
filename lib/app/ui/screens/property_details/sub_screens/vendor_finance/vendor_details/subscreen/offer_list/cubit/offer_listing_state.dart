part of 'offer_listing_cubit.dart';

sealed class OfferListingState extends Equatable {
  const OfferListingState();
}

final class OfferListingInitial extends OfferListingState {
  @override
  List<Object> get props => [];
}


final class DataLoaded extends OfferListingState {
  @override
  List<Object> get props => [];
}
