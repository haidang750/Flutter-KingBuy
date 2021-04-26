// Ảnh 48 - Liên hệ
import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/ProfileScreens/Contact/Contact_viewmodel.dart';
import 'package:projectui/src/presentation/ProfileScreens/Contact/DetailContact_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:toast/toast.dart';
import 'package:projectui/src/utils/utils.dart';
import 'CreateContact_screen.dart';

class Contact extends StatefulWidget {
  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  final contactViewModel = ContactViewModel();

  @override
  void initState() {
    super.initState();
    contactViewModel.getContactInfo();
  }

  @override
  void dispose() {
    contactViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(titleSpacing: 0, title: Text("Liên hệ")),
        body: StreamBuilder(
          stream: contactViewModel.contactStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                padding: EdgeInsets.only(left: 25, right: 35, top: 20),
                child: ListView(
                  children: [
                    buildTypeContact(
                        Image.asset("assets/chat.png"),
                        snapshot.data[0]["message"],
                        Image.asset(
                          "assets/messenger.png",
                        ),
                        handleMessenger),
                    buildTypeContact(
                        Image.asset("assets/call-answer.png"),
                        snapshot.data[0]["hotLine"],
                        Icon(Icons.arrow_forward_ios_outlined,
                            size: 18, color: Colors.grey),
                        () => handlePhone(snapshot.data[0]["hotLine"])),
                    buildTypeContact(
                        Image.asset("assets/email.png"),
                        snapshot.data[0]["email"],
                        Icon(Icons.arrow_forward_ios_outlined,
                            size: 18, color: Colors.grey),
                        handleEmail)
                  ],
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }

  Widget buildTypeContact(
      Image iconStart, String content, Widget iconEnd, Function action) {
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

  handleMessenger() async {
    if (await canLaunch('http://m.me/100040733580443')) {
      await launch('https://m.me/100040733580443');
    } else
      Toast.show("Không thể mở Messenger", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
  }

  handlePhone(String hotLine) async {
    if (await canLaunch('tel:$hotLine')) {

      await launch('tel:$hotLine');
    } else {
      Toast.show("Không thể mở điện thoại", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  handleEmail() async {
    if (AppUtils.checkLogin()) {
      bool isContacted = await contactViewModel.checkFeedbackOfUser();
      isContacted
          ? Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailContact(),
              ))
          : Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateContact(),
              ));
    } else {
      AppUtils.myShowDialog(context);
    }
  }
}
