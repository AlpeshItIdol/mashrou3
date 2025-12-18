part of 'add_edit_property_cubit.dart';

sealed class AddEditPropertyState extends Equatable {
  const AddEditPropertyState();
}

final class AddEditPropertyInitial extends AddEditPropertyState {
  @override
  List<Object> get props => [];
}

final class PropertyCategoryFieldsLoading extends AddEditPropertyState {
  @override
  List<Object> get props => [];
}

final class AddEditPropertyFieldsLoading extends AddEditPropertyState {
  @override
  List<Object> get props => [];
}

final class AddEditPropertyFieldsLoaded extends AddEditPropertyState {
  @override
  List<Object> get props => [];
}
final class AddEditPropertyThumbnailLoaded extends AddEditPropertyState {
  @override
  List<Object> get props => [];
}

final class AddEditPropertyAttachmentLoaded extends AddEditPropertyState {
  @override
  List<Object> get props => [];
}

class SuffixBoolChangedStateInitial extends AddEditPropertyState {
  @override
  List<Object> get props => [];
}

class SingleItemStateInit extends AddEditPropertyState {
  @override
  List<Object> get props => [];
}

class ValidateExecuted extends AddEditPropertyState {
  @override
  List<Object> get props => [];
}

class SingleItemStateUpdate extends AddEditPropertyState {
  @override
  List<Object> get props => [];
}

class MultiItemStateInit extends AddEditPropertyState {
  @override
  List<Object> get props => [];
}

class MultiItemStateUpdate extends AddEditPropertyState {
  @override
  List<Object> get props => [];
}

class ValidationStateInit extends AddEditPropertyState {
  @override
  List<Object> get props => [];
}

class ValidationStateUpdate extends AddEditPropertyState {
  @override
  List<Object> get props => [];
}

class SuffixBoolChangedState extends AddEditPropertyState {
  final bool? showBool;

  const SuffixBoolChangedState({this.showBool});

  @override
  List<Object> get props => [showBool!];
}

class BottomSheetValueUpdateState extends AddEditPropertyState {
  final List<CategoryItemData>? selectedItem;

  const BottomSheetValueUpdateState({this.selectedItem});

  @override
  List<Object> get props => [selectedItem!];
}

class AddMoreVideoLinks extends AddEditPropertyState {
  final List<String> videoLinks;
  final List<TextEditingController> videoLinksCtls;

  const AddMoreVideoLinks(
      {required this.videoLinks, required this.videoLinksCtls});

  @override
  List<Object> get props => [videoLinks, videoLinksCtls];
}

class AddMoreNeighbourhoodKeys extends AddEditPropertyState {
  final List<String> neighbourhoodKeys;
  final List<TextEditingController> neighbourhoodKeysCtrl;

  const AddMoreNeighbourhoodKeys(
      {required this.neighbourhoodKeys, required this.neighbourhoodKeysCtrl});

  @override
  List<Object> get props => [neighbourhoodKeys, neighbourhoodKeysCtrl];
}

class AddEditPropertyLoading extends AddEditPropertyState {
  @override
  List<Object> get props => [];
}

class AddEditPropertySuccess extends AddEditPropertyState {
  @override
  List<Object> get props => [];
}

class AddEditPropertyCountryFetching extends AddEditPropertyState {
  @override
  List<Object> get props => [];
}

class AddEditPropertyCountryFetchSuccess extends AddEditPropertyState {
  @override
  List<Object> get props => [];
}

class AddEditPropertyCountryFetchError extends AddEditPropertyState {
  final String errorMessage;

  const AddEditPropertyCountryFetchError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class AddEditPropertyCategoryLoading extends AddEditPropertyState {
  @override
  List<Object> get props => [];
}

class AddEditPropertyCategorySuccess extends AddEditPropertyState {
  @override
  List<Object> get props => [];
}

class AddEditPropertyCategoryFailure extends AddEditPropertyState {
  final String error;

  const AddEditPropertyCategoryFailure(this.error);

  @override
  List<Object> get props => [error];
}

class AddEditPropertySubCategoryLoading extends AddEditPropertyState {
  @override
  List<Object> get props => [];
}

class AddEditPropertySubCategorySuccess extends AddEditPropertyState {
  final List<PropertySubCategoryData>? dataList;

  const AddEditPropertySubCategorySuccess({this.dataList});

  @override
  List<Object> get props => [dataList ?? []];
}

class AddEditPropertySubCategoryFailure extends AddEditPropertyState {
  final String errorMessage;

  const AddEditPropertySubCategoryFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class PropertyCategoryDataLoading extends AddEditPropertyState {
  @override
  List<Object> get props => [];
}

class AddEditPropertyLivingSpacesUpdated extends AddEditPropertyState {
  @override
  List<Object> get props => [];
}

class PropertyCategoryDataSuccess extends AddEditPropertyState {
  @override
  List<Object> get props => [];
}

class PropertyCategoryDataFailure extends AddEditPropertyState {
  final String errorMessage;

  const PropertyCategoryDataFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

final class AddPropertyAPILoading extends AddEditPropertyState {
  @override
  List<Object> get props => [];
}

class AddPropertyAPISuccess extends AddEditPropertyState {
  final AddEditPropertyResponseModel model;

  const AddPropertyAPISuccess({required this.model});

  @override
  List<Object> get props => [model];
}

class CurrencyListAPISuccess extends AddEditPropertyState {
  final CurrencyListResponseModel model;

  const CurrencyListAPISuccess({required this.model});

  @override
  List<Object> get props => [model];
}

class AddPropertyAPIFailure extends AddEditPropertyState {
  final String errorMessage;

  const AddPropertyAPIFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

final class PropertyDetailsLoading extends AddEditPropertyState {
  @override
  List<Object> get props => [];
}

final class PropertyDetailsLoaded extends AddEditPropertyState {
  @override
  List<Object> get props => [];
}

class PropertyDetailsSuccess extends AddEditPropertyState {
  final PropertyDetailsResponseModel model;

  const PropertyDetailsSuccess({required this.model});

  @override
  List<Object> get props => [model];
}

class PropertyDetailsFailure extends AddEditPropertyState {
  final String errorMessage;

  const PropertyDetailsFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class CategoryState extends AddEditPropertyState {
  final CategoryItemOptions categoryItemOptions;
  final List<CategoryItemData> selectedItems;

  const CategoryState({
    required this.categoryItemOptions,
    this.selectedItems = const [],
  });

  CategoryState copyWith({
    List<CategoryItemData>? selectedItems,
  }) {
    return CategoryState(
      categoryItemOptions: categoryItemOptions,
      selectedItems: selectedItems ?? this.selectedItems,
    );
  }

  @override
  List<Object> get props => [categoryItemOptions, selectedItems];
}

class AddEditPropertyCategoryFieldsLoaded extends AddEditPropertyState {
  final Map<String, CategoryItemOptions> categories;

  const AddEditPropertyCategoryFieldsLoaded({required this.categories});

  @override
  List<Object?> get props => [categories];
}

class AddEditPropertyCategoryFieldsFailure extends AddEditPropertyState {
  final String errorMessage;

  const AddEditPropertyCategoryFieldsFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class CategoryOptionState extends AddEditPropertyState {
  final Map<String, CategoryState> categories;
  final String? errorMessage;

  CategoryOptionState({
    Map<String, CategoryState>? categories,
    this.errorMessage,
  }) : categories = categories ?? {};

  CategoryOptionState copyWith({
    Map<String, CategoryState>? categories,
    String? errorMessage,
  }) {
    return CategoryOptionState(
      categories: categories ?? this.categories,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [categories, errorMessage ?? ""];
}

class NearByPropertyAddedState extends AddEditPropertyState {
  final List<NearByLocationModel> selectedLocations;

  const NearByPropertyAddedState({required this.selectedLocations});

  @override
  List<Object> get props => [selectedLocations];
}

class AddPropertyCountryChangedState extends AddEditPropertyState {
  final CountryListData country;

  const AddPropertyCountryChangedState(this.country);

  @override
  List<Object?> get props => [country];
}

class AddPropertyAltCountryChangedState extends AddEditPropertyState {
  final CountryListData country;

  const AddPropertyAltCountryChangedState(this.country);

  @override
  List<Object?> get props => [country];
}