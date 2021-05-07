// Sản phẩm đã xem
import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/CategoriesScreens/CategoriesScreens.dart';
import 'package:projectui/src/presentation/ProfileScreens/ViewedProducts/ViewedProducts.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/presentation/widgets/MyGridView.dart';
import 'package:projectui/src/presentation/widgets/MyLoading.dart';
import 'package:projectui/src/presentation/widgets/ShowOneProduct.dart';
import 'package:projectui/src/presentation/widgets/ShowPath.dart';
import 'package:projectui/src/resource/model/ListProductsModel.dart';
import 'package:projectui/src/resource/model/ViewedProductLocalStorage.dart';
import 'package:projectui/src/utils/app_utils.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class ViewedProducts extends StatefulWidget {
  @override
  ViewedProductsState createState() => ViewedProductsState();
}

class ViewedProductsState extends State<ViewedProducts> with ResponsiveWidget {
  final viewedProductsViewModel = ViewedProductsViewModel();
  final productDetailViewModel = ProductDetailViewModel();
  final keyGridView = GlobalKey<MyGridViewState>();
  final checkLoginSubject = BehaviorSubject<bool>();

  @override
  void initState() {
    checkLogin();
    super.initState();
  }

  checkLogin() async {
    List<int> idViewedProducts = Provider.of<ViewedProductLocalStorage>(context, listen: false).idViewedProducts;
    bool isLogin = await AppUtils.checkLogin();

    if (isLogin == false) productDetailViewModel.getViewedProductsLocal(idViewedProducts);
    checkLoginSubject.sink.add(isLogin);
  }

  @override
  void dispose() {
    super.dispose();
    checkLoginSubject.close();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: viewedProductsViewModel,
        builder: (context, viewModel, child) => Scaffold(
            appBar: AppBar(titleSpacing: 0, title: Text("Sản phẩm đã xem")),
            body: Container(padding: EdgeInsets.symmetric(horizontal: 10), child: buildUi(context: context))));
  }

  Widget buildScreen() {
    return Column(
      children: [buildPath(), buildListProduct()],
    );
  }

  Widget buildPath() {
    return Container(
        height: 50,
        alignment: Alignment.centerLeft,
        child: ShowPath(
          rootTab: "Tài khoản",
          parentTab: null,
          childTab: "Sản phẩm đã xem",
        ));
  }

  Widget itemBuilder(List<Product> dataList, BuildContext context, int index) {
    Product product = dataList[index];
    return ShowOneProduct(
      product: product,
    );
  }

  Widget buildListProduct() {
    return Expanded(
        child: StreamBuilder(
      stream: checkLoginSubject.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data) {
            return buildViewedProductLogin();
          } else {
            return buildViewedProductLocal();
          }
        } else {
          return MyLoading();
        }
      },
    ));
  }

  // nếu user đã Login
  Widget buildViewedProductLogin() {
    return MyGridView(
      key: keyGridView,
      itemBuilder: itemBuilder,
      dataRequester: viewedProductsViewModel.dataRequester,
      initRequester: viewedProductsViewModel.initRequester,
      childAspectRatio: 1 / 2.2,
      crossAxisCount: 2,
    );
  }

  // nếu user chưa Login
  Widget buildViewedProductLocal() {
    return StreamBuilder(
      stream: productDetailViewModel.viewedProductsLocalStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Product> localViewedProducts = snapshot.data;

          if (localViewedProducts.length != 0) {
            return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1 / 2.2,
                  crossAxisCount: 2,
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 1,
                ),
                padding: EdgeInsets.only(bottom: 10),
                itemCount: localViewedProducts.length,
                itemBuilder: (context, index) {
                  Product product = localViewedProducts[index];

                  return ShowOneProduct(
                    product: product,
                  );
                });
          } else {
            return Center(child: Text("Không có dữ liệu"));
          }
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
