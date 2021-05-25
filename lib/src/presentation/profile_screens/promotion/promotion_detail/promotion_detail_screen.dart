// Chi tiết khuyến mãi
import 'package:flutter/material.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/presentation.dart';

class PromotionDetail extends StatefulWidget {
  PromotionDetail({this.image, this.title, this.description});

  String image;
  String title;
  String description;

  @override
  PromotionDetailState createState() => PromotionDetailState();
}

class PromotionDetailState extends State<PromotionDetail> with ResponsiveWidget {
  PromotionDetailViewModel promotionDetailViewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: PromotionDetailViewModel(),
        onViewModelReady: (viewModel) => promotionDetailViewModel = viewModel,
        builder: (context, viewModel, child) => Scaffold(appBar: AppBar(titleSpacing: 0, title: Text("Chi tiết")), body: buildUi(context: context)));
  }

  Widget buildScreen() {
    return Container(
      child: ListView(
        children: [
          Container(
            height: 220,
            padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: Image.network(
              "${AppEndpoint.BASE_URL}${widget.image}",
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Text(
              widget.title,
              style: TextStyle(fontSize: 17, color: AppColors.primary, fontWeight: FontWeight.w700, height: 1.3),
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Text(
              widget.description,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, height: 1.3),
            ),
          ),
          SizedBox(height: 10),
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
