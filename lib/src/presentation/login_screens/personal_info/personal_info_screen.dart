import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/login_screens/login_screens.dart';
import 'package:projectui/src/presentation/base/base.dart';

class PersonalInfo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PersonalInfoState();
  }
}

class PersonalInfoState extends State<PersonalInfo> with ResponsiveWidget {
  final personalInfoViewModel = PersonalInfoViewModel();
  String radioValue = "";
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final birthdayController = TextEditingController();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: personalInfoViewModel,
        builder: (context, viewModel, child) => Scaffold(
            appBar: AppBar(
              title: Text("Thông tin cá nhân"),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 10, top: 14, bottom: 10),
                  child: ButtonTheme(
                      minWidth: 66,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      disabledColor: AppColors.disableButton,
                      buttonColor: AppColors.enableButton,
                      child: RaisedButton(
                        child: Text("LƯU",
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.buttonContent,
                            )),
                        onPressed: () {},
                      )),
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
            height: 270,
            child: Column(
              children: [
                buildTextInput(AppImages.icUser, 20, 16, nameController, "Họ và tên"),
                Padding(padding: EdgeInsets.only(top: 10)),
                buildTextInput(AppImages.icPhone, 20, 20, phoneController, "Số điện thoại"),
                Padding(padding: EdgeInsets.only(top: 10)),
                buildTextInput(AppImages.icCalendar, 20, 20, birthdayController, "Ngày tháng năm sinh"),
                Padding(padding: EdgeInsets.only(top: 10)),
                buildTextInput(AppImages.icEnvelope, 18, 24, emailController, "Email")
              ],
            ),
          ),
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
                  child: Text(
                    "Giới tính",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                  ),
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
                            child: Text("Nam", style: TextStyle(fontSize: 17)),
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
                            child: Text("Nữ", style: TextStyle(fontSize: 17)),
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
    );
  }

  Widget buildAvatar() {
    return Container(
        height: 160,
        child: Center(
            child: GestureDetector(
                child: Container(
                    height: 100,
                    width: 100,
                    child: Badge(
                      badgeContent: Icon(
                        Icons.edit_rounded,
                        color: AppColors.buttonContent,
                        size: 16,
                      ),
                      badgeColor: AppColors.primary,
                      position: BadgePosition.bottomEnd(bottom: 0, end: 0),
                      child: Image.asset(
                        AppImages.icUser2,
                        fit: BoxFit.cover,
                      ),
                    )),
                onTap: () {
                  print("Handle Change Avatar");
                })));
  }

  Widget buildTextInput(String iconImage, double iconHeight, double iconWidth, TextEditingController textController, String hintText) {
    return Container(
        height: 56,
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Container(
          decoration: BoxDecoration(border: Border.all(width: 0.5), borderRadius: BorderRadius.all(Radius.circular(28))),
          child: Row(
            children: [
              Container(
                  width: 60,
                  child: Center(
                      child: Container(
                          height: iconHeight,
                          width: iconWidth,
                          child: Image.asset(
                            iconImage,
                            fit: BoxFit.cover,
                          )))),
              Expanded(
                child: Container(
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(border: InputBorder.none, hintText: hintText),
                  ),
                ),
              )
            ],
          ),
        ));
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
