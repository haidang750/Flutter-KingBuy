// Ảnh 41 - Profile chính
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:badges/badges.dart';
import 'package:projectui/src/presentation/profile_screens/address/list_address/list_address.dart';
import 'package:projectui/src/resource/model/data.dart';
import 'package:projectui/src/utils/app_utils.dart';
import 'package:provider/provider.dart';
import '../../presentation.dart';

List<Map<String, dynamic>> items = [
  {"id": 1, "icon": AppImages.icPerson, "content": "Thông tin cá nhân", "badgeContent": null},
  {"id": 2, "icon": AppImages.icPromotion, "content": "Khuyến mãi", "badgeContent": "4"},
  {"id": 3, "icon": AppImages.icBike, "content": "Địa chỉ giao hàng", "badgeContent": null},
  {"id": 4, "icon": AppImages.icTag, "content": "Coupon của tôi", "badgeContent": null},
  {"id": 5, "icon": AppImages.icHistory, "content": "Lịch sử đặt hàng", "badgeContent": null},
  {"id": 6, "icon": AppImages.icEye, "content": "Sản phẩm đã xem", "badgeContent": null},
  {"id": 7, "icon": AppImages.icLock, "content": "Đổi mật khẩu", "badgeContent": null},
  {"id": 8, "icon": AppImages.icGroup, "content": "Cam kết của Kingbuy", "badgeContent": null},
  {"id": 9, "icon": AppImages.icPhone, "content": "Liên hệ", "badgeContent": null},
  {"id": 10, "icon": AppImages.icPolicy, "content": "Điều khoản sử dụng", "badgeContent": null},
];

class RootProfileScreen extends StatefulWidget {
  @override
  RootProfileScreenState createState() => RootProfileScreenState();
}

class RootProfileScreenState extends State<RootProfileScreen> with ResponsiveWidget {
  final rootProfileViewModel = RootProfileViewModel();
  File image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return BaseWidget(mainScreen: true, viewModel: rootProfileViewModel, builder: (context, viewModel, child) => buildUi(context: context));
  }

  Widget buildScreen() {
    Data userData = Provider.of<Data>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [buildPersonalInfoContainer(userData), buildListOption(), buildPhoneAndAddress(), buildLoginAndLogout(userData)],
        ),
      ),
    );
  }

  Widget buildPersonalInfoContainer(Data userData) {
    return Container(
      height: userData.profile != null ? 240 : 180,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(padding: EdgeInsets.only(top: 40)),
          GestureDetector(
              // Tạo Badge bằng Stack và Positioned
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: userData.profile != null
                        ? (image == null ? NetworkImage("${AppEndpoint.BASE_URL}${userData.profile.avatarSource}") : FileImage(image))
                        : AssetImage(AppImages.icUser2),
                    backgroundColor: Colors.white,
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: userData != null
                          ? Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.all(Radius.circular(12))),
                              child: Center(
                                child: Icon(Icons.edit_rounded, size: 16, color: Colors.white),
                              ))
                          : Container())
                ],
              ),
              onTap: userData.profile != null
                  ? () {
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
                    }
                  : null),
          SizedBox(
            height: 15,
          ),
          Text(userData.profile != null ? userData.profile.name : "Guest", style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
          userData.profile != null ? Text(userData.profile.phoneNumber, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400)) : Container(),
          userData.rewardPoints != null
              ? Text("${userData.rewardPoints} điểm", style: TextStyle(fontSize: 21, color: AppColors.primary, fontWeight: FontWeight.bold))
              : Container()
        ],
      ),
    );
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

  Widget buildListOption() {
    return Container(
        height: 510,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Container(
                height: 50,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              child: Center(
                                  // Tạo Badge bằng package bagdes.dart có sẵn
                                  child: Badge(
                                showBadge: items[index]["badgeContent"] == null ? false : true,
                                badgeContent: Text("${items[index]["badgeContent"]}", style: TextStyle(color: Colors.white)),
                                badgeColor: AppColors.primary,
                                position: BadgePosition.topEnd(top: -11, end: -11),
                                child: Container(
                                  height: 24,
                                  width: 24,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12))),
                                  child: Image.asset(items[index]["icon"]),
                                ),
                              )),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "${items[index]["content"]}",
                              style: TextStyle(fontSize: 17),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 16,
                      )
                    ],
                  ),
                  onTap: () => {onSelectItem(items[index]["id"])},
                ));
          },
        ));
  }

  Widget buildPhoneAndAddress() {
    return Container(
      height: 70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Hotline: 1900.6810",
            style: TextStyle(fontSize: 20),
          ),
          Text(
            "2020 Kingbuy.Ver 1.07",
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget buildLoginAndLogout(Data userData) {
    return Container(
        height: 60,
        child: Center(
          child: GestureDetector(
            child: Text(
              userData.profile != null ? "Đăng xuất" : "Đăng nhập",
              style: TextStyle(fontSize: 17, color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              rootProfileViewModel.handleLogout(userData);
            },
          ),
        ));
  }

  onSelectItem(int id) async {
    switch (id) {
      case 1:
        if (await AppUtils.checkLogin()) {
          await Navigator.pushNamed(context, Routers.Detail_Profile);
        } else {
          AppUtils.myShowDialog(context, -1, "");
        }
        break;
      case 2:
        Navigator.pushNamed(context, Routers.List_Promotion);
        break;
      case 3:
        if (await AppUtils.checkLogin()) {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => ListAddress(enableSelect: false, isCallFromCart: false)));
        } else {
          AppUtils.myShowDialog(context, -1, "");
        }
        break;
      case 4:
        if (await AppUtils.checkLogin()) {
          await Navigator.pushNamed(context, Routers.List_Coupons);
        } else {
          AppUtils.myShowDialog(context, -1, "");
        }
        break;
      case 5:
        if (await AppUtils.checkLogin()) {
          await Navigator.pushNamed(context, Routers.Order_History);
        } else {
          AppUtils.myShowDialog(context, -1, "");
        }
        break;
      case 6:
        Navigator.pushNamed(context, Routers.Viewed_Products);
        break;
      case 7:
        if (await AppUtils.checkLogin()) {
          await Navigator.pushNamed(context, Routers.Change_Password);
        } else {
          AppUtils.myShowDialog(context, -1, "");
        }
        break;
      case 8:
        Navigator.pushNamed(context, Routers.Commitment);
        break;
      case 9:
        Navigator.pushNamed(context, Routers.Contact_Types);
        break;
      case 10:
        Navigator.pushNamed(context, Routers.Term_Of_Use);
        break;
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
