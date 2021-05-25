import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/categories_screens/category_detail/category_detail_viewmodel.dart';
import 'package:projectui/src/presentation/presentation.dart';
import 'package:projectui/src/presentation/widgets/my_grid_view_button.dart';
import 'package:projectui/src/presentation/widgets/my_loading.dart';
import 'package:projectui/src/presentation/widgets/my_network_image.dart';
import 'package:projectui/src/presentation/widgets/show_one_product.dart';
import 'package:projectui/src/presentation/widgets/show_path.dart';
import 'package:projectui/src/resource/model/category_model.dart';
import 'package:projectui/src/resource/model/list_products_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_html/flutter_html.dart';

import '../category_utils/clip_path.dart';

class CategoryDetail extends StatefulWidget {
  CategoryDetail({Key key, this.category, this.searchContent}) : super(key: key);
  Category category;
  String searchContent;

  @override
  CategoryDetailState createState() => CategoryDetailState();
}

class CategoryDetailState extends State<CategoryDetail> with ResponsiveWidget {
  CategoryDetailViewModel categoryDetailViewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: CategoryDetailViewModel(),
        onViewModelReady: (viewModel) => categoryDetailViewModel = viewModel..init(widget.category, widget.searchContent),
        builder: (context, viewModel, child) => buildUi(context: context));
  }

  // {* build UI màn hình Filter *} //
  // Nghiệp vụ phần Filter: Khi vào màn hình 1 category bất kỳ thì màn hình Filter không có phần Danh mục và sẽ mặc định filter theo id của
  // danh mục đó. Chỉ khi ta tìm kiếm theo cách nhập searchWord thì màn hình Filter mới có phần Danh mục.
  // Nghiệp vụ phần TextField search: Dù ở màn hình của bất kỳ category nào thì chỗ search này đều search theo tất cả sản phẩm có trong hệ
  // thống chứ không phải các sản phẩm thuộc category đó.

  Widget buildScreen() {
    return Scaffold(
        key: categoryDetailViewModel.scaffoldKey,
        endDrawer: Drawer(
          child: buildFilterContainer(),
        ),
        appBar: buildAppBar(),
        body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: StreamBuilder(
                stream: Rx.combineLatest2(
                    categoryDetailViewModel.searchSubject.stream, categoryDetailViewModel.applyButtonSubject, (stream1, stream2) => stream1),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // Nếu đã submit nội dung search thì build searchedProductList
                    if (snapshot.data != "") {
                      return buildSearchResult(snapshot.data);
                    } else {
                      if (widget.searchContent == null) {
                        return ListView(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          children: [
                            buildOneContainer(buildPath()),
                            buildOneContainer(buildCategoryBackground()),
                            buildOneContainer(buildListChildCategories()),
                            buildOneContainer(buildListProducts()),
                            widget.category.description != null
                                ? buildCategoryDescription(widget.category.name, widget.category.description)
                                : Container()
                          ],
                        );
                      } else {
                        return buildSearchResult(snapshot.data);
                      }
                    }
                  } else {
                    return MyLoading();
                  }
                })));
  }

  Widget buildAppBar() {
    return AppBar(
      titleSpacing: 0,
      title: buildSearchContainer(),
      leading: (ModalRoute.of(context)?.canPop ?? false) ? BackButton() : null,
      centerTitle: true,
      actions: [
        buildFilterButton(),
      ],
    );
  }

  Widget buildSearchContainer() {
    return Container(
        width: MediaQuery.of(context).size.width - 102,
        height: 34,
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
              width: 5,
            ),
            Expanded(
                child: Row(
              children: [
                Expanded(
                  // build vùng nhập nội dung tìm kiếm
                  child: Container(
                    transform: Matrix4.translationValues(0.0, 1.2, 0.0),
                    child: TextField(
                      key: categoryDetailViewModel.formKey,
                      controller: categoryDetailViewModel.searchController,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: "Tìm kiếm", hintStyle: TextStyle(fontSize: 15, color: AppColors.hintText)),
                      style: TextStyle(fontSize: 15),
                      onSubmitted: (value) {
                        categoryDetailViewModel.onSubmitSearchContent(value);
                      },
                    ),
                  ),
                ),
                // build button cancel để xóa nội dung tìm kiếm đã nhập
                widget.searchContent == null
                    ? StreamBuilder(
                        stream: categoryDetailViewModel.searchSubject.stream,
                        builder: (context, snapshot) {
                          if (snapshot.data != "") {
                            return Container(
                                width: 35,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.cancel,
                                    color: AppColors.grey,
                                  ),
                                  iconSize: 18,
                                  onPressed: () {
                                    categoryDetailViewModel.onDeleteSearchContent();
                                  },
                                ));
                          } else {
                            return Container();
                          }
                        },
                      )
                    : Container()
              ],
            ))
          ],
        ));
  }

  Widget buildFilterButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 12, 15, 10),
      child: GestureDetector(
        child: Column(children: [
          Image.asset(
            AppImages.icFilter,
            height: 22,
            width: 22,
            color: AppColors.white,
          ),
          Text(
            "Lọc",
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
          )
        ]),
        onTap: () {
          categoryDetailViewModel.scaffoldKey.currentState.openEndDrawer();
        },
      ),
    );
  }

  Widget buildFilterContainer() {
    return Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [buildHeader(), buildBody()],
        ));
  }

  // build Header của phần Inside
  Widget buildHeader() {
    return Container(
        height: 55,
        color: AppColors.blue,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 15),
        child: Row(
          children: [
            Image.asset(
              AppImages.icFilter,
              height: 22,
              width: 22,
              color: AppColors.white,
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              "BỘ LỌC TÌM KIẾM",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.white),
            )
          ],
        ));
  }

  // build Body của phần Inside = 3 option (Danh mục - Thương hiệu - Giá) + phần TextField nhập giá + phần Button action
  Widget buildBody() {
    return Expanded(
      child: Container(
        color: AppColors.white,
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: ListView(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            children: [
              StreamBuilder(
                stream: categoryDetailViewModel.searchSubject.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data != "") {
                      return Column(
                        children: [
                          buildFilterOption(
                              "Danh mục",
                              categoryDetailViewModel.listCategoriesSubject,
                              categoryDetailViewModel.idCategorySubject,
                              categoryDetailViewModel.nameCategorySubject,
                              true,
                              categoryDetailViewModel.categoryButtonSubject,
                              categoryDetailViewModel.listCategories,
                              categoryDetailViewModel.listCategoriesPartition),
                          SizedBox(height: 30)
                        ],
                      );
                    } else {
                      return Container();
                    }
                  } else {
                    return MyLoading();
                  }
                },
              ),
              buildFilterOption(
                  "Thương hiệu",
                  categoryDetailViewModel.listBrandsSubject,
                  categoryDetailViewModel.idBrandSubject,
                  categoryDetailViewModel.nameBrandSubject,
                  true,
                  categoryDetailViewModel.brandButtonSubject,
                  categoryDetailViewModel.listBrands,
                  categoryDetailViewModel.listBrandsPartition),
              SizedBox(height: 30),
              buildFilterOption("Giá", categoryDetailViewModel.listPriceRangesSubject, categoryDetailViewModel.idPriceSubject,
                  categoryDetailViewModel.namePriceRangeSubject, false, null, [], []),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text("Hoặc nhập giá ở ô dưới", style: TextStyle(fontSize: 14)),
              ),
              SizedBox(height: 5),
              buildInputPrice(),
              SizedBox(height: 25),
              buildButtonContainer(),
              SizedBox(
                height: 15,
              )
            ],
          ),
        ),
      ),
    );
  }

  // Build 3 filter options
  Widget buildFilterOption(String optionTitle, BehaviorSubject listSubject, BehaviorSubject idSubject, BehaviorSubject nameSubject, bool isShowButton,
      BehaviorSubject buttonSubject, List listOriginal, List listPartition) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          optionTitle,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: StreamBuilder(
              stream: listSubject.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 3 / 1,
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) => StreamBuilder(
                            stream: idSubject.stream,
                            builder: (context, snapshot2) => GestureDetector(
                              child: Stack(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.blue.shade200,
                                        border: snapshot2.data == snapshot.data[index].id ? Border.all(width: 1, color: AppColors.primary) : null,
                                        borderRadius: BorderRadius.all(Radius.circular(8))),
                                    child: Text(
                                      snapshot.data[index].name,
                                      style: TextStyle(fontSize: 14),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  snapshot2.data == snapshot.data[index].id
                                      ? ClipPath(
                                          clipper: ClipPathClass(),
                                          child: Container(
                                              decoration:
                                                  BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.all(Radius.circular(8)))),
                                        )
                                      : Container()
                                ],
                              ),
                              onTap: () {
                                idSubject.sink.add(snapshot.data[index].id);
                                nameSubject.sink.add(snapshot.data[index].name);
                              },
                            ),
                          ));
                } else {
                  return MyLoading();
                }
              },
            )),
        SizedBox(height: 15),
        isShowButton
            ? StreamBuilder(
                stream: buttonSubject.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Center(
                        child: GestureDetector(
                      child: Container(
                          height: 30,
                          width: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              border: Border.all(width: 0.5, color: AppColors.blue), borderRadius: BorderRadius.all(Radius.circular(20))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                snapshot.data,
                                style: TextStyle(fontSize: 13, color: AppColors.blue, decoration: TextDecoration.underline),
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Icon(
                                snapshot.data == "Xem thêm" ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                                size: 16,
                                color: AppColors.blue,
                              )
                            ],
                          )),
                      onTap: () {
                        if (snapshot.data == "Xem thêm") {
                          if (listOriginal.length > 4) listPartition.addAll(listOriginal.getRange(4, listOriginal.length));
                          listSubject.sink.add(listPartition);
                          buttonSubject.sink.add("Rút gọn");
                        } else {
                          listPartition.removeRange(4, listPartition.length);
                          listSubject.sink.add(listPartition);
                          buttonSubject.sink.add("Xem thêm");
                        }
                      },
                    ));
                  } else {
                    return Center(child: SpinKitCircle(color: AppColors.blue, size: 14));
                  }
                })
            : Container()
      ],
    );
  }

  // Build phần nhập giá From - To
  Widget buildInputPrice() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 3 / 0.95,
          crossAxisCount: 2,
          crossAxisSpacing: 20,
        ),
        itemCount: 2,
        itemBuilder: (context, index) => BorderTextField(
          textPaddingLeft: 5,
          transformText: -2,
          borderColor: AppColors.borderTextField,
          borderRadius: 8,
          textController: index == 0 ? categoryDetailViewModel.priceFromController : categoryDetailViewModel.priceToController,
          fontSize: 14,
          keyboardType: TextInputType.number,
          hintText: index == 0 ? "Từ 0đ" : "Đến 0đ",
          hintTextFontSize: 14,
          hintTextFontWeight: FontWeight.w300,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // Build 2 button Thiết lập lại và Áp dụng
  Widget buildButtonContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        buildOneButton("Thiết lập lại", AppColors.grey, categoryDetailViewModel.handleResetButton),
        SizedBox(
          width: 10,
        ),
        buildOneButton("Áp dụng", AppColors.primary, categoryDetailViewModel.handleApplyButton)
      ],
    );
  }

  Widget buildOneButton(String buttonContent, Color buttonColor, Function buttonAction) {
    return GestureDetector(
        child: Container(
          height: 32,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(color: buttonColor, borderRadius: BorderRadius.all(Radius.circular(16))),
          child: Text(
            buttonContent,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.buttonContent),
          ),
        ),
        onTap: buttonAction);
  }

  Widget buildSearchResult(String searchContent) {
    CategoryDetailViewModel searchedCategoryDetailViewModel =
        categoryDetailViewModel.priceFromController.text != "" && categoryDetailViewModel.priceToController.text != ""
            ? CategoryDetailViewModel(
                searchWord: searchContent,
                productCategoryId: categoryDetailViewModel.idCategorySubject.stream.value,
                brandId: categoryDetailViewModel.idBrandSubject.stream.value,
                priceFrom: int.parse(categoryDetailViewModel.priceFromController.text),
                priceTo: int.parse(categoryDetailViewModel.priceToController.text))
            : categoryDetailViewModel.idPriceSubject.stream.value - 1 >= 0
                ? CategoryDetailViewModel(
                    searchWord: searchContent,
                    productCategoryId: categoryDetailViewModel.idCategorySubject.stream.value,
                    brandId: categoryDetailViewModel.idBrandSubject.stream.value,
                    priceFrom: categoryDetailViewModel.priceRanges[categoryDetailViewModel.idPriceSubject.stream.value - 1].from,
                    priceTo: categoryDetailViewModel.priceRanges[categoryDetailViewModel.idPriceSubject.stream.value - 1].to)
                : CategoryDetailViewModel(
                    searchWord: searchContent,
                    productCategoryId: categoryDetailViewModel.idCategorySubject.stream.value,
                    brandId: categoryDetailViewModel.idBrandSubject.stream.value,
                  );
    return Container(
        padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
        child: Column(
          children: [
            StreamBuilder(
              stream: categoryDetailViewModel.filterOptionsSubject.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.any((filterOption) => filterOption != "")) {
                    return Container(
                      height: 60,
                      alignment: Alignment.centerLeft,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) => snapshot.data[index] != ""
                              ? Stack(
                                  children: [
                                    Card(
                                        child: Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.symmetric(horizontal: 10),
                                            child: Text(snapshot.data[index], style: TextStyle(fontSize: 15), textAlign: TextAlign.center))),
                                    Positioned(
                                        top: 4,
                                        right: 4,
                                        child: GestureDetector(
                                            child: Icon(Icons.cancel, size: 16, color: AppColors.blue),
                                            onTap: () {
                                              categoryDetailViewModel.handleDeleteFilterOption(index);
                                            }))
                                  ],
                                )
                              : Container()),
                    );
                  } else {
                    return Container();
                  }
                } else {
                  return Container();
                }
              },
            ),
            KeyedSubtree(
              key: UniqueKey(),
              child: MyGridViewButton(
                itemBuilder: itemBuilder,
                dataRequester: searchedCategoryDetailViewModel.dataRequesterSearchedProduct,
                initRequester: searchedCategoryDetailViewModel.initRequesterSearchedProduct,
                childAspectRatio: 1 / 2.2,
                crossAxisCount: 2,
              ),
            )
          ],
        ));
  }

  Widget buildOneContainer(Widget widget) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: widget,
    );
  }

  Widget buildPath() {
    return ShowPath(
      rootTab: "Danh mục",
      parentTab: widget.category.parent != null ? widget.category.parent.name : null,
      childTab: widget.category.name,
    );
  }

  Widget buildCategoryBackground() {
    return widget.category.backgroundImage != null
        ? MyNetworkImage(
            height: MediaQuery.of(context).size.height * 0.26,
            url: "${AppEndpoint.BASE_URL}${widget.category.backgroundImage}",
          )
        : Container();
  }

  Widget buildListChildCategories() {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height * 0.12,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.09,
        alignment: Alignment.centerLeft,
        child: ListView.builder(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: widget.category.children.length + 1,
          itemBuilder: (context, index) {
            return Row(
              children: [
                index == 0 ? buildOneChildCategory(index, "Tất cả") : buildOneChildCategory(index, widget.category.children[index - 1].name),
                SizedBox(width: 5)
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildOneChildCategory(int index, String categoryName) {
    return StreamBuilder(
        stream: categoryDetailViewModel.currentCategorySubject.stream,
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
                        color: snapshot.data == index ? AppColors.blue : AppColors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Text(categoryName,
                          style: TextStyle(color: snapshot.data == index ? AppColors.white : AppColors.black, fontSize: 16),
                          textAlign: TextAlign.center)),
                ),
                onTap: () {
                  categoryDetailViewModel.handleTapOneChildCategory(index, widget.category);
                });
          } else {
            return Container();
          }
        });
  }

  Widget itemBuilder(List<Product> products, BuildContext context, int index) {
    Product product = products[index];
    return ShowOneProduct(
      product: product,
    );
  }

  Widget buildListProducts() {
    return StreamBuilder(
      stream: Rx.combineLatest2(
          categoryDetailViewModel.categoryIdSubject.stream, categoryDetailViewModel.applyButtonSubject.stream, (stream1, stream2) => stream1),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          CategoryDetailViewModel currentCategoryDetailViewModel =
              categoryDetailViewModel.priceFromController.text != "" && categoryDetailViewModel.priceToController.text != ""
                  ? CategoryDetailViewModel(
                      productCategoryId: snapshot.data,
                      brandId: categoryDetailViewModel.idBrandSubject.stream.value,
                      priceFrom: int.parse(categoryDetailViewModel.priceFromController.text),
                      priceTo: int.parse(categoryDetailViewModel.priceToController.text))
                  : categoryDetailViewModel.idPriceSubject.stream.value - 1 >= 0
                      ? CategoryDetailViewModel(
                          productCategoryId: snapshot.data,
                          brandId: categoryDetailViewModel.idBrandSubject.stream.value,
                          priceFrom: categoryDetailViewModel.priceRanges[categoryDetailViewModel.idPriceSubject.stream.value - 1].from,
                          priceTo: categoryDetailViewModel.priceRanges[categoryDetailViewModel.idPriceSubject.stream.value - 1].to)
                      : CategoryDetailViewModel(
                          productCategoryId: snapshot.data,
                          brandId: categoryDetailViewModel.idBrandSubject.stream.value,
                        );
          return KeyedSubtree(
            key: UniqueKey(),
            child: MyGridViewButton(
              itemBuilder: itemBuilder,
              dataRequester: currentCategoryDetailViewModel.dataRequesterCategoryProduct,
              initRequester: currentCategoryDetailViewModel.initRequesterCategoryProduct,
              childAspectRatio: 1 / 2.2,
              crossAxisCount: 2,
            ),
          );
        } else {
          return MyLoading();
        }
      },
    );
  }

  Widget buildCategoryDescription(String categoryName, String categoryDescription) {
    return Container(
        color: Colors.grey.shade400,
        padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
        child: Column(
          children: [
            Container(
              height: 20,
              alignment: Alignment.centerLeft,
              child: Text(categoryName, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ),
            Html(data: categoryDescription),
            SizedBox(
              height: 20,
            )
          ],
        ));
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
