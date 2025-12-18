part of 'view_all_certificates_cubit.dart';

sealed class ViewAllCertificatesState extends Equatable {
  const ViewAllCertificatesState();
}

final class AddVendorInitial extends ViewAllCertificatesState {
  @override
  List<Object> get props => [];
}

final class CertificatesLoaded extends ViewAllCertificatesState {
  @override
  List<Object> get props => [];
}

final class SubmitOfferLoading extends ViewAllCertificatesState {
  @override
  List<Object> get props => [];
}

final class SubmitOfferSuccess extends ViewAllCertificatesState {
  @override
  List<Object> get props => [];
}

final class SubmitOfferFailure extends ViewAllCertificatesState {
  String message;

  SubmitOfferFailure(this.message);

  @override
  List<Object> get props => [];
}
