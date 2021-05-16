import 'package:flutter/material.dart';
import 'package:projectui/src/resource/database/CartProvider.dart';
import 'package:projectui/src/resource/model/ListProductsModel.dart';
import 'package:provider/provider.dart';

// giỏ hàng
class CartModel with ChangeNotifier {
  int id;
  int totalQuantity = 0; // tổng số sản phẩm
  List<CartItem> products = []; // danh sách sản phẩm được thêm vào giỏ
  int deliveryAddressId; // địa chỉ giao hàng được chọn
  String dateTime = ""; // ngày nhận hàng dd/MM/yyyy
  String hourTime = ""; // giờ nhận hàng hh:mm-hh:mm
  int paymentType = 1; // phương thức giao hàng (1. COD, 2. Banking, 3. VISA, 4. Point Rewards)
  String note = ""; // Ghi chú đơn hàng
  int isExportInvoice = 0; // 1.Yêu cầu xuất hóa đơn VAT, 0.Không yêu cầu
  int couponId;
  int totalUnread;
  int deliveryStatus = 1;
  int savePoint;

  CartModel(
      {this.id,
      this.totalQuantity,
      this.products,
      this.deliveryAddressId,
      this.dateTime,
      this.hourTime,
      this.paymentType,
      this.note,
      this.isExportInvoice,
      this.couponId,
      this.totalUnread,
      this.deliveryStatus,
      this.savePoint});

  initCart() {
    this.totalQuantity = 0;
    this.products = [];
    this.dateTime = "";
    this.hourTime = "";
    this.note = "";
    this.isExportInvoice = 0;
    this.totalUnread = 0;
    this.deliveryStatus = 1;
    this.savePoint = 0;
    return this;
  }

  static CartModel of(BuildContext context, {bool listen = false}) {
    return Provider.of<CartModel>(context, listen: listen);
  }

  Future<CartModel> getCart() async {
    return await CartProvider.instance.getCart();
  }

  // tính lại tổng số lượng sản phẩm của giỏ hàng
  void refreshQuantity() {
    //Tính tổng số lượng
    int q = 0;
    if (products != null && products.length > 0) {
      products.forEach((CartItem item) {
        q += item.qty;
      });
    }
    this.totalQuantity = q;

    // luu database
    updateCart();

    //Update state
    notifyListeners();
  }

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
        totalQuantity: json['total_quantity'],
        deliveryAddressId: json['delivery_address_id'],
        dateTime: json['date_time'],
        hourTime: json['hour_time'],
        paymentType: json['payment_type'],
        note: json['note'],
        isExportInvoice: json['is_export_invoice'],
        couponId: json['coupon_id'],
        totalUnread: json['total_unread'],
        deliveryStatus: json['delivery_status'],
        savePoint: json['save_point'],
        id: json['id']);
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "total_quantity": totalQuantity,
      "delivery_address_id": deliveryAddressId,
      "date_time": dateTime,
      "hour_time": hourTime,
      "payment_type": paymentType,
      "note": note,
      "is_export_invoice": isExportInvoice,
      "coupon_id": couponId,
      "total_unread": totalUnread,
      "delivery_status": deliveryStatus,
      "save_point": savePoint
    };
    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  void setData(CartModel model) {
    // thiết lập các thông tin giỏ hàng đã chọn
    this.id = model.id;
    this.products = model.products;
    this.deliveryAddressId = model.deliveryAddressId;
    this.dateTime = model.dateTime;
    this.hourTime = model.hourTime;
    this.paymentType = model.paymentType;
    this.note = model.note;
    this.isExportInvoice = model.isExportInvoice;
    this.couponId = model.couponId;
    this.totalQuantity = model.totalQuantity;
    this.totalUnread = model.totalUnread;
    this.deliveryStatus = model.deliveryStatus;
    this.savePoint = model.savePoint;

    refreshQuantity();
  }

  setProducts(List<CartItem> items) {
    this.products = items;
    refreshQuantity();
  }

  // thêm sản phẩm vào giỏ hàng
  void addProduct(Product product, {int colorId = -1}) async {
    var newProduct = (this.products != null && this.products.length > 0)
        ? this.products.firstWhere((val) => val.productId == product.id, orElse: () => null)
        : null;
    if (newProduct != null) {
      // san pham da co cap nhat so luong san pham vao sqlite
      CartItem cartItem = await CartProvider.instance.getCartItem("product_id", product.id);
      if (cartItem != null) {
        cartItem.qty = cartItem.qty + 1;
        cartItem.hasRead = 0;
        this.totalUnread = this.totalUnread == null ? 1 : this.totalUnread + 1;
        updateCartQuantity(newProduct, true);
        await CartProvider.instance.updateCartItem(cartItem);
      } else {
        CartItem item = CartItem(qty: 1, productId: product.id, product: product, hasRead: 0, colorId: colorId);
        item.id = await CartProvider.instance.insertCartItem(item);
        this.products = this.products == null ? [] : this.products;
        this.products.add(item);
      }
    } else {
      // san pham chua co tang so luong san pham len 1
      this.totalQuantity = this.totalQuantity == 0 ? 1 : this.totalQuantity + 1;
      this.totalUnread = this.totalUnread == null ? 1 : this.totalUnread + 1;
      CartItem item = CartItem(product: product, qty: 1, productId: product.id, hasRead: 0, colorId: colorId);
      this.products = this.products == null ? [] : this.products;
      this.products.add(item);

      // them san pham vao sqlite
      await CartProvider.instance.insertCartItem(item);
    }

    // tang so luong chua doc
    // luu cart
    updateCart();

    // cap nhat lai cart model
    notifyListeners();
  }

  // bớt sản phẩm ra khỏi giỏ
  void removeProduct(CartItem item) async {
    // xoa trong db sqlite truoc
    await CartProvider.instance.deleteCartItem(item.id);

    // remove khoi cart item
    if (this.products != null && this.products.length > 0) this.products.removeWhere((val) => val.productId == item.productId);

    // giam so luong san pham
    this.totalQuantity = this.totalQuantity == 0 ? 0 : this.totalQuantity;
    if (this.totalQuantity > item.qty)
      this.totalQuantity = this.totalQuantity - item.qty;
    else
      this.totalQuantity = 0;

    // cap nhat lai cart model
    notifyListeners();
  }

  // cập nhật số lượng cart item (tăng/giảm)
  updateCartQuantity(CartItem item, bool isIncrease) async {
    var product = (this.products != null && this.products.length > 0)
        ? this.products.firstWhere((val) => val.productId == item.productId, orElse: () => null)
        : null;
    if (product != null) {
      if (isIncrease)
        product.plus();
      else
        product.minus();
      await CartProvider.instance.updateCartItem(product);
    }
    this.totalQuantity = this.totalQuantity == 0 ? 0 : this.totalQuantity;
    this.totalQuantity += isIncrease ? 1 : (this.totalQuantity > 0 ? -1 : 0);
    //save cart
    updateCart();
    notifyListeners();
  }

  // lấy tổng giá theo sản phẩm chưa tính hoa hồng
  int get totalPrice {
    int total = 0;
    if (products != null && products.length > 0) {
      products.forEach((CartItem model) {
        total += model.getTotalPrice;
      });
    }
    return total;
  }

  // chọn mã giảm giá
  setCoupon(int code) {
    this.couponId = code;
    notifyListeners();
  }

  // chọn địa chỉ nhận hàng
  setDeliveryAddressId(int id) {
    this.deliveryAddressId = id;
    notifyListeners();

    // luu database
    updateCart();
  }

  // chọn ngày nhận hàng
  setDeliveryDate(String dateTime) {
    this.dateTime = dateTime;
    notifyListeners();

    // luu database
    updateCart();
  }

  // chọn giờ nhận hàng
  setDeliveryHour(String hourTime) {
    this.hourTime = hourTime;
    notifyListeners();

    // luu database
    updateCart();
  }

  // chọn giờ nhận hàng
  setDeliveryStatus(int deliveryStatus) {
    this.deliveryStatus = deliveryStatus;
    notifyListeners();

    // luu database
    updateCart();
  }

  // chọn su dung tich diem
  setSavePoint(int savePoint) {
    this.savePoint = savePoint;
    notifyListeners();

    // luu database
    updateCart();
  }

  // chọn xuất hoá đơn
  setExportInvoice(int isExportInvoice) {
    this.isExportInvoice = isExportInvoice;
    notifyListeners();
    updateCart();
  }

  // chọn phương thức thanh toán
  setPaymentMethod(int paymentType) {
    this.paymentType = paymentType;
    notifyListeners();

    // luu database
    updateCart();
  }

  // nhập ghi chú
  setNote(String value) {
    this.note = value;
    notifyListeners();

    // luu database
    updateCart();
  }

  updateCart() async {
    print("updateCartTotalUnread: ${this.totalUnread}");
    await CartProvider.instance.updateCart(this);
  }

  deleteAllProducts() async {
    await CartProvider.instance.deleteAllCartItem();
    this.products = [];
    this.totalUnread = 0;
    this.totalQuantity = 0;

    updateCart();
    notifyListeners();
  }

  readAll() async {
    if (this.products != null && this.products.length > 0) {
      this.products.map((item) => item.hasRead = 1);
      this.totalUnread = 0;
      notifyListeners();
      // update all row
      await CartProvider.instance.readAll();
    } else {
      this.totalUnread = 0;
      notifyListeners();
    }
  }

  @override
  String toString() {
    return CartModel().toMap().toString();
  }
}

class CartItem {
  int qty;

  // sqlite db
  int id;
  int productId;
  Product product;
  int hasRead;
  int colorId;

  CartItem({this.qty, this.product, this.id, this.productId, this.hasRead, this.colorId = -1});

  int get getTotalPrice {
    int p = 0;
    if (this.product != null) {
      if (this.product.salePrice != null && this.product.salePrice > 0)
        p = this.product.salePrice * this.qty;
      else
        p = this.product.price ?? 0 * this.qty;
    }
    return p != null ? p : 0;
  }

  plus() {
    qty = qty == null ? 0 : qty;
    qty++;
  }

  minus() {
    qty = qty == null ? 0 : qty;
    qty = qty > 0 ? (qty - 1) : 0;
  }

  // them phuong thuc de luu tru sql
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(id: json['id'], productId: json['product_id'], colorId: json['color_id'], qty: json['qty'], hasRead: json['hasRead']);
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "product_id": productId,
      "color_id": colorId,
      "qty": qty,
      "has_read": hasRead,
    };
    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  static List<CartItem> listFromJson(dynamic listJson) => listJson != null ? List<CartItem>.from(listJson.map((x) => CartItem.fromJson(x))) : [];

  // them phuong thuc de tao map luu csdl
  Map toJson() => {'product_id': productId, 'color_id': colorId, 'qty': qty};
}
