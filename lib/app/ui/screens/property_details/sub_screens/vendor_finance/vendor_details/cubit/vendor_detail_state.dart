part of 'vendor_detail_cubit.dart';

sealed class VendorDetailState extends Equatable {
  const VendorDetailState();
}

final class VendorDetailInitial extends VendorDetailState {
  @override
  List<Object> get props => [];
}

final class VendorDetailLoading extends VendorDetailState {
  @override
  List<Object> get props => [];
}

final class VendorDetailLoaded extends VendorDetailState {
  @override
  List<Object> get props => [];
}

class VendorDetailSuccess extends VendorDetailState {
  final UserDetailsData model;

  const VendorDetailSuccess({required this.model});

  @override
  List<Object> get props => [model];
}

class VendorDetailFailure extends VendorDetailState {
  final String errorMessage;

  const VendorDetailFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

final class VendorOffersLoading extends VendorDetailState {
  @override
  List<Object> get props => [];
}

final class VendorOffersLoaded extends VendorDetailState {
  @override
  List<Object> get props => [];
}

class VendorOffersSuccess extends VendorDetailState {
  final List<OfferData>? offerList;

  const VendorOffersSuccess({required this.offerList});

  @override
  List<Object> get props => [];
}

class VendorOffersFailure extends VendorDetailState {
  final String errorMessage;

  const VendorOffersFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class FinanceRequestLoading extends VendorDetailState {
  @override
  List<Object> get props => [];
}

class FinanceRequestSuccess extends VendorDetailState {
  final String message;

  const FinanceRequestSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class FinanceRequestFailure extends VendorDetailState {
  final String errorMessage;

  const FinanceRequestFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

final class VendorOfferSelectionChanged extends VendorDetailState {
  @override
  List<Object> get props => [];
}

final class VendorOfferSelectionReset extends VendorDetailState {
  @override
  List<Object> get props => [];
}
