part of 'complete_profile_cubit.dart';

abstract class CompleteProfileState extends Equatable {
  const CompleteProfileState();
}

class CompleteProfileInitial extends CompleteProfileState {
  @override
  List<Object> get props => [];
}

class CompleteProfileLoading extends CompleteProfileState {
  @override
  List<Object> get props => [];
}

class CompleteProfileLocationSet extends CompleteProfileState {
  @override
  List<Object> get props => [];
}

class CompleteProfileAPILoading extends CompleteProfileState {
  @override
  List<Object> get props => [];
}

class CompleteProfileSuccess extends CompleteProfileState {
  final VerifyResponseModel model;

  const CompleteProfileSuccess({required this.model});

  @override
  List<Object> get props => [model];
}

class CountryUpdateInit extends CompleteProfileState {
  @override
  List<Object> get props => [];
}

class CountryUpdateSuccess extends CompleteProfileState {
  @override
  List<Object> get props => [];
}

class APISuccess extends CompleteProfileState {
  @override
  List<Object> get props => [];
}

class AttachmentLoaded extends CompleteProfileState {
  @override
  List<Object> get props => [];
}

class CompanyLogoLoaded extends CompleteProfileState {
  @override
  List<Object> get props => [];
}

class NoCityListFoundState extends CompleteProfileState {
  @override
  List<Object> get props => [];
}


class CityMoreListLoading extends CompleteProfileState {
  @override
  List<Object> get props => [];
}

class CityListLoading extends CompleteProfileState {
  @override
  List<Object> get props => [];
}

class CityListSuccess extends CompleteProfileState {
  bool isLastPage;
  int currentKey;
  List<Cities> cityList;

  CityListSuccess(
      this.isLastPage, this.currentKey, this.cityList);

  @override
  List<Object> get props => [isLastPage, currentKey, cityList];
}


class BanksListSuccess extends CompleteProfileState {
  final BanksListResponseModel model;

  const BanksListSuccess({required this.model});

  @override
  List<Object> get props => [model];
}

class SelectedCountry extends CompleteProfileState {
  final bool value;

  const SelectedCountry(this.value);

  @override
  List<Object> get props => [value];
}

class CompleteProfileError extends CompleteProfileState {
  final String errorMessage;

  const CompleteProfileError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class AddMoreProfileLinks extends CompleteProfileState {
  final List<String> profileLinks;
  final List<TextEditingController> profileLinksCtls;

  const AddMoreProfileLinks(
      {required this.profileLinks, required this.profileLinksCtls});

  @override
  List<Object> get props => [profileLinks, profileLinksCtls];
}
