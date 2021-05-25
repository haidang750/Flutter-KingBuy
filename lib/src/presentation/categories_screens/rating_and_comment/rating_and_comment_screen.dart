import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/categories_screens/categories_screens.dart';
import 'package:projectui/src/presentation/base/base_widget.dart';
import 'package:projectui/src/presentation/routers.dart';
import 'package:projectui/src/presentation/widgets/my_loading.dart';
import 'package:projectui/src/presentation/widgets/show_rating.dart';
import 'package:projectui/src/resource/model/comment_model.dart';
import 'package:projectui/src/resource/model/data.dart';
import 'package:projectui/src/resource/model/rating_model.dart';
import 'package:projectui/src/utils/app_utils.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class RatingAndComment extends StatefulWidget {
  RatingAndComment({this.productId, this.productVideoLink, this.isUserRated});

  int productId;
  String productVideoLink;
  bool isUserRated;

  @override
  RatingAndCommentState createState() => RatingAndCommentState();
}

class RatingAndCommentState extends State<RatingAndComment> with ResponsiveWidget {
  RatingAndCommentViewModel ratingAndCommentViewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: RatingAndCommentViewModel(),
        onViewModelReady: (viewModel) => ratingAndCommentViewModel = viewModel..init(widget.productId, widget.isUserRated),
        builder: (context, viewModel, child) => Scaffold(
            key: ratingAndCommentViewModel.scaffoldKey,
            appBar: AppBar(title: Text("Đánh giá & Bình luận"), titleSpacing: 0),
            body: buildUi(context: context)));
  }

  Widget buildScreen() {
    Data userData = Provider.of<Data>(context, listen: true);
    List<Comment> comments = Provider.of<CommentModel>(context).comments;
    ratingAndCommentViewModel.productCommentSubject.sink.add(comments != null ? comments : []);
    ratingAndCommentViewModel.userProfileSubject.sink.add(userData.profile);

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: ListView(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            children: [
              SizedBox(height: 30),
              buildRating(),
              SizedBox(height: 10),
              StreamBuilder(
                stream: Rx.combineLatest2(ratingAndCommentViewModel.isUserRatedSubject.stream, ratingAndCommentViewModel.userProfileSubject.stream,
                    (stream1, stream2) => stream1),
                builder: (context, snapshot) {
                  if (userData.profile != null) {
                    ratingAndCommentViewModel.isUserRatedSubject.sink.add(
                        ratingAndCommentViewModel.isUserRated(userData.profile.id, ratingAndCommentViewModel.productCommentSubject.stream.value));
                  } else {
                    ratingAndCommentViewModel.isUserRatedSubject.sink.add(false);
                  }

                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        GestureDetector(
                            child: Container(
                                height: 45,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border: Border.all(width: 1, color: snapshot.data ? AppColors.grey : AppColors.primary),
                                    borderRadius: BorderRadius.all(Radius.circular(6))),
                                child: Text(snapshot.data ? "Đã đánh giá" : "Viết đánh giá",
                                    style: TextStyle(fontSize: 14, color: snapshot.data ? AppColors.grey : AppColors.primary))),
                            onTap: snapshot.data
                                ? null
                                : () async {
                                    if (await AppUtils.checkLogin()) {
                                      await Navigator.pushNamed(ratingAndCommentViewModel.scaffoldKey.currentContext, Routers.Writing_Comment,
                                          arguments: widget.productId);
                                    } else {
                                      AppUtils.myShowDialog(
                                          ratingAndCommentViewModel.scaffoldKey.currentContext, widget.productId, widget.productVideoLink);
                                    }
                                  }),
                        SizedBox(height: 15)
                      ],
                    );
                  } else {
                    return MyLoading();
                  }
                },
              ),
              buildComments(),
            ],
          )),
    );
  }

  Widget buildRating() {
    RatingModel ratingInfo = Provider.of<RatingModel>(context, listen: true);

    return Row(
      children: [
        Container(
          height: 100,
          width: MediaQuery.of(context).size.width * 0.4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ShowRating(star: ratingInfo.avgRating, starSize: 20, allowHalfRating: true),
              SizedBox(height: 5),
              Text("Đánh giá trung bình", style: TextStyle(fontSize: 14)),
              SizedBox(height: 5),
              Text("(${ratingInfo.ratingCount.toString()} đánh giá)", style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
              SizedBox(height: 5),
              Text("${ratingInfo.avgRating.toString()}/5", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
            ],
          ),
        ),
        Expanded(
            child: Container(
          height: 100,
          child: ListView.builder(
            shrinkWrap: true,
            reverse: true,
            physics: BouncingScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, index) {
              int oneRatingCount = index == 0
                  ? ratingInfo.oneStarCount
                  : (index == 1
                      ? ratingInfo.twoStarCount
                      : (index == 2 ? ratingInfo.threeStarCount : (index == 3 ? ratingInfo.fourStarCount : ratingInfo.fiveStarCount)));

              return Column(
                children: [
                  Row(
                    children: [
                      Text((index + 1).toString(), style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
                      SizedBox(width: 3),
                      Icon(Icons.star_rounded, size: 13, color: Colors.grey.shade600),
                      SizedBox(width: 3),
                      Stack(
                        children: [
                          Container(
                            height: 13,
                            width: MediaQuery.of(context).size.width * 0.261,
                            decoration: BoxDecoration(color: Colors.grey.withOpacity(0.5), borderRadius: BorderRadius.all(Radius.circular(6.5))),
                          ),
                          Container(
                            height: 13,
                            width: ratingInfo.ratingCount != 0
                                ? MediaQuery.of(context).size.width * 0.261 * (oneRatingCount * 1.0 / ratingInfo.ratingCount)
                                : 0,
                            decoration: BoxDecoration(color: Colors.yellow.shade700, borderRadius: BorderRadius.all(Radius.circular(6.5))),
                          ),
                        ],
                      ),
                      SizedBox(width: 7),
                      Text("${oneRatingCount.toString()} đánh giá", style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
                    ],
                  ),
                  SizedBox(height: 5)
                ],
              );
            },
          ),
        ))
      ],
    );
  }

  Widget buildComments() {
    List<Comment> comments = Provider.of<CommentModel>(context, listen: true).comments;

    return ListView.builder(
        shrinkWrap: true,
        reverse: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: comments.length,
        itemBuilder: (context, index) {
          Comment comment = comments[index];

          return Column(
            children: [
              Container(height: 0.5, color: Colors.black.withOpacity(0.3)),
              SizedBox(height: 10),
              Container(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      "${AppEndpoint.BASE_URL}${comment.avatarSource}",
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("${comment.name}", style: TextStyle(fontSize: 12)),
                          SizedBox(width: 10),
                          comment.isBuy == 1 ? Image.asset(AppImages.icSuccess, height: 12, width: 12) : Container(),
                          comment.isBuy == 1 ? SizedBox(width: 3) : Container(),
                          comment.isBuy == 1 ? Text("Đã mua hàng ở KingBuy", style: TextStyle(fontSize: 12, color: Colors.green)) : Container(),
                          Spacer(),
                          comment.phoneNumber != ""
                              ? Text(comment.phoneNumber.substring(0, 6) + "****", style: TextStyle(fontSize: 12, color: Colors.grey.shade500))
                              : Container()
                        ],
                      ),
                      Container(height: 18, child: ShowRating(star: comment.star, starSize: 12)),
                      Container(
                        child: Text(comment.comment, style: TextStyle(fontSize: 14)),
                      ),
                      SizedBox(height: 10),
                      Text(DateFormat("dd-MM-yyyy").format(comment.createdAt), style: TextStyle(fontSize: 12, color: Colors.grey.shade500))
                    ],
                  ))
                ],
              )),
              SizedBox(height: 5),
            ],
          );
        });
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
