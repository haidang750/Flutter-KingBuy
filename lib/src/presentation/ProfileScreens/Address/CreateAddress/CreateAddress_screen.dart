import 'package:flutter/material.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/presentation.dart';
import 'package:projectui/src/resource/model/AddressModel.dart';
import 'package:projectui/src/resource/model/DistrictModel.dart';
import 'package:projectui/src/resource/model/ProvinceModel.dart';
import 'package:projectui/src/resource/model/WardModel.dart';
import '../../../widgets/BorderTextField.dart';

class CreateAddress extends StatefulWidget {
  CreateAddress({this.address, this.event});

  Address address;
  String event;

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
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: createAddressViewModel,
        builder: (context, viewModel, child) => Scaffold(
              appBar: AppBar(
                titleSpacing: 0,
                title: Text(widget.event == "create" ? "Thêm mới địa chỉ" : "Chi tiết địa chỉ"),
              ),
              body: buildUi(context: context)
            ));
  }

  Widget buildScreen(){
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
              height: isExportInvoice ? 330 : 65,
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
            borderColor: AppColors.borderTextField,
            borderRadius: 8,
            textController: fullNameController,
            fontSize: 16,
            hintText: "Họ và tên",
            hintTextFontSize: 15,
            hintTextFontWeight: FontWeight.w400,
          ),
          BorderTextField(
            borderColor: AppColors.borderTextField,
            borderRadius: 8,
            textController: firstPhoneController,
            fontSize: 16,
            keyboardType: TextInputType.phone,
            hintText: "Số điện thoại",
            hintTextFontSize: 15,
            hintTextFontWeight: FontWeight.w400,
          ),
          BorderTextField(
            borderColor: AppColors.borderTextField,
            borderRadius: 8,
            textController: secondPhoneController,
            fontSize: 16,
            keyboardType: TextInputType.phone,
            hintText: "Số điện thoại 2 (nếu có)",
            hintTextFontSize: 15,
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
            borderColor: AppColors.borderTextField,
            borderRadius: 8,
            textController: addressController,
            fontSize: 16,
            hintText: "Địa chỉ cụ thể (số nhà, tên tòa nhà)",
            hintTextFontSize: 15,
            hintTextFontWeight: FontWeight.w400,
          ),
        ],
      ),
    );
  }

  Widget buildProvinceField() {
    return Container(
        height: 50,
        width: MediaQuery.of(context).size.width * 0.45,
        padding: EdgeInsets.only(left: 10, right: 5),
        decoration:
            BoxDecoration(border: Border.all(width: 1, color: Colors.grey.shade500), borderRadius: BorderRadius.all(Radius.circular(8))),
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
        decoration:
            BoxDecoration(border: Border.all(width: 1, color: Colors.grey.shade500), borderRadius: BorderRadius.all(Radius.circular(8))),
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
        decoration:
            BoxDecoration(border: Border.all(width: 1, color: Colors.grey.shade500), borderRadius: BorderRadius.all(Radius.circular(8))),
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
                print("Value checkbox: $value");
                setState(() {
                  isExportInvoice = !isExportInvoice;
                  taxCodeController.clear();
                  companyNameController.clear();
                  companyAddressController.clear();
                  companyEmailController.clear();
                });
              },
            ),
            Text(
              "YÊU CẦU XUẤT HÓA ĐƠN VAT",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            )
          ],
        ));
  }

  Widget buildVATInfo() {
    return Container(
      height: 270,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          BorderTextField(
            borderColor: AppColors.borderTextField,
            borderRadius: 8,
            textController: taxCodeController,
            fontSize: 16,
            hintText: "Mã số thuế",
            hintTextFontSize: 15,
            hintTextFontWeight: FontWeight.w400,
          ),
          BorderTextField(
            borderColor: AppColors.borderTextField,
            borderRadius: 8,
            textController: companyNameController,
            fontSize: 16,
            hintText: "Tên công ty",
            hintTextFontSize: 15,
            hintTextFontWeight: FontWeight.w400,
          ),
          BorderTextField(
            borderColor: AppColors.borderTextField,
            borderRadius: 8,
            textController: companyAddressController,
            fontSize: 16,
            hintText: "Địa chỉ công ty",
            hintTextFontSize: 15,
            hintTextFontWeight: FontWeight.w400,
          ),
          BorderTextField(
            borderColor: AppColors.borderTextField,
            borderRadius: 8,
            textController: companyEmailController,
            fontSize: 16,
            hintText: "Email",
            hintTextFontSize: 15,
            hintTextFontWeight: FontWeight.w400,
          ),
        ],
      ),
    );
  }

  Widget buildButton(Alignment alignment, double buttonHeight, double buttonWidth, Color buttonColor, double buttonBorderRadius,
      String buttonContent, Color buttonContentColor, double buttonContentSize, FontWeight buttonContentFontWeight, Function buttonAction) {
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
        child: buildButton(
            Alignment.centerRight, 60, 100, Colors.blue, 30, "Thêm mới", Colors.white, 16, FontWeight.w500, handleButtonCreate));
  }

  Widget buildUpdateButton() {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          buildButton(
              Alignment.centerRight, 60, 100, Colors.red.shade500, 30, "Xóa", Colors.white, 16, FontWeight.w500, handleButtonDelete),
          SizedBox(
            width: 10,
          ),
          buildButton(Alignment.centerRight, 60, 100, isDefault == 1 ? Colors.grey : Colors.blue, 30, "Áp dụng", Colors.white, 16,
              FontWeight.w500, handleButtonApplyDefault),
          SizedBox(
            width: 10,
          ),
          buildButton(Alignment.centerRight, 60, 100, Colors.blue, 30, "Lưu lại", Colors.white, 16, FontWeight.w500, handleButtonUpdate)
        ],
      ),
    );
  }

  void handleButtonCreate() async {
    bool result = await createAddressViewModel.createDeliveryAddress(
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
    if (result) {
      print("Thêm mới địa chỉ thành công");
      Navigator.pop(context);
    } else {
      print("Thêm mới địa chỉ không thành công");
    }
  }

  void handleButtonUpdate() async {
    bool result = await createAddressViewModel.updateDeliveryAddress(
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
    if (result) {
      print("Cập nhật địa chỉ thành công");
      Navigator.pop(context);
    } else {
      print("Cập nhật địa chỉ không thành công");
    }
  }

  void handleButtonApplyDefault() async {
    if (isDefault == 0) {
      setState(() {
        isDefault = 1;
      });
      bool result = await createAddressViewModel.updateDeliveryAddress(
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
      if (result) {
        print("Set địa chỉ mặc định thành công");
      } else {
        print("Set địa chỉ mặc định không thành công");
      }
    } else {
      return null;
    }
  }

  void handleButtonDelete() async {
    bool result = await createAddressViewModel.deleteDeliveryAddress(
      context,
      deliveryAddressId,
    );
    if (result) {
      print("Xóa địa chỉ thành công");
      Navigator.pop(context);
    } else {
      print("Xóa địa chỉ không thành công");
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
