import 'package:flutter/material.dart';

class AddressModel with ChangeNotifier {
  AddressModel({
    this.addresses,
  });

  List<Address> addresses;

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        addresses:
            List<Address>.from(json["rows"].map((x) => Address.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "rows": List<dynamic>.from(addresses.map((x) => x.toJson())),
      };

  void setAddress(List<Address> addresses) {
    this.addresses = addresses;
    notifyListeners();
  }

  List<Address> getAddress() => this.addresses;
}

class Address {
  Address({
    this.id,
    this.userId,
    this.address,
    this.provinceCode,
    this.provinceName,
    this.districtName,
    this.wardName,
    this.districtCode,
    this.deliveryStatus,
    this.wardCode,
    this.isDefault,
    this.isExportInvoice,
    this.taxCode,
    this.companyName,
    this.companyAddress,
    this.companyEmail,
    this.firstPhone,
    this.secondPhone,
    this.fullName,
    this.shipFeeBulky,
    this.shipFeeNotBulky,
    this.fullAddress,
  });

  int id;
  int userId;
  String address;
  String provinceCode;
  String provinceName;
  String districtName;
  String wardName;
  String districtCode;
  List<int> deliveryStatus;
  String wardCode;
  int isDefault;
  int isExportInvoice;
  dynamic taxCode;
  dynamic companyName;
  dynamic companyAddress;
  dynamic companyEmail;
  String firstPhone;
  String secondPhone;
  String fullName;
  int shipFeeBulky;
  int shipFeeNotBulky;
  String fullAddress;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"],
        userId: json["user_id"],
        address: json["address"],
        provinceCode: json["province_code"],
        provinceName: json["province_name"],
        districtName: json["district_name"],
        wardName: json["ward_name"],
        districtCode: json["district_code"],
        deliveryStatus: List<int>.from(json["delivery_status"].map((x) => x)),
        wardCode: json["ward_code"],
        isDefault: json["is_default"],
        isExportInvoice: json["is_export_invoice"],
        taxCode: json["tax_code"],
        companyName: json["company_name"],
        companyAddress: json["company_address"],
        companyEmail: json["company_email"],
        firstPhone: json["first_phone"],
        secondPhone: json["second_phone"] ?? null,
        fullName: json["fullname"],
        shipFeeBulky: json["ship_fee_bulky"],
        shipFeeNotBulky: json["ship_fee_not_bulky"],
        fullAddress: json["full_address"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "address": address,
        "province_code": provinceCode,
        "province_name": provinceName,
        "district_name": districtName,
        "ward_name": wardName,
        "district_code": districtCode,
        "delivery_status": List<dynamic>.from(deliveryStatus.map((x) => x)),
        "ward_code": wardCode,
        "is_default": isDefault,
        "is_export_invoice": isExportInvoice,
        "tax_code": taxCode,
        "company_name": companyName,
        "company_address": companyAddress,
        "company_email": companyEmail,
        "first_phone": firstPhone,
        "second_phone": secondPhone ?? null,
        "fullname": fullName,
        "ship_fee_bulky": shipFeeBulky,
        "ship_fee_not_bulky": shipFeeNotBulky,
        "full_address": fullAddress,
      };
}
