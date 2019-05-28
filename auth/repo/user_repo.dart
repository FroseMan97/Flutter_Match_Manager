import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Zenit/auth/model/user_model.dart';

class UserRepository {
   FirebaseAuth _auth;
   Firestore _db;
  UserRepository(){
     _auth = FirebaseAuth.instance;
   _db = Firestore.instance;
  }

  signInWithEmail(String email, String password) async {
    return await _auth
        .signInWithEmailAndPassword(email: email, password: password);
        
  }

  isSigned() async {
    if (await getCurrentUser() != null) {
      return true;
    } else {
      return false;
    }
  }

  signOut() async {
    return await _auth.signOut();
  }

  Future<FirebaseUser> getCurrentUser() async {
    return await _auth.currentUser();
  }


  getUserInfo(String uid) async {
    DocumentSnapshot data = await _db.collection('users').document(uid).get();
    User user;
    if(data.data!=null){
    String name = data?.data['name'] ?? '??';
    String surname =
        data?.data['surname'] ?? '??';
    String phone = data?.data['phone'] ?? '??';
    String avatar = data?.data['avatar'] ?? null;
    user =  User(uid,name, surname, phone, avatar);
    }else{
      user =  User('??','??','??','??','??');
    }
    print(user);
    return user;
  }

  @override
   String toString() => 'UserRepository';
}
