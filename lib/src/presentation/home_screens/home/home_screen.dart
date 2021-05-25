import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/navigation/navigation_screen.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/presentation/presentation.dart';
import 'package:projectui/src/presentation/widgets/my_list_view.dart';
import 'package:projectui/src/presentation/widgets/my_loading.dart';
import 'package:projectui/src/resource/model/category_model.dart';
import 'package:projectui/src/resource/model/promotion_model.dart';
import 'package:projectui/src/resource/model/model.dart';
import 'package:projectui/src/presentation/home_screens/home/home_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with ResponsiveWidget {
  HomeViewModel homeViewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        showPhone: true,
        mainScreen: true,
        viewModel: HomeViewModel(),
        onViewModelReady: (viewModel) => homeViewModel = viewModel..init(context),
        builder: (context, viewModel, child) => Scaffold(appBar: buildAppBar(), body: buildUi(context: context)));
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
                  stream: homeViewModel.cartBadgeSubject.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Stack(
                        children: [
                          GestureDetector(
                            child: Container(
                              transform: Matrix4.translationValues(0.0, snapshot.data != 0 ? 0 : 4, 0.0),
                              child: Image.asset(AppImages.icShoppingCart, height: 26, width: 26, color: AppColors.white),
                            ),
                            onTap: () {
                              homeViewModel.onTapShoppingCartIcon(context);
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
        stream: homeViewModel.promotionStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Promotion> promotions = snapshot.data;

            return Stack(
              children: [
                CarouselSlider.builder(
                  itemCount: snapshot.data.length,
                  carouselController: homeViewModel.carouselController,
                  options: CarouselOptions(
                    initialPage: 0,
                    height: 170,
                    enlargeCenterPage: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(seconds: 1),
                    autoPlayCurve: Curves.easeInOut,
                    viewportFraction: 1,
                    onPageChanged: (index, reason) => homeViewModel.currentPromotionImage.sink.add(index),
                  ),
                  itemBuilder: (context, index, realIndex) => GestureDetector(
                    child: Image.network(
                      "${AppEndpoint.BASE_URL}${promotions[index].imageSource}",
                      height: 170,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                    onTap: () {
                      homeViewModel.onTapPromotion(promotions[index]);
                    },
                  ),
                ),
                Positioned(
                  right: 5,
                  bottom: 5,
                  child: Container(
                    height: 10,
                    child: StreamBuilder(
                      stream: homeViewModel.currentPromotionImage.stream,
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
            stream: homeViewModel.hotCategoriesStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Category> categories = snapshot.data;

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
                          homeViewModel.onTapMyPromotion(myPromotions[index]);
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

  Widget categoryBuilder(List<dynamic> categories, BuildContext context, int categoryIndex) {
    Category category = categories[categoryIndex];
    List<int> currentCategoryId = homeViewModel.currentCategoryId;
    if (currentCategoryId.any((id) => id == category.id) == false) {
      //
      List<int> currentCategory = homeViewModel.currentCategory;
      currentCategory.add(0);
      homeViewModel.currentCategorySubject.sink.add(currentCategory);
      //
      currentCategoryId.add(category.id);
      homeViewModel.currentCategoryIdSubject.sink.add(currentCategoryId);
      //
      homeViewModel.getProductByChildCategory(category, currentCategoryId);
    }

    return StreamBuilder(
      stream: homeViewModel.currentProductCategorySubject.stream,
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
      stream: homeViewModel.currentCategorySubject.stream,
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
              onTap: () {
                homeViewModel.onTapChildCategory(childCategoryIndex, categoryIndex, category);
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
