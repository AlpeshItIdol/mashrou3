part of 'profile_detail_cubit.dart';

sealed class ProfileDetailState extends Equatable {
  const ProfileDetailState();
}

final class ProfileDetailInitial extends ProfileDetailState {
  @override
  List<Object> get props => [];
}

final class ProfileDetailLoading extends ProfileDetailState {
  @override
  List<Object> get props => [];
}

final class UserDetailsLoadedForProfileDetail extends ProfileDetailState {
  @override
  List<Object> get props => [];
}

final class UpdatedUserDetailsLoading extends ProfileDetailState {
  @override
  List<Object> get props => [];
}

final class UpdatedUserDetailsLoaded extends ProfileDetailState {
  @override
  List<Object> get props => [];
}

final class ProfileDetailCountryFetchSuccess extends ProfileDetailState {
  @override
  List<Object> get props => [];
}

final class APISuccess extends ProfileDetailState {
  @override
  List<Object> get props => [];
}

final class ImageDataLoaded extends ProfileDetailState {
  @override
  List<Object> get props => [];
}

final class ProfileDetailError extends ProfileDetailState {
  final String errorMessage;

  const ProfileDetailError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class CompleteProfileSuccess extends ProfileDetailState {
  final VerifyResponseModel model;

  const CompleteProfileSuccess({required this.model});

  @override
  List<Object> get props => [model];
}

class DeleteProfileSuccess extends ProfileDetailState {
  final String successMessage;

  const DeleteProfileSuccess(this.successMessage);

  @override
  List<Object> get props => [successMessage];
}


class ProfileDetailSuccess extends ProfileDetailState {
  final UserDetailsData model;

  const ProfileDetailSuccess({required this.model});

  @override
  List<Object> get props => [model];
}
class PropertyListLoading extends ProfileDetailState {
  @override
  List<Object> get props => [];
}

class PropertyListSuccess extends ProfileDetailState {
  final bool isLastPage;
  final int currentKey;
  final List<PropertyData> propertyList;

  PropertyListSuccess(this.isLastPage, this.currentKey, this.propertyList);

  @override
  List<Object> get props => [isLastPage, currentKey, propertyList];
}

class PropertyListError extends ProfileDetailState {
  final String errorMessage;

  const PropertyListError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class NoPropertyFoundState extends ProfileDetailState {
  @override
  List<Object> get props => [];
}

class PropertyAddFavLoadState extends ProfileDetailState {
  @override
  List<Object> get props => [];
}

class AddedToFavorite extends ProfileDetailState {
  final String successMessage;

  const AddedToFavorite(this.successMessage);

  @override
  List<Object> get props => [successMessage];
}

class PropertyAddFavError extends ProfileDetailState {
  final String errorMessage;

  const PropertyAddFavError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
