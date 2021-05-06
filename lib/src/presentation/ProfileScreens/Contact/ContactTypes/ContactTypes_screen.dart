// Ảnh 48 - Liên hệ
import 'package:flutter/material.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/ProfileScreens/Contact/ContactTypes/ContactTypes_viewmodel.dart';
import 'package:projectui/src/presentation/ProfileScreens/Contact/DetailContact/DetailContact_screen.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/presentation/presentation.dart';
import 'package:projectui/src/presentation/widgets/MyLoading.dart';
import 'package:projectui/src/utils/utils.dart';
import '../CreateContact/CreateContact_screen.dart';

class ContactTypes extends StatefulWidget {
  @override
  ContactTypesState createState() => ContactTypesState();
}

class ContactTypesState extends State<ContactTypes> with ResponsiveWidget {
  final contactTypesViewModel = ContactTypesViewModel();

  @override
  void initState() {
    super.initState();
    contactTypesViewModel.getContactInfo();
  }

  @override
  void dispose() {
    contactTypesViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: contactTypesViewModel,
        builder: (context, viewModel, child) => Scaffold(
            appBar: AppBar(titleSpacing: 0, title: Text("Liên hệ")),
            body: buildUi(context: context)));
  }

  Widget buildScreen() {
    return StreamBuilder(
      stream: contactTypesViewModel.contactStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            padding: EdgeInsets.only(left: 25, right: 35, top: 20),
            child: ListView(
              children: [
                buildTypeContact(
                    Image.asset(AppImages.icChat),
                    snapshot.data[0]["message"],
                    Image.asset(
                      AppImages.icMessenger,
                    ),
                        () => AppUtils.handleMessenger(context)),
                buildTypeContact(
                    Image.asset(AppImages.icCall),
                    snapshot.data[0]["hotLine"],
                    Icon(Icons.arrow_forward_ios_outlined, size: 18, color: Colors.grey),
                        () => AppUtils.handlePhone(context, snapshot.data[0]["hotLine"])),
                buildTypeContact(Image.asset(AppImages.icEmail), snapshot.data[0]["email"],
                    Icon(Icons.arrow_forward_ios_outlined, size: 18, color: Colors.grey), handleEmail)
              ],
            ),
          );
        } else {
          return MyLoading();
        }
      },
    );
  }

  Widget buildTypeContact(Image iconStart, String content, Widget iconEnd, Function action) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: 50,
        child: Row(children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(width: 20, height: 20, child: iconStart),
                SizedBox(
                  width: 15,
                ),
                Text(
                  content,
                  style: TextStyle(fontSize: 17),
                )
              ],
            ),
          ),
          Container(
            height: 28,
            width: 28,
            child: iconEnd,
          )
        ]),
      ),
      onTap: action,
    );
  }

  handleEmail() async {
    if (await AppUtils.checkLogin()) {
      bool isContacted = await contactTypesViewModel.checkFeedbackOfUser();
      isContacted
          ? Navigator.pushNamed(context, Routers.Detail_Contact)
          : Navigator.pushNamed(context, Routers.Create_Contact);
    } else {
      AppUtils.myShowDialog(context, -1, "");
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
