import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/ProfileScreens/Contact/Contact.dart';
import 'package:projectui/src/presentation/widgets/BorderTextField.dart';

class CreateContact extends StatefulWidget {
  @override
  _CreateContactState createState() => _CreateContactState();
}

class _CreateContactState extends State<CreateContact> {
  final contactViewModel = ContactViewModel();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final subjectController = TextEditingController();
  final bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Gửi liên hệ"),
          actions: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 15, 10),
              child: GestureDetector(
                child: RotationTransition(
                  turns: AlwaysStoppedAnimation(-30 / 360),
                  child: Icon(Icons.send),
                ),
                onTap: () async {
                  String message = await contactViewModel.userSendContact(
                      fullNameController.text, emailController.text, phoneController.text,
                      subjectController.text, bodyController.text);
                  print(message);
                },
              ),
            ),
          ],
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(15, 25, 15, 0),
            color: Colors.grey.shade300,
            child: Column(
              children: [
                BorderTextField(
                  textPaddingLeft: 10,
                  textPaddingRight: 5,
                  borderWidth: 0,
                  borderColor: Colors.white,
                  borderRadius: 0,
                  textController: fullNameController,
                  fontSize: 16,
                  hintText: "Họ tên",
                  hintTextFontSize: 15,
                  hintTextFontWeight: FontWeight.w400,
                ),
                SizedBox(height: 15),
                BorderTextField(
                  textPaddingLeft: 10,
                  textPaddingRight: 5,
                  borderWidth: 0,
                  borderColor: Colors.white,
                  borderRadius: 0,
                  textController: emailController,
                  fontSize: 16,
                  keyboardType: TextInputType.emailAddress,
                  hintText: "Email",
                  hintTextFontSize: 15,
                  hintTextFontWeight: FontWeight.w400,
                ),
                SizedBox(height: 15),
                BorderTextField(
                  textPaddingLeft: 10,
                  textPaddingRight: 5,
                  borderWidth: 0,
                  borderColor: Colors.white,
                  borderRadius: 0,
                  textController: phoneController,
                  fontSize: 16,
                  keyboardType: TextInputType.phone,
                  hintText: "Số điện thoại",
                  hintTextFontSize: 15,
                  hintTextFontWeight: FontWeight.w400,
                ),
                SizedBox(height: 15),
                BorderTextField(
                  textPaddingLeft: 10,
                  textPaddingRight: 5,
                  borderWidth: 0,
                  borderColor: Colors.white,
                  borderRadius: 0,
                  textController: subjectController,
                  fontSize: 16,
                  hintText: "Tiêu đề",
                  hintTextFontSize: 15,
                  hintTextFontWeight: FontWeight.w400,
                ),
                SizedBox(height: 15),
                BorderTextField(
                  height: 200,
                  textPaddingLeft: 10,
                  textPaddingRight: 5,
                  borderWidth: 0,
                  borderColor: Colors.white,
                  borderRadius: 0,
                  textController: bodyController,
                  fontSize: 16,
                  hintText: "Nội dung",
                  hintTextFontSize: 15,
                  hintTextFontWeight: FontWeight.w400,
                ),
              ],
            ),
          ),
        ));
  }
}
