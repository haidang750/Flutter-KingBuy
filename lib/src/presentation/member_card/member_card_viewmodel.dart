import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/resource/model/model.dart';
import 'package:projectui/src/utils/app_utils.dart';
import 'package:rxdart/rxdart.dart';

class MemberCardViewModel extends BaseViewModel {
  final memberCardSubject = BehaviorSubject<MemberCard>();

  Stream<MemberCard> get memberCardStream => memberCardSubject.stream;

  init() {
    checkLogin();
    getCardMemberDetail();
  }

  checkLogin() async {
    if (await AppUtils.checkLogin() == false) {
      AppUtils.myShowDialog(context, -1, "");
    }
  }

  getCardMemberDetail() async {
    NetworkState<MemberCardModel> result = await authRepository.getMemberCardDetail();
    if(result.isSuccess){
       if(result.data.status == 1){
         memberCardSubject.sink.add(result.data.memberCard);
       }else{
         memberCardSubject.sink.add(null);
       }
    }else{
      print("Vui lòng kiểm tra lại kết nối Internet");
      memberCardSubject.sink.add(null);
    }
  }

  void dispose() {
    memberCardSubject.close();
  }
}