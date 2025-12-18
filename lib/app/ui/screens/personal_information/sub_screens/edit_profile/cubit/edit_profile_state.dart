part of 'edit_profile_cubit.dart';

abstract class EditProfileState extends Equatable {
  const EditProfileState();
}

class EditProfileInitial extends EditProfileState {
  @override
  List<Object> get props => [];
}

class EditProfileLoading extends EditProfileState {
  @override
  List<Object> get props => [];
}

class EditProfileAPILoading extends EditProfileState {
  @override
  List<Object> get props => [];
}

class EditProfileSuccess extends EditProfileState {
  final VerifyResponseModel model;

  const EditProfileSuccess({required this.model});

  @override
  List<Object> get props => [model];
}

class CountryUpdateInit extends EditProfileState {
  @override
  List<Object> get props => [];
}

class CountryUpdateSuccess extends EditProfileState {
  @override
  List<Object> get props => [];
}

class APISuccessForEditProfile extends EditProfileState {
  @override
  List<Object> get props => [];
}

class AttachmentLoaded extends EditProfileState {
  @override
  List<Object> get props => [];
}

class CompanyLogoLoaded extends EditProfileState {
  @override
  List<Object> get props => [];
}

class UserEditDetailsLoaded extends EditProfileState {
  @override
  List<Object> get props => [];
}

class UserDetailsLoaded extends EditProfileState {
  @override
  List<Object> get props => [];
}

class SelectedCountry extends EditProfileState {
  final bool value;

  const SelectedCountry(this.value);

  @override
  List<Object> get props => [value];
}

class EditProfileError extends EditProfileState {
  final String errorMessage;

  const EditProfileError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class AddMoreProfileLinks extends EditProfileState {
  final List<String> profileLinks;
  final List<TextEditingController> profileLinksCtls;

  const AddMoreProfileLinks(
      {required this.profileLinks, required this.profileLinksCtls});

  @override
  List<Object> get props => [profileLinks, profileLinksCtls];
}

class AddMoreAddresses extends EditProfileState {
  final List<Location> addresses;
  final List<TextEditingController> addressesCtls;
  final List<FocusNode> addressesFns;

  const AddMoreAddresses(
      {required this.addresses, required this.addressesCtls, required this.addressesFns});

  @override
  List<Object> get props => [addresses, addressesCtls, addressesFns];
}
