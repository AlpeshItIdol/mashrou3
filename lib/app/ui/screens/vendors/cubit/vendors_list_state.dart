part of 'vendors_list_cubit.dart';

sealed class VendorsListState extends Equatable {
  const VendorsListState();
}

final class VendorsListInitial extends VendorsListState {
  @override
  List<Object?> get props => [];
}

final class VendorsListLoading extends VendorsListState {
  @override
  List<Object?> get props => [];
}

final class VendorsListEmpty extends VendorsListState {
  @override
  List<Object?> get props => [];
}

final class VendorsListSuccess extends VendorsListState {
  final bool isLastPage;
  final int currentKey;
  final List<VendorSequenceUser> vendors;
  final int totalCount;

  const VendorsListSuccess({
    required this.isLastPage,
    required this.currentKey,
    required this.vendors,
    required this.totalCount,
  });

  @override
  List<Object?> get props => [isLastPage, currentKey, vendors, totalCount];
}

final class VendorsListError extends VendorsListState {
  final String errorMessage;
  const VendorsListError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

// Vendor Categories States
final class VendorCategoriesLoading extends VendorsListState {
  @override
  List<Object?> get props => [];
}

final class VendorCategoriesEmpty extends VendorsListState {
  @override
  List<Object?> get props => [];
}

final class VendorCategoriesSuccess extends VendorsListState {
  final List<VendorCategoryData> categories;
  final int currentPage;
  final int totalPages;
  final bool hasMorePages;

  const VendorCategoriesSuccess({
    required this.categories,
    required this.currentPage,
    required this.totalPages,
    required this.hasMorePages,
  });

  @override
  List<Object?> get props => [categories, currentPage, totalPages, hasMorePages];
}

final class VendorCategoriesError extends VendorsListState {
  final String errorMessage;
  const VendorCategoriesError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

// Category Selection State
final class VendorCategorySelected extends VendorsListState {
  final String? categoryId;
  const VendorCategorySelected({this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}


