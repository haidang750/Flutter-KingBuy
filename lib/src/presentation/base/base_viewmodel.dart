import 'package:projectui/src/resource/repo/Commitment_Repository.dart';
import 'package:projectui/src/resource/repo/Contact_Repository.dart';
import 'package:projectui/src/resource/repo/Coupon_Repository.dart';
import 'package:projectui/src/resource/repo/auth_repository.dart';
import 'package:projectui/src/resource/repo/category_repository.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

abstract class BaseViewModel extends ChangeNotifier {
  BuildContext _context;

  BuildContext get context => _context;

  setContext(BuildContext value) {
    _context = value;
  }

  final loadingSubject = BehaviorSubject<bool>();
  final errorSubject = BehaviorSubject<String>();

  void setLoading(bool loading) {
    if (loading != isLoading) loadingSubject.add(loading);
  }

  bool get isLoading => loadingSubject.value;

  void setError(String message) {
    errorSubject.add(message);
  }

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  final authRepository = AuthRepository();
  final categoryRepository = CategoryRepository();
  final commitmentRepository = CommitmentRepository();
  final contactRepository = ContactRepository();
  final couponRepository = CouponRepository();

  @override
  void dispose() async {
    await loadingSubject.drain();
    loadingSubject.close();
    await errorSubject.drain();
    errorSubject.close();
    super.dispose();
  }
}
