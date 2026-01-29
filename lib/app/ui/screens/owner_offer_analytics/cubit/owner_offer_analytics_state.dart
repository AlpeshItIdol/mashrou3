part of 'owner_offer_analytics_cubit.dart';

abstract class OwnerOfferAnalyticsState extends Equatable {
  const OwnerOfferAnalyticsState();

  @override
  List<Object?> get props => [];
}

class OwnerOfferAnalyticsInitial extends OwnerOfferAnalyticsState {}

class OwnerOfferAnalyticsLoading extends OwnerOfferAnalyticsState {}

class OwnerOfferAnalyticsSuccess extends OwnerOfferAnalyticsState {
  final List<OwnerPropertyAnalytics> properties;
  final int pageCount;
  final int currentPage;
  final int documentCount;
  final bool isLastPage;

  const OwnerOfferAnalyticsSuccess({
    required this.properties,
    required this.pageCount,
    required this.currentPage,
    required this.documentCount,
    required this.isLastPage,
  });

  @override
  List<Object?> get props =>
      [properties, pageCount, currentPage, documentCount, isLastPage];
}

class OwnerOfferAnalyticsError extends OwnerOfferAnalyticsState {
  final String errorMessage;

  const OwnerOfferAnalyticsError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

class NoOwnerOfferAnalyticsFound extends OwnerOfferAnalyticsState {}

class OwnerOfferAnalyticsRefresh extends OwnerOfferAnalyticsState {}


