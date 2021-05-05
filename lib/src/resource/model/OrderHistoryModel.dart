import 'package:projectui/src/resource/model/ListProductsModel.dart';

class OrderHistoryModel {
  OrderHistoryModel({
    this.orders,
    this.recordsTotal,
  });

  List<Order> orders;
  int recordsTotal;

  factory OrderHistoryModel.fromJson(Map<String, dynamic> json) =>
      OrderHistoryModel(
        orders: List<Order>.from(json["rows"].map((x) => Order.fromJson(x))),
        recordsTotal: json["recordsTotal"],
      );

  Map<String, dynamic> toJson() => {
        "rows": List<dynamic>.from(orders.map((x) => x.toJson())),
        "recordsTotal": recordsTotal,
      };
}

class Order {
  Order({
    this.id,
    this.invoiceCode,
    this.userId,
    this.paymentType,
    this.orderAddress,
    this.orderPhone,
    this.orderPhone2,
    this.orderName,
    this.note,
    this.deliveryCharge,
    this.discount,
    this.total,
    this.rewardPoints,
    this.isUsePoint,
    this.usedPoints,
    this.status,
    this.deliveryStatus,
    this.payment,
    this.isExportInvoice,
    this.taxCode,
    this.companyName,
    this.companyAddress,
    this.companyEmail,
    this.createdAt,
    this.deliveryDate,
    this.pointToMoneyDiscount,
    this.couponId,
    this.items,
    this.monthsInstallment,
    this.prepayInstallmentAmount,
    this.prepayInstallment,
    this.payMonthlyInstallment,
  });

  int id;
  String invoiceCode;
  int userId;
  int paymentType;
  String orderAddress;
  String orderPhone;
  dynamic orderPhone2;
  String orderName;
  String note;
  int deliveryCharge;
  int discount;
  int total;
  int rewardPoints;
  int isUsePoint;
  int usedPoints;
  int status;
  dynamic deliveryStatus;
  int payment;
  int isExportInvoice;
  dynamic taxCode;
  dynamic companyName;
  dynamic companyAddress;
  dynamic companyEmail;
  String createdAt;
  String deliveryDate;
  int pointToMoneyDiscount;
  dynamic couponId;
  List<Item> items;
  int monthsInstallment;
  int prepayInstallmentAmount;
  int prepayInstallment;
  int payMonthlyInstallment;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        invoiceCode: json["invoice_code"],
        userId: json["user_id"],
        paymentType: json["payment_type"],
        orderAddress: json["order_address"],
        orderPhone: json["order_phone"],
        orderPhone2: json["order_phone_2"],
        orderName: json["order_name"],
        note: json["note"],
        deliveryCharge: json["delivery_charge"],
        discount: json["discount"],
        total: json["total"],
        rewardPoints: json["reward_points"],
        isUsePoint: json["is_use_point"],
        usedPoints: json["used_points"],
        status: json["status"],
        deliveryStatus: json["delivery_status"],
        payment: json["payment"],
        isExportInvoice: json["is_export_invoice"],
        taxCode: json["tax_code"],
        companyName: json["company_name"],
        companyAddress: json["company_address"],
        companyEmail: json["company_email"],
        createdAt: json["created_at"],
        deliveryDate: json["delivery_date"],
        pointToMoneyDiscount: json["point_to_money_discount"],
        couponId: json["coupon_id"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        monthsInstallment: json["months_installment"],
        prepayInstallmentAmount: json["prepay_installment_amount"],
        prepayInstallment: json["prepay_installment"],
        payMonthlyInstallment: json["pay_monthly_installment"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "invoice_code": invoiceCode,
        "user_id": userId,
        "payment_type": paymentType,
        "order_address": orderAddress,
        "order_phone": orderPhone,
        "order_phone_2": orderPhone2,
        "order_name": orderName,
        "note": note,
        "delivery_charge": deliveryCharge,
        "discount": discount,
        "total": total,
        "reward_points": rewardPoints,
        "is_use_point": isUsePoint,
        "used_points": usedPoints,
        "status": status,
        "delivery_status": deliveryStatus,
        "payment": payment,
        "is_export_invoice": isExportInvoice,
        "tax_code": taxCode,
        "company_name": companyName,
        "company_address": companyAddress,
        "company_email": companyEmail,
        "created_at": createdAt,
        "delivery_date": deliveryDate,
        "point_to_money_discount": pointToMoneyDiscount,
        "coupon_id": couponId,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "months_installment": monthsInstallment,
        "prepay_installment_amount": prepayInstallmentAmount,
        "prepay_installment": prepayInstallment,
        "pay_monthly_installment": payMonthlyInstallment,
      };
}

class Item {
  Item({
    this.id,
    this.invoiceId,
    this.productId,
    this.imageSource,
    this.productName,
    this.colorName,
    this.gifts,
    this.price,
    this.qty,
    this.total,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int invoiceId;
  int productId;
  String imageSource;
  String productName;
  dynamic colorName;
  List<Gift> gifts;
  int price;
  int qty;
  int total;
  DateTime createdAt;
  DateTime updatedAt;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        invoiceId: json["invoice_id"],
        productId: json["product_id"],
        imageSource: json["image_source"],
        productName: json["product_name"],
        colorName: json["color_name"],
        gifts: List<Gift>.from(json["gifts"].map((x) => Gift.fromJson(x))),
        price: json["price"],
        qty: json["qty"],
        total: json["total"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "invoice_id": invoiceId,
        "product_id": productId,
        "image_source": imageSource,
        "product_name": productName,
        "color_name": colorName,
        "gifts": List<dynamic>.from(gifts.map((x) => x.toJson())),
        "price": price,
        "qty": qty,
        "total": total,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

