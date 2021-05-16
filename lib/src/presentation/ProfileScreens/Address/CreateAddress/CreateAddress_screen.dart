import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/presentation.dart';
import 'package:projectui/src/resource/model/AddressModel.dart';
import 'package:projectui/src/resource/model/CartModel.dart';
import 'package:projectui/src/resource/model/DistrictModel.dart';
import 'package:projectui/src/resource/model/ProvinceModel.dart';
import 'package:projectui/src/resource/model/WardModel.dart';
import 'package:projectui/src/utils/app_shared.dart';
import 'package:rxdart/rxdart.dart';
import 'package:toast/toast.dart';
import '../../../widgets/BorderTextField.dart';

class CreateAddress extends StatefulWidget {
  CreateAddress({this.address, this.listAddress, this.event, this.isCallFromCart});

  Address address;
  List<Address> listAddress;
  String event;
  bool isCallFromCart;

  @override
  CreateAddressState createState() => CreateAddressState();
}

class CreateAddressState extends State<CreateAddress> with ResponsiveWidget {
  final createAddressViewModel = CreateAddressViewModel();
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

  @override
  void initState() {
    super.initState();
    createAddressViewModel.getProvince();
    if (widget.event == "update") {
      deliveryAddressId = widget.address.id;
      fullNameController.text = widget.address.fullName;
      firstPhoneController.text = widget.address.firstPhone;
      secondPhoneController.text = widget.address.secondPhone;
      provinceDropdownValue = widget.address.provinceCode;
      checkDistrict();
      checkWard();
      addressController.text = widget.address.address;
      isExportInvoice = widget.address.isExportInvoice == 1 ? true : false;
      taxCodeController.text = widget.address.taxCode;
      companyNameController.text = widget.address.companyName;
      companyAddressController.text = widget.address.companyAddress;
      companyEmailController.text = widget.address.companyEmail;
      isDefault = widget.address.isDefault;
      print("provinceName: ${widget.address.provinceName}");
      print("provinceCode: ${widget.address.provinceCode}");
      oldProvinceName.sink.add(widget.address.provinceName);
      oldDistrictName.sink.add(widget.address.districtName);
      oldWardName.sink.add(widget.address.wardName);
    }
  }

  Future<void> checkDistrict() async {
    districtDropdownValue = await createAddressViewModel
        .getDistrict(provinceDropdownValue)
        .then((districts) => districts.any((district) => district.code == widget.address.districtCode) ? widget.address.districtCode : "");
  }

  Future<void> checkWard() async {
    wardDropdownValue = await createAddressViewModel
        .getWard(widget.address.districtCode)
        .then((wards) => wards.any((ward) => ward.code == widget.address.wardCode) ? widget.address.wardCode : "");
  }

  @override
  void dispose() {
    super.dispose();
    createAddressViewModel.dispose();
    oldProvinceName.close();
    oldDistrictName.close();
    oldWardName.close();
    provinceName.close();
    districtName.close();
    wardName.close();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: createAddressViewModel,
        builder: (context, viewModel, child) => Scaffold(
            appBar: AppBar(
                titleSpacing: 0,
                title: Text(widget.event == "create" ? "Thêm mới địa chỉ" : "Chi tiết địa chỉ"),
                leading: Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context, widget.listAddress);
                      },
                    );
                  },
                )),
            body: buildUi(context: context)));
  }

  Widget buildScreen() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: ListView(
        children: [
          buildRequiredInfo(),
          Container(
            height: 10,
            color: Colors.grey.shade300,
          ),
          Container(
              height: isExportInvoice ? 310 : 65,
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: ListView(
                physics: NeverScrollableScrollPhysics(),
                children: [buildCheckVAT(), isExportInvoice ? buildVATInfo() : Container()],
              )),
          widget.event == "create" ? buildCreateButton() : buildUpdateButton(),
          Container(
            height: 20,
          )
        ],
      ),
    );
  }

  Widget buildRequiredInfo() {
    return Container(
      height: 420,
      padding: EdgeInsets.fromLTRB(15, 20, 15, 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BorderTextField(
            height: 50,
            borderColor: AppColors.grey3,
            borderRadius: 6,
            borderWidth: 0.8,
            textController: fullNameController,
            fontSize: 14,
            hintText: "Họ và tên",
            hintTextFontSize: 14,
            hintTextFontWeight: FontWeight.w400,
          ),
          BorderTextField(
            height: 50,
            borderColor: AppColors.grey3,
            borderRadius: 6,
            borderWidth: 0.8,
            textController: firstPhoneController,
            fontSize: 14,
            hintText: "Số điện thoại",
            hintTextFontSize: 14,
            hintTextFontWeight: FontWeight.w400,
          ),
          BorderTextField(
            height: 50,
            borderColor: AppColors.grey3,
            borderRadius: 6,
            borderWidth: 0.8,
            textController: secondPhoneController,
            fontSize: 14,
            hintText: "Số điện thoại 2 (nếu có)",
            hintTextFontSize: 14,
            hintTextFontWeight: FontWeight.w400,
          ),
          Container(
            height: 50,
            child: Row(
              children: [buildProvinceField(), Spacer(), buildDistrictField()],
            ),
          ),
          buildWardField(),
          BorderTextField(
            height: 50,
            borderColor: AppColors.grey3,
            borderRadius: 6,
            borderWidth: 0.8,
            textController: addressController,
            fontSize: 14,
            hintText: "Địa chỉ cụ thể (số nhà, tên tòa nhà)",
            hintTextFontSize: 14,
            hintTextFontWeight: FontWeight.w400,
          )
        ],
      ),
    );
  }

  Widget buildProvinceField() {
    return Container(
        height: 50,
        width: MediaQuery.of(context).size.width * 0.45,
        padding: EdgeInsets.only(left: 10, right: 5),
        decoration: BoxDecoration(border: Border.all(width: 0.8, color: AppColors.grey3), borderRadius: BorderRadius.all(Radius.circular(6))),
        child: StreamBuilder(
          stream: createAddressViewModel.provinceStream,
          builder: (context, snapshot) {
            return DropdownButton<String>(
                isExpanded: true,
                underline: Container(),
                value: provinceDropdownValue == "" ? null : provinceDropdownValue,
                hint: Text(
                  "Tỉnh/Thành phố",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                ),
                icon: Icon(Icons.keyboard_arrow_down),
                onChanged: (provinceCode) async {
                  setState(() {
                    provinceDropdownValue = provinceCode;
                    districtDropdownValue = "";
                    wardDropdownValue = "";
                  });
                  createAddressViewModel.provinceSubject.stream.value.forEach((province) {
                    if (province.code == provinceDropdownValue) {
                      provinceName.sink.add(province.name);
                    }
                  });
                  await createAddressViewModel.getDistrict(provinceDropdownValue);
                },
                items: snapshot.hasData
                    ? snapshot.data.map<DropdownMenuItem<String>>((Province province) {
                        return DropdownMenuItem<String>(
                          value: province.code,
                          child: Text(province.name),
                        );
                      }).toList()
                    : []);
          },
        ));
  }

  Widget buildDistrictField() {
    return Container(
        height: 50,
        width: MediaQuery.of(context).size.width * 0.45,
        padding: EdgeInsets.only(left: 10, right: 5),
        decoration: BoxDecoration(border: Border.all(width: 0.8, color: AppColors.grey3), borderRadius: BorderRadius.all(Radius.circular(6))),
        child: StreamBuilder(
          stream: createAddressViewModel.districtStream,
          builder: (context, snapshot) {
            return DropdownButton<String>(
                isExpanded: true,
                underline: Container(),
                value: districtDropdownValue == "" ? null : districtDropdownValue,
                hint: Text(
                  "Quận/Huyện",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                ),
                icon: Icon(Icons.keyboard_arrow_down),
                onChanged: (districtCode) async {
                  setState(() {
                    districtDropdownValue = districtCode;
                    wardDropdownValue = "";
                  });
                  createAddressViewModel.districtSubject.stream.value.forEach((district) {
                    if (district.code == districtDropdownValue) {
                      districtName.sink.add(district.nameWithType);
                    }
                  });
                  await createAddressViewModel.getWard(districtDropdownValue);
                },
                items: snapshot.hasData
                    ? snapshot.data.map<DropdownMenuItem<String>>((District district) {
                        return DropdownMenuItem<String>(
                          value: district.code,
                          child: Text(district.nameWithType == null ? "" : district.nameWithType),
                        );
                      }).toList()
                    : []);
          },
        ));
  }

  Widget buildWardField() {
    return Container(
        height: 50,
        padding: EdgeInsets.only(left: 10, right: 5),
        decoration: BoxDecoration(border: Border.all(width: 0.8, color: AppColors.grey3), borderRadius: BorderRadius.all(Radius.circular(6))),
        child: StreamBuilder(
          stream: createAddressViewModel.wardStream,
          builder: (context, snapshot) {
            return DropdownButton<String>(
                isExpanded: true,
                underline: Container(),
                value: wardDropdownValue == "" ? null : wardDropdownValue,
                hint: Text(
                  "Phường/Xã",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                ),
                icon: Icon(Icons.keyboard_arrow_down),
                onChanged: (wardCode) {
                  setState(() {
                    wardDropdownValue = wardCode;
                  });
                  createAddressViewModel.wardSubject.stream.value.forEach((ward) {
                    if (ward.code == wardDropdownValue) {
                      wardName.sink.add(ward.nameWithType);
                    }
                  });
                },
                items: snapshot.hasData
                    ? snapshot.data.map<DropdownMenuItem<String>>((Ward ward) {
                        return DropdownMenuItem<String>(
                          value: ward.code,
                          child: Text(ward.nameWithType == null ? "" : ward.nameWithType),
                        );
                      }).toList()
                    : []);
          },
        ));
  }

  Widget buildCheckVAT() {
    return Container(
        padding: EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
              value: isExportInvoice,
              activeColor: AppColors.primary,
              onChanged: (value) {
                setState(() {
                  isExportInvoice = !isExportInvoice;
                  taxCodeController.clear();
                  companyNameController.clear();
                  companyAddressController.clear();
                  companyEmailController.clear();
                });
              },
            ),
            GestureDetector(
              child: Text(
                "YÊU CẦU XUẤT HÓA ĐƠN VAT",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                setState(() {
                  isExportInvoice = !isExportInvoice;
                  taxCodeController.clear();
                  companyNameController.clear();
                  companyAddressController.clear();
                  companyEmailController.clear();
                });
              },
            )
          ],
        ));
  }

  Widget buildVATInfo() {
    return Column(
      children: [
        BorderTextField(
          height: 50,
          borderColor: AppColors.grey3,
          borderRadius: 6,
          borderWidth: 0.8,
          textController: taxCodeController,
          fontSize: 14,
          hintText: "Mã số thuế",
          hintTextFontSize: 14,
          hintTextFontWeight: FontWeight.w400,
        ),
        SizedBox(height: 10),
        BorderTextField(
          height: 50,
          borderColor: AppColors.grey3,
          borderRadius: 6,
          borderWidth: 0.8,
          textController: companyNameController,
          fontSize: 14,
          hintText: "Tên công ty",
          hintTextFontSize: 14,
          hintTextFontWeight: FontWeight.w400,
        ),
        SizedBox(height: 10),
        BorderTextField(
          height: 50,
          borderColor: AppColors.grey3,
          borderRadius: 6,
          borderWidth: 0.8,
          textController: companyAddressController,
          fontSize: 14,
          hintText: "Địa chỉ công ty",
          hintTextFontSize: 14,
          hintTextFontWeight: FontWeight.w400,
        ),
        SizedBox(height: 10),
        BorderTextField(
          height: 50,
          borderColor: AppColors.grey3,
          borderRadius: 6,
          borderWidth: 0.8,
          textController: companyEmailController,
          fontSize: 14,
          hintText: "Email",
          hintTextFontSize: 14,
          hintTextFontWeight: FontWeight.w400,
        ),
      ],
    );
  }

  Widget buildButton(Alignment alignment, double buttonHeight, double buttonWidth, Color buttonColor, double buttonBorderRadius, String buttonContent,
      Color buttonContentColor, double buttonContentSize, FontWeight buttonContentFontWeight, Function buttonAction) {
    return GestureDetector(
        child: Container(
            alignment: alignment,
            child: Container(
                height: buttonHeight,
                width: buttonWidth,
                decoration: BoxDecoration(color: buttonColor, borderRadius: BorderRadius.all(Radius.circular(buttonBorderRadius))),
                alignment: Alignment.center,
                child: Text(buttonContent,
                    style: TextStyle(
                      color: buttonContentColor,
                      fontSize: buttonContentSize,
                      fontWeight: buttonContentFontWeight,
                    )))),
        onTap: buttonAction);
  }

  Widget buildCreateButton() {
    return Container(
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: buildButton(Alignment.centerRight, 60, 100, Colors.blue, 30, "Thêm mới", Colors.white, 16, FontWeight.w500, handleButtonCreate));
  }

  Widget buildUpdateButton() {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: widget.isCallFromCart
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Khi không đăng nhập, phải chọn 1 địa chỉ trong danh sách địa chỉ rồi nhấn Áp dụng thì mới cho phép chỉnh sửa lại thông tin địa
                // chỉ đó, khi nhấn Áp dụng thì địa chỉ này cũng được sử dụng để hiển thị ngoài CartScreen
                widget.listAddress.length > 1
                    ? Container()
                    : buildButton(Alignment.centerRight, 60, 100, Colors.blue, 30, "Lưu lại", Colors.white, 16, FontWeight.w500, handleButtonUpdate),
                widget.listAddress.length > 1 ? Container() : SizedBox(width: 10),
                buildButton(Alignment.centerRight, 60, 100, Colors.blue, 30, "Áp dụng", Colors.white, 16, FontWeight.w500, handleButtonApplyDefault),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                buildButton(Alignment.centerRight, 60, 100, Colors.red.shade500, 30, "Xóa", Colors.white, 16, FontWeight.w500, handleButtonDelete),
                SizedBox(width: 10),
                buildButton(Alignment.centerRight, 60, 100, isDefault == 1 ? Colors.grey : Colors.blue, 30, "Áp dụng", Colors.white, 16,
                    FontWeight.w500, handleButtonApplyDefault),
                SizedBox(width: 10),
                buildButton(Alignment.centerRight, 60, 100, Colors.blue, 30, "Lưu lại", Colors.white, 16, FontWeight.w500, handleButtonUpdate)
              ],
            ),
    );
  }

  void handleButtonCreate() async {
    List<Address> listAdress = await createAddressViewModel.createDeliveryAddress(
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
    if (listAdress != null) {
      Toast.show("Thêm mới địa chỉ thành công", context, gravity: Toast.CENTER);
      Navigator.pop(context, listAdress);
    } else {
      Toast.show("Thêm mới địa chỉ không thành công", context, gravity: Toast.CENTER);
    }
  }

  void handleButtonUpdate() async {
    if (widget.isCallFromCart) {
      // đây là trường hợp Update địa chỉ khi không Login
      final createAddressViewModel = CreateAddressViewModel();
      List<dynamic> deliveryStatus = [];
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
        }
      });

      Map<String, dynamic> addressJson = {
        "id": widget.address.id,
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
      List<Address> listAddress = await createAddressViewModel.updateDeliveryAddress(
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

  void handleButtonApplyDefault() async {
    if (widget.isCallFromCart) {
      // Xóa hết địa chỉ đã lưu trong SharedPreferences và chỉ giữ lại địa chỉ được Áp dụng
      AppShared.setListAddress([json.encode(widget.address)]); // lưu vào
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
        setState(() {
          isDefault = 1;
        });
        List<Address> listAddress = await createAddressViewModel.updateDeliveryAddress(
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

  void handleButtonDelete() async {
    List<Address> listAddress = await createAddressViewModel.deleteDeliveryAddress(
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
  Widget buildDesktop(BuildContext context) {
    // TODO: implement buildDesktop
    return buildScreen();
  }

  @override
  Widget buildMobile(BuildContext context) {
    // TODO: implement buildMobile
    return buildScreen();
  }

  @override
  Widget buildTablet(BuildContext context) {
    // TODO: implement buildTablet
    return buildScreen();
  }
}
