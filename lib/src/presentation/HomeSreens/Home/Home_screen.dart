import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/Navigation/Navigation_screen.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/presentation/presentation.dart';
import 'package:projectui/src/presentation/widgets/MyListView.dart';
import 'package:projectui/src/presentation/widgets/MyLoading.dart';
import 'package:projectui/src/resource/model/CartModel.dart';
import 'package:projectui/src/resource/model/CategoryModel.dart';
import 'package:projectui/src/resource/model/PromotionModel.dart';
import 'package:projectui/src/resource/model/model.dart';
import 'package:projectui/src/utils/app_shared.dart';
import 'package:rxdart/rxdart.dart';
import 'Home_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with ResponsiveWidget {
  final homeViewModel = HomeViewModel();
  final listPromotionViewModel = ListPromotionViewModel();
  final cartBadgeSubject = BehaviorSubject<int>();
  CarouselController carouselController = CarouselController();
  final currentPromotionImage = BehaviorSubject<int>(); // lưu trữ hình ảnh đang hiển thị ở Carousel hiện tại
  final rootCategoriesViewModel = RootCategoriesViewModel();

  // currentCategorySubject: lưu trữ Child Category (ví dụ: ghế massage thương gia) đang được chọn tại mỗi Category (ví dụ: ghế massage)
  final currentCategorySubject = BehaviorSubject<List<int>>();

  // currentCategoryIdSubject: lưu trữ id của Child Category đang được chọn tại mỗi Category
  final currentCategoryIdSubject = BehaviorSubject<List<int>>();

  // currentProductCategorySubject: lưu trữ luồng Stream chứa danh sách các sản phẩm của Child Category đang được chọn tại mỗi Category
  final currentProductCategorySubject = BehaviorSubject<List<Stream<List<Product>>>>();

  @override
  void initState() {
    super.initState();
    cartBadgeSubject.sink.add(CartModel.of(context).totalUnread);
    listPromotionViewModel.getPromotion();
    currentPromotionImage.sink.add(0);
    rootCategoriesViewModel.getHotCategories();
    homeViewModel.getAllMyPromotion();
    homeViewModel.getAllProductNew();
    homeViewModel.getAllProductSelling();
    currentCategorySubject.sink.add([]);
    currentCategoryIdSubject.sink.add([]);
    currentProductCategorySubject.sink.add([]);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      bool isShowPopup = await AppShared.getShowPopup();
      if (isShowPopup) {
        homeViewModel.getPopup();
        showPopup();
        AppShared.setShowPopup(false);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    cartBadgeSubject.close();
    listPromotionViewModel.dispose();
    currentPromotionImage.close();
    rootCategoriesViewModel.dispose();
    homeViewModel.dispose();
    currentCategorySubject.close();
    currentCategoryIdSubject.close();
    currentProductCategorySubject.close();
  }

  showPopup() {
    showDialog(
        context: context,
        builder: (context) => StreamBuilder(
              stream: homeViewModel.popupStream,
              builder: (context, snapshot) {
                PopupData popup = snapshot.data;

                if (snapshot.hasData) {
                  return Dialog(
                      backgroundColor: Colors.white,
                      insetPadding: EdgeInsets.symmetric(horizontal: 25.5, vertical: MediaQuery.of(context).size.height * 0.18),
                      child: Stack(
                        children: [
                          GestureDetector(
                              child: MyNetworkImage(
                                  url: "${AppEndpoint.BASE_URL}${popup.popupImage}",
                                  height: MediaQuery.of(context).size.height * 0.64,
                                  width: MediaQuery.of(context).size.width - 30),
                              onTap: () async {
                                List<int> productIds = [];
                                productIds.add(popup.popupProductId);
                                Product popupProduct = await homeViewModel.getPopupProduct(productIds);
                                if (popupProduct != null)
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProductDetail(
                                              product: popupProduct, productId: popupProduct.id, productVideoLink: popupProduct.videoLink)));
                              }),
                          Positioned(
                              top: 10,
                              right: 10,
                              child: GestureDetector(
                                  child: Icon(Icons.cancel, size: 20, color: AppColors.black),
                                  onTap: () {
                                    Navigator.pop(context);
                                  }))
                        ],
                      ));
                } else {
                  return MyLoading();
                }
              },
            ));
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        showPhone: true,
        mainScreen: true,
        viewModel: homeViewModel,
        builder: (context, viewModel, child) => GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: Scaffold(
                appBar: buildAppBar(),
                body: buildUi(context: context),
              ),
            ));
  }

  Widget buildAppBar() {
    return AppBar(
      titleSpacing: 0,
      title: buildSearchContainer(),
      leading: Center(
        child: Image.asset(AppImages.logo, height: 50, width: 52),
      ),
      centerTitle: true,
      actions: [
        Padding(
            padding: EdgeInsets.fromLTRB(8, 12, 0, 10),
            child: Row(
              children: [
                GestureDetector(
                  child: Image.asset(AppImages.icLocation, height: 24, width: 24),
                  onTap: () {
                    Navigator.pushNamed(context, Routers.Store_Location);
                  },
                ),
                SizedBox(width: 8),
                StreamBuilder(
                  stream: cartBadgeSubject.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Stack(
                        children: [
                          GestureDetector(
                            child: Container(
                              transform: Matrix4.translationValues(0.0, snapshot.data != 0 ? 0 : 4, 0.0),
                              child: Image.asset(AppImages.icShoppingCart, height: 26, width: 26, color: AppColors.white),
                            ),
                            onTap: () async {
                              CartModel.of(context).readAll();
                              cartBadgeSubject.sink.add(CartModel.of(context).totalUnread);
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => CartScreen(totalQuantity: CartModel.of(context).totalQuantity)));
                            },
                          ),
                          snapshot.data == 0
                              ? Container()
                              : Container(
                                  height: 16,
                                  width: 16,
                                  transform: Matrix4.translationValues(18, -3.5, 0.0),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.all(Radius.circular(8))),
                                  child: Text(snapshot.data.toString(),
                                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.buttonContent)))
                        ],
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
                SizedBox(width: 10),
              ],
            ))
      ],
    );
  }

  Widget buildSearchContainer() {
    return GestureDetector(
      child: Container(
          height: 34,
          width: MediaQuery.of(context).size.width - 100,
          padding: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.all(Radius.circular(18))),
          child: Row(
            children: [
              Image.asset(AppImages.icSearch, height: 18, width: 18),
              SizedBox(
                width: 5,
              ),
              Expanded(
                  child: Container(
                      transform: Matrix4.translationValues(0.0, 1.2, 0.0),
                      child: TextField(
                          decoration: InputDecoration(
                              border: InputBorder.none, hintText: "Tìm kiếm", hintStyle: TextStyle(fontSize: 15, color: AppColors.hintText)),
                          style: TextStyle(fontSize: 15),
                          enabled: false)))
            ],
          )),
      onTap: () {
        Navigator.pushNamed(context, Routers.Search);
      },
    );
  }

  Widget buildScreen() {
    return buildListCategories();
  }

  Widget buildPromotions() {
    return StreamBuilder(
        stream: listPromotionViewModel.promotionStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Promotion> promotions = snapshot.data;

            return Stack(
              children: [
                CarouselSlider.builder(
                  itemCount: snapshot.data.length,
                  carouselController: carouselController,
                  options: CarouselOptions(
                    initialPage: 0,
                    height: 170,
                    enlargeCenterPage: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(seconds: 1),
                    autoPlayCurve: Curves.easeInOut,
                    viewportFraction: 1,
                    onPageChanged: (index, reason) => currentPromotionImage.sink.add(index),
                  ),
                  itemBuilder: (context, index, realIndex) => GestureDetector(
                    child: Image.network(
                      "${AppEndpoint.BASE_URL}${promotions[index].imageSource}",
                      height: 170,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PromotionDetail(
                              image: promotions[index].imageSource,
                              title: promotions[index].title,
                              description: promotions[index].description,
                            ),
                          ));
                    },
                  ),
                ),
                Positioned(
                  right: 5,
                  bottom: 5,
                  child: Container(
                    height: 10,
                    child: StreamBuilder(
                      stream: currentPromotionImage.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: promotions.length,
                            itemBuilder: (context, index) => Row(
                              children: [
                                Container(
                                    height: 10,
                                    width: 10,
                                    decoration: BoxDecoration(
                                        color: index == snapshot.data ? Colors.white : Colors.transparent,
                                        border: Border.all(width: 0.8, color: Colors.white),
                                        borderRadius: BorderRadius.all(Radius.circular(5)))),
                                SizedBox(width: 3)
                              ],
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                )
              ],
            );
          } else {
            return MyLoading();
          }
        });
  }

  Widget buildTitle(String title) {
    return Container(
        height: 50,
        color: AppColors.white,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 10),
        child: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)));
  }

  Widget buildHotCategories() {
    return Column(
      children: [
        buildTitle("Danh mục hot"),
        Container(
          color: AppColors.white,
          padding: EdgeInsets.symmetric(horizontal: 3),
          child: StreamBuilder(
            stream: rootCategoriesViewModel.hotCategoriesStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Category> categories = snapshot.data.categories;

                return GridView.count(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    crossAxisCount: 3,
                    childAspectRatio: 1 / 0.9,
                    mainAxisSpacing: 3,
                    crossAxisSpacing: 3,
                    children: List.generate(
                        categories.length + 1,
                        (index) => GestureDetector(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    width: 66,
                                    height: 66,
                                    color: Colors.white,
                                    child: index == 0
                                        ? Image.asset(AppImages.icAllCategories, fit: BoxFit.cover)
                                        : Image.network("${AppEndpoint.BASE_URL}${categories[index - 1].imageSource}",
                                            errorBuilder: (context, error, stackTrace) => Image.asset(AppImages.errorImage, fit: BoxFit.cover))),
                                SizedBox(height: 6),
                                Container(
                                    child: Text(index == 0 ? "DANH MỤC" : categories[index - 1].name.toUpperCase(),
                                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold), textAlign: TextAlign.center))
                              ],
                            ),
                            onTap: () {
                              index == 0
                                  ? MainTabControlDelegate.getInstance().tabJumpTo(1)
                                  : Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => CategoryDetail(category: categories[index - 1], searchContent: null)));
                            })));
              } else {
                return MyLoading();
              }
            },
          ),
        )
      ],
    );
  }

  Widget buildMyPromotion() {
    return Column(
      children: [
        buildTitle("Ưu đãi dành cho bạn"),
        Container(
          height: 160,
          color: AppColors.white,
          padding: EdgeInsets.only(left: 10),
          child: StreamBuilder(
            stream: homeViewModel.myPromotionStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<MyPromotion> myPromotions = snapshot.data;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: myPromotions.length,
                  itemBuilder: (context, index) => Row(
                    children: [
                      GestureDetector(
                        child: Container(
                          height: 160,
                          width: MediaQuery.of(context).size.width * 0.58,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(6))),
                          child: Image.network("${AppEndpoint.BASE_URL}${myPromotions[index].imageSource}", fit: BoxFit.cover),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PromotionDetail(
                                      image: myPromotions[index].imageSource,
                                      title: myPromotions[index].title,
                                      description: myPromotions[index].description)));
                        },
                      ),
                      SizedBox(width: 12)
                    ],
                  ),
                );
              } else {
                return MyLoading();
              }
            },
          ),
        )
      ],
    );
  }

  Widget buildListProduct(Stream<List<Product>> productStream) {
    return Container(
      height: 370,
      color: AppColors.white,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 10),
      child: StreamBuilder(
        stream: productStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Product> listProduct = snapshot.data;

            return ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: listProduct.length,
              itemBuilder: (context, index) => Row(
                children: [Container(height: 175 * 2.2, width: 175, child: ShowOneProduct(product: listProduct[index])), SizedBox(height: 5)],
              ),
            );
          } else {
            return MyLoading();
          }
        },
      ),
    );
  }

  Widget buildNewProducts() {
    return Column(
      children: [buildTitle("Sản phẩm mới"), buildListProduct(homeViewModel.newProductStream)],
    );
  }

  Widget buildSellingProduct() {
    return Column(
      children: [buildTitle("Sản phẩm bán chạy"), buildListProduct(homeViewModel.sellingProductStream)],
    );
  }

  getProductByCategory(Category category, List<int> currentCategoryId) async {
    final currentHomeViewModel = HomeViewModel();
    List<Stream<List<Product>>> currentProductCategory = currentProductCategorySubject.stream.value;
    Stream<List<Product>> productCategory = await currentHomeViewModel.getProductsByCategory(currentCategoryId[currentCategoryId.length - 1]);
    currentProductCategory.add(productCategory);
    if (currentProductCategory.length > 6) {
      currentProductCategory = currentProductCategory.sublist(0, 6);
    }
    currentProductCategorySubject.sink.add(currentProductCategory);
  }

  Widget categoryBuilder(List<dynamic> categories, BuildContext context, int categoryIndex) {
    Category category = categories[categoryIndex];
    List<int> currentCategoryId = currentCategoryIdSubject.stream.value;
    if (currentCategoryId.any((id) => id == category.id) == false) {
      //
      List<int> currentCategory = currentCategorySubject.stream.value;
      currentCategory.add(0);
      currentCategorySubject.sink.add(currentCategory);
      //
      currentCategoryId.add(category.id);
      currentCategoryIdSubject.sink.add(currentCategoryId);
      //
      getProductByCategory(category, currentCategoryId);
    }

    return StreamBuilder(
      stream: currentProductCategorySubject.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print("length: ${snapshot.data.length}");
          print("categoryIndex: $categoryIndex");
          return Column(
            children: [
              buildTitle(category.name),
              Container(
                color: AppColors.white,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: MyNetworkImage(
                    url: "${AppEndpoint.BASE_URL}${category.backgroundImage}", height: 160, width: MediaQuery.of(context).size.width - 30),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.12,
                alignment: Alignment.center,
                color: AppColors.white,
                padding: EdgeInsets.only(left: 10),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.09,
                  color: AppColors.white,
                  alignment: Alignment.centerLeft,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: category.children.length + 1,
                    itemBuilder: (context, childCategoryIndex) {
                      return Row(
                        children: [
                          childCategoryIndex == 0
                              ? buildOneChildCategory(category, categoryIndex, childCategoryIndex, "Tất cả")
                              : buildOneChildCategory(category, categoryIndex, childCategoryIndex, category.children[childCategoryIndex - 1].name),
                          SizedBox(height: 10, child: Container(color: AppColors.white)),
                        ],
                      );
                    },
                  ),
                ),
              ),
              buildListProduct(snapshot.data[categoryIndex]),
              Container(
                  height: 30,
                  color: AppColors.white,
                  alignment: Alignment.center,
                  child: GestureDetector(
                      child: Text("Xem thêm", style: TextStyle(color: AppColors.blue, decoration: TextDecoration.underline)),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryDetail(searchContent: null, category: category)));
                      })),
            ],
          );
        } else {
          return MyLoading();
        }
      },
    );
  }

  Widget buildOneChildCategory(Category category, int categoryIndex, int childCategoryIndex, String categoryName) {
    return StreamBuilder(
      stream: currentCategorySubject.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return GestureDetector(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: snapshot.data[categoryIndex] == childCategoryIndex ? AppColors.blue : AppColors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Text(categoryName,
                        style: TextStyle(color: snapshot.data[categoryIndex] == childCategoryIndex ? AppColors.white : AppColors.black, fontSize: 16),
                        textAlign: TextAlign.center)),
              ),
              onTap: () async {
                // Load lại danh sách sản phẩm khi nhấn chọn 1 Child Category
                if (childCategoryIndex > 0) {
                  int childCategoryId = category.children[childCategoryIndex - 1].id;
                  List<int> currentCategoryId = currentCategoryIdSubject.stream.value;
                  currentCategoryId[categoryIndex] = childCategoryId;
                  currentCategoryIdSubject.sink.add(currentCategoryId);
                  //
                  final currentHomeViewModel = HomeViewModel();
                  List<Stream<List<Product>>> currentProductCategory = currentProductCategorySubject.stream.value;
                  Stream<List<Product>> productCategoryStream = await currentHomeViewModel.getProductsByCategory(childCategoryId);
                  currentProductCategory[categoryIndex] = productCategoryStream;
                  currentProductCategorySubject.sink.add(currentProductCategory);
                } else {
                  // Nếu nhấn chọn lại Tất cả (currentCategory = 0)
                  List<int> currentCategoryId = currentCategoryIdSubject.stream.value;
                  currentCategoryId[categoryIndex] = category.id;
                  currentCategoryIdSubject.sink.add(currentCategoryId);
                  //
                  final currentHomeViewModel = HomeViewModel();
                  List<Stream<List<Product>>> currentProductCategory = currentProductCategorySubject.stream.value;
                  Stream<List<Product>> productCategoryStream = await currentHomeViewModel.getProductsByCategory(category.id);
                  currentProductCategory[categoryIndex] = productCategoryStream;
                  currentProductCategorySubject.sink.add(currentProductCategory);
                }
                List<int> currentCategory = currentCategorySubject.stream.value;
                currentCategory[categoryIndex] = childCategoryIndex;
                currentCategorySubject.sink.add(currentCategory);
                if (currentCategorySubject.stream.value.length > 6) {
                  currentCategorySubject.sink.add(currentCategorySubject.stream.value.sublist(0, 6));
                }
                if (currentCategoryIdSubject.stream.value.length > 6) {
                  currentCategoryIdSubject.sink.add(currentCategoryIdSubject.stream.value.sublist(0, 6));
                }
                print("currentCategory List: ${currentCategorySubject.stream.value}");
                print("currentCategoryId List: ${currentCategoryIdSubject.stream.value}");
              });
        } else {
          return Container();
        }
      },
    );
  }

  Widget buildListCategories() {
    return MyListView.build(
        header: ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            buildPromotions(),
            buildHotCategories(),
            SizedBox(height: 10, child: Container(color: AppColors.white)),
            buildMyPromotion(),
            SizedBox(height: 10, child: Container(color: AppColors.white)),
            buildNewProducts(),
            SizedBox(height: 10, child: Container(color: AppColors.white)),
            buildSellingProduct(),
            SizedBox(height: 10, child: Container(color: AppColors.white)),
          ],
        ),
        itemBuilder: categoryBuilder,
        dataRequester: homeViewModel.dataRequester,
        initRequester: homeViewModel.initRequester);
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
