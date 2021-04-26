import 'package:projectui/src/resource/model/CategoryModel.dart';
import 'package:projectui/src/resource/model/network_state.dart';
import 'package:projectui/src/resource/repo/category_repository.dart';
import 'package:rxdart/rxdart.dart';

class RootCategoriesViewModel {
  final categoryRepository = CategoryRepository();

  final hotCategoriesSubject = BehaviorSubject<CategoryModel>();
  final allCategoriesSubject = BehaviorSubject<CategoryModel>();

  Stream<CategoryModel> get hotCategoriesStream => hotCategoriesSubject.stream;
  Stream<CategoryModel> get allCategoriesStream => allCategoriesSubject.stream;

  getHotCategories() async{
    NetworkState<CategoryModel> result = await categoryRepository.getHotCategories();
    if(result.isSuccess){
      hotCategoriesSubject.sink.add(result.data);
    }else{
      print("Vui lòng kiểm tra lại kết nối Internet!");
    }
  }

  Future<List<Category>> getAllCategories() async{
    NetworkState<CategoryModel> result = await categoryRepository.getAllCategories();
    if(result.isSuccess){
      allCategoriesSubject.sink.add(result.data);
      return result.data.categories;
    }else{
      print("Vui lòng kiểm tra lại kết nối Internet!");
      return [];
    }
  }

  void dispose(){
    hotCategoriesSubject.close();
    allCategoriesSubject.close();
  }
}