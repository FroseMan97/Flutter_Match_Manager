import 'package:Zenit/auth/model/user_model.dart';
import 'package:Zenit/auth/repo/user_repo.dart';
import 'package:Zenit/matches/models/matches_emp_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MatchEmpRepository {
  UserRepository _userRepository;
  Firestore _db;
  final String mainPath = 'matches';

  MatchEmpRepository(this._userRepository) {
    
    _db = Firestore.instance;
  }

  _fetchRequestsAndWorkersByID(String matchID) async {
    DocumentSnapshot snapshot = await _db
        .collection(mainPath)
        .document(matchID)
        .collection('teams')
        .document('ecus')
        .get();
    List<dynamic> tempReq;
    List<dynamic> tempWorkers;
    try {
      tempReq = snapshot?.data['requests'];
      tempWorkers = snapshot?.data['workers'];
    } catch (_) {}
    List<List<dynamic>> list = new List<List<dynamic>>();
    list.add(tempReq);
    list.add(tempWorkers);
    return list;
  }

  fetchUserWithHumanFaces(String matchID) async {
    List<List<dynamic>> list = await _fetchRequestsAndWorkersByID(matchID);
    List<User> usersOfRequests = new List<User>();
    List<User> usersOfWorkers = new List<User>();
    if (list[0] != null) {
      for (dynamic request in list[0]) {
        usersOfRequests.add(await _userRepository.getUserInfo(request));
      }
    }
    if (list[1] != null) {
      for (dynamic request in list[1]) {
        usersOfWorkers.add(await _userRepository.getUserInfo(request));
      }
    }
    MatchEmp matchEmp = new MatchEmp(usersOfRequests, usersOfWorkers);
    return matchEmp;
  }

  addRequest(matchID) async {
    final DocumentReference postRef = _db
        .collection(mainPath)
        .document(matchID)
        .collection('teams')
        .document('ecus');

    FirebaseUser user = await _userRepository.getCurrentUser();

    await _db.runTransaction((Transaction tx) async {
      DocumentSnapshot snapshot = await tx.get(postRef);
      var doc = snapshot.data;
      if (doc['requests'].contains(user.uid)) {
        await tx.update(snapshot.reference, <String, FieldValue>{
          'requests': FieldValue.arrayRemove([user.uid])
        });
      } else {
        await tx.update(snapshot.reference, <String, FieldValue>{
          'requests': FieldValue.arrayUnion([user.uid])
        });
      }
    });
  }
}
