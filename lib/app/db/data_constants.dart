abstract class DbConstants {
  //------------- Cart ---------
  static const tblCart = 'cart';

  static const cartID = 'cart_id';
  static const cartProductId = 'cart_product_id';
  static const cartProductName = 'cart_product_name';
  static const cartProductQuantity = 'cart_quantity';
  static const cartProductImage = 'cart_product_image';

  //------------- Previous Order ---------
  static const tblPreviousOrder = 'previous_orders';

  static const orderId = 'order_autoincrement_id';
  static const orderProductId = 'order_product_id';
  static const orderProductName = 'order_product_name';
  static const orderProductImage = 'order_product_image';
  static const orderPurchaseDate = 'order_purchase_date';
  static const orderProductQuantity = 'order_quantity';
  static const orderStatus = 'order_status';
  static const orderSyncStatus = 'order_sync_status';
}
