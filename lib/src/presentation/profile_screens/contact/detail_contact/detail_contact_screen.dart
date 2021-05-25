import 'package:flutter/material.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/presentation/presentation.dart';
import 'package:projectui/src/presentation/widgets/border_text_field.dart';
import 'package:projectui/src/presentation/widgets/my_loading.dart';
import 'package:projectui/src/resource/model/contact_model.dart';
import 'package:projectui/src/resource/model/data.dart';
import 'package:provider/provider.dart';

import 'detail_contact_viewmodel.dart';

class DetailContact extends StatefulWidget {
  @override
  DetailContactState createState() => DetailContactState();
}

class DetailContactState extends State<DetailContact> with ResponsiveWidget {
  DetailContactViewModel detailContactViewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: DetailContactViewModel(),
        onViewModelReady: (viewModel) => detailContactViewModel = viewModel..init(),
        builder: (context, viewModel, child) =>
            Scaffold(appBar: AppBar(titleSpacing: 0, title: Text("Chi tiết liên hệ")), body: buildUi(context: context)));
  }

  Widget buildScreen() {
    return Container(
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
                              children: [buildConversation(snapshot.data), buildInputFeedback(), SizedBox(height: 10), buildButtonFeedback()],
                            )))
                  ],
                );
              } else {
                return MyLoading();
              }
            },
          )),
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
        controller: detailContactViewModel.scrollController,
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
      textController: detailContactViewModel.feedbackController,
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
            onTap: () {
              detailContactViewModel.handleUserReply();
              setState(() {});
            }));
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
