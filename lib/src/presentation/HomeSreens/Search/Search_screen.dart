import 'package:flutter/material.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/CategoriesScreens/CategoriesScreens.dart';
import 'package:projectui/src/presentation/HomeSreens/HomeScreens.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/presentation/presentation.dart';
import 'package:projectui/src/resource/model/ListProductsModel.dart';
import 'package:projectui/src/utils/app_shared.dart';
import 'package:rxdart/rxdart.dart';

class SearchScreen extends StatefulWidget {
  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> with ResponsiveWidget {
  final searchViewModel = SearchViewModel();
  final searchController = TextEditingController();
  final searchContentSubject = BehaviorSubject<String>();
  final listSearchSubject = BehaviorSubject<List<String>>();
  final searchedProductSubject = BehaviorSubject<List<Product>>();

  @override
  void initState() {
    super.initState();
    setState(() {
      searchController.text = "";
    });
    searchContentSubject.sink.add(searchController.text);
    getListSearch();
    searchedProductSubject.sink.add([]);
  }

  getListSearch() async {
    listSearchSubject.sink.add(await AppShared.getListSearch());
  }

  @override
  void dispose() {
    super.dispose();
    listSearchSubject.close();
    searchedProductSubject.close();
    searchContentSubject.close();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: searchViewModel,
        builder: (context, viewModel, child) => GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: Scaffold(
                  appBar: AppBar(
                    title: Container(
                        height: 34,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.all(Radius.circular(18))),
                        child: Row(
                          children: [
                            Image.asset(
                              AppImages.icSearch,
                              height: 18,
                              width: 18,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: Container(
                                    transform: Matrix4.translationValues(0.0, 1.2, 0.0),
                                    child: TextField(
                                      controller: searchController,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Tìm kiếm",
                                          hintStyle: TextStyle(fontSize: 15, color: AppColors.hintText)),
                                      style: TextStyle(fontSize: 15),
                                      onChanged: (value) async {
                                        searchContentSubject.sink.add(value);
                                        CategoryDetailViewModel searchedCategoryDetailViewModel = CategoryDetailViewModel(
                                          searchWord: value,
                                          productCategoryId: 0,
                                          brandId: 0,
                                          limit: 6
                                        );

                                        List<Product> searchedProduct = await searchedCategoryDetailViewModel.loadDataSearchedProduct(0);
                                        searchedProductSubject.sink.add(searchedProduct);
                                      },
                                      onSubmitted: (value) async {
                                        // Lưu từ khóa đã search vào Local
                                        if (value != "") {
                                          if (listSearchSubject.stream.value == null) {
                                            List<String> listSearch = [];
                                            listSearch.add(value);
                                            listSearchSubject.sink.add(listSearch);
                                            AppShared.setListSearch(listSearchSubject.stream.value);
                                          } else {
                                            List<String> listSearch = listSearchSubject.stream.value;
                                            listSearch.add(value);
                                            listSearchSubject.sink.add(listSearch);
                                            AppShared.setListSearch(listSearchSubject.stream.value);
                                          }
                                        }
                                        Navigator.push(
                                            context, MaterialPageRoute(builder: (context) => CategoryDetail(searchContent: searchController.text)));
                                      },
                                    )))
                          ],
                        )),
                    automaticallyImplyLeading: false,
                    actions: [
                      GestureDetector(
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 20, 10, 10),
                            child: Container(
                                transform: Matrix4.translationValues(-3, 0, 0),
                                child: Text("Hủy", style: TextStyle(fontSize: 14, color: AppColors.white)))),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                  body: buildUi(context: context)),
            ));
  }

  Widget buildScreen() {
    return StreamBuilder(
      stream: searchContentSubject.stream,
      builder: (context, snapshot) {
        if (snapshot.data == "" || snapshot.data == null) {
          return StreamBuilder(
            stream: listSearchSubject.stream,
            builder: (context, snapshot1) {
              if (snapshot1.data != null) {
                List<String> listSearch = snapshot1.data;

                return Container(
                  color: AppColors.grey2,
                  child: ListView.builder(
                      itemCount: listSearch.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Container(
                              height: 50,
                              color: AppColors.white,
                              padding: EdgeInsets.symmetric(horizontal: 40),
                              alignment: Alignment.centerLeft,
                              child: Text(listSearch[index]),
                            ),
                            Container(
                              height: 0.5,
                              color: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Container(
                                color: AppColors.grey3,
                              ),
                            ),
                            index == listSearch.length - 1
                                ? GestureDetector(
                                    child: Container(
                                      height: 50,
                                      color: AppColors.white,
                                      alignment: Alignment.center,
                                      child: Text("Xóa lịch sử tìm kiếm"),
                                    ),
                                    onTap: () async {
                                      listSearchSubject.sink.add(null);
                                      AppShared.setListSearch(null);
                                    },
                                  )
                                : Container()
                          ],
                        );
                      }),
                );
              } else {
                return Container(
                  color: AppColors.grey2,
                );
              }
            },
          );
        } else {
          return StreamBuilder(
            stream: searchedProductSubject.stream,
            builder: (context, snapshot2) {
              if (snapshot2.hasData) {
                List<Product> searchedProduct = snapshot2.data;

                return Container(
                  color: AppColors.grey2,
                  child: ListView.builder(
                    itemCount: searchedProduct.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          GestureDetector(
                            child: Container(
                              height: 50,
                              color: AppColors.white,
                              padding: EdgeInsets.only(left: 40, right: 25),
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Text(searchedProduct[index].name.length > 30
                                      ? searchedProduct[index].name.substring(0, 30) + " ..."
                                      : searchedProduct[index].name),
                                  Spacer(),
                                  MyNetworkImage(url: "${AppEndpoint.BASE_URL}${searchedProduct[index].imageSource}", height: 40, width: 40)
                                ],
                              ),
                            ),
                            onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProductDetail(
                                          product: searchedProduct[index], productId: searchedProduct[index].id, productVideoLink: searchedProduct[index].videoLink)));
                            }
                          ),
                          index != searchedProduct.length - 1
                              ? Container(
                                  height: 0.5,
                                  color: Colors.white,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Container(
                                    color: AppColors.grey3,
                                  ),
                                )
                              : Container()
                        ],
                      );
                    },
                  ),
                );
              } else {
                return Container(
                  color: AppColors.grey2,
                );
              }
            },
          );
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
