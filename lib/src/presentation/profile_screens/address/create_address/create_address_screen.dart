import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/presentation.dart';
import 'package:projectui/src/resource/model/address_model.dart';
import 'package:projectui/src/resource/model/cart_model.dart';
import 'package:projectui/src/resource/model/district_model.dart';
import 'package:projectui/src/resource/model/province_model.dart';
import 'package:projectui/src/resource/model/ward_model.dart';
import 'package:projectui/src/utils/app_shared.dart';
import 'package:rxdart/rxdart.dart';
import 'package:toast/toast.dart';
import '../../../widgets/border_text_field.dart';

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
  CreateAddressViewModel createAddressViewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: CreateAddressViewModel(),
        onViewModelReady: (viewModel) => createAddressViewModel = viewModel..init(widget.event, widget.address),
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
    return ListView(
      children: [
        buildRequiredInfo(),
        Container(
          height: 10,
          color: Colors.grey.shade300,
        ),
        Container(
            height: createAddressViewModel.isExportInvoice ? 310 : 65,
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              children: [buildCheckVAT(), createAddressViewModel.isExportInvoice ? buildVATInfo() : Container()],
            )),
        widget.event == "create" ? buildCreateButton() : buildUpdateButton(),
        Container(
          height: 20,
        )
      ],
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
            textController: createAddressViewModel.fullNameController,
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
            textController: createAddressViewModel.firstPhoneController,
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
            textController: createAddressViewModel.secondPhoneController,
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
            textController: createAddressViewModel.addressController,
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
                value: createAddressViewModel.provinceDropdownValue == "" ? null : createAddressViewModel.provinceDropdownValue,
                hint: Text(
                  "Tỉnh/Thành phố",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                ),
                icon: Icon(Icons.keyboard_arrow_down),
                onChanged: (provinceCode) {
                  setState(() {
                    createAddressViewModel.provinceDropdownValue = provinceCode;
                    createAddressViewModel.districtDropdownValue = "";
                    createAddressViewModel.wardDropdownValue = "";
                  });
                  createAddressViewModel.onSelectProvince(provinceCode);
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
                value: createAddressViewModel.districtDropdownValue == "" ? null : createAddressViewModel.districtDropdownValue,
                hint: Text(
                  "Quận/Huyện",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                ),
                icon: Icon(Icons.keyboard_arrow_down),
                onChanged: (districtCode) async {
                  setState(() {
                    createAddressViewModel.districtDropdownValue = districtCode;
                    createAddressViewModel.wardDropdownValue = "";
                  });
                  createAddressViewModel.onSelectDistrict(districtCode);
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
                value: createAddressViewModel.wardDropdownValue == "" ? null : createAddressViewModel.wardDropdownValue,
                hint: Text(
                  "Phường/Xã",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                ),
                icon: Icon(Icons.keyboard_arrow_down),
                onChanged: (wardCode) {
                  setState(() {
                    createAddressViewModel.wardDropdownValue = wardCode;
                  });
                  createAddressViewModel.onSelectWard(wardCode);
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
              value: createAddressViewModel.isExportInvoice,
              activeColor: AppColors.primary,
              onChanged: (value) {
                setState(() {
                  createAddressViewModel.onSelectExportVAT();
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
                  createAddressViewModel.onSelectExportVAT();
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
          textController: createAddressViewModel.taxCodeController,
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
          textController: createAddressViewModel.companyNameController,
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
          textController: createAddressViewModel.companyAddressController,
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
          textController: createAddressViewModel.companyEmailController,
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
        child: buildButton(Alignment.centerRight, 60, 100, Colors.blue, 30, "Thêm mới", Colors.white, 16, FontWeight.w500,
            createAddressViewModel.handleButtonCreate));
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
                    : buildButton(Alignment.centerRight, 60, 100, Colors.blue, 30, "Lưu lại", Colors.white, 16, FontWeight.w500,
                        () => createAddressViewModel.handleButtonUpdate(widget.isCallFromCart, widget.address)),
                widget.listAddress.length > 1 ? Container() : SizedBox(width: 10),
                buildButton(Alignment.centerRight, 60, 100, Colors.blue, 30, "Áp dụng", Colors.white, 16, FontWeight.w500, () {
                  createAddressViewModel.handleButtonApplyDefault(widget.isCallFromCart, widget.address);
                  setState(() {});
                }),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                buildButton(Alignment.centerRight, 60, 100, Colors.red.shade500, 30, "Xóa", Colors.white, 16, FontWeight.w500,
                    createAddressViewModel.handleButtonDelete),
                SizedBox(width: 10),
                buildButton(Alignment.centerRight, 60, 100, createAddressViewModel.isDefault == 1 ? Colors.grey : Colors.blue, 30, "Áp dụng",
                    Colors.white, 16, FontWeight.w500, () {
                  createAddressViewModel.handleButtonApplyDefault(widget.isCallFromCart, widget.address);
                  setState(() {});
                }),
                SizedBox(width: 10),
                buildButton(Alignment.centerRight, 60, 100, Colors.blue, 30, "Lưu lại", Colors.white, 16, FontWeight.w500,
                    () => createAddressViewModel.handleButtonUpdate(widget.isCallFromCart, widget.address))
              ],
            ),
    );
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
