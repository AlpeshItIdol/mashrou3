import 'package:mashrou3/app/ui/screens/property_details/sub_screens/vendor_finance/model/property_vendor_finance_data.dart';

class PropertyVendorFinanceService {
  PropertyVendorFinanceData _propertyVendorFinanceData =
      PropertyVendorFinanceData();

  PropertyVendorFinanceData get data => _propertyVendorFinanceData;

  void setData(PropertyVendorFinanceData data) {
    _propertyVendorFinanceData = data;
  }

  void setPropertyId(String propertyId) {
    _propertyVendorFinanceData.propertyId = propertyId;
  }

  String? getPropertyId() {
    return _propertyVendorFinanceData.propertyId;
  }

  void setVendorCatId(String vendorCatId) {
    _propertyVendorFinanceData.vendorCategoryId = vendorCatId;
  }

  String? getVendorCatId() {
    return _propertyVendorFinanceData.vendorCategoryId;
  }

  void setVendorId(String vendorId) {
    _propertyVendorFinanceData.vendorId = vendorId;
  }

  String? getVendorId() {
    return _propertyVendorFinanceData.vendorId;
  }

  void updateCashSelection(bool isCashSelected) {
    _propertyVendorFinanceData.isCashSelected = isCashSelected;
  }

  bool? isCashSelected() {
    return _propertyVendorFinanceData.isCashSelected;
  }

  void clearData() {
    _propertyVendorFinanceData = PropertyVendorFinanceData();
  }
}
