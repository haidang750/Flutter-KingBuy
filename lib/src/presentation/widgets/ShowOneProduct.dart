import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';
import 'package:projectui/src/configs/constants/app_endpoint.dart';
import 'package:projectui/src/presentation/widgets/ShowMoney.dart';

class ShowOneProduct extends StatefulWidget {
  ShowOneProduct(
      {Key key,
      this.imageSource,
      this.saleOff,
      this.name,
      this.brandName,
      this.star,
      this.salePrice,
      this.price});

  String imageSource, name, brandName;
  int saleOff, star, salePrice, price;
  @override
  ShowOneProductState createState() => ShowOneProductState();
}

class ShowOneProductState extends State<ShowOneProduct> {
  @override
  Widget build(BuildContext context) {
    return Column(
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
                child: Text(widget.name,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ),
              SizedBox(
                height: 5,
              ),
              Text(widget.brandName,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue)),
              SizedBox(
                height: 5,
              ),
              buildRate(widget.star),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShowMoney(
                    price: widget.salePrice,
                    fontSizeLarge: 13,
                    fontSizeSmall: 10,
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.bold,
                    isLineThrough: false,
                  ),
                  ShowMoney(
                    price: widget.price,
                    fontSizeLarge: 11,
                    fontSizeSmall: 8,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    isLineThrough: true,
                  ),
                ],
              )
            ],
          ),
        ))
      ],
    );
  }

  Widget buildImage() {
    return Container(
        height: 180,
        child: Image.network("${AppEndpoint.BASE_URL}${widget.imageSource}",
            fit: BoxFit.fill,
            loadingBuilder: (context, child, loadingProgress) =>
                (loadingProgress == null)
                    ? child
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
            errorBuilder: (context, error, stackTrace) =>
                Image.asset("assets/logo.png")));
  }

  Widget buildImageProduct() {
    print("imageSource: ${widget.imageSource}");
    print("Image URL: ${AppEndpoint.BASE_URL}${widget.imageSource}");

    return Container(
        height: 180,
        child: CachedNetworkImage(
          imageUrl:
              Uri.encodeFull("${AppEndpoint.BASE_URL}${widget.imageSource}"),
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Image.asset("assets/logo.png"),
        ));
  }

  Widget buildDiscount() {
    return Positioned(
        top: 4,
        right: 4,
        child: Container(
          height: 32,
          width: 56,
          decoration: BoxDecoration(
              color: Colors.red.shade600,
              borderRadius: BorderRadius.all(Radius.circular(19))),
          child: Center(
            child: Text(
              "-${widget.saleOff.toString()}%",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
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
}
