import 'package:flutter/material.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/categories_screens/root_categories/root_categories_screen.dart';
import 'package:projectui/src/presentation/home_screens/home/home_screen.dart';
import 'package:projectui/src/presentation/member_card/member_card.dart';
import 'package:projectui/src/presentation/navigation/navigation.dart';
import 'package:projectui/src/presentation/notifications/notifications_screen.dart';
import 'package:projectui/src/presentation/profile_screens/root_profile/root_profile_screen.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/presentation/presentation.dart';
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
  Widget build(BuildContext context) {
    return BaseWidget(
        showPhone: false, viewModel: navigationViewModel, builder: (context, viewModel, child) => Scaffold(body: buildUi(context: context)));
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
                  MemberCardScreen(), // 2
                  Notifications(), // 3
                  RootProfileScreen() // 4
                ],
                // thay đổi UI bottom khi lướt
                onPageChanged: (value) {
                  setState(() {
                    currentIndex = value;
                  });
                })),
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
              buildBottomItem(2, null),
              buildBottomItem(3, countNotification),
              buildBottomItem(4, null)
            ],
          ),
        )
      ],
    );
  }

  Widget buildBottomItem(int index, int countNotification) {
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
        image = null;
        name = null;
        break;
      case 3:
        image = AppImages.icAlarm;
        name = "Thông báo";
        break;
      case 4:
        image = AppImages.icUser;
        name = "Tài khoản";
        break;
    }

    return GestureDetector(
        child: Column(
          children: [
            index != 2
                ? Padding(
                    padding: EdgeInsets.only(top: 12),
                  )
                : Container(),
            index != 2 ? buildOneItem(image, name, index, count) : buildButtonMemberCard()
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
            index == 3 ? buildNotificationItem(countNotification) : Container()
          ],
        ),
        // build Title
        Text(name,
            style: TextStyle(
                fontSize: 14, color: index == currentIndex ? AppColors.enableButton : AppColors.disableButton, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget buildButtonMemberCard() {
    return Container(
      height: 56,
      width: 56,
      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.all(Radius.circular(28))),
      child: Center(
        child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                color: AppColors.primary, border: Border.all(width: 2, color: AppColors.white), borderRadius: BorderRadius.all(Radius.circular(25))),
            child: Icon(
              Icons.payment_outlined,
              size: 22,
              color: AppColors.white,
            )),
      ),
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
