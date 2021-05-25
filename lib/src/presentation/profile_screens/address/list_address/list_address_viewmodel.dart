import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/profile_screens/address/create_address/create_address.dart';
import 'package:projectui/src/presentation/base/base_viewmodel.dart';
import 'package:projectui/src/resource/model/address_model.dart';
import 'package:projectui/src/resource/model/cart_model.dart';
import 'package:projectui/src/resource/model/network_state.dart';
import 'package:projectui/src/utils/app_shared.dart';
import 'package:projectui/src/utils/app_utils.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class ListAddressViewModel extends BaseViewModel {
  final selectedAddressSubject = BehaviorSubject<int>();
  final listAddressSubject = BehaviorSubject<List<Address>>();
  final showAddAddressIcon = BehaviorSubject<bool>();
  final cartAddressSubject = BehaviorSubject<Address>();

  init(Address cartAddress) {
    selectedAddressSubject.sink.add(-1);
    cartAddressSubject.sink.add(cartAddress);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (await AppUtils.checkLogin()) {
        print("Login => Show ListAddress Provider");
        await getDeliveryAddress(context);
        listAddressSubject.sink.add(Provider.of<AddressModel>(context, listen: false).addresses);
        showAddAddressIcon.sink.add(true);
      } else {
        print("Not Login => Show ListAddress SharedPreferences");
        List<String> listAddressLocal = await AppShared.getAddressModel();
        List<Address> listAddress = [];
        listAddressLocal.forEach((addressLocal) {
          Map<String, dynamic> address = jsonDecode(addressLocal);
          listAddress.add(Address.fromJson(address));
        });
        showAddAddressIcon.sink.add(listAddress.length > 0 ? false : true);
        listAddressSubject.sink.add(listAddress);
      }
    });
  }

  getDeliveryAddress(BuildContext context) async {
    NetworkState<AddressModel> result = await authRepository.getDeliveryAddress();
    if (result.isSuccess) {
      List<Address> listAddress = result.data.addresses;
      // Sau khi lấy dữ liệu về thành công thì set dữ liệu vào Provider
      Provider.of<AddressModel>(context, listen: false).setAddress(listAddress);
      saveListAddressLocal(listAddress);
    }
  }

  // Sau khi đăng nhập và lấy danh sách Address về thì lưu danh sách này vào Local để sử dụng khi không Đăng nhập
  saveListAddressLocal(List<Address> listAddress) {
    List<String> listAddressLocal = [];
    listAddress.forEach((address) {
      listAddressLocal.add(json.encode(address));
    });
    AppShared.setListAddress(listAddressLocal);
  }

  onTapButtonAdd(bool isCallFromCart) async {
    listAddressSubject.sink.add(await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CreateAddress(isCallFromCart: isCallFromCart, event: "create", listAddress: listAddressSubject.stream.value))));
  }

  handleDeliveryToAddress(int selectedAddressIndex) async {
    Address address = listAddressSubject.stream.value[selectedAddressIndex];
    // Update địa chỉ đó thành địa chỉ mặc định
    await AppUtils.updateDeliveryAddress(
        context,
        address.id,
        address.fullName,
        address.firstPhone,
        address.secondPhone,
        address.provinceCode,
        address.districtCode,
        address.wardCode,
        address.address,
        1,
        address.isExportInvoice,
        address.taxCode,
        address.companyName,
        address.companyAddress,
        address.companyEmail);
    if (address.taxCode == null) address.taxCode = "";
    if (address.companyName == null) address.companyName = "";
    if (address.companyAddress == null) address.companyAddress = "";
    if (address.companyEmail == null) address.companyEmail = "";
    CartModel.of(context).setDeliveryAddressId(address.id);
    Navigator.pop(context, address);
  }

  onSelectOneAddress(bool enableSelect, int index, Address address, bool isCallFromCart) async {
    if (enableSelect) {
      selectedAddressSubject.sink.add(index);
    } else {
      await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      CreateAddress(isCallFromCart: isCallFromCart, address: address, listAddress: listAddressSubject.stream.value, event: "update")))
          .then((listAddress) {
        listAddressSubject.sink.add(listAddress);
        cartAddressSubject.sink.add(listAddress[0]);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    selectedAddressSubject.close();
    listAddressSubject.close();
    showAddAddressIcon.close();
    cartAddressSubject.close();
  }
}
