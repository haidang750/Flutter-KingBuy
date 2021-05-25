import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/categories_screens/product_detail/product_detail_viewmodel.dart';
import 'package:projectui/src/presentation/categories_screens/rating_and_comment/rating_and_comment.dart';
import 'package:projectui/src/presentation/presentation.dart';
import 'package:projectui/src/presentation/widgets/my_list_view.dart';
import 'package:projectui/src/presentation/widgets/my_loading.dart';
import 'package:projectui/src/presentation/widgets/my_network_image.dart';
import 'package:projectui/src/presentation/widgets/show_path.dart';
import 'package:projectui/src/presentation/widgets/show_rating.dart';
import 'package:projectui/src/presentation/widgets/show_money.dart';
import 'package:projectui/src/resource/model/comment_model.dart';
import 'package:projectui/src/resource/model/data.dart';
import 'package:projectui/src/resource/model/detail_product_model.dart';
import 'package:projectui/src/resource/model/list_products_model.dart';
import 'package:projectui/src/resource/model/product_question_model.dart';
import 'package:projectui/src/resource/model/model.dart';
import 'package:projectui/src/utils/app_utils.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ProductDetail extends StatefulWidget {
  ProductDetail({Key key, this.productId, this.productVideoLink, this.product}) : super(key: key);
  int productId;
  String productVideoLink;
  Product product;

  @override
  ProductDetailState createState() => ProductDetailState();
}

class ProductDetailState extends State<ProductDetail> with ResponsiveWidget, TickerProviderStateMixin {
  ProductDetailViewModel productDetailViewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: ProductDetailViewModel(),
        onViewModelReady: (viewModel) => productDetailViewModel = viewModel..init(context, widget.productId, widget.productVideoLink, widget.product),
        builder: (context, viewModel, child) =>
            Scaffold(key: productDetailViewModel.scaffoldKey, appBar: buildAppBar(), body: buildUi(context: context)));
  }

  Widget buildAppBar() {
    return AppBar(
      actions: [
        Padding(
            padding: EdgeInsets.fromLTRB(0, 12, 15, 10),
            child: Row(
              children: [
                GestureDetector(
                  child: Image.asset(AppImages.icSearchWhite, height: 26, width: 26),
                  onTap: () {
                    Navigator.pushNamed(context, Routers.Search);
                  },
                ),
                SizedBox(width: 10),
                GestureDetector(
                  child: Image.asset(AppImages.icHome, height: 28, width: 28, color: AppColors.white),
                  onTap: () {
                    Navigator.pushNamed(context, Routers.Navigation);
                  },
                ),
                SizedBox(width: 10),
                Stack(
                  children: [
                    GestureDetector(
                      child: Image.asset(AppImages.icShoppingCart, height: 28, width: 28, color: AppColors.white),
                      onTap: () {
                        productDetailViewModel.onTapShoppingCartIcon();
                      },
                    ),
                    StreamBuilder(
                      stream: productDetailViewModel.cartBadgeSubject.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data == 0) {
                            return Container();
                          } else {
                            return Container(
                                height: 16,
                                width: 16,
                                transform: Matrix4.translationValues(18, -2, 0.0),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.all(Radius.circular(8))),
                                child: Text(snapshot.data.toString(),
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.buttonContent)));
                          }
                        } else {
                          return Container();
                        }
                      },
                    )
                  ],
                ),
              ],
            ))
      ],
    );
  }

  Widget buildScreen() {
    return Column(
      children: [buildProductDetailContainer(), buildBottomBar()],
    );
  }

  Widget buildProductDetailContainer() {
    return Expanded(
      child: SingleChildScrollView(
          // physics: ClampingScrollPhysics(),
          child: StreamBuilder(
        stream: productDetailViewModel.productDetailStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            productDetailViewModel.product = snapshot.data.product;
            List<ShopAddress> shopAddress = snapshot.data.shopAddress;
            Rating rating = snapshot.data.rating;

            return ListView(shrinkWrap: true, physics: BouncingScrollPhysics(), children: [
              buildGeneralInfoContainer(productDetailViewModel.product, rating),
              buildLineSpacing(),
              productDetailViewModel.product.gifts.length > 0 ? buildGiftsContainer(productDetailViewModel.product.gifts) : Container(),
              productDetailViewModel.product.gifts.length > 0 ? buildLineSpacing() : Container(),
              buildShopAddressContainer(shopAddress),
              buildLineSpacing(),
              buildProductInfoContainer(productDetailViewModel.product.content),
              buildLineSpacing(),
              buildProductSpecificationsContainer(productDetailViewModel.product.specifications),
              buildLineSpacing(),
              buildProductVideoContainer(productDetailViewModel.product.videoLink),
              buildLineSpacing(),
              buildBrandInfoContainer(productDetailViewModel.product.brandInfo),
              buildLineSpacing(),
              buildProductRatingAndComments(productDetailViewModel.product.id),
              buildLineSpacing(),
              buildProductQuestions(),
              buildLineSpacing(),
              buildPurchasedTogetherProducts(productDetailViewModel.product.id),
              buildLineSpacing(),
              buildRelatedProducts(productDetailViewModel.product.id),
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
        buildProductRating(),
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
    productDetailViewModel.subImageProductSubject.sink.add(imageSourceList);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          // build main image
          StreamBuilder(
            stream: productDetailViewModel.subImageProductSubject.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return CarouselSlider.builder(
                  itemCount: snapshot.data.length,
                  carouselController: productDetailViewModel.carouselController,
                  options: CarouselOptions(
                    initialPage: 0,
                    height: MediaQuery.of(context).size.height * 0.5,
                    enlargeCenterPage: true,
                    viewportFraction: 1,
                    onPageChanged: (index, reason) => productDetailViewModel.onSwipeProductImage(index),
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
              stream: productDetailViewModel.subImageProductSubject.stream,
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
                                  stream: productDetailViewModel.currentSubImageSubject.stream,
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
                                  productDetailViewModel.onTapProductImage(index);
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
                                    stream: productDetailViewModel.currentColorProductSubject.stream,
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
                                  productDetailViewModel.onTapProductColor(index, colors);
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

  Widget buildProductRating() {
    RatingModel ratingInfo = Provider.of<RatingModel>(context, listen: true);

    return Padding(
        padding: EdgeInsets.only(top: 5),
        child: Row(
          children: [
            Container(
                padding: EdgeInsets.only(left: 10, right: 3),
                child: ShowRating(star: ratingInfo.avgRating != null ? ratingInfo.avgRating : 0, starSize: 24)),
            GestureDetector(
              child: Text(
                "(Xem ${ratingInfo.ratingCount.toString()} nhận xét)",
                style: TextStyle(fontSize: 12, color: Colors.blue),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RatingAndComment(
                            productId: widget.productId,
                            productVideoLink: widget.productVideoLink,
                            isUserRated: productDetailViewModel.isUserRatedSubject.stream.value)));
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
                    price: price, fontSizeLarge: 11, fontSizeSmall: 9, color: Colors.black, fontWeight: FontWeight.normal, isLineThrough: true),
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
    productDetailViewModel.productStatus = goodsStatus;

    return Container(
        height: 40,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Text("Tình trạng: ", style: TextStyle(fontSize: 13)),
            SizedBox(width: 2),
            Text(productDetailViewModel.getGoodsStatus(goodsStatus),
                style: TextStyle(fontSize: 13, color: goodsStatus == 1 ? Colors.green : Colors.red, fontWeight: FontWeight.bold)),
          ],
        ));
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
                child: Center(child: Text("Đặt mua trả góp", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600))),
              ),
              onTap: () => productDetailViewModel.handlePurchaseButton("Đặt mua trả góp", widget.product)));
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
        buildTitleContainer("Hệ thống KingBuy", 50, Alignment.centerLeft, false),
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
                                onTap: () => productDetailViewModel.onTapShopPhone(context, shopAddress, index))
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
        stream: productDetailViewModel.showFullProductInfoSubject.stream,
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
                          buildTitleContainer("Thông tin sản phẩm", 50, Alignment.centerLeft, false),
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
                                stops: [0.1, 0.35, 0.6, 0.85],
                                colors: [
                                  Colors.white.withOpacity(0.75),
                                  Colors.white.withOpacity(0.5),
                                  Colors.white.withOpacity(0.3),
                                  Colors.white.withOpacity(0.1)
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
                        productDetailViewModel.showFullProductInfo();
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
        buildTitleContainer("Thông số kỹ thuật", 32.5, Alignment.bottomLeft, false),
        productSpecifications != null ? Html(padding: EdgeInsets.fromLTRB(10, 5, 10, 0), data: productSpecifications) : Container(),
        SizedBox(height: 15)
      ],
    );
  }

  // build phần Video sản phẩm
  Widget buildProductVideoContainer(String productVideoLink) {
    return Column(
      children: [
        buildTitleContainer("Video", 50, Alignment.centerLeft, false),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.centerLeft,
            child: productVideoLink == null
                ? Container()
                : Container(
                    child: YoutubePlayer(controller: productDetailViewModel.youtubePlayerController, showVideoProgressIndicator: true),
                  )),
        productVideoLink == null ? Container() : SizedBox(height: 15)
      ],
    );
  }

  // build phần Thông tin Thương hiệu
  Widget buildBrandInfoContainer(String brandInfo) {
    return StreamBuilder(
        stream: productDetailViewModel.showFullBrandInfoSubject.stream,
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
                      buildTitleContainer("Thông tin thương hiệu", 32.5, Alignment.bottomLeft, false),
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
                            productDetailViewModel.showFullBrandInfo();
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
    Data userData = Provider.of<Data>(context, listen: false);
    List<Comment> comments = Provider.of<CommentModel>(context, listen: false).comments;
    productDetailViewModel.productCommentSubject.sink.add(comments != null ? comments : []);
    productDetailViewModel.userProfileSubject.sink.add(userData.profile);

    return Column(
      children: [
        buildTitleContainer("Đánh giá & Bình luận", 50, Alignment.centerLeft, false),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                buildRating(),
                SizedBox(height: 10),
                StreamBuilder(
                  stream: Rx.combineLatest2(productDetailViewModel.isUserRatedSubject.stream, productDetailViewModel.userProfileSubject.stream,
                      (stream1, stream2) => stream1),
                  builder: (context, snapshot) {
                    userData.profile != null
                        ? productDetailViewModel.isUserRatedSubject.sink
                            .add(productDetailViewModel.isUserRated(userData.profile.id, productDetailViewModel.productCommentSubject.stream.value))
                        : productDetailViewModel.isUserRatedSubject.sink.add(false);

                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          GestureDetector(
                              child: Container(
                                  height: 45,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      border: Border.all(width: 1, color: snapshot.data ? AppColors.grey : AppColors.primary),
                                      borderRadius: BorderRadius.all(Radius.circular(6))),
                                  child: Text(snapshot.data ? "Đã đánh giá" : "Viết đánh giá",
                                      style: TextStyle(fontSize: 14, color: snapshot.data ? AppColors.grey : AppColors.primary))),
                              onTap: snapshot.data
                                  ? null
                                  : () {
                                      productDetailViewModel.onTapWritingComment(widget.productId, widget.productVideoLink);
                                    }),
                          SizedBox(height: 15)
                        ],
                      );
                    } else {
                      return MyLoading();
                    }
                  },
                ),
                buildComments(),
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
                        productDetailViewModel.showFullRatingAndComments(context, widget.productId, widget.productVideoLink);
                      },
                    ))
              ],
            )),
      ],
    );
  }

  // build phần Đánh giá
  Widget buildRating() {
    RatingModel ratingInfo = Provider.of<RatingModel>(context, listen: true);

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
              Text("(${ratingInfo.ratingCount.toString()} đánh giá)", style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
              SizedBox(height: 5),
              Text("${ratingInfo.avgRating.toString()}/5", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
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
                          ? ratingInfo.oneStarCount
                          : (index == 1
                              ? ratingInfo.twoStarCount
                              : (index == 2 ? ratingInfo.threeStarCount : (index == 3 ? ratingInfo.fourStarCount : ratingInfo.fiveStarCount)));

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
                                    decoration:
                                        BoxDecoration(color: Colors.grey.withOpacity(0.5), borderRadius: BorderRadius.all(Radius.circular(6.5))),
                                  ),
                                  Container(
                                    height: 13,
                                    width: ratingInfo.ratingCount != 0
                                        ? MediaQuery.of(context).size.width *
                                            0.261 *
                                            (oneRatingCount != null ? oneRatingCount * 1.0 / ratingInfo.ratingCount : 0)
                                        : 0,
                                    decoration: BoxDecoration(color: Colors.yellow.shade700, borderRadius: BorderRadius.all(Radius.circular(6.5))),
                                  ),
                                ],
                              ),
                              SizedBox(width: 7),
                              Text("${oneRatingCount.toString()} đánh giá", style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
                            ],
                          ),
                          SizedBox(height: 5)
                        ],
                      );
                    })))
      ],
    );
  }

  // build phần Bình luận
  Widget buildComments() {
    List<Comment> comments = Provider.of<CommentModel>(context, listen: true).comments;

    return comments == null
        ? Container()
        : ListView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            reverse: comments.length > 3 ? true : false,
            // nếu có nhiều hơn 3 bình luận thì chỉ hiển thị 3 bình luận ở màn hình ProductDetail
            itemCount: comments.length,
            itemBuilder: (context, index) {
              Comment comment = comments[index];

              // nếu có nhiều hơn 3 bình luận thì hiển thị 3 bình luận mới nhất, ngược lại thì in ra bình thường
              return comments.length > 3 ? (comments.length - index <= 3 ? buildOneComment(comment) : Container()) : buildOneComment(comment);
            });
  }

  Widget buildOneComment(Comment comment) {
    return Column(children: [
      Container(height: 0.5, color: Colors.black.withOpacity(0.3)),
      SizedBox(height: 10),
      Container(
          child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
        CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(
              "${AppEndpoint.BASE_URL}${comment.avatarSource}",
            )),
        SizedBox(width: 8),
        Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text("${comment.name}", style: TextStyle(fontSize: 12)),
            SizedBox(width: 10),
            comment.isBuy == 1 ? Image.asset(AppImages.icSuccess, height: 12, width: 12) : Container(),
            comment.isBuy == 1 ? SizedBox(width: 3) : Container(),
            comment.isBuy == 1 ? Text("Đã mua hàng ở KingBuy", style: TextStyle(fontSize: 12, color: Colors.green)) : Container(),
            Spacer(),
            comment.phoneNumber != ""
                ? Text(comment.phoneNumber.substring(0, 6) + "****", style: TextStyle(fontSize: 12, color: Colors.grey.shade500))
                : Container()
          ]),
          Container(height: 18, child: ShowRating(star: comment.star, starSize: 12)),
          Container(child: Text(comment.comment, style: TextStyle(fontSize: 14))),
          SizedBox(height: 10),
          Text(DateFormat("dd-MM-yyyy").format(comment.createdAt), style: TextStyle(fontSize: 12, color: Colors.grey.shade500))
        ]))
      ])),
      SizedBox(height: 5)
    ]);
  }

  // build phần Hỏi đáp về sản phẩm
  Widget buildProductQuestions() {
    List<Question> productQuestions = Provider.of<ProductQuestionModel>(context, listen: true).questions;
    productDetailViewModel.productQuestionSubject.sink.add(productQuestions);

    return Column(
      children: [
        buildTitleContainer("Hỏi đáp về sản phẩm", 50, Alignment.centerLeft, true),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                StreamBuilder(
                  stream: Rx.combineLatest2(productDetailViewModel.productQuestionSubject.stream, productDetailViewModel.reloadQuestionSubject.stream,
                      (stream1, stream2) => stream1),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      productQuestions = Provider.of<ProductQuestionModel>(context, listen: false).questions;
                      productDetailViewModel.productQuestionSubject.sink.add(productQuestions);

                      return snapshot.data.length > 0
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              itemCount: snapshot.data.length >= 3 ? 3 : snapshot.data.length,
                              itemBuilder: (context, index) {
                                Question productQuestion = snapshot.data[index];

                                return Container(
                                    height: 50,
                                    color: AppColors.grey2,
                                    padding: EdgeInsets.symmetric(horizontal: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                            height: 30,
                                            width: 30,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.all(Radius.circular(16))),
                                            child: Icon(Icons.person, size: 20, color: AppColors.white)),
                                        SizedBox(width: 10),
                                        Container(
                                            width: MediaQuery.of(context).size.width * 0.8,
                                            child: Text(productQuestion.content, style: TextStyle(fontSize: 14)))
                                      ],
                                    ));
                              })
                          : Container(
                              height: 20,
                              alignment: Alignment.center,
                              child: Text("Chưa có câu hỏi nào!", style: TextStyle(fontSize: 14, color: Colors.red)));
                    } else {
                      return MyLoading();
                    }
                  },
                ),
                SizedBox(height: 10),
                GestureDetector(
                    child: Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width * 0.7,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.all(Radius.circular(15))),
                        child: Text("Đặt câu hỏi cho sản phẩm",
                            style: TextStyle(color: AppColors.buttonContent, fontSize: 14, fontWeight: FontWeight.bold))),
                    onTap: () async {
                      if (await AppUtils.checkLogin()) {
                        showMaterialModalBottomSheet(
                            context: context,
                            builder: (context) => Container(
                                height: 160,
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Đặt câu hỏi", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                    SizedBox(height: 10),
                                    BorderTextField(
                                      height: 75,
                                      textController: productDetailViewModel.productQuestionController,
                                      color: AppColors.white,
                                      borderColor: AppColors.black.withOpacity(0.5),
                                      isChangeBorderColor: true,
                                      borderRadius: 4,
                                      borderWidth: 0.7,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      hintText: "Nội dung",
                                      hintTextFontSize: 14,
                                      hintTextFontWeight: FontWeight.normal,
                                      textPaddingLeft: 5,
                                      textPaddingRight: 5,
                                      transformText: -12,
                                    ),
                                    SizedBox(height: 10),
                                    Center(
                                        child: GestureDetector(
                                      child: Container(
                                          height: 30,
                                          width: MediaQuery.of(context).size.width * 0.7,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.all(Radius.circular(15))),
                                          child: Text("Gửi",
                                              style: TextStyle(color: AppColors.buttonContent, fontSize: 14, fontWeight: FontWeight.bold))),
                                      onTap: () {
                                        productDetailViewModel.sendQuestion(widget.productId, productDetailViewModel.productQuestionController.text);
                                      },
                                    ))
                                  ],
                                )));
                      } else {
                        AppUtils.myShowDialog(context, widget.productId, widget.productVideoLink);
                      }
                    }),
                SizedBox(height: 15)
              ],
            ))
      ],
    );
  }

  // build phần Sản phẩm mua cùng
  Widget buildPurchasedTogetherProducts(int productId) {
    return Column(
      children: [
        buildTitleContainer("Sản phẩm mua cùng", 50, Alignment.centerLeft, false),
        Container(
            child: StreamBuilder(
          stream: productDetailViewModel.purchasedTogetherProductsStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<bool> checkList = [];
              for (int i = 0; i < snapshot.data.length; i++) {
                checkList.add(false);
              }
              productDetailViewModel.purchasedTogetherProductSubject.sink.add(checkList);

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
                            stream: productDetailViewModel.showFullPurchasedTogetherProductSubject.stream,
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
                                                    stream: productDetailViewModel.purchasedTogetherProductSubject.stream,
                                                    builder: (context, snapshot3) {
                                                      if (snapshot3.hasData) {
                                                        return Row(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Container(
                                                                height: 25,
                                                                width: 18,
                                                                alignment: Alignment.topLeft,
                                                                child: Checkbox(
                                                                    value: snapshot3.data[index],
                                                                    activeColor: AppColors.primary,
                                                                    onChanged: (value) {
                                                                      productDetailViewModel.onSelectPurchasedTogetherProduct(
                                                                          snapshot3, index, checkList);
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
                                                                  productDetailViewModel.onSelectPurchasedTogetherProduct(
                                                                      snapshot3, index, checkList);
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
                                            stream: productDetailViewModel.countCheckPurchasedTogetherProductSubject.stream,
                                            builder: (context, snapshot4) {
                                              if (snapshot4.hasData) {
                                                return GestureDetector(
                                                    child: Container(
                                                      height: 40,
                                                      width: MediaQuery.of(context).size.width * 0.8,
                                                      decoration: BoxDecoration(
                                                          color: snapshot4.data > 0 ? AppColors.primary : AppColors.grey,
                                                          borderRadius: BorderRadius.all(Radius.circular(20))),
                                                      alignment: Alignment.center,
                                                      child: Text("Thêm ${snapshot4.data} sản phẩm vào giỏ hàng",
                                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                                                    ),
                                                    onTap: snapshot4.data != 0
                                                        ? () {
                                                            productDetailViewModel.addPurchasedTogetherProductToCart(snapshot, widget.product);
                                                          }
                                                        : null);
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
                              stream: productDetailViewModel.showFullPurchasedTogetherProductSubject.stream,
                              builder: (context, snapshot5) {
                                if (snapshot5.hasData) {
                                  return GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(snapshot5.data ? "Rút gọn" : "Xem tất cả", style: TextStyle(fontSize: 14, color: Colors.blue)),
                                        SizedBox(width: 5),
                                        Icon(snapshot5.data ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, size: 18, color: Colors.blue)
                                      ],
                                    ),
                                    onTap: () {
                                      productDetailViewModel.showFullPurchasedTogetherProduct();
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
        buildTitleContainer("Sản phẩm liên quan", 50, Alignment.centerLeft, false),
        StreamBuilder(
          stream: Rx.combineLatest2(productDetailViewModel.relatedProductStream, productDetailViewModel.countRelatedProductLoadedSubject.stream,
              (stream1, stream2) => stream1),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // để tránh trường hợp loadmore ở tận cùng danh sách sẽ bị trả về snapshot.data.length = 0, ta khai báo 1 stream
              // countRelatedProductLoaded để kiểm soát số lượng relatedProduct đã load ra
              productDetailViewModel.countRelatedProductLoadedSubject.sink
                  .add(productDetailViewModel.countRelatedProductLoadedSubject.stream.value + snapshot.data.length);

              return snapshot.data.length > 0 || productDetailViewModel.countRelatedProductLoadedSubject.stream.value > 0
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
        hasParentSingleChildScrollView: true,
        itemBuilder: itemRelatedProductBuilder,
        dataRequester: dataRelatedProductRequester,
        initRequester: initRelatedProductRequester);
  }

  // build phần Sản phẩm đã xem
  buildViewedProducts() {
    return Column(
      children: [
        buildTitleContainer("Sản phẩm đã xem", 50, Alignment.centerLeft, false),
        Container(
            height: 370,
            padding: EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.centerLeft,
            child: StreamBuilder(
                stream:
                    productDetailViewModel.isLogin ? productDetailViewModel.viewedProductsStream : productDetailViewModel.viewedProductsLocalStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) => Container(height: 175 * 2.2, width: 175, child: ShowOneProduct(product: snapshot.data[index])),
                    );
                  } else {
                    return MyLoading();
                  }
                })),
        SizedBox(height: 10),
        Container(
          height: 40,
          color: Colors.white,
          alignment: Alignment.center,
          child: GestureDetector(
            child: Text("Xem thêm", style: TextStyle(fontSize: 14, color: Colors.blue, decoration: TextDecoration.underline)),
            onTap: () {
              Navigator.pushNamed(context, Routers.Viewed_Products);
            },
          ),
        )
      ],
    );
  }

  Widget buildTitleContainer(String title, double height, Alignment alignment, bool enableNavigation) {
    return Container(
        height: height,
        padding: EdgeInsets.symmetric(horizontal: 10),
        alignment: alignment,
        child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: Row(
              children: [
                Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                Spacer(),
                enableNavigation ? Icon(Icons.arrow_forward_ios, size: 15) : Container()
              ],
            ),
            onTap: enableNavigation
                ? () {
                    productDetailViewModel.navigateProductQuestionScreen(widget.product, widget.productVideoLink);
                  }
                : null));
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
          buildBottomBarItem(MediaQuery.of(context).size.width * 0.15 - 0.5, Colors.white, AppImages.icZalo, 24, false, false, "Chat Zalo", 11,
              Colors.black, true, () => productDetailViewModel.handleChatZalo(context)),
          buildVerticalSeperateLine(8, 0.5, Colors.grey),
          buildBottomBarItem(MediaQuery.of(context).size.width * 0.22 - 0.5, Colors.white, AppImages.icMessenger, 24, false, false, "Chat Facebook",
              11, Colors.black, true, () => productDetailViewModel.handleMessenger(context)),
          buildVerticalSeperateLine(8, 0.5, Colors.grey),
          buildBottomBarItem(MediaQuery.of(context).size.width * 0.28, Colors.white, AppImages.icShoppingCart, 24, true, true, "Thêm vào giỏ hàng",
              11, Colors.black, true, () => productDetailViewModel.handleAddToCart(widget.product)),
          buildBottomBarItem(MediaQuery.of(context).size.width * 0.35, AppColors.primary, null, null, false, false, "Mua ngay", 13, Colors.white,
              false, () => productDetailViewModel.handlePurchaseButton("Mua ngay", widget.product)),
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

  Widget buildBottomBarItem(double containerWidth, Color containerColor, String iconSource, double iconSize, bool iconColor, bool isShowBadge,
      String title, double titleSize, Color titleColor, bool isShowIcon, Function action) {
    return GestureDetector(
      child: Container(
        width: containerWidth,
        color: containerColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            isShowIcon
                ? (isShowBadge
                    ? (StreamBuilder(
                        stream: productDetailViewModel.cartBadgeSubject.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data == 0) {
                              return Image.asset(iconSource, height: iconSize, width: iconSize, color: iconColor ? Colors.black : null);
                            } else {
                              return Stack(
                                children: [
                                  Image.asset(iconSource, height: iconSize, width: iconSize, color: iconColor ? Colors.black : null),
                                  Container(
                                      height: 15,
                                      width: 15,
                                      transform: Matrix4.translationValues(17, -3, 0.0),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.all(Radius.circular(8))),
                                      child: Text(snapshot.data.toString(),
                                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.buttonContent)))
                                ],
                              );
                            }
                          } else {
                            return Image.asset(iconSource, height: iconSize, width: iconSize, color: iconColor ? Colors.black : null);
                          }
                        },
                      ))
                    : Image.asset(iconSource, height: iconSize, width: iconSize, color: iconColor ? Colors.black : null))
                : Container(),
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
