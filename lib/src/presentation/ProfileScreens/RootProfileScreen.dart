// Ảnh 41 - Profile chính
import 'package:flutter/material.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/LoginScreens/LoginScreen.dart';
import 'package:badges/badges.dart';
import 'package:projectui/src/presentation/ProfileScreens/Address/Addresss.dart';
import 'package:projectui/src/presentation/ProfileScreens/ChangePassword/ChangePassword_screen.dart';
import 'package:projectui/src/presentation/ProfileScreens/Commitment/KingbuyCommitment_screen.dart';
import 'package:projectui/src/presentation/ProfileScreens/Coupon/MyCoupon_screen.dart';
import 'package:projectui/src/presentation/ProfileScreens/Order/OrderHistory_screen.dart';
import 'package:projectui/src/presentation/ProfileScreens/DetailProfile/DetailProfile_screen.dart';
import 'package:projectui/src/presentation/ProfileScreens/ViewedProducts/ViewedProducts_screen.dart';
import 'package:projectui/src/presentation/ProfileScreens/TermOfUse/TermOfUse_screen.dart';
import 'package:projectui/src/resource/model/Data.dart';
import 'package:projectui/src/resource/model/NotificationModel.dart';
import 'package:projectui/src/resource/model/network_state.dart';
import 'package:projectui/src/resource/repo/auth_repository.dart';
import 'package:projectui/src/utils/app_shared.dart';
import 'package:projectui/src/utils/app_utils.dart';
import 'package:provider/provider.dart';
import '../presentation.dart';
import 'Contact/Contact_screen.dart';
import 'Promotion/Promotion_screen.dart';

List<Map<String, dynamic>> items = [
  {"id": 1, "icon": "person.png", "content": "Thông tin cá nhân", "badgeContent": null},
  {"id": 2, "icon": "promotion.png", "content": "Khuyến mãi", "badgeContent": "4"},
  {"id": 3, "icon": "bike.png", "content": "Địa chỉ giao hàng", "badgeContent": null},
  {"id": 4, "icon": "star.png", "content": "Coupon của tôi", "badgeContent": null},
  {"id": 5, "icon": "history.png", "content": "Lịch sử đặt hàng", "badgeContent": null},
  {"id": 6, "icon": "eye.png", "content": "Sản phẩm đã xem", "badgeContent": null},
  {"id": 7, "icon": "lock.png", "content": "Đổi mật khẩu", "badgeContent": null},
  {"id": 8, "icon": "group.png", "content": "Cam kết của Kingbuy", "badgeContent": null},
  {"id": 9, "icon": "phone.png", "content": "Liên hệ", "badgeContent": null},
  {"id": 10, "icon": "policy.png", "content": "Điều khoản sử dụng", "badgeContent": null},
];

class RootProfileScreen extends StatefulWidget {
  @override
  RootProfileScreenState createState() => RootProfileScreenState();
}

class RootProfileScreenState extends State<RootProfileScreen> {
  @override
  Widget build(BuildContext context) {
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
                        ? NetworkImage("${AppEndpoint.BASE_URL}${userData.profile.avatarSource}")
                        : AssetImage("assets/user@2x.png"),
                    backgroundColor: Colors.white,
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: userData != null
                          ? Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(color: Colors.red.shade700, borderRadius: BorderRadius.all(Radius.circular(12))),
                              child: Center(
                                child: Icon(
                                  Icons.edit_rounded,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : Container())
                ],
              ),
              onTap: userData.profile != null
                  ? () {
                      print("Click avatar");
                    }
                  : null),
          SizedBox(
            height: 15,
          ),
          Text(userData.profile != null ? userData.profile.name : "Guest",
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
          userData.profile != null
              ? Text(userData.profile.phoneNumber, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400))
              : Container(),
          userData.rewardPoints != null
              ? Text("${userData.rewardPoints} điểm",
                  style: TextStyle(fontSize: 21, color: Colors.red.shade700, fontWeight: FontWeight.bold))
              : Container()
        ],
      ),
    );
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
                                badgeColor: Colors.red.shade600,
                                position: BadgePosition.topEnd(top: -11, end: -11),
                                child: Container(
                                  height: 24,
                                  width: 24,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12))),
                                  child: Image.asset("assets/" + "${items[index]["icon"]}"),
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
              style: TextStyle(fontSize: 17, color: Colors.red.shade700, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              handleLogout(userData);
            },
          ),
        ));
  }

  onSelectItem(int id) async {
    switch (id) {
      case 1:
        if (await AppUtils.checkLogin()) {
          await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailProfile(),
              ));
        } else {
          AppUtils.myShowDialog(context, -1, "");
        }
        break;
      case 2:
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Promotion(),
            ));
        break;
      case 3:
        if (await AppUtils.checkLogin()) {
          await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddressScreen(),
              ));
        } else {
          AppUtils.myShowDialog(context, -1, "");
        }
        break;
      case 4:
        if (await AppUtils.checkLogin()) {
          await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyCoupon(),
              ));
        } else {
          AppUtils.myShowDialog(context, -1, "");
        }
        break;
      case 5:
        if (await AppUtils.checkLogin()) {
          await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderHistory(),
              ));
        } else {
          AppUtils.myShowDialog(context, -1, "");
        }
        break;
      case 6:
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewedProducts(),
            ));
        break;
      case 7:
        if (await AppUtils.checkLogin()) {
          await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChangePassword(),
              ));
        } else {
          AppUtils.myShowDialog(context, -1, "");
        }
        break;
      case 8:
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => KingbuyCommitment(),
            ));
        break;
      case 9:
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Contact(),
            ));
        break;
      case 10:
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TermsOfUse(),
            ));
        break;
    }
  }

  handleLogout(Data userData) async {
    if (userData.profile != null) {
      final authRepository = AuthRepository();
      NetworkState<int> response = await authRepository.sendRequestLogout();
      if (response.data == 1) {
        // Xóa dữ liệu user và accessToken khi đăng xuất
        Provider.of<Data>(context, listen: false).setData(null, null, null, null);
        await AppShared.setAccessToken(null);

        // Xóa dữ liệu Notification khi đăng xuất
        Provider.of<NotificationModel>(context, listen: false).setCountNotification(null);
        await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyBottomNavigationBar(),
            ));
      }
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }
}
