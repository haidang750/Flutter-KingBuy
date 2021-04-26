import 'package:flutter/material.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/widgets/MyNetworkImage.dart';
import 'package:projectui/src/resource/model/ProductModel.dart';

class ProductDetail extends StatefulWidget {
  ProductDetail({Key key, this.product}) : super(key: key);
  Product product;

  @override
  ProductDetailState createState() => ProductDetailState();
}


class ProductDetailState extends State<ProductDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text("Chi tiết sản phẩm"),
      ),
      body: Center(
        child: MyNetworkImage(
          url: "${AppEndpoint.BASE_URL}${widget.product.imageSource}",
          height: 400,
        )
      ),
    );
  }
}
