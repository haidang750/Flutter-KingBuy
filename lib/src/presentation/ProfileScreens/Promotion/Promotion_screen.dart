// Danh sách khuyến mãi
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projectui/src/presentation/ProfileScreens/Promotion/PromotionDetail_screen.dart';
import 'Promotion_viewmodel.dart';

class Promotion extends StatefulWidget {
  @override
  _PromotionState createState() => _PromotionState();
}

class _PromotionState extends State<Promotion> {
  final promotionViewModel = PromotionViewModel();

  @override
  void initState() {
    super.initState();
    promotionViewModel.getPromotion();
  }

  @override
  void dispose() {
    promotionViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Khuyến mãi")),
        body: Container(
            padding: EdgeInsets.only(left: 25, top: 0, right: 25),
            child: buildList()));
  }

  buildList() {
    return StreamBuilder(
      stream: promotionViewModel.promotionStream,
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
                            image: DecorationImage(
                                image: NetworkImage(
                                    "https://kingbuy.vn${snapshot.data[index].imageSource}"),
                                fit: BoxFit.fill)),
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
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 5),
                            Text(
                                DateFormat("yyyy-MM-dd")
                                    .format(snapshot.data[index].createdAt),
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
                  onTapPromotion(
                      snapshot.data[index].imageSource,
                      snapshot.data[index].title,
                      snapshot.data[index].description);
                },
              );
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  onTapPromotion(String image, String title, String description) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PromotionDetail(
            image: image,
            title: title,
            description: description,
          ),
        ));
  }
}
