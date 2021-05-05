import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/CategoriesScreens/ProductDetail/ProductDetail_viewmodel.dart';
import 'package:projectui/src/presentation/CategoriesScreens/RatingAndComment/RatingAndComment_screen.dart';
import 'package:projectui/src/presentation/presentation.dart';
import 'package:projectui/src/presentation/widgets/MyListView.dart';
import 'package:projectui/src/presentation/widgets/MyLoading.dart';
import 'package:projectui/src/presentation/widgets/MyNetworkImage.dart';
import 'package:projectui/src/presentation/widgets/ShowPath.dart';
import 'package:projectui/src/presentation/widgets/ShowRating.dart';
import 'package:projectui/src/presentation/widgets/ShowMoney.dart';
import 'package:projectui/src/resource/model/CommentModel.dart';
import 'package:projectui/src/resource/model/DetailProductModel.dart';
import 'package:projectui/src/resource/model/ListProductsModel.dart';
import 'package:projectui/src/resource/model/ViewedProductLocalStorage.dart';
import 'package:projectui/src/utils/app_utils.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../Installment/Installment_screen.dart';
import '../WritingComment/WritingComment_screen.dart';

class ProductDetail extends StatefulWidget {
  ProductDetail({Key key, this.productId, this.productVideoLink}) : super(key: key);
  int productId;
  String productVideoLink;

  @override
  ProductDetailState createState() => ProductDetailState();
}

class ProductDetailState extends State<ProductDetail> with ResponsiveWidget {
  final productDetailViewModel = ProductDetailViewModel();
  final subImageProductSubject = BehaviorSubject<List<dynamic>>(); // list ảnh phụ
  final currentSubImageSubject = BehaviorSubject<int>();
  final currentColorProductSubject = BehaviorSubject<int>();
  CarouselController carouselController = CarouselController();
  final showFullProductInfoSubject = BehaviorSubject<bool>();
  YoutubePlayerController youtubePlayerController;
  final showFullBrandInfoSubject = BehaviorSubject<bool>();
  final purchasedTogetherProductSubject = BehaviorSubject<List<bool>>();
  final showFullPurchasedTogetherProductSubject = BehaviorSubject<bool>();
  final countCheckPurchasedTogetherProductSubject = BehaviorSubject<int>();
  final countRelatedProductLoadedSubject = BehaviorSubject<int>();
  bool isLogin; // biến kiểm tra xem user đã login chưa để quyết định cách show phần Sản phẩm đã xem
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Product product;

  @override
  void initState() {
    checkLogin();
    productDetailViewModel.getSingleProduct(widget.productId);
    productDetailViewModel.ratingInfoByProduct(widget.productId);
    productDetailViewModel.getReviewByProduct(widget.productId);
    productDetailViewModel.purchasedTogetherProducts(widget.productId);
    productDetailViewModel.getRelatedProducts(widget.productId, 0);
    currentSubImageSubject.sink.add(0);
    currentColorProductSubject.sink.add(-1);
    showFullProductInfoSubject.sink.add(false);
    if (widget.productVideoLink != null) {
      youtubePlayerController = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(widget.productVideoLink),
        flags: YoutubePlayerFlags(mute: false, autoPlay: false, disableDragSeek: true, loop: false, enableCaption: false),
      );
    }
    showFullBrandInfoSubject.sink.add(false);
    showFullPurchasedTogetherProductSubject.sink.add(false);
    countCheckPurchasedTogetherProductSubject.sink.add(0);
    countRelatedProductLoadedSubject.sink.add(0);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ViewedProductLocalStorage>(context, listen: false).addViewedProduct(widget.productId);
    });
  }

  checkLogin() async {
    isLogin = await AppUtils.checkLogin();
    if (isLogin) productDetailViewModel.getViewedProducts();
  }

  @override
  void dispose() {
    super.dispose();
    productDetailViewModel.dispose();
    subImageProductSubject.close();
    currentSubImageSubject.close();
    currentColorProductSubject.close();
    showFullProductInfoSubject.close();
    showFullBrandInfoSubject.close();
    purchasedTogetherProductSubject.close();
    showFullPurchasedTogetherProductSubject.close();
    countCheckPurchasedTogetherProductSubject.close();
    countRelatedProductLoadedSubject.close();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: productDetailViewModel,
        builder: (context, viewModel, child) => Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              titleSpacing: 0,
              title: Text("Chi tiết sản phẩm"),
            ),
            body: buildUi(context: context)));
  }

  Widget buildScreen() {
    return Column(
      children: [buildProductDetailContainer(), buildBottomBar()],
    );
  }

  Widget buildProductDetailContainer() {
    return Expanded(
      child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: StreamBuilder(
            stream: productDetailViewModel.productDetailStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                product = snapshot.data.product;
                List<ShopAddress> shopAddress = snapshot.data.shopAddress;
                Rating rating = snapshot.data.rating;

                return ListView(shrinkWrap: true, physics: BouncingScrollPhysics(), children: [
                  buildGeneralInfoContainer(product, rating),
                  buildLineSpacing(),
                  product.gifts.length > 0 ? buildGiftsContainer(product.gifts) : Container(),
                  product.gifts.length > 0 ? buildLineSpacing() : Container(),
                  buildShopAddressContainer(shopAddress),
                  buildLineSpacing(),
                  buildProductInfoContainer(product.content),
                  buildLineSpacing(),
                  buildProductSpecificationsContainer(product.specifications),
                  buildLineSpacing(),
                  buildProductVideoContainer(product.videoLink),
                  buildLineSpacing(),
                  buildBrandInfoContainer(product.brandInfo),
                  buildLineSpacing(),
                  buildProductRatingAndComments(product.id),
                  buildLineSpacing(),
                  buildPurchasedTogetherProducts(product.id),
                  buildLineSpacing(),
                  buildRelatedProducts(product.id),
                  buildLineSpacing(),
                  buildViewedProducts(),
                ]);
              } else {
                return MyLoading();
              }
            },
          )),
    );
  }

  Widget buildLineSpacing() {
    return Container(
      height: 10,
      color: Colors.grey.shade300,
    );
  }

  // build phần thông tin chung gồm path, ảnh, color, name, star&comment, price, discount, status, installment của sản phẩm
  Widget buildGeneralInfoContainer(Product product, Rating rating) {
    return Column(
      children: [
        buildProductPath(product.category.parent != null ? product.category.parent.name : null, product.category.name),
        buildProductImagesAndColors(product.imageSource, product.imageSourceList, product.colors),
        buildProductName(product.name),
        buildProductRating(product.star, rating.totalRateUser),
        buildProductPrice(product.salePrice, product.price, product.saleOff),
        buildProductStatus(product.goodsStatus),
        buildProductInstallment(product.isInstallment)
      ],
    );
  }

  Widget buildProductPath(String parentName, String childName) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: ShowPath(
        rootTab: "Danh mục",
        parentTab: parentName,
        childTab: childName,
      ),
    );
  }

  Widget buildProductImagesAndColors(String imageSource, List<String> imageSourceList, List<dynamic> colors) {
    subImageProductSubject.sink.add(imageSourceList);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          // build main image
          StreamBuilder(
            stream: subImageProductSubject.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return CarouselSlider.builder(
                  itemCount: snapshot.data.length,
                  carouselController: carouselController,
                  options: CarouselOptions(
                    initialPage: 0,
                    height: MediaQuery.of(context).size.height * 0.5,
                    enlargeCenterPage: true,
                    viewportFraction: 1,
                    onPageChanged: (index, reason) => currentSubImageSubject.sink.add(index),
                  ),
                  itemBuilder: (context, index, realIndex) => MyNetworkImage(
                    url: "${AppEndpoint.BASE_URL}${snapshot.data[index]}",
                  ),
                );
              } else {
                return MyLoading();
              }
            },
          ),
          // build sub images
          Container(
            height: 110,
            alignment: Alignment.centerLeft,
            child: StreamBuilder(
              stream: subImageProductSubject.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) => Row(
                            children: [
                              GestureDetector(
                                child: StreamBuilder(
                                  stream: currentSubImageSubject.stream,
                                  builder: (context, snapshot2) => Container(
                                      height: 90,
                                      width: 90,
                                      decoration: BoxDecoration(
                                          border: index == snapshot2.data
                                              ? Border.all(width: 2, color: Colors.blue)
                                              : Border.all(width: 0, color: Colors.white),
                                          borderRadius: BorderRadius.all(Radius.circular(4))),
                                      child: Container(
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4))),
                                        child: MyNetworkImage(
                                          url: "${AppEndpoint.BASE_URL}${snapshot.data[index]}",
                                        ),
                                      )),
                                ),
                                onTap: () {
                                  carouselController.jumpToPage(index);
                                  currentSubImageSubject.sink.add(index);
                                },
                              ),
                              SizedBox(width: 3)
                            ],
                          ));
                } else {
                  return MyLoading();
                }
              },
            ),
          ),
          // build product colors
          colors.length > 0
              ? Container(
                  height: 43,
                  alignment: Alignment.centerLeft,
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: colors.length,
                      itemBuilder: (context, index) => Row(
                            children: [
                              GestureDetector(
                                child: StreamBuilder(
                                    stream: currentColorProductSubject.stream,
                                    builder: (context, snapshot2) => Container(
                                          height: 43,
                                          width: 95,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: Colors.grey.withOpacity(0.5),
                                              border: index == snapshot2.data
                                                  ? Border.all(width: 2, color: Colors.blue)
                                                  : Border.all(width: 0, color: Colors.white),
                                              borderRadius: BorderRadius.all(Radius.circular(4))),
                                          child: Text(
                                            colors[index]["name"],
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        )),
                                onTap: () {
                                  currentColorProductSubject.sink.add(index);
                                  subImageProductSubject.sink.add(colors[index]["image_source"]);
                                  carouselController.jumpToPage(0);
                                },
                              ),
                              SizedBox(width: 5)
                            ],
                          )),
                )
              : Container()
        ],
      ),
    );
  }

  Widget buildProductName(String productName) {
    return Padding(
        padding: EdgeInsets.only(top: 10),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.centerLeft,
          child: Text(
            productName,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ));
  }

  Widget buildProductRating(int star, int totalComments) {
    return Padding(
        padding: EdgeInsets.only(top: 5),
        child: Row(
          children: [
            Container(padding: EdgeInsets.only(left: 10, right: 3), child: ShowRating(star: star, starSize: 24)),
            GestureDetector(
              child: Text(
                "(Xem $totalComments nhận xét)",
                style: TextStyle(fontSize: 12, color: Colors.blue),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => RatingAndComment()));
              },
            )
          ],
        ));
  }

  Widget buildProductPrice(int salePrice, int price, int saleOff) {
    return Container(
      height: 30,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ShowMoney(
                  price: salePrice,
                  fontSizeLarge: 15,
                  fontSizeSmall: 13,
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  isLineThrough: false),
            ],
          ),
          SizedBox(width: 3),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 3),
                child: ShowMoney(
                    price: price,
                    fontSizeLarge: 11,
                    fontSizeSmall: 9,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    isLineThrough: true),
              )
            ],
          ),
          Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 30,
                width: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Text("-$saleOff%", style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500)),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildProductStatus(int goodsStatus) {
    return Container(
        height: 40,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Text("Tình trạng: ", style: TextStyle(fontSize: 13)),
            SizedBox(width: 2),
            Text(getGoodsStatus(goodsStatus),
                style: TextStyle(fontSize: 13, color: goodsStatus == 1 ? Colors.green : Colors.red, fontWeight: FontWeight.bold)),
          ],
        ));
  }

  String getGoodsStatus(int goodsStatus) {
    switch (goodsStatus) {
      case 1:
        return "Còn hàng";
      case 2:
        return "Hết hàng";
      case 3:
        return "Ngừng kinh doanh";
      default:
        return "";
    }
  }

  Widget buildProductInstallment(int isInstallment) {
    if (isInstallment == 1) {
      return Container(
          height: 55,
          alignment: Alignment.topCenter,
          child: GestureDetector(
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.5,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: Colors.orange.shade700, borderRadius: BorderRadius.all(Radius.circular(4))),
                child: Center(
                    child: Text("Đặt mua trả góp", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600))),
              ),
              onTap: () => handlePurchaseButton("Đặt mua trả góp")));
    } else {
      return Container();
    }
  }

  // build phần Quà tặng kèm
  Widget buildGiftsContainer(List<Gift> gifts) {
    return Column(
      children: [
        // build Title
        Container(
          height: 50,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Image.asset(AppImages.icGift, height: 24, width: 24),
              SizedBox(width: 10),
              Text("Quà tặng kèm:", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue.shade700))
            ],
          ),
        ),
        // build List gifts
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: gifts.length,
              itemBuilder: (context, index) => Column(
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              padding: EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                  border: Border.all(width: 0.5, color: Colors.black.withOpacity(0.5)),
                                  borderRadius: BorderRadius.all(Radius.circular(4))),
                              clipBehavior: Clip.antiAlias,
                              child: MyNetworkImage(url: "${AppEndpoint.BASE_URL}${gifts[index].imageSource}"),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                height: 60,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(gifts[index].name, style: TextStyle(fontSize: 14)),
                                    ShowMoney(
                                        price: gifts[index].price,
                                        fontSizeLarge: 14,
                                        fontSizeSmall: 11,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                        isLineThrough: false)
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 10)
                    ],
                  )),
        ),
        SizedBox(height: 5)
      ],
    );
  }

  // build phần Địa chỉ Shop
  Widget buildShopAddressContainer(List<ShopAddress> shopAddress) {
    return Column(
      children: [
        // build Title
        buildTitleContainer("Hệ thống KingBuy", 50, Alignment.centerLeft),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: ListView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemCount: shopAddress.length,
            itemBuilder: (context, index) => Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(AppImages.icPin, height: 24, width: 24, color: AppColors.primary),
                    SizedBox(width: 5),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("KingBuy", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary)),
                        SizedBox(height: 5),
                        Text(shopAddress[index].address, style: TextStyle(fontSize: 14)),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Image.asset(AppImages.icPhone, height: 14, width: 14, color: Colors.blue),
                            SizedBox(width: 5),
                            GestureDetector(
                              child: Text(shopAddress[index].hotLine,
                                  style: TextStyle(fontSize: 14, color: Colors.blue, decoration: TextDecoration.underline)),
                              onTap: () => AppUtils.handlePhone(context, shopAddress[index].hotLine),
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 10)
              ],
            ),
          ),
        ),
        SizedBox(height: 5)
      ],
    );
  }

  // build phần Thông tin sản phẩm
  Widget buildProductInfoContainer(String productInfo) {
    return StreamBuilder(
        stream: showFullProductInfoSubject.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: snapshot.data ? null : MediaQuery.of(context).size.height * 0.5,
                      child: ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          buildTitleContainer("Thông tin sản phẩm", 32.5, Alignment.bottomLeft),
                          Html(data: productInfo, padding: EdgeInsets.symmetric(horizontal: 10)),
                        ],
                      ),
                    ),
                    snapshot.data
                        ? Container()
                        : Container(
                            height: snapshot.data ? null : MediaQuery.of(context).size.height * 0.5,
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: snapshot.data ? null : MediaQuery.of(context).size.height * 0.25,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                stops: [
                                  0.1,
                                  0.35,
                                  0.6,
                                  0.85,
                                ],
                                colors: [
                                  Colors.white.withOpacity(0.75),
                                  Colors.white.withOpacity(0.5),
                                  Colors.white.withOpacity(0.3),
                                  Colors.white.withOpacity(0.1),
                                ],
                              )),
                            ),
                          )
                  ],
                ),
                Container(
                    height: 40,
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(snapshot.data ? "Rút gọn" : "Xem tất cả", style: TextStyle(fontSize: 14, color: Colors.blue)),
                          SizedBox(width: 5),
                          Icon(snapshot.data ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, size: 18, color: Colors.blue)
                        ],
                      ),
                      onTap: () {
                        showFullProductInfoSubject.sink.add(!showFullProductInfoSubject.stream.value);
                      },
                    ))
              ],
            );
          } else {
            return MyLoading();
          }
        });
  }

  // build phần Thông số kỹ thuật
  Widget buildProductSpecificationsContainer(String productSpecifications) {
    return Column(
      children: [
        buildTitleContainer("Thông số kỹ thuật", 32.5, Alignment.bottomLeft),
        Html(padding: EdgeInsets.fromLTRB(10, 5, 10, 0), data: productSpecifications),
        SizedBox(height: 15)
      ],
    );
  }

  // build phần Video sản phẩm
  Widget buildProductVideoContainer(String productVideoLink) {
    return Column(
      children: [
        buildTitleContainer("Video", 50, Alignment.centerLeft),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.centerLeft,
            child: productVideoLink == null
                ? Container()
                : Container(
                    child: YoutubePlayer(controller: youtubePlayerController, showVideoProgressIndicator: true),
                  )),
        productVideoLink == null ? Container() : SizedBox(height: 15)
      ],
    );
  }

  // build phần Thông tin Thương hiệu
  Widget buildBrandInfoContainer(String brandInfo) {
    return StreamBuilder(
        stream: showFullBrandInfoSubject.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Container(
                  height: brandInfo != null ? (snapshot.data ? null : MediaQuery.of(context).size.height * 0.25) : null,
                  child: ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      buildTitleContainer("Thông tin thương hiệu", 32.5, Alignment.bottomLeft),
                      brandInfo != null ? Html(data: brandInfo, padding: EdgeInsets.symmetric(horizontal: 10)) : Container(),
                    ],
                  ),
                ),
                brandInfo != null
                    ? Container(
                        height: 40,
                        color: Colors.white,
                        alignment: Alignment.center,
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(snapshot.data ? "Rút gọn" : "Xem tất cả", style: TextStyle(fontSize: 14, color: Colors.blue)),
                              SizedBox(width: 5),
                              Icon(snapshot.data ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, size: 18, color: Colors.blue)
                            ],
                          ),
                          onTap: () {
                            showFullBrandInfoSubject.sink.add(!showFullBrandInfoSubject.stream.value);
                          },
                        ))
                    : Container(
                        height: 15,
                      )
              ],
            );
          } else {
            return MyLoading();
          }
        });
  }

  // build phần Đánh giá & Bình luận
  Widget buildProductRatingAndComments(int productId) {
    return Column(
      children: [
        buildTitleContainer("Đánh giá & Bình luận", 50, Alignment.centerLeft),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                StreamBuilder(
                  stream: productDetailViewModel.ratingInfoStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Row(
                        children: [
                          Container(
                            height: 100,
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Đánh giá trung bình", style: TextStyle(fontSize: 14)),
                                SizedBox(height: 5),
                                Text("(${snapshot.data.ratingCount.toString()} đánh giá)",
                                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
                                SizedBox(height: 5),
                                Text("${snapshot.data.avgRating.toString()}/5",
                                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
                              ],
                            ),
                          ),
                          Expanded(
                              child: Container(
                            height: 100,
                            child: ListView.builder(
                              shrinkWrap: true,
                              reverse: true,
                              physics: BouncingScrollPhysics(),
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                int oneRatingCount = index == 0
                                    ? snapshot.data.oneStarCount
                                    : (index == 1
                                        ? snapshot.data.twoStarCount
                                        : (index == 2
                                            ? snapshot.data.threeStarCount
                                            : (index == 3 ? snapshot.data.fourStarCount : snapshot.data.fiveStarCount)));

                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text((index + 1).toString(), style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
                                        SizedBox(width: 3),
                                        Icon(Icons.star_rounded, size: 13, color: Colors.grey.shade600),
                                        SizedBox(width: 3),
                                        Stack(
                                          children: [
                                            Container(
                                              height: 13,
                                              width: MediaQuery.of(context).size.width * 0.261,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey.shade400, borderRadius: BorderRadius.all(Radius.circular(6.5))),
                                            ),
                                            Container(
                                              height: 13,
                                              width: snapshot.data.ratingCount != 0
                                                  ? MediaQuery.of(context).size.width *
                                                      0.261 *
                                                      (oneRatingCount * 1.0 / snapshot.data.ratingCount)
                                                  : 0,
                                              decoration: BoxDecoration(
                                                  color: Colors.yellow.shade700, borderRadius: BorderRadius.all(Radius.circular(6.5))),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: 7),
                                        Text("${oneRatingCount.toString()} đánh giá",
                                            style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
                                      ],
                                    ),
                                    SizedBox(height: 5)
                                  ],
                                );
                              },
                            ),
                          ))
                        ],
                      );
                    } else {
                      return MyLoading();
                    }
                  },
                ),
                SizedBox(height: 10),
                GestureDetector(
                    child: Container(
                        height: 45,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: AppColors.primary), borderRadius: BorderRadius.all(Radius.circular(6))),
                        child: Text("Viết đánh giá", style: TextStyle(fontSize: 14, color: Colors.red))),
                    onTap: () async {
                      if (await AppUtils.checkLogin()) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WritingComment(),
                            ));
                      } else {
                        AppUtils.myShowDialog(context, widget.productId, widget.productVideoLink);
                      }
                    }),
                SizedBox(height: 15),
                StreamBuilder(
                  stream: productDetailViewModel.commentInfoStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: snapshot.data.totalRecords > 3 ? 3 : snapshot.data.totalRecords,
                          itemBuilder: (context, index) {
                            Comment comment = snapshot.data.comments[index];

                            return Column(
                              children: [
                                Container(height: 0.5, color: Colors.black.withOpacity(0.3)),
                                SizedBox(height: 15),
                                Container(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundImage: NetworkImage(
                                        "${AppEndpoint.BASE_URL}${comment.avatarSource}",
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text("${comment.name}", style: TextStyle(fontSize: 12)),
                                            SizedBox(width: 10),
                                            comment.isBuy == 1 ? Image.asset(AppImages.icSuccess, height: 12, width: 12) : Container(),
                                            comment.isBuy == 1 ? SizedBox(width: 3) : Container(),
                                            comment.isBuy == 1
                                                ? Text("Đã mua hàng ở KingBuy", style: TextStyle(fontSize: 12, color: Colors.green))
                                                : Container(),
                                            Spacer(),
                                            comment.phoneNumber != ""
                                                ? Text(comment.phoneNumber.substring(0, 6) + "****",
                                                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500))
                                                : Container()
                                          ],
                                        ),
                                        Container(height: 18, child: ShowRating(star: comment.star, starSize: 12)),
                                        Container(
                                          child: Text(comment.comment, style: TextStyle(fontSize: 14)),
                                        ),
                                        SizedBox(height: 10),
                                        Text(DateFormat("dd-MM-yyyy").format(comment.createdAt),
                                            style: TextStyle(fontSize: 12, color: Colors.grey.shade500))
                                      ],
                                    ))
                                  ],
                                )),
                                SizedBox(height: 10),
                              ],
                            );
                          });
                    } else {
                      return MyLoading();
                    }
                  },
                ),
                Container(
                    height: 40,
                    decoration: BoxDecoration(border: Border(top: BorderSide(width: 0.5, color: Colors.black.withOpacity(0.3)))),
                    child: GestureDetector(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Xem tất cả",
                            style: TextStyle(fontSize: 14, color: Colors.blue),
                          ),
                          SizedBox(width: 5),
                          Icon(Icons.arrow_forward_ios, size: 12, color: Colors.blue)
                        ],
                      ),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => RatingAndComment()));
                      },
                    ))
              ],
            )),
      ],
    );
  }

  // build phần Sản phẩm mua cùng
  Widget buildPurchasedTogetherProducts(int productId) {
    return Column(
      children: [
        buildTitleContainer("Sản phẩm mua cùng", 50, Alignment.centerLeft),
        Container(
            child: StreamBuilder(
          stream: productDetailViewModel.purchasedTogetherProductsStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<bool> checkList = [];
              for (int i = 0; i < snapshot.data.length; i++) {
                checkList.add(false);
              }
              purchasedTogetherProductSubject.sink.add(checkList);

              return snapshot.data.length > 0
                  ? Column(
                      children: [
                        // build Image PurchasedTogetherProducts
                        Container(
                            height: 100,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  Product product = snapshot.data[index];

                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      MyNetworkImage(url: "${AppEndpoint.BASE_URL}${product.imageSource}", height: 100, width: 100),
                                      index != snapshot.data.length - 1
                                          ? Container(height: 90, width: 60, child: Center(child: Icon(Icons.add, size: 34)))
                                          : Container()
                                    ],
                                  );
                                })),
                        SizedBox(height: 15),
                        // build List PurchasedTogetherProducts (name + checkbox)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: StreamBuilder(
                            stream: showFullPurchasedTogetherProductSubject.stream,
                            builder: (context, snapshot2) {
                              if (snapshot2.hasData) {
                                return snapshot2.data
                                    ? Column(
                                        children: [
                                          ListView.builder(
                                            shrinkWrap: true,
                                            physics: BouncingScrollPhysics(),
                                            itemCount: snapshot.data.length,
                                            itemBuilder: (context, index) {
                                              Product product = snapshot.data[index];

                                              return Column(
                                                children: [
                                                  StreamBuilder(
                                                    stream: purchasedTogetherProductSubject.stream,
                                                    builder: (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        return Row(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Container(
                                                                height: 25,
                                                                width: 18,
                                                                alignment: Alignment.topLeft,
                                                                child: Checkbox(
                                                                    value: snapshot.data[index],
                                                                    activeColor: AppColors.primary,
                                                                    onChanged: (value) {
                                                                      snapshot.data[index]
                                                                          ? countCheckPurchasedTogetherProductSubject.sink.add(
                                                                              countCheckPurchasedTogetherProductSubject.stream.value - 1)
                                                                          : countCheckPurchasedTogetherProductSubject.sink.add(
                                                                              countCheckPurchasedTogetherProductSubject.stream.value + 1);
                                                                      checkList.replaceRange(index, index + 1, [!snapshot.data[index]]);
                                                                      purchasedTogetherProductSubject.sink.add(checkList);
                                                                    })),
                                                            SizedBox(width: 12),
                                                            GestureDetector(
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Container(
                                                                        width: MediaQuery.of(context).size.width - 50,
                                                                        child: Text(product.name, style: TextStyle(fontSize: 14))),
                                                                    SizedBox(height: 4),
                                                                    ShowMoney(
                                                                        price: product.salePrice,
                                                                        color: Colors.black,
                                                                        fontSizeLarge: 14,
                                                                        fontSizeSmall: 11,
                                                                        fontWeight: FontWeight.bold,
                                                                        isLineThrough: false)
                                                                  ],
                                                                ),
                                                                onTap: () {
                                                                  snapshot.data[index]
                                                                      ? countCheckPurchasedTogetherProductSubject.sink
                                                                          .add(countCheckPurchasedTogetherProductSubject.stream.value - 1)
                                                                      : countCheckPurchasedTogetherProductSubject.sink
                                                                          .add(countCheckPurchasedTogetherProductSubject.stream.value + 1);
                                                                  checkList.replaceRange(index, index + 1, [!snapshot.data[index]]);
                                                                  purchasedTogetherProductSubject.sink.add(checkList);
                                                                })
                                                          ],
                                                        );
                                                      } else {
                                                        return MyLoading();
                                                      }
                                                    },
                                                  ),
                                                  SizedBox(height: 15)
                                                ],
                                              );
                                            },
                                          ),
                                          SizedBox(height: 5),
                                          StreamBuilder(
                                            stream: countCheckPurchasedTogetherProductSubject.stream,
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                return GestureDetector(
                                                    child: Container(
                                                      height: 40,
                                                      width: MediaQuery.of(context).size.width * 0.8,
                                                      decoration: BoxDecoration(
                                                          color: AppColors.primary, borderRadius: BorderRadius.all(Radius.circular(20))),
                                                      alignment: Alignment.center,
                                                      child: Text("Thêm ${snapshot.data} sản phẩm vào giỏ hàng",
                                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                                                    ),
                                                    onTap: () {
                                                      print("Thêm vào giỏ hàng");
                                                    });
                                              } else {
                                                return MyLoading();
                                              }
                                            },
                                          )
                                        ],
                                      )
                                    : Container();
                              } else {
                                return MyLoading();
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                            height: 40,
                            color: Colors.white,
                            child: StreamBuilder(
                              stream: showFullPurchasedTogetherProductSubject.stream,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(snapshot.data ? "Rút gọn" : "Xem tất cả", style: TextStyle(fontSize: 14, color: Colors.blue)),
                                        SizedBox(width: 5),
                                        Icon(snapshot.data ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                            size: 18, color: Colors.blue)
                                      ],
                                    ),
                                    onTap: () {
                                      showFullPurchasedTogetherProductSubject.sink
                                          .add(!showFullPurchasedTogetherProductSubject.stream.value);
                                    },
                                  );
                                } else {
                                  return MyLoading();
                                }
                              },
                            ))
                      ],
                    )
                  : Container();
            } else {
              return MyLoading();
            }
          },
        )),
      ],
    );
  }

  // build phần Sản phẩm liên quan
  Widget buildRelatedProducts(int productId) {
    return Column(
      children: [
        buildTitleContainer("Sản phẩm liên quan", 50, Alignment.centerLeft),
        StreamBuilder(
          stream: Rx.combineLatest2(
              productDetailViewModel.relatedProductStream, countRelatedProductLoadedSubject.stream, (stream1, stream2) => stream1),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // để tránh trường hợp loadmore ở tận cùng danh sách sẽ bị trả về snapshot.data.length = 0, ta khai báo 1 stream
              // countRelatedProductLoaded để kiểm soát số lượng relatedProduct đã load ra
              countRelatedProductLoadedSubject.sink.add(countRelatedProductLoadedSubject.stream.value + snapshot.data.length);

              return snapshot.data.length > 0 || countRelatedProductLoadedSubject.stream.value > 0
                  ? Column(
                      children: [
                        Container(height: 370, padding: EdgeInsets.symmetric(horizontal: 10), child: listRelatedProducts()),
                        SizedBox(height: 15)
                      ],
                    )
                  : Container();
            } else {
              return MyLoading();
            }
          },
        )
      ],
    );
  }

  Widget itemRelatedProductBuilder(List<dynamic> relatedProducts, BuildContext context, int index) {
    Product relatedProduct = relatedProducts[index];

    return Container(height: 175 * 2.2, width: 175, child: ShowOneProduct(product: relatedProduct));
  }

  Future<List<Product>> initRelatedProductRequester() async {
    return await productDetailViewModel.getRelatedProducts(widget.productId, 0);
  }

  Future<List<Product>> dataRelatedProductRequester(int currentSize) async {
    return await productDetailViewModel.getRelatedProducts(widget.productId, currentSize);
  }

  Widget listRelatedProducts() {
    return MyListView.build(
        scrollDirection: Axis.horizontal,
        itemBuilder: itemRelatedProductBuilder,
        dataRequester: dataRelatedProductRequester,
        initRequester: initRelatedProductRequester);
  }

  // build phần Sản phẩm đã xem
  buildViewedProducts() {
    List<int> idViewedProducts = Provider.of<ViewedProductLocalStorage>(context).idViewedProducts;

    return Column(
      children: [
        buildTitleContainer("Sản phẩm đã xem", 50, Alignment.centerLeft),
        isLogin
            ? Container(
                height: 370,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: StreamBuilder(
                  stream: productDetailViewModel.viewedProductsStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) =>
                            Container(height: 175 * 2.2, width: 175, child: ShowOneProduct(product: snapshot.data[index])),
                      );
                    } else {
                      return MyLoading();
                    }
                  },
                ))
            : Container(alignment: Alignment.center, child: Text("Id Viewed Products: $idViewedProducts")),
        SizedBox(height: 10),
        Container(
          height: 40,
          color: Colors.white,
          alignment: Alignment.center,
          child: GestureDetector(
            child: Text("Xem thêm", style: TextStyle(fontSize: 14, color: Colors.blue, decoration: TextDecoration.underline)),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ViewedProducts()));
            },
          ),
        )
      ],
    );
  }

  Widget buildTitleContainer(String title, double height, Alignment alignment) {
    return Container(
      height: height,
      padding: EdgeInsets.symmetric(horizontal: 10),
      alignment: alignment,
      child: Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
    );
  }

  Widget buildBottomBar() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          buildBottomBarItem(MediaQuery.of(context).size.width * 0.15 - 0.5, Colors.white, AppImages.icZalo, 24, false, "Chat Zalo", 11,
              Colors.black, true, handleChatZalo),
          buildVerticalSeperateLine(8, 0.5, Colors.grey),
          buildBottomBarItem(MediaQuery.of(context).size.width * 0.22 - 0.5, Colors.white, AppImages.icMessenger, 24, false,
              "Chat Facebook", 11, Colors.black, true, () => AppUtils.handleMessenger(context)),
          buildVerticalSeperateLine(8, 0.5, Colors.grey),
          buildBottomBarItem(MediaQuery.of(context).size.width * 0.28, Colors.white, AppImages.icShoppingCart, 24, true,
              "Thêm vào giỏ hàng", 11, Colors.black, true, handleAddToCart),
          buildBottomBarItem(MediaQuery.of(context).size.width * 0.35, AppColors.primary, null, null, false, "Mua ngay", 13, Colors.white,
              false, () => handlePurchaseButton("Mua ngay")),
        ],
      ),
    );
  }

  Widget buildVerticalSeperateLine(double paddingVertical, double width, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: paddingVertical),
      child: Container(
        width: width,
        color: color,
      ),
    );
  }

  Widget buildBottomBarItem(double containerWidth, Color containerColor, String iconSource, double iconSize, bool iconColor, String title,
      double titleSize, Color titleColor, bool isShowIcon, Function action) {
    return GestureDetector(
      child: Container(
        width: containerWidth,
        color: containerColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            isShowIcon ? Image.asset(iconSource, height: iconSize, width: iconSize, color: iconColor ? Colors.black : null) : Container(),
            isShowIcon
                ? SizedBox(
                    height: 2,
                  )
                : Container(),
            Text(
              title,
              style: TextStyle(fontSize: titleSize, color: titleColor, fontWeight: FontWeight.w400),
            )
          ],
        ),
      ),
      onTap: action,
    );
  }

  handleChatZalo() {
    print("handleChatZalo()");
  }

  handleAddToCart() {
    print("handleAddToCart()");
  }

  // hàm này sử dụng cho cả 2 button "Đặt mua trả góp" và "Mua ngay"
  void handlePurchaseButton(String buttonContent) async {
    // if (await AppUtils.checkLogin()) {
    //   if (product.goodsStatus == 1) {
    //     if (buttonContent == "Mua ngay") {
    //       print("Handle Mua ngay");
    //     } else {
    //       Navigator.push(context, MaterialPageRoute(builder: (context) => InstallmentScreen()));
    //     }
    //   } else {
    //     print("Sản phẩm đã hết hàng");
    //   }
    // } else {
    //   AppUtils.myShowDialog(scaffoldKey.currentContext, widget.productId, widget.productVideoLink);
    // }
    print("Handle Mua ngay");
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
