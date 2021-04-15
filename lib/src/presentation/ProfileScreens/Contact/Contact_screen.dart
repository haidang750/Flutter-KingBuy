// Ảnh 48 - Liên hệ
import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/ProfileScreens/Contact/Contact_viewmodel.dart';

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
        appBar: AppBar(title: Text("Liên hệ")),
        body: StreamBuilder(
          stream: contactViewModel.contactStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                padding: EdgeInsets.only(left: 25, right: 35, top: 20),
                child: ListView(
                  children: [
                    _buildChat(snapshot.data[0]["message"]),
                    _buildPhone(snapshot.data[0]["hotLine"]),
                    _buildEmail(snapshot.data[0]["email"])
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

  Widget _buildChat(String message) {
    return Container(
      height: 50,
      child: Row(children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  width: 20, height: 20, child: Image.asset("assets/chat.png")),
              SizedBox(
                width: 15,
              ),
              Text(
                message,
                style: TextStyle(fontSize: 17),
              )
            ],
          ),
        ),
        Container(
          height: 28,
          width: 28,
          child: Image.asset(
            "assets/messenger.png",
          ),
        )
      ]),
    );
  }

  Widget _buildPhone(String hotLine) {
    return Container(
      height: 50,
      child: Row(children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  width: 20,
                  height: 20,
                  child: Image.asset("assets/call-answer.png")),
              SizedBox(
                width: 20,
              ),
              Text(
                hotLine,
                style: TextStyle(fontSize: 17),
              )
            ],
          ),
        ),
        Container(
          child: Icon(Icons.arrow_forward_ios_outlined,
              size: 18, color: Colors.grey),
        )
      ]),
    );
  }

  Widget _buildEmail(String email) {
    return Container(
      height: 50,
      child: Row(children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  width: 20,
                  height: 20,
                  child: Image.asset("assets/email.png")),
              SizedBox(
                width: 20,
              ),
              Text(
                email,
                style: TextStyle(fontSize: 17),
              )
            ],
          ),
        ),
        Container(
          child: Icon(Icons.arrow_forward_ios_outlined,
              size: 18, color: Colors.grey),
        )
      ]),
    );
  }
}
