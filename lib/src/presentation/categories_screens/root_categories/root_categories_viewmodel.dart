import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/categories_screens/category_detail/category_detail.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/resource/model/category_model.dart';
import 'package:projectui/src/utils/app_utils.dart';
import 'package:rxdart/rxdart.dart';

class RootCategoriesViewModel extends BaseViewModel {
  int currentIndex = 0;
  final pageController = PageController(initialPage: 0, keepPage: true);
  ScrollController scrollController = ScrollController();
  final hotCategoriesSubject = BehaviorSubject<List<Category>>();
  final allCategoriesSubject = BehaviorSubject<List<Category>>();

  Stream<List<Category>> get hotCategoriesStream => hotCategoriesSubject.stream;
  Stream<List<Category>> get allCategoriesStream => allCategoriesSubject.stream;

  init() {
    getHotCategories();
    getAllCategories();
  }

  getHotCategories() async{
    CategoryModel categoryModel = await AppUtils.getHotCategories();
    hotCategoriesSubject.sink.add(categoryModel.categories);
  }

  getAllCategories() async{
    List<Category> categories = await AppUtils.getAllCategories();
    allCategoriesSubject.sink.add(categories);
  }

  onPageChanged(int value) {
    currentIndex = value;
    scrollController.animateTo(currentIndex * MediaQuery.of(context).size.width * 0.3,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  onTapCategoryLeft(int index) {
    currentIndex = index;
    pageController.jumpToPage(currentIndex);
  }

  onTapCategoryRight(Category category) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryDetail(category: category, searchContent: null)));
  }

  void dispose(){
    hotCategoriesSubject.close();
    allCategoriesSubject.close();
  }
}