import 'package:flutter/material.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/presentation/presentation.dart';
import 'package:projectui/src/presentation/widgets/BorderTextField.dart';
import 'package:projectui/src/presentation/widgets/MyLoading.dart';
import 'package:projectui/src/resource/model/ContactModel.dart';
import 'package:projectui/src/resource/model/Data.dart';
import 'package:provider/provider.dart';

import 'DetailContact_viewmodel.dart';

class DetailContact extends StatefulWidget {
  @override
  DetailContactState createState() => DetailContactState();
}

class DetailContactState extends State<DetailContact> with ResponsiveWidget {
  final detailContactViewModel = DetailContactViewModel();
  final feedbackController = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    detailContactViewModel.getAllFeedback();
  }

  @override
  void dispose() {
    super.dispose();
    detailContactViewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: detailContactViewModel,
        builder: (context, viewModel, child) => Scaffold(
            appBar: AppBar(
              titleSpacing: 0,
              title: Text("Chi tiết liên hệ"),
            ),
            body: buildUi(context: context)));
  }

  Widget buildScreen() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(15, 25, 15, 20),
        color: Colors.grey.shade300,
        child: Container(
            decoration: BoxDecoration(color: Colors.white, border: Border.all(width: 1, color: Colors.grey.shade400)),
            child: StreamBuilder(
              stream: detailContactViewModel.feedbackStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      buildTitle(snapshot.data.titleFirst),
                      Expanded(
                          child: Container(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                              child: Column(
                                children: [
                                  buildConversation(snapshot.data),
                                  buildInputFeedback(),
                                  SizedBox(height: 10),
                                  buildButtonFeedback()
                                ],
                              )))
                    ],
                  );
                } else {
                  return MyLoading();
                }
              },
            )),
      ),
    );
  }

  Widget buildTitle(String titleFirst) {
    return Container(
      height: 40,
      padding: EdgeInsets.only(left: 10),
      color: AppColors.primary,
      child: Row(
        children: [
          Text("-", style: TextStyle(color: Colors.white)),
          SizedBox(
            width: 15,
          ),
          Text(titleFirst, style: TextStyle(color: Colors.white))
        ],
      ),
    );
  }

  Widget buildConversation(ContactModel contactInfo) {
    return Container(
      height: 310,
      padding: EdgeInsets.only(bottom: 10),
      child: ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        controller: scrollController,
        itemCount: contactInfo.feedbacks.length == 0 ? 1 : contactInfo.feedbacks.length,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Column(
              children: [buildOneFeedback(contactInfo.contentFirst), buildOneFeedback(contactInfo.feedbacks[index].content)],
            );
          } else {
            return buildOneFeedback(contactInfo.feedbacks[index].content);
          }
        },
      ),
    );
  }

  Widget buildOneFeedback(String content) {
    Data userData = Provider.of<Data>(context);
    String userAvatar = userData.profile.avatarSource;

    return Container(
        padding: EdgeInsets.fromLTRB(5, 10, 25, 10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage("${AppEndpoint.BASE_URL}$userAvatar"),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: Text(
              content,
            ))
          ],
        ));
  }

  Widget buildInputFeedback() {
    return BorderTextField(
      height: 100,
      color: Colors.grey.shade300,
      textPaddingLeft: 10,
      textPaddingRight: 5,
      transformText: -9,
      borderWidth: 0,
      borderColor: Colors.white,
      borderRadius: 0,
      textController: feedbackController,
      fontSize: 15,
      hintText: "Nội dung",
      hintTextFontSize: 14,
      hintTextFontWeight: FontWeight.w400,
    );
  }

  Widget buildButtonFeedback() {
    return Container(
        height: 40,
        alignment: Alignment.centerRight,
        child: GestureDetector(
            child: Container(
              alignment: Alignment.center,
              width: 80,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Text(
                "Trả lời",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
            onTap: () => handleUserReply()));
  }

  handleUserReply() async {
    int status = await detailContactViewModel.userReplyFeedback(feedbackController.text);
    if (status == 1) {
      print("Gửi phản hồi thành công");
      setState(() {
        feedbackController.text = "";
      });
      await detailContactViewModel.getAllFeedback();
      scrollController.animateTo(scrollController.position.maxScrollExtent + 50,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      print("Gửi phản hồi thất bại");
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
