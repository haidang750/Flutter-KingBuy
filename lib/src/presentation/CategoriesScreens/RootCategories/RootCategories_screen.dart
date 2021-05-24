import 'package:flutter/material.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/CategoriesScreens/CategoriesScreens.dart';
import 'package:projectui/src/presentation/CategoriesScreens/CategoryDetail/CategoryDetail_screen.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/presentation/presentation.dart';
import 'package:projectui/src/presentation/widgets/MyLoading.dart';
import 'package:projectui/src/resource/model/CategoryModel.dart';
import 'RootCategories.dart';

class RootCategoriesScreen extends StatefulWidget {
  @override
  RootCategoriesScreenState createState() => RootCategoriesScreenState();
}

class RootCategoriesScreenState extends State<RootCategoriesScreen> with ResponsiveWidget {
  int currentIndex = 0;
  final pageController = PageController(initialPage: 0, keepPage: true);
  ScrollController scrollController = ScrollController();
  final rootCategoriesViewModel = RootCategoriesViewModel();

  @override
  void initState() {
    super.initState();
    rootCategoriesViewModel.getHotCategories();
    rootCategoriesViewModel.getAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      mainScreen: true,
        viewModel: rootCategoriesViewModel,
        builder: (context, viewModel, child) => Scaffold(
            appBar: AppBar(
              title: Text("Danh mục"),
              automaticallyImplyLeading: false,
            ),
            body: buildUi(context: context)));
  }

  Widget buildScreen() {
    return StreamBuilder(
      stream: rootCategoriesViewModel.allCategoriesStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Row(
            children: [listCategoriesContainer(snapshot.data.categories), oneCategoryContainer(snapshot.data.categories)],
          );
        } else {
          return MyLoading();
        }
      },
    );
  }

  Widget listCategoriesContainer(List<Category> categories) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.3,
        child: ListView.builder(
          controller: scrollController,
          itemCount: categories.length + 1,
          itemBuilder: (context, index) {
            return buildListCategories(index, categories, () {
              setState(() {
                currentIndex = index;
              });
              pageController.jumpToPage(currentIndex);
            });
          },
        ));
  }

  Widget oneCategoryContainer(List<Category> categories) {
    return Expanded(
        child: PageView(
      controller: pageController,
      scrollDirection: Axis.vertical,
      children: List.generate(
          categories.length + 1,
          (index) => Container(
                decoration: BoxDecoration(border: Border(left: BorderSide(width: 0.3, color: Colors.grey))),
                child: Column(
                  children: [
                    categoryName(index == 0 ? "Danh mục đang hot" : categories[index - 1].name,
                        () => index == 0 ? null : handleTouchCategory(categories[index - 1])),
                    categoryBody(index, index >= 1 ? categories[index - 1].backgroundImage : "", index >= 1 ? categories[index - 1].children : [])
                  ],
                ),
              )),
      onPageChanged: (value) {
        setState(() {
          currentIndex = value;
        });
        scrollController.animateTo(currentIndex * MediaQuery.of(context).size.width * 0.3,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      },
    ));
  }

  Widget buildListCategories(int index, List<Category> categories, Function action) {
    return Container(
      height: MediaQuery.of(context).size.width * 0.3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(width: 5, color: index == currentIndex ? Colors.blue : Colors.white),
          Expanded(
              child: GestureDetector(
            child: Container(
                color: index == currentIndex ? Colors.grey.shade50 : Colors.white,
                child: index == 0
                    ? Center(child: Container(width: 60, height: 60, color: Colors.yellow.shade200, child: Image.asset(AppImages.icStar)))
                    : buildOneCategory(categories[index - 1].name, categories[index - 1].imageSource)),
            onTap: action,
          ))
        ],
      ),
    );
  }

  Widget buildOneCategory(String name, String imageSource) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            width: 60,
            height: 60,
            color: Colors.white,
            child: Image.network(
              "${AppEndpoint.BASE_URL}$imageSource",
              errorBuilder: (context, error, stackTrace) => Image.asset(AppImages.errorImage, fit: BoxFit.cover),
            )),
        SizedBox(height: 6),
        Container(
          child: Text(
            name.toUpperCase(),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }

  Widget categoryName(String title, Function action) {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(left: BorderSide(width: 0.1, color: Colors.grey), bottom: BorderSide(width: 1, color: Colors.grey.shade400)),
      ),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 5),
            child: Text(title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          ),
          Spacer(),
          GestureDetector(child: Icon(Icons.arrow_forward_ios_outlined, size: 16), onTap: action)
        ],
      ),
    );
  }

  // categoryBody = ảnh Banner + tất cả Child Categories của 1 Category
  Widget categoryBody(int index, String backgroundImage, List<Category> childCategories) {
    if (index == 0) {
      // nếu là Danh mục đang hot
      return Expanded(
          child: StreamBuilder(
              stream: rootCategoriesViewModel.hotCategoriesStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                      color: AppColors.white, padding: EdgeInsets.fromLTRB(15, 0, 15, 5), child: buildListChildCategories(snapshot.data.categories));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }));
    } else {
      return Expanded(
        child: Column(
          children: [
            // Ảnh banner
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                    color: AppColors.white,
                    image: DecorationImage(image: NetworkImage("${AppEndpoint.BASE_URL}$backgroundImage"), fit: BoxFit.fill),
                    borderRadius: BorderRadius.all(Radius.circular(8))),
              ),
            ),
            Expanded(
              child: Container(color: AppColors.white, padding: EdgeInsets.fromLTRB(15, 5, 15, 5), child: buildListChildCategories(childCategories)),
            )
          ],
        ),
      );
    }
  }

  // build tất cả Child Category trong 1 Category
  Widget buildListChildCategories(List<Category> categories) {
    return GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1 / 1.2,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        children: List.generate(categories.length,
            (index) => buildOneChildCategory(categories[index].name, categories[index].imageSource, () => handleTouchCategory(categories[index]))));
  }

  // build 1 Child Category trong 1 Category
  Widget buildOneChildCategory(String name, String imageSource, Function action) {
    return GestureDetector(child: buildOneCategory(name, imageSource), onTap: action);
  }

  handleTouchCategory(Category category) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryDetail(category: category, searchContent: null)));
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
