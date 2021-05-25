import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/presentation.dart';
import 'package:projectui/src/presentation/widgets/border_text_field.dart';

class CreateContact extends StatefulWidget {
  @override
  CreateContactState createState() => CreateContactState();
}

class CreateContactState extends State<CreateContact> with ResponsiveWidget {
  CreateContactViewModel createContactViewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: CreateContactViewModel(),
        onViewModelReady: (viewModel) => createContactViewModel = viewModel,
        builder: (context, viewModel, child) => Scaffold(
            appBar: AppBar(
              titleSpacing: 0,
              title: Text("Gửi liên hệ"),
              actions: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 15, 10),
                  child: GestureDetector(
                    child: RotationTransition(
                      turns: AlwaysStoppedAnimation(-30 / 360),
                      child: Icon(Icons.send),
                    ),
                    onTap: () {
                      createContactViewModel.onSendContact();
                    },
                  ),
                ),
              ],
            ),
            body: buildUi(context: context)));
  }

  Widget buildScreen() {
    return Container(
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
            textController: createContactViewModel.fullNameController,
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
            textController: createContactViewModel.emailController,
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
            textController: createContactViewModel.phoneController,
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
            textController: createContactViewModel.subjectController,
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
            textController: createContactViewModel.bodyController,
            fontSize: 16,
            hintText: "Nội dung",
            hintTextFontSize: 15,
            hintTextFontWeight: FontWeight.w400,
          ),
        ],
      ),
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
