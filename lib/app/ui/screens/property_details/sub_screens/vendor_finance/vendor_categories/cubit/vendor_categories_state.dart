part of 'vendor_categories_cubit.dart';

sealed class VendorCategoriesState extends Equatable {
  const VendorCategoriesState();
}

final class VendorCategoriesInitial extends VendorCategoriesState {
  @override
  List<Object> get props => [];
}

final class VendorCategoriesLoading extends VendorCategoriesState {
  @override
  List<Object> get props => [];
}

final class VendorCategoriesSuccess extends VendorCategoriesState {
  @override
  List<Object> get props => [];
}

final class VendorCategoriesError extends VendorCategoriesState {
  final String errorMessage;

  const VendorCategoriesError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class SuffixBoolChangedStateInitial extends VendorCategoriesState {
  @override
  List<Object> get props => [];
}

class SuffixBoolChangedState extends VendorCategoriesState {
  final bool? showBool;

  const SuffixBoolChangedState({this.showBool});

  @override
  List<Object> get props => [showBool!];
}

final class VendorCategoriesDataLoaded extends VendorCategoriesState {
  final PropertyVendorFinanceData? propertyVendorFinanceData;

  const VendorCategoriesDataLoaded({
    this.propertyVendorFinanceData,
  });

  @override
  List<Object?> get props =>
      [propertyVendorFinanceData ?? PropertyVendorFinanceData()];
}

// State for error handling (optional)
final class VendorCategoriesDataError extends VendorCategoriesState {
  final String error;

  const VendorCategoriesDataError(this.error);

  @override
  List<Object?> get props => [error];
}
