import 'package:flutter/material.dart';
import 'package:projectui/src/resource/model/ContactModel.dart';
import 'package:projectui/src/resource/model/model.dart';
import 'package:projectui/src/resource/repo/Contact_Repository.dart';
import 'package:projectui/src/resource/repo/auth_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:provider/provider.dart';

class ContactViewModel {
  final _contactRepository = ContactRepository();
  final authRepository = AuthRepository();

  final contactSubject = BehaviorSubject<List<dynamic>>();
  final feedbackSubject = BehaviorSubject<ContactModel>();

  Stream<List<dynamic>> get contactStream => contactSubject.stream;

  Stream<ContactModel> get feedbackStream => feedbackSubject.stream;

  getContactInfo() async {
    List<dynamic> contactInfo = await _contactRepository.getContactInfo();
    contactSubject.sink.add(contactInfo);
  }

  Future<bool> checkFeedbackOfUser() async {
    NetworkState<bool> result = await authRepository.checkFeedbackOfUser();
    return result.data;
  }

  Future<String> userSendContact(String fullName, String email, String phone,
      String subject, String body) async {
    NetworkState<String> result = await authRepository.userSendContact(
        fullName, email, phone, subject, body);
    return result.data;
  }

  getAllFeedback() async {
    NetworkState result = await authRepository.getAllFeedback();
    feedbackSubject.sink.add(result.data);
  }

  Future<int> userReplyFeedback(String contentRep) async {
    NetworkState result = await authRepository.userReplyFeedback(contentRep);
    return result.data;
  }

  void dispose() {
    contactSubject.close();
    feedbackSubject.close();
  }
}
