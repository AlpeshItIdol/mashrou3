part of 'vendor_offer_analytics_cubit.dart';

abstract class VendorOfferAnalyticsState extends Equatable {
  const VendorOfferAnalyticsState();

  @override
  List<Object?> get props => [];
}

class VendorOfferAnalyticsInitial extends VendorOfferAnalyticsState {}

class VendorOfferAnalyticsLoading extends VendorOfferAnalyticsState {}

class VendorOfferAnalyticsSuccess extends VendorOfferAnalyticsState {
  final List<VendorOfferAnalyticsOffer> offers;
  final int pageCount;
  final int currentPage;
  final int documentCount;
  final bool isLastPage;

  const VendorOfferAnalyticsSuccess({
    required this.offers,
    required this.pageCount,
    required this.currentPage,
    required this.documentCount,
    required this.isLastPage,
  });

  @override
  List<Object?> get props => [offers, pageCount, currentPage, documentCount, isLastPage];
}

class VendorOfferAnalyticsError extends VendorOfferAnalyticsState {
  final String errorMessage;

  const VendorOfferAnalyticsError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

class NoVendorOfferAnalyticsFound extends VendorOfferAnalyticsState {}

class VendorOfferAnalyticsRefresh extends VendorOfferAnalyticsState {}

