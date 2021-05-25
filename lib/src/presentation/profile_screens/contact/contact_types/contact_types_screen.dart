// Ảnh 48 - Liên hệ
import 'package:flutter/material.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/profile_screens/contact/contact_types/contact_types_viewmodel.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/presentation/presentation.dart';
import 'package:projectui/src/presentation/widgets/my_loading.dart';

class ContactTypes extends StatefulWidget {
  @override
  ContactTypesState createState() => ContactTypesState();
}

class ContactTypesState extends State<ContactTypes> with ResponsiveWidget {
  ContactTypesViewModel contactTypesViewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: ContactTypesViewModel(),
        onViewModelReady: (viewModel) => contactTypesViewModel = viewModel..init(),
        builder: (context, viewModel, child) => Scaffold(appBar: AppBar(titleSpacing: 0, title: Text("Liên hệ")), body: buildUi(context: context)));
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
                    () => contactTypesViewModel.handleMessenger(context)),
                buildTypeContact(
                    Image.asset(AppImages.icCall),
                    snapshot.data[0]["hotLine"],
                    Icon(Icons.arrow_forward_ios_outlined, size: 18, color: Colors.grey),
                    () => contactTypesViewModel.handlePhone(context, snapshot.data[0]["hotLine"])),
                buildTypeContact(Image.asset(AppImages.icEmail), snapshot.data[0]["email"],
                    Icon(Icons.arrow_forward_ios_outlined, size: 18, color: Colors.grey), () => contactTypesViewModel.handleEmail())
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
