import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/vendor_finance/model/vendor_category_list_response.dart';

import '../../../model/property/property_category_response_model.dart';

class ToggleCubit extends Cubit<int> {
  ToggleCubit(this.items,
      {List<VendorCategoryData>? vendorItems, int defaultIndex = 0})
      : vendorItems = vendorItems ?? [],
        super(vendorItems != null && vendorItems.isNotEmpty ? defaultIndex : 0);

  List<PropertyCategoryData> items;
  List<VendorCategoryData> vendorItems;

  void selectItem(int index) {
    emit(index);
  }

  Future<void> updateCategories(
      List<PropertyCategoryData> updatedCategories) async {
    items = updatedCategories;
    emit(0);
  }

  Future<void> updateVendorCategories(
      List<VendorCategoryData> updatedCategories, int selectedIndex) async {
    vendorItems = updatedCategories;
    emit(selectedIndex);
  }
}
