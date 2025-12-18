part of 'add_edit_certificates_cubit.dart';

sealed class AddEditCertificatesState extends Equatable {
  const AddEditCertificatesState();
}

final class AddVendorInitial extends AddEditCertificatesState {
  @override
  List<Object> get props => [];
}

final class AddEditCertificatesLoading extends AddEditCertificatesState {
  @override
  List<Object> get props => [];
}

final class AddEditCertificatesSuccess extends AddEditCertificatesState {
  @override
  List<Object> get props => [];
}
final class DefaultDataInit extends AddEditCertificatesState {
  @override
  List<Object> get props => [];
}
final class DefaultDataLoaded extends AddEditCertificatesState {
  @override
  List<Object> get props => [];
}

final class AttachmentLoaded extends AddEditCertificatesState {
  @override
  List<Object> get props => [];
}

final class AddEditCertificatesFailure extends AddEditCertificatesState {
  final String message;

  const AddEditCertificatesFailure(this.message);

  @override
  List<Object> get props => [];
}
