import 'package:flutter/material.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/CategoriesScreens/RootCategories/RootCategories_screen.dart';
import 'package:projectui/src/presentation/HomeSreens/Home/Home_screen.dart';
import 'package:projectui/src/presentation/MemberCard/MemberCard.dart';
import 'package:projectui/src/presentation/Navigation/Navigation.dart';
import 'package:projectui/src/presentation/Notifications/Notifications_screen.dart';
import 'package:projectui/src/presentation/ProfileScreens/RootProfile/RootProfile_screen.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/resource/model/model.dart';
import 'package:provider/provider.dart';

class MainTabControlDelegate {
  int index;
  Function(int index) tabJumpTo;

  static MainTabControlDelegate _instance;

  static MainTabControlDelegate getInstance() {
    return _instance ??= MainTabControlDelegate._();
  }

  MainTabControlDelegate._();
}

class NavigationScreen extends StatefulWidget {
  @override
  NavigationScreenState createState() {
    return NavigationScreenState();
  }
}

class NavigationScreenState extends State<NavigationScreen> with WidgetsBindingObserver, ResponsiveWidget {
  final navigationViewModel = NavigationViewModel();
  int currentIndex = 0;
  final controller = PageController(
    initialPage: 0, // HomeScreen
  );

  @override
  void initState() {
    super.initState();
    MainTabControlDelegate.getInstance().tabJumpTo = (int index) {
      controller?.jumpToPage(index);
    };
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(viewModel: navigationViewModel, builder: (context, viewModel, child) => Scaffold(body: buildUi(context: context)));
  }

  Widget buildScreen() {
    int countNotification = Provider.of<NotificationModel>(context).countNotification;

    return Column(
      children: [
        Expanded(
            child: PageView(
          controller: controller,
          scrollDirection: Axis.horizontal,
          // hướng swipe
          physics: NeverScrollableScrollPhysics(),
          // Chỉ số Page sẽ bắt đầu từ 0
          children: [
            HomeScreen(), // 0
            RootCategoriesScreen(), // 1
            Notifications(), // 2
            RootProfileScreen() // 3
          ],
          // thay đổi UI bottom khi lướt
          onPageChanged: (value) {
            setState(() {
              currentIndex = value;
            });
          },
        )),
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.bottomBarShadow,
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildBottomItem(0, null),
              buildBottomItem(1, null),
              // Payment Button (middle of BottomNavigationBar)
              GestureDetector(
                child: Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.all(Radius.circular(28))),
                  child: Center(
                    child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: AppColors.primary,
                            border: Border.all(width: 2, color: AppColors.white),
                            borderRadius: BorderRadius.all(Radius.circular(25))),
                        child: Icon(
                          Icons.payment_outlined,
                          size: 22,
                          color: AppColors.white,
                        )),
                  ),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MemberCardScreen()));
                },
              ),
              buildBottomItem(2, countNotification),
              buildBottomItem(3, null)
            ],
          ),
        )
      ],
    );
  }

  buildBottomItem(int index, int countNotification) {
    String image;
    String name;
    int count = countNotification;

    switch (index) {
      case 0:
        image = AppImages.icHome;
        name = "Trang chủ";
        break;
      case 1:
        image = AppImages.icMenu;
        name = "Danh mục";
        break;
      case 2:
        image = AppImages.icAlarm;
        name = "Thông báo";
        break;
      case 3:
        image = AppImages.icUser;
        name = "Tài khoản";
        break;
    }

    return GestureDetector(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 12),
            ),
            buildOneItem(image, name, index, count)
          ],
        ),
        // thay đổi Page khi click item bottom
        onTap: () {
          setState(() {
            currentIndex = index;
          });
          controller.jumpToPage(currentIndex);
        });
  }

  Widget buildOneItem(String image, String name, int index, int countNotification) {
    return Column(
      children: [
        Stack(
          children: [
            // build Icon
            Container(
              height: 24,
              width: 40,
              child: Image.asset(
                image,
                color: index == currentIndex ? AppColors.enableButton : AppColors.disableButton,
              ),
            ),
            // build Badge
            index == 2 ? buildNotificationItem(countNotification) : Container()
          ],
        ),
        // build Title
        Text(name,
            style: TextStyle(
                fontSize: 14,
                color: index == currentIndex ? AppColors.enableButton : AppColors.disableButton,
                fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget buildNotificationItem(int countNotification) {
    return countNotification != null
        ? Positioned(
            top: 0,
            right: 2,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(color: AppColors.enableButton, borderRadius: BorderRadius.all(Radius.circular(8))),
              child: Center(
                  child: Text(
                countNotification.toString(),
                style: TextStyle(color: AppColors.white),
              )),
            ),
          )
        : Container();
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
