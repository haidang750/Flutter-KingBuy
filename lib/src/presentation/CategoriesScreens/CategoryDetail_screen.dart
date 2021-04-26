import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/CategoriesScreens/CategoryDetail_viewmodel.dart';
import 'package:projectui/src/presentation/CategoriesScreens/PriceRange.dart';
import 'package:projectui/src/presentation/presentation.dart';
import 'package:projectui/src/presentation/widgets/MyGridViewButton.dart';
import 'package:projectui/src/presentation/widgets/MyNetworkImage.dart';
import 'package:projectui/src/presentation/widgets/ShowOneProduct.dart';
import 'package:projectui/src/presentation/widgets/ShowPath.dart';
import 'package:projectui/src/resource/model/BrandModel.dart';
import 'package:projectui/src/resource/model/CategoryModel.dart';
import 'package:projectui/src/resource/model/ProductModel.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import 'ClipPathClass.dart';

List<PriceRange> priceRanges = [
  PriceRange(id: 1, name: "0 - 10 triệu", from: 0, to: 10000000),
  PriceRange(id: 2, name: "10 - 20 triệu", from: 10000000, to: 20000000),
  PriceRange(id: 3, name: "20 - 50 triệu", from: 20000000, to: 50000000),
  PriceRange(id: 4, name: "50 - 100 triệu", from: 50000000, to: 100000000),
];

class CategoryDetail extends StatefulWidget {
  CategoryDetail({Key key, this.category}) : super(key: key);
  Category category;

  @override
  CategoryDetailState createState() => CategoryDetailState();
}

class CategoryDetailState extends State<CategoryDetail> {
  final rootCategoriesViewModel = RootCategoriesViewModel();
  final categoryDetailViewModel = CategoryDetailViewModel();
  final keyGridViewButton = GlobalKey<MyGridViewButtonState>();
  final currentCategorySubject = BehaviorSubject<int>();
  final searchController = TextEditingController();
  final searchSubject = BehaviorSubject<String>();
  final categoryIdSubject = BehaviorSubject<int>(); // Dùng trong màn hình [Chi tiết danh mục]/[Danh sách sản phẩm]
  final filterButtonSubject = BehaviorSubject<bool>();

  // Dưới đây là danh sách các biến dùng cho Filter Screen
  final priceFromController = TextEditingController();
  final priceToController = TextEditingController();
  final idCategorySubject = BehaviorSubject<int>(); // Dùng để thay đổi UI (ClipPath) khi nhấn chọn category khác (theo id)
  final nameCategorySubject = BehaviorSubject<String>(); // Dùng để quản lý giá trị tên danh mục mà ta chọn để lọc
  final idBrandSubject = BehaviorSubject<int>(); // Dùng để thay đổi UI (ClipPath) khi nhấn chọn brand khác (theo id)
  final nameBrandSubject = BehaviorSubject<String>(); // Dùng để quản lý giá trị tên thương hiệu mà ta chọn để lọc
  final idPriceSubject = BehaviorSubject<int>(); // Dùng để thay đổi UI (ClipPath) khi nhấn chọn priceRange khác (theo id)
  final namePriceRangeSubject = BehaviorSubject<String>(); // Dùng để quản lý giá trị range giá mà ta chọn để lọc
  List<Category> listCategories = []; // Dùng để lưu toàn bộ categories lấy về từ API
  List<Brand> listBrands = []; // Dùng để lưu toàn bộ brands lấy về từ API
  List<Category> listCategoriesPartition = []; // Dùng để lưu các category lấy ra từ listCategories
  List<Brand> listBrandsPartition = []; // Dùng để lưu các brand lấy ra từ listBrands
  final listCategoriesSubject = BehaviorSubject<List<Category>>(); // Dùng cho StreamBuilder của Danh mục/GridView.builder
  final listBrandsSubject = BehaviorSubject<List<Brand>>(); // Dùng cho StreamBuilder của Thương hiệu/GridView.builder
  final listPriceRangesSubject = BehaviorSubject<List<PriceRange>>();
  final categoryButtonSubject = BehaviorSubject<String>(); // Dùng cho StreamBuilder của Danh mục/Button Xem thêm-Rút gọn
  final brandButtonSubject = BehaviorSubject<String>(); // Dùng cho StreamBuilder của Thương hiệu/Button Xem thêm-Rút gọn
  final applyButtonSubject = BehaviorSubject<bool>();

  @override
  void initState() {
    super.initState();
    categoryIdSubject.add(widget.category.id);
    searchController.text = "";
    getListCategories();
    getListBrands();
  }

  getListCategories() async {
    listCategories = await rootCategoriesViewModel.getAllCategories();
    listCategoriesPartition.addAll(listCategories.getRange(0, 4));
  }

  getListBrands() async {
    listBrands = await categoryDetailViewModel.getBrands();
    listBrandsPartition.addAll(listBrands.getRange(0, 4));
  }

  @override
  void dispose() {
    super.dispose();
    searchSubject.close();
    categoryIdSubject.close();
    filterButtonSubject.close();
    idPriceSubject.close();
    listCategoriesSubject.close();
    listBrandsSubject.close();
    listPriceRangesSubject.close();
    categoryButtonSubject.close();
    brandButtonSubject.close();
    idCategorySubject.close();
    idBrandSubject.close();
    nameCategorySubject.close();
    nameBrandSubject.close();
    namePriceRangeSubject.close();
    applyButtonSubject.close();
    currentCategorySubject.close();
  }

  @override
  Widget build(BuildContext context) {
    print("Recall build function");
    searchSubject.sink.add(searchController.text);
    filterButtonSubject.sink.add(false);
    currentCategorySubject.sink.add(0);
    listCategoriesSubject.sink.add(listCategoriesPartition);
    listBrandsSubject.sink.add(listBrandsPartition);
    listPriceRangesSubject.sink.add(priceRanges);
    categoryButtonSubject.sink.add("Xem thêm");
    brandButtonSubject.sink.add("Xem thêm");
    idCategorySubject.sink.add(0);
    idBrandSubject.sink.add(0);
    idPriceSubject.sink.add(0);
    applyButtonSubject.sink.add(false);

    return Stack(
      children: [buildCategoryDetailContainer(), buildFilterContainer()],
    );
  }

  // {* build UI màn hình Filter *} //
  // Nghiệp vụ phần Filter: Khi vào màn hình 1 category bất kỳ thì màn hình Filter không có phần Danh mục và sẽ mặc định filter theo id của
  // danh mục đó. Chỉ khi ta tìm kiếm theo cách nhập searchWord thì màn hình Filter mới có phần Danh mục.
  // Nghiệp vụ phần TextField search: Dù ở màn hình của bất kỳ category nào thì chỗ search này đều search theo tất cả sản phẩm có trong hệ
  // thống chứ không phải các sản phẩm thuộc category đó.

  // build UI Filter = Phần bên trái (Outside) + Phần bên phải (Inside)
  Widget buildFilterContainer() {
    return StreamBuilder(
      stream: filterButtonSubject.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data
              ? Row(
                  children: [buildOutside(), buildInside()],
                )
              : Container();
        } else {
          return Center(child: SpinKitCircle(color: Colors.blue, size: 36));
        }
      },
    );
  }

  Widget buildOutside() {
    return Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: GestureDetector(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.15,
            color: Colors.black.withOpacity(0.7),
          ),
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
            filterButtonSubject.sink.add(false);
          },
        ));
  }

  Widget buildInside() {
    return Expanded(
        child: Material(
      type: MaterialType.transparency,
      child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [buildHeader(), buildBody()],
            ),
          )),
    ));
  }

  // build Header của phần Inside
  Widget buildHeader() {
    return Container(
        height: 55,
        color: Colors.blue,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 15),
        child: Row(
          children: [
            Image.asset(
              "assets/filter_black.png",
              height: 22,
              width: 22,
              color: Colors.white,
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              "BỘ LỌC TÌM KIẾM",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            )
          ],
        ));
  }

  // build Body của phần Inside = 3 option (Danh mục - Thương hiệu - Giá) + phần TextField nhập giá + phần Button action
  Widget buildBody() {
    return Expanded(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: ListView(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            children: [
              searchSubject.stream.value != ""
                  ? buildFilterOption("Danh mục", listCategoriesSubject, idCategorySubject, true, categoryButtonSubject, listCategories,
                      listCategoriesPartition)
                  : Container(),
              searchSubject.stream.value != "" ? SizedBox(height: 30) : Container(),
              buildFilterOption(
                  "Thương hiệu", listBrandsSubject, idBrandSubject, true, brandButtonSubject, listBrands, listBrandsPartition),
              SizedBox(height: 30),
              buildFilterOption("Giá", listPriceRangesSubject, idPriceSubject, false, null, [], []),
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
  Widget buildFilterOption(String optionTitle, BehaviorSubject listSubject, BehaviorSubject idSubject, bool isShowButton,
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
                        childAspectRatio: 3 / 1.1,
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
                                        border: snapshot2.data == snapshot.data[index].id
                                            ? Border.all(width: 1, color: Colors.red.shade700)
                                            : null,
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
                                              decoration: BoxDecoration(
                                                  color: Colors.red.shade700, borderRadius: BorderRadius.all(Radius.circular(8)))),
                                        )
                                      : Container()
                                ],
                              ),
                              onTap: () {
                                idSubject.sink.add(snapshot.data[index].id);
                              },
                            ),
                          ));
                } else {
                  return Center(
                    child: SpinKitCircle(color: Colors.blue, size: 36),
                  );
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
                              border: Border.all(width: 0.5, color: Colors.blue), borderRadius: BorderRadius.all(Radius.circular(20))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                snapshot.data,
                                style: TextStyle(fontSize: 13, color: Colors.blue, decoration: TextDecoration.underline),
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Icon(
                                snapshot.data == "Xem thêm" ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                                size: 16,
                                color: Colors.blue,
                              )
                            ],
                          )),
                      onTap: () {
                        if (snapshot.data == "Xem thêm") {
                          listPartition.addAll(listOriginal.getRange(4, listOriginal.length));
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
                    return Center(child: SpinKitCircle(color: Colors.blue, size: 14));
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
          borderColor: Colors.grey.shade400,
          borderRadius: 8,
          textController: index == 0 ? priceFromController : priceToController,
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
        buildOneButton("Thiết lập lại", Colors.grey, handleSetUpButton),
        SizedBox(
          width: 10,
        ),
        buildOneButton("Áp dụng", Colors.red.shade700, handleApplyButton)
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
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
        onTap: buttonAction);
  }

  handleSetUpButton() {
    priceFromController.clear();
    priceToController.clear();
    idCategorySubject.sink.add(0);
    idBrandSubject.sink.add(0);
    idPriceSubject.sink.add(0);
  }

  handleApplyButton() async {
    CategoryDetailViewModel filterCategoryDetailViewModel = priceFromController.text != "" && priceToController.text != ""
        ? CategoryDetailViewModel(
            productCategoryId: searchSubject.stream.value != "" ? idCategorySubject.stream.value : widget.category.id,
            brandId: idBrandSubject.stream.value,
            priceFrom: int.parse(priceFromController.text),
            priceTo: int.parse(priceToController.text))
        : idPriceSubject.stream.value - 1 >= 0
            ? CategoryDetailViewModel(
                productCategoryId: searchSubject.stream.value != "" ? idCategorySubject.stream.value : widget.category.id,
                brandId: idBrandSubject.stream.value,
                priceFrom: priceRanges[idPriceSubject.stream.value - 1].from,
                priceTo: priceRanges[idPriceSubject.stream.value - 1].to)
            : CategoryDetailViewModel(
                productCategoryId: searchSubject.stream.value != "" ? idCategorySubject.stream.value : widget.category.id,
                brandId: idBrandSubject.stream.value,
              );
    filterButtonSubject.sink.add(false);
    applyButtonSubject.sink.add(!applyButtonSubject.stream.value);
  }

  // {* build UI màn hình CategoryDetail *} //

  Widget buildCategoryDetailContainer() {
    return Scaffold(
        appBar: buildAppBar(),
        body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: StreamBuilder(
                    stream: searchSubject.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        // Nếu đã submit nội dung search thì build searchedProductList
                        if (snapshot.data != "") {
                          CategoryDetailViewModel searchedCategoryDetailViewModel = CategoryDetailViewModel(searchWord: snapshot.data);

                          return Container(
                              padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                              child: KeyedSubtree(
                                key: UniqueKey(),
                                child: MyGridViewButton(
                                  itemBuilder: itemBuilder,
                                  dataRequester: searchedCategoryDetailViewModel.dataRequesterSearchedProduct,
                                  initRequester: searchedCategoryDetailViewModel.initRequesterSearchedProduct,
                                  childAspectRatio: 1 / 2.26,
                                  crossAxisCount: 2,
                                ),
                              ));
                        } else {
                          // ngược lại build màn hình CategoryDetail
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
                        }
                      } else {
                        return Center(child: SpinKitCircle(color: Colors.blue, size: 36));
                      }
                    }))));
  }

  Widget buildAppBar() {
    return AppBar(
      titleSpacing: 0,
      title: buildSearchContainer(),
      centerTitle: true,
      actions: [
        buildFilterButton(),
      ],
    );
  }

  Widget buildSearchContainer() {
    return Container(
        width: MediaQuery.of(context).size.width * 0.72,
        height: 36,
        padding: EdgeInsets.only(left: 10),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(18))),
        child: Row(
          children: [
            Image.asset(
              "assets/search.jpg",
              height: 20,
              width: 20,
            ),
            SizedBox(
              width: 5,
            ),
            Expanded(
                child: Row(
              children: [
                Expanded(
                  // build vùng nhập nội dung tìm kiếm
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: "Tìm kiếm", hintStyle: TextStyle(fontSize: 16, color: Colors.grey.shade500)),
                    style: TextStyle(fontSize: 16),
                    onSubmitted: (value) {
                      print(123123);
                      String oldValue = searchSubject.stream.value;
                      if (oldValue != value) searchSubject.sink.add(value);
                    },
                  ),
                ),
                // build button cancel để xóa nội dung tìm kiếm đã nhập
                StreamBuilder(
                  stream: searchSubject.stream,
                  builder: (context, snapshot) {
                    if (snapshot.data != "") {
                      return Container(
                          width: 35,
                          child: IconButton(
                            icon: Icon(
                              Icons.cancel,
                              color: Colors.grey,
                            ),
                            iconSize: 18,
                            onPressed: () {
                              searchController.clear();
                              searchSubject.sink.add("");
                            },
                          ));
                    } else {
                      return Container();
                    }
                  },
                )
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
            "assets/filter_black.png",
            height: 22,
            width: 22,
            color: Colors.white,
          ),
          Text(
            "Lọc",
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
          )
        ]),
        onTap: () {
          filterButtonSubject.sink.add(true);
        },
      ),
    );
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
      height: MediaQuery.of(context).size.height * 0.14,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        alignment: Alignment.centerLeft,
        child: ListView.builder(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: widget.category.children.length + 1,
          itemBuilder: (context, index) {
            return Row(
              children: [
                index == 0
                    ? buildOneChildCategory(index, "Tất cả")
                    : buildOneChildCategory(index, widget.category.children[index - 1].name),
                SizedBox(
                  width: 10,
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildOneChildCategory(int index, String categoryName) {
    return StreamBuilder(
      stream: currentCategorySubject.stream,
      builder: (context, snapshot) => GestureDetector(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: snapshot.data == index ? Colors.blue : Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                ),
                child: Text(categoryName,
                    style: TextStyle(color: snapshot.data == index ? Colors.white : Colors.black, fontSize: 16),
                    textAlign: TextAlign.center)),
          ),
          onTap: () {
            // Load lại danh sách sản phẩm khi nhấn chọn 1 Child Category
            if (index > 0) {
              int childCategoryId = widget.category.children[index - 1].id;
              categoryIdSubject.add(childCategoryId);
            } else {
              // Nếu nhấn chọn lại Tất cả (currentCategory = 0)
              categoryIdSubject.add(widget.category.id);
            }
            currentCategorySubject.sink.add(index);
          }),
    );
  }

  Widget itemBuilder(List<Product> products, BuildContext context, int index) {
    Product product = products[index];
    return ShowOneProduct(
      product: product,
    );
  }

  Widget buildListProducts() {
    return StreamBuilder(
      stream: Rx.combineLatest2(categoryIdSubject.stream, applyButtonSubject.stream, (stream1, stream2) => stream1),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          CategoryDetailViewModel categoryDetailViewModel = priceFromController.text != "" && priceToController.text != ""
              ? CategoryDetailViewModel(
                  productCategoryId: snapshot.data,
                  brandId: idBrandSubject.stream.value,
                  priceFrom: int.parse(priceFromController.text),
                  priceTo: int.parse(priceToController.text))
              : idPriceSubject.stream.value - 1 >= 0
                  ? CategoryDetailViewModel(
                      productCategoryId: snapshot.data,
                      brandId: idBrandSubject.stream.value,
                      priceFrom: priceRanges[idPriceSubject.stream.value - 1].from,
                      priceTo: priceRanges[idPriceSubject.stream.value - 1].to)
                  : CategoryDetailViewModel(
                      productCategoryId: snapshot.data,
                      brandId: idBrandSubject.stream.value,
                    );
          return KeyedSubtree(
            key: UniqueKey(),
            child: MyGridViewButton(
              itemBuilder: itemBuilder,
              dataRequester: categoryDetailViewModel.dataRequesterCategoryProduct,
              initRequester: categoryDetailViewModel.initRequesterCategoryProduct,
              childAspectRatio: 1 / 2.26,
              crossAxisCount: 2,
            ),
          );
          ;
        } else {
          return Center(
            child: SpinKitCircle(
              color: Colors.blue,
              size: 36,
            ),
          );
        }
      },
    );
  }

  Widget buildCategoryDescription(String categoryName, String categoryDescription) {
    return Container(
        color: Colors.grey.shade400,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Container(
              height: 50,
              alignment: Alignment.centerLeft,
              child: Text(categoryName, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ),
            HtmlWidget(categoryDescription, customStylesBuilder: (element) => {'text-align': 'left'}),
            SizedBox(
              height: 20,
            )
          ],
        ));
  }
}
