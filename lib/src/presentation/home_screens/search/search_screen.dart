import 'package:flutter/material.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/home_screens/home_screens.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/presentation/presentation.dart';
import 'package:projectui/src/resource/model/list_products_model.dart';

class SearchScreen extends StatefulWidget {
  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> with ResponsiveWidget {
  SearchViewModel searchViewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: SearchViewModel(),
        onViewModelReady: (viewModel) => searchViewModel = viewModel..init(),
        builder: (context, viewModel, child) => Scaffold(
            appBar: AppBar(
              title: Container(
                  height: 34,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.all(Radius.circular(18))),
                  child: Row(
                    children: [
                      Image.asset(AppImages.icSearch, height: 18, width: 18),
                      SizedBox(width: 10),
                      Expanded(
                          child: Container(
                              transform: Matrix4.translationValues(0.0, 1.2, 0.0),
                              child: TextField(
                                controller: searchViewModel.searchController,
                                decoration: InputDecoration(
                                    border: InputBorder.none, hintText: "Tìm kiếm", hintStyle: TextStyle(fontSize: 15, color: AppColors.hintText)),
                                style: TextStyle(fontSize: 15),
                                onChanged: (value) async {
                                  searchViewModel.onChangeSearchContent(value);
                                },
                                onSubmitted: (value) async {
                                  searchViewModel.onSubmitSearchContent(value);
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
            body: buildUi(context: context)));
  }

  Widget buildScreen() {
    return StreamBuilder(
      stream: searchViewModel.searchContentSubject.stream,
      builder: (context, snapshot) {
        if (snapshot.data == "" || snapshot.data == null) {
          return StreamBuilder(
            stream: searchViewModel.listSearchSubject.stream,
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
                                      searchViewModel.onDeleteSearchHistory();
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
            stream: searchViewModel.searchedProductSubject.stream,
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
                              onTap: () {
                                searchViewModel.onTapOneSearchResult(searchedProduct[index]);
                              }),
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
