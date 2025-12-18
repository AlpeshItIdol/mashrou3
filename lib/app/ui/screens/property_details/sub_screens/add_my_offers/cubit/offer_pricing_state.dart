part of 'offer_pricing_cubit.dart';

abstract class OfferPricingState extends Equatable {
  const OfferPricingState();

  @override
  List<Object?> get props => [];
}

class OfferPricingInitial extends OfferPricingState {}

class OfferPricingLoading extends OfferPricingState {}

class OfferPricingTypeChanged extends OfferPricingState {
  final String? offerType;

  const OfferPricingTypeChanged(this.offerType);

  @override
  List<Object?> get props => [offerType];
}

class OfferPricingDateChanged extends OfferPricingState {}

class OfferPricingSuccess extends OfferPricingState {
  final PriceCalculationsResponseModel model;

  const OfferPricingSuccess({required this.model});

  @override
  List<Object?> get props => [model];
}

class OfferPricingError extends OfferPricingState {
  final String errorMessage;

  const OfferPricingError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

