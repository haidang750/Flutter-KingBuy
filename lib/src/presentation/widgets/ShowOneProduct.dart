import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:projectui/src/configs/constants/app_endpoint.dart';
import 'package:projectui/src/presentation/CategoriesScreens/ProductDetail_screen.dart';
import 'package:projectui/src/presentation/widgets/MyNetworkImage.dart';
import 'package:projectui/src/presentation/widgets/ShowMoney.dart';
import '../../resource/model/ProductModel.dart';

class ShowOneProduct extends StatefulWidget {
  ShowOneProduct({Key key, this.product});

  Product product;

  @override
  ShowOneProductState createState() => ShowOneProductState();
}

class ShowOneProductState extends State<ShowOneProduct> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Card(
            child: Column(
          children: [
            Stack(
              children: [buildImageProduct(), buildDiscount()],
            ),
            Expanded(
                child: Padding(
              padding: EdgeInsets.only(top: 10, left: 5, right: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 58,
                    child: Text(widget.product.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(widget.product.brandName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.blue)),
                  SizedBox(
                    height: 5,
                  ),
                  buildRate(widget.product.star),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShowMoney(
                        price: widget.product.salePrice,
                        fontSizeLarge: 13,
                        fontSizeSmall: 9.5,
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.bold,
                        isLineThrough: false,
                      ),
                      ShowMoney(
                        price: widget.product.price,
                        fontSizeLarge: 11,
                        fontSizeSmall: 8,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        isLineThrough: true,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  widget.product.gifts.length > 0 ? buildGift() : Container(),
                  widget.product.isInstallment == 1
                      ? SizedBox(
                          height: 5,
                        )
                      : Container(),
                  widget.product.isInstallment == 1
                      ? Text(
                          "Trả góp: 0%",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        )
                      : Container()
                ],
              ),
            ))
          ],
        )),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetail(
                  product: widget.product,
                ),
              ));
        });
  }

  Widget buildImageProduct() {
    return MyNetworkImage(
      url: "${AppEndpoint.BASE_URL}${widget.product.imageSource}",
      height: 180,
    );
  }

  Widget buildDiscount() {
    return Positioned(
        top: 4,
        right: 4,
        child: Container(
          height: 32,
          width: 56,
          decoration: BoxDecoration(color: Colors.red.shade600, borderRadius: BorderRadius.all(Radius.circular(19))),
          child: Center(
            child: Text(
              "-${widget.product.saleOff.toString()}%",
              style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
        ));
  }

  List<Icon> buildStar(int star) {
    List<Icon> stars = [];
    for (var i = 0; i < star; i++) {
      stars.add(Icon(
        Icons.star,
        color: Colors.yellow.shade600,
        size: 15,
      ));
    }

    for (var i = 0; i < 5 - star; i++) {
      stars.add(Icon(
        Icons.star_border_outlined,
        color: Colors.yellow.shade600,
        size: 15,
      ));
    }
    return stars;
  }

  Widget buildRate(int star) {
    return Row(children: buildStar(star));
  }

  Widget buildGift() {
    return Row(
      children: [
        Container(
          height: 24,
          child: Image.asset(
            "assets/gift.png",
            fit: BoxFit.fill,
          ),
        ),
        SizedBox(
          width: 7,
        ),
        Text("Quà tặng kèm", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.blue))
      ],
    );
  }
}
