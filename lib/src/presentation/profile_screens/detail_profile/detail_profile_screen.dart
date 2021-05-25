// Ảnh 42 - Thông tin cá nhân
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/profile_screens/detail_profile/detail_profile.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/resource/model/data.dart';
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
  DetailProfileViewModel detailProfileViewModel;
  String avatarSource = "";
  File image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    Data userData = Provider.of<Data>(context);
    avatarSource = userData.profile.avatarSource;

    return BaseWidget(
        viewModel: DetailProfileViewModel(),
        onViewModelReady: (viewModel) {
          detailProfileViewModel = viewModel..init(context);
        },
        builder: (context, viewModel, child) => Scaffold(
            appBar: AppBar(
              titleSpacing: 0,
              title: Text("Thông tin cá nhân"),
              actions: [
                Builder(
                  builder: (context) => Padding(
                    padding: EdgeInsets.only(right: 10, top: 14, bottom: 10),
                    child: ButtonTheme(
                        minWidth: 66,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        disabledColor: Colors.grey.shade500,
                        buttonColor: AppColors.primary,
                        child: RaisedButton(
                            child: Text("LƯU",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                )),
                            onPressed: () => detailProfileViewModel.updateProfile(
                                detailProfileViewModel.nameController.text,
                                detailProfileViewModel.phoneController.text,
                                detailProfileViewModel.birthdayController.text,
                                detailProfileViewModel.radioValue == "Nam" ? 1 : 0,
                                detailProfileViewModel.emailController.text,
                                detailProfileViewModel.image != null ? viewModel.image.path : null))),
                  ),
                )
              ],
            ),
            body: buildUi(context: context)));
  }

  Widget buildScreen() {
    return Container(
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
                    buildTextInput(detailProfileViewModel.nameController),
                    SizedBox(
                      height: 15,
                    ),
                    buildTitle("Số điện thoại"),
                    buildTextInput(detailProfileViewModel.phoneController),
                    SizedBox(
                      height: 15,
                    ),
                    buildTitle("Ngày tháng năm sinh"),
                    TextField(
                      controller: detailProfileViewModel.birthdayController,
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
                    buildTextInput(detailProfileViewModel.emailController),
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
                            groupValue: detailProfileViewModel.radioValue,
                            onChanged: (value) {
                              setState(() {
                                detailProfileViewModel.radioValue = value;
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
                                detailProfileViewModel.radioValue = "Nam";
                              });
                            }),
                        Radio(
                            value: "Nữ",
                            groupValue: detailProfileViewModel.radioValue,
                            onChanged: (value) {
                              setState(() {
                                detailProfileViewModel.radioValue = value;
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
                                detailProfileViewModel.radioValue = "Nữ";
                              });
                            }),
                      ],
                    ))
              ],
            ),
          )
        ],
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
                    backgroundImage: image == null
                        ? ((avatarSource != null && avatarSource != "")
                            ? NetworkImage("${AppEndpoint.BASE_URL}$avatarSource")
                            : AssetImage(AppImages.icUser2))
                        : FileImage(image),
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
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext bc) {
                      return SafeArea(
                        child: Container(
                          child: Wrap(
                            children: <Widget>[
                              ListTile(
                                  leading: Icon(Icons.photo_library),
                                  title: Text('Photo Library'),
                                  onTap: () {
                                    getImageFromGallery();
                                    Navigator.of(context).pop();
                                  }),
                              ListTile(
                                leading: Icon(Icons.photo_camera),
                                title: Text('Camera'),
                                onTap: () {
                                  getImageFromCamera();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              }),
        ));
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
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

  showPickerDate(BuildContext context) {
    Picker(
        hideHeader: true,
        adapter: DateTimePickerAdapter(isNumberMonth: false, yearBegin: 1930, yearEnd: 2100, customColumnType: [1, 2, 0]),
        title: Text("Chọn ngày sinh"),
        cancelText: "Hủy bỏ",
        confirmText: "Xác nhận",
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          detailProfileViewModel.birthdayController.text = DateFormat("yyyy-MM-dd").format((picker.adapter as DateTimePickerAdapter).value);
        }).showDialog(context);
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
