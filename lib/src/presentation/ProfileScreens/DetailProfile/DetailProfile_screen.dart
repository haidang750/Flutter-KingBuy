// Ảnh 42 - Thông tin cá nhân
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/ProfileScreens/DetailProfile/DetailProfile.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/resource/model/Data.dart';
import 'package:projectui/src/resource/model/network_state.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_picker/flutter_picker.dart';

class DetailProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DetailProfileState();
  }
}

class DetailProfileState extends State<DetailProfile> with ResponsiveWidget {
  final detailProfileViewModel = DetailProfileViewModel();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final birthdayController = TextEditingController();
  final emailController = TextEditingController();
  File image;
  final picker = ImagePicker();
  String avatarSource = "";
  String radioValue = "";

  // dùng initState để khởi tạo giá trị ban đầu cho các ô TextField (khác với hintText)
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Data userData = Provider.of<Data>(context, listen: false);
      nameController.text = userData.profile.name;
      phoneController.text = userData.profile.phoneNumber;
      birthdayController.text = DateFormat("yyyy-MM-dd").format(userData.profile.dateOfBirth);
      emailController.text = userData.profile.email;
      setState(() {
        radioValue = userData.profile.gender == 1 ? "Nam" : "Nữ";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Data userData = Provider.of<Data>(context);
    avatarSource = userData.profile.avatarSource;

    return BaseWidget(
        viewModel: detailProfileViewModel,
        builder: (context, viewModel, child) => Scaffold(
            appBar: AppBar(
              titleSpacing: 0,
              title: Text("Thông tin cá nhân"),
              actions: [
                Builder(
                  builder: (context) => Padding(
                    padding: EdgeInsets.only(right: 20, top: 16, bottom: 8),
                    child: ButtonTheme(
                        minWidth: 66,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        disabledColor: Colors.grey.shade500,
                        buttonColor: AppColors.primary,
                        child: RaisedButton(
                            child: Text("LƯU",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                )),
                            onPressed: () => updateProfile(context, nameController.text, phoneController.text, birthdayController.text,
                                radioValue == "Nam" ? 1 : 0, emailController.text, image != null ? image.path : null))),
                  ),
                )
              ],
            ),
            body: buildUi(context: context)));
  }

  Widget buildScreen() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Container(
        alignment: Alignment.center,
        child: ListView(
          children: [
            buildAvatar(),
            Container(
                height: 320,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTitle("Họ và tên"),
                      buildTextInput(nameController),
                      SizedBox(
                        height: 15,
                      ),
                      buildTitle("Số điện thoại"),
                      buildTextInput(phoneController),
                      SizedBox(
                        height: 15,
                      ),
                      buildTitle("Ngày tháng năm sinh"),
                      TextField(
                        controller: birthdayController,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                        ),
                        readOnly: true,
                        onTap: () {
                          showPickerDate(context);
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      buildTitle("Email"),
                      buildTextInput(emailController),
                    ],
                  ),
                )),
            Container(
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: buildTitle("Giới tính"),
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        children: [
                          Radio(
                              value: "Nam",
                              groupValue: radioValue,
                              onChanged: (value) {
                                setState(() {
                                  radioValue = value;
                                });
                              }),
                          GestureDetector(
                              child: Text("Nam",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  )),
                              onTap: () {
                                setState(() {
                                  radioValue = "Nam";
                                });
                              }),
                          Radio(
                              value: "Nữ",
                              groupValue: radioValue,
                              onChanged: (value) {
                                setState(() {
                                  radioValue = value;
                                });
                              }),
                          GestureDetector(
                              child: Text("Nữ",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  )),
                              onTap: () {
                                setState(() {
                                  radioValue = "Nữ";
                                });
                              }),
                        ],
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildAvatar() {
    return Container(
        height: 160,
        child: Center(
          child: GestureDetector(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: image == null ? NetworkImage("${AppEndpoint.BASE_URL}$avatarSource") : FileImage(image),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: Center(
                        child: Icon(
                          Icons.edit_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              onTap: () {
                getImage();
              }),
        ));
  }

  Widget buildTitle(String title) {
    return Text(title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ));
  }

  Widget buildTextInput(TextEditingController textController) {
    return TextField(
      controller: textController,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
      ),
    );
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  showPickerDate(BuildContext context) {
    Picker(
        hideHeader: true,
        adapter: DateTimePickerAdapter(isNumberMonth: false, yearBegin: 1930, yearEnd: 2100, customColumnType: [1, 2, 0]),
        title: Text("Chọn ngày sinh"),
        cancelText: "Hủy bỏ",
        confirmText: "Xác nhận",
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          birthdayController.text = DateFormat("yyyy-MM-dd").format((picker.adapter as DateTimePickerAdapter).value);
        }).showDialog(context);
  }

  updateProfile(
    BuildContext context,
    String name,
    String phoneNumber,
    String dateOfBirth,
    int gender,
    String email,
    String avatarPath,
  ) async {
    NetworkState<Data> result = await detailProfileViewModel.updateProfile(name, phoneNumber, dateOfBirth, gender, email, avatarPath);

    if (result.isSuccess) {
      print("Cập nhật thông tin thành công");
      // Sau khi update profile thành công thì set lại profile trong Data
      Provider.of<Data>(context, listen: false).setProfile(result.data.profile);
      Scaffold.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 2),
          backgroundColor: Colors.blue,
          content: Text(
            "Cập nhật thông tin thành công",
            style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          )));
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 2),
          backgroundColor: Colors.blue,
          content: Text("Cập nhật thông tin thất bại",
              style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500), textAlign: TextAlign.center)));
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
