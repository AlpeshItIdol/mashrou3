part of 'add_vendor_cubit.dart';

sealed class AddVendorOfferState extends Equatable {
  const AddVendorOfferState();
}

final class AddVendorInitial extends AddVendorOfferState {
  @override
  List<Object> get props => [];
}

final class SubmitOfferLoading extends AddVendorOfferState {
  @override
  List<Object> get props => [];
}

final class SubmitOfferSuccess extends AddVendorOfferState {
  final String message;

  const SubmitOfferSuccess(this.message);

  @override
  List<Object> get props => [message];
}

final class UpdateOfferSuccess extends AddVendorOfferState {
  final String message;

  const UpdateOfferSuccess(this.message);

  @override
  List<Object> get props => [message];
}

final class AttachmentLoaded extends AddVendorOfferState {
  @override
  List<Object> get props => [];
}

final class OfferDetailsLoaded extends AddVendorOfferState {
  @override
  List<Object> get props => [];
}

final class GetOfferDetailsLoading extends AddVendorOfferState {
  @override
  List<Object> get props => [];
}

final class GetOfferCurrencyLoading extends AddVendorOfferState {
  @override
  List<Object> get props => [];
}

final class GetOfferCurrencyLoaded extends AddVendorOfferState {
  @override
  List<Object> get props => [];
}

final class GetOfferDetailsLoaded extends AddVendorOfferState {
  @override
  List<Object> get props => [];
}

final class GetOfferDataLoaded extends AddVendorOfferState {
  @override
  List<Object> get props => [];
}

final class SubmitOfferFailure extends AddVendorOfferState {
  final String errorMessage;

  const SubmitOfferFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
