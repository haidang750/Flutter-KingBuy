import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/resource/model/address_model.dart';
import 'package:projectui/src/resource/model/cart_model.dart';
import 'package:projectui/src/resource/model/district_model.dart';
import 'package:projectui/src/resource/model/province_model.dart';
import 'package:projectui/src/resource/model/ward_model.dart';
import 'package:projectui/src/resource/model/network_state.dart';
import 'package:projectui/src/utils/app_shared.dart';
import 'package:projectui/src/utils/app_utils.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:toast/toast.dart';

class CreateAddressViewModel extends BaseViewModel {
  int deliveryAddressId;
  final fullNameController = TextEditingController();
  final firstPhoneController = TextEditingController();
  final secondPhoneController = TextEditingController();
  String provinceDropdownValue = "";
  String districtDropdownValue = "";
  String wardDropdownValue = "";
  final oldProvinceName = BehaviorSubject<String>();
  final oldDistrictName = BehaviorSubject<String>();
  final oldWardName = BehaviorSubject<String>();
  final provinceName = BehaviorSubject<String>();
  final districtName = BehaviorSubject<String>();
  final wardName = BehaviorSubject<String>();
  final addressController = TextEditingController();
  bool isExportInvoice = false;
  final taxCodeController = TextEditingController();
  final companyNameController = TextEditingController();
  final companyAddressController = TextEditingController();
  final companyEmailController = TextEditingController();
  int isDefault = 0;
  final provinceSubject = BehaviorSubject<List<Province>>();
  final districtSubject = BehaviorSubject<List<District>>();
  final wardSubject = BehaviorSubject<List<Ward>>();

  Stream<List<Province>> get provinceStream => provinceSubject.stream;

  Stream<List<District>> get districtStream => districtSubject.stream;

  Stream<List<Ward>> get wardStream => wardSubject.stream;

  init(String event, Address address) {
    getProvince();
    if (event == "update") {
      deliveryAddressId = address.id;
      fullNameController.text = address.fullName;
      firstPhoneController.text = address.firstPhone;
      secondPhoneController.text = address.secondPhone;
      provinceDropdownValue = address.provinceCode;
      checkDistrict(address);
      checkWard(address);
      addressController.text = address.address;
      isExportInvoice = address.isExportInvoice == 1 ? true : false;
      taxCodeController.text = address.taxCode;
      companyNameController.text = address.companyName;
      companyAddressController.text = address.companyAddress;
      companyEmailController.text = address.companyEmail;
      isDefault = address.isDefault;
      print("provinceName: ${address.provinceName}");
      print("provinceCode: ${address.provinceCode}");
      oldProvinceName.sink.add(address.provinceName);
      oldDistrictName.sink.add(address.districtName);
      oldWardName.sink.add(address.wardName);
    }
  }

  Future<void> checkDistrict(Address address) async {
    districtDropdownValue = await getDistrict(provinceDropdownValue)
        .then((districts) => districts.any((district) => district.code == address.districtCode) ? address.districtCode : "");
  }

  Future<void> checkWard(Address address) async {
    wardDropdownValue =
        await getWard(address.districtCode).then((wards) => wards.any((ward) => ward.code == address.wardCode) ? address.wardCode : "");
  }

  getProvince() async {
    NetworkState<ProvinceModel> result = await authRepository.getProvince();
    if (result.isSuccess) {
      List<Province> provinces = result.data.provinces;
      provinceSubject.sink.add(provinces);
    }
  }

  onSelectProvince(String provinceCode) async {
    provinceSubject.stream.value.forEach((province) {
      if (province.code == provinceDropdownValue) {
        provinceName.sink.add(province.name);
      }
    });
    await getDistrict(provinceDropdownValue);
  }

  Future<List<District>> getDistrict(String provinceCode) async {
    NetworkState<DistrictModel> result = await authRepository.getDistrict(provinceCode);
    if (result.isSuccess) {
      List<District> districts = result.data.districts;
      districtSubject.sink.add(districts);
      return districts;
    } else {
      return [];
    }
  }

  onSelectDistrict(String districtCode) async {
    districtSubject.stream.value.forEach((district) {
      if (district.code == districtDropdownValue) {
        districtName.sink.add(district.nameWithType);
      }
    });
    await getWard(districtDropdownValue);
  }

  Future<List<Ward>> getWard(String districtCode) async {
    NetworkState<WardModel> result = await authRepository.getWard(districtCode);
    if (result.isSuccess) {
      List<Ward> wards = result.data.wards;
      wardSubject.sink.add(wards);
      return wards;
    } else {
      return [];
    }
  }

  onSelectWard(String wardCode) async {
    wardSubject.stream.value.forEach((ward) {
      if (ward.code == wardDropdownValue) {
        wardName.sink.add(ward.nameWithType);
      }
    });
  }

  onSelectExportVAT() {
    isExportInvoice = !isExportInvoice;
    taxCodeController.clear();
    companyNameController.clear();
    companyAddressController.clear();
    companyEmailController.clear();
  }

  Future<List<Address>> createDeliveryAddress(
      BuildContext context,
      String fullName,
      String firstPhone,
      String secondPhone,
      String provinceCode,
      String districtCode,
      String wardCode,
      String address,
      int isDefault,
      int isExportInvoice,
      String taxCode,
      String companyName,
      String companyAddress,
      String companyEmail) async {
    NetworkState<AddressModel> result = await authRepository.createDeliveryAddress(fullName, firstPhone, secondPhone, provinceCode, districtCode,
        wardCode, address, isDefault, isExportInvoice, taxCode, companyName, companyAddress, companyEmail);
    if (result.isSuccess) {
      List<Address> addresses = result.data.addresses;
      Provider.of<AddressModel>(context, listen: false).setAddress(addresses);
      return addresses;
    } else {
      return null;
    }
  }

  Future<List<Address>> deleteDeliveryAddress(
    BuildContext context,
    int deliveryAddressId,
  ) async {
    NetworkState<AddressModel> result = await authRepository.deleteDeliveryAddress(
      deliveryAddressId,
    );
    if (result.isSuccess) {
      List<Address> addresses = result.data.addresses;
      Provider.of<AddressModel>(context, listen: false).setAddress(addresses);
      return addresses;
    } else {
      return null;
    }
  }

  handleButtonCreate() async {
    List<Address> listAddress = await createDeliveryAddress(
        context,
        fullNameController.text,
        firstPhoneController.text,
        secondPhoneController.text,
        provinceDropdownValue,
        districtDropdownValue,
        wardDropdownValue,
        addressController.text,
        isDefault,
        isExportInvoice ? 1 : 0,
        taxCodeController.text,
        companyNameController.text,
        companyAddressController.text,
        companyEmailController.text);
    if (listAddress != null) {
      Toast.show("Thêm mới địa chỉ thành công", context, gravity: Toast.CENTER);
      Navigator.pop(context, listAddress);
    } else {
      Toast.show("Thêm mới địa chỉ không thành công", context, gravity: Toast.CENTER);
    }
  }

  handleButtonUpdate(bool isCallFromCart, Address address) async {
    if (isCallFromCart) {
      // đây là trường hợp Update địa chỉ khi không Login
      final createAddressViewModel = CreateAddressViewModel();
      List<dynamic> deliveryStatus = [];
      int shipFeeBulky;
      int shipFeeNotBulky;
      String ward = wardName.stream.value != null ? wardName.stream.value : oldWardName.stream.value;
      String district = districtName.stream.value != null ? districtName.stream.value : oldDistrictName.stream.value;
      String province = provinceName.stream.value != null ? provinceName.stream.value : oldProvinceName.stream.value;
      String fullAddress = addressController.text + ", $ward" + ", $district" + ", $province";

      // từ provinceCode đã chọn, lấy ra danh sách các districts của province đó
      List<District> districts = await createAddressViewModel.getDistrict(provinceDropdownValue);
      // kiểm tra trong danh sách district trả về, district nào trùng với district đang chọn thì lấy ra delivery_status của district đó
      districts.forEach((district) {
        if (district.code == districtDropdownValue) {
          deliveryStatus = district.deliveryStatus;
          shipFeeBulky = district.shipFeeBulky;
          shipFeeNotBulky = district.shipFeeNotBulky;
        }
      });

      Map<String, dynamic> addressJson = {
        "id": address.id,
        "delivery_status": deliveryStatus,
        "first_phone": firstPhoneController.text,
        "second_phone": secondPhoneController.text,
        "fullname": fullNameController.text,
        "province_code": provinceDropdownValue,
        "province_name": province,
        "district_code": districtDropdownValue,
        "district_name": district,
        "ward_code": wardDropdownValue,
        "ward_name": ward,
        "address": addressController.text,
        "full_address": fullAddress,
        "is_export_invoice": isExportInvoice ? 1 : 0,
        "tax_code": taxCodeController.text,
        "company_name": companyNameController.text,
        "company_address": companyAddressController.text,
        "company_email": companyEmailController.text,
        "ship_fee_bulky": shipFeeBulky,
        "ship_fee_not_bulky": shipFeeNotBulky
      };

      Address addressObject = Address.fromJson(addressJson);
      AppShared.setListAddress([json.encode(addressObject)]);
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
        List<String> listAddressLocal = await AppShared.getAddressModel(); // lấy ra để hiển thị ở màn hình ListAddresss
        List<Address> listAddress = [];
        Map<String, dynamic> address = jsonDecode(listAddressLocal[0]);
        listAddress.add(Address.fromJson(address));
        CartModel.of(context).setDeliveryAddressId(listAddress[0].id);
        Toast.show("Cập nhật địa chỉ thành công", context, gravity: Toast.CENTER);
        Navigator.pop(context, listAddress);
      });
    } else {
      List<Address> listAddress = await AppUtils.updateDeliveryAddress(
          context,
          deliveryAddressId,
          fullNameController.text,
          firstPhoneController.text,
          secondPhoneController.text,
          provinceDropdownValue,
          districtDropdownValue,
          wardDropdownValue,
          addressController.text,
          isDefault,
          isExportInvoice ? 1 : 0,
          taxCodeController.text,
          companyNameController.text,
          companyAddressController.text,
          companyEmailController.text);
      if (listAddress != null) {
        Toast.show("Cập nhật địa chỉ thành công", context, gravity: Toast.CENTER);
        Navigator.pop(context, listAddress);
      } else {
        Toast.show("Cập nhật địa chỉ không thành công", context, gravity: Toast.CENTER);
      }
    }
  }

  handleButtonApplyDefault(bool isCallFromCart, Address address) async {
    if (isCallFromCart) {
      // Xóa hết địa chỉ đã lưu trong SharedPreferences và chỉ giữ lại địa chỉ được Áp dụng
      AppShared.setListAddress([json.encode(address)]); // lưu vào
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
        List<String> listAddressLocal = await AppShared.getAddressModel(); // lấy ra để hiển thị ở màn hình ListAddresss
        List<Address> listAddress = [];
        Map<String, dynamic> address = jsonDecode(listAddressLocal[0]);
        listAddress.add(Address.fromJson(address));
        CartModel.of(context).setDeliveryAddressId(listAddress[0].id);
        Toast.show("Áp dụng địa chỉ giao hàng thành công", context, gravity: Toast.CENTER);
        Navigator.pop(context, listAddress);
      });
    } else {
      if (isDefault == 0) {
        isDefault = 1;
        List<Address> listAddress = await AppUtils.updateDeliveryAddress(
            context,
            deliveryAddressId,
            fullNameController.text,
            firstPhoneController.text,
            secondPhoneController.text,
            provinceDropdownValue,
            districtDropdownValue,
            wardDropdownValue,
            addressController.text,
            isDefault,
            isExportInvoice ? 1 : 0,
            taxCodeController.text,
            companyNameController.text,
            companyAddressController.text,
            companyEmailController.text);
        if (listAddress != null) {
          Toast.show("Áp dụng địa chỉ mặc định thành công", context, gravity: Toast.CENTER);
          Navigator.pop(context, listAddress);
        } else {
          Toast.show("Áp dụng địa chỉ mặc định không thành công", context, gravity: Toast.CENTER);
        }
      } else {
        return null;
      }
    }
  }

  handleButtonDelete() async {
    List<Address> listAddress = await deleteDeliveryAddress(
      context,
      deliveryAddressId,
    );
    if (listAddress != null) {
      Toast.show("Xóa địa chỉ thành công", context, gravity: Toast.CENTER);
      Navigator.pop(context, listAddress);
    } else {
      Toast.show("Xóa địa chỉ không thành công", context, gravity: Toast.CENTER);
    }
  }

  @override
  void dispose() {
    super.dispose();
    oldProvinceName.close();
    oldDistrictName.close();
    oldWardName.close();
    provinceName.close();
    districtName.close();
    wardName.close();
    provinceSubject.close();
    districtSubject.close();
    wardSubject.close();
  }
}
