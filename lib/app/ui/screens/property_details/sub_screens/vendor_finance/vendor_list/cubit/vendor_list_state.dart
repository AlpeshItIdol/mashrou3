part of 'vendor_list_cubit.dart';

sealed class VendorListState extends Equatable {
  const VendorListState();
}

final class VendorListInitial extends VendorListState {
  @override
  List<Object> get props => [];
}

class SuffixBoolChangedStateInitial extends VendorListState {
  @override
  List<Object> get props => [];
}

class SuffixBoolChangedState extends VendorListState {
  final bool? showBool;

  const SuffixBoolChangedState({this.showBool});

  @override
  List<Object> get props => [showBool!];
}

final class VendorCategoryUpdated extends VendorListState {
  final String categoryId;
  final int index;

  const VendorCategoryUpdated({required this.categoryId,required this.index});

  @override
  List<Object> get props => [categoryId,index];
}


final class VendorCategoriesLoading extends VendorListState {
  @override
  List<Object> get props => [];
}

final class VendorCategoriesSuccess extends VendorListState {
  @override
  List<Object> get props => [];
}

final class VendorCategoriesError extends VendorListState {
  final String errorMessage;

  const VendorCategoriesError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

final class VendorListLoading extends VendorListState {
  @override
  List<Object> get props => [];
}

final class VendorRefreshLoading extends VendorListState {
  @override
  List<Object> get props => [];
}

final class NoVendorListFound extends VendorListState {
  @override
  List<Object> get props => [];
}

final class VendorListSuccess extends VendorListState {
  bool isLastPage;
  int currentKey;
  List<VendorUserData> vendorList;

  VendorListSuccess(this.isLastPage, this.currentKey, this.vendorList);

  @override
  List<Object> get props => [];
}

final class VendorListError extends VendorListState {
  final String errorMessage;

  const VendorListError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
