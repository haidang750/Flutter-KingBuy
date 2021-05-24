import 'package:flutter/material.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/HomeSreens/HomeScreens.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/presentation/presentation.dart';
import 'package:projectui/src/resource/model/model.dart';

class DetailStoreScreen extends StatefulWidget {
  DetailStoreScreen({this.store});

  Store store;

  @override
  DetailStoreScreenState createState() => DetailStoreScreenState();
}

class DetailStoreScreenState extends State<DetailStoreScreen> with ResponsiveWidget {
  final detailStoreViewModel = DetailStoreViewModel();

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: detailStoreViewModel,
        builder: (context, viewModel, child) => Scaffold(
              appBar: AppBar(title: Text("Cửa hàng"), titleSpacing: 0),
              body: buildUi(context: context),
            ));
  }

  Widget buildScreen() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
      child: Column(
        children: [
          Image.network("${AppEndpoint.BASE_URL}${widget.store.imageSource}",
              height: 220, width: MediaQuery.of(context).size.width - 20, fit: BoxFit.cover),
          SizedBox(height: 40),
          Container(
            padding: EdgeInsets.only(left: 50, right: 20),
            alignment: Alignment.centerLeft,
            child: Text(widget.store.address),
          ),
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Image.asset(AppImages.icPhone, color: AppColors.primary, height: 20, width: 20),
                SizedBox(width: 10),
                Text(widget.store.hotLine)
              ],
            ),
          ),
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [Icon(Icons.access_time_outlined, size: 24, color: AppColors.primary), SizedBox(width: 10), Text(widget.store.openingHours)],
            ),
          )
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
