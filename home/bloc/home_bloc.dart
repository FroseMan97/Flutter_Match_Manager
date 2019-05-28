import 'dart:async';
import 'package:Zenit/auth/model/user_model.dart';
import 'package:Zenit/auth/repo/user_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc {
  UserRepository _userRepository;

  BehaviorSubject _userSubject = BehaviorSubject<User>();
  StreamSink get _userSink => _userSubject.sink;
  Stream get user => _userSubject.stream;

  BehaviorSubject _navigationSubject = BehaviorSubject<String>();
  StreamSink get _navSink => _navigationSubject.sink;
  Stream get nav => _navigationSubject.stream;

  HomeBloc(this._userRepository) : assert(_userRepository != null){
    loadUser();
  }

  loadUser() async {
    FirebaseUser firebaseUser = await _userRepository.getCurrentUser();
    String uid = firebaseUser.uid;
    User user = await _userRepository.getUserInfo(uid);
    _userSink.add(user);
  }

  navigationChange(String navigation){
    _navSink.add(navigation);
  }

  dispose() {
    _userSubject.close();
    _navigationSubject.close();
  }
}
