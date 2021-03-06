// Danh sách khuyến mãi
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projectui/src/presentation/profile_screens/promotion/promotion_detail/promotion_detail_screen.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/presentation/widgets/my_loading.dart';
import 'list_promotion_viewmodel.dart';

class ListPromotion extends StatefulWidget {
  @override
  ListPromotionState createState() => ListPromotionState();
}

class ListPromotionState extends State<ListPromotion> with ResponsiveWidget {
  ListPromotionViewModel listPromotionViewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: ListPromotionViewModel(),
        onViewModelReady: (viewModel) => listPromotionViewModel = viewModel..init(),
        builder: (context, viewModel, child) => Scaffold(
            appBar: AppBar(titleSpacing: 0, title: Text("Khuyến mãi")),
            body: Container(padding: EdgeInsets.only(left: 25, top: 0, right: 25), child: buildUi(context: context))));
  }

  Widget buildScreen() {
    return StreamBuilder(
      stream: listPromotionViewModel.promotionStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: Container(
                  height: 115,
                  padding: EdgeInsets.only(top: 10, bottom: 5),
                  child: Row(
                    children: [
                      Container(
                        width: 145,
                        decoration: BoxDecoration(
                            image: DecorationImage(image: NetworkImage("https://kingbuy.vn${snapshot.data[index].imageSource}"), fit: BoxFit.fill)),
                      ),
                      Expanded(
                          child: Container(
                        padding: EdgeInsets.only(left: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data[index].title,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 5),
                            Text(DateFormat("yyyy-MM-dd").format(snapshot.data[index].createdAt),
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                ))
                          ],
                        ),
                      ))
                    ],
                  ),
                ),
                onTap: () {
                  listPromotionViewModel.onTapPromotion(
                      snapshot.data[index].imageSource, snapshot.data[index].title, snapshot.data[index].description);
                },
              );
            },
          );
        } else {
          return MyLoading();
        }
      },
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
