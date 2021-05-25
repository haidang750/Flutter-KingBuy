import 'package:projectui/src/resource/model/list_products_model.dart';

class SearchedProductModel {
  SearchedProductModel({
    this.status,
    this.products,
  });

  int status;
  List<Product> products;

  factory SearchedProductModel.fromJson(Map<String, dynamic> json) => SearchedProductModel(
    status: json["status"],
    products: List<Product>.from(json["data"].map((x) => Product.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(products.map((x) => x.toJson())),
  };
}
