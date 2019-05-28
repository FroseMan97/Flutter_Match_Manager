import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Zenit/matches/models/matches_info_model.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

 
class MatchInfoRepository {
  Firestore _db;
  final String mainPath = 'matches';

  MatchInfoRepository() {
    _db = Firestore.instance;
    initializeDateFormatting('ru');
  }

  fetchMatchInfoByID(String matchID) async {
    DocumentSnapshot doc;
    String name, img, leftDate, leftTime;
    String date = 'Дата уточняется', time = 'уточняется', status = 'Статус не определен';
    MatchInfo matchInfo;
    doc = await _db.collection(mainPath).document(matchID).get();
    name = doc['name'] ?? 'Матч';
    img = doc['img'] ?? 'default';
    if (doc['date'] != null) {
      DateTime tempDate;
      Timestamp dateTimestamp;
      if (Platform.isIOS) {
        dateTimestamp = doc['date'];
        tempDate = dateTimestamp.toDate();
      }
      if (Platform.isAndroid) {
        tempDate = doc['date'];
      }
      date = DateFormat('d MMMM HH:mm', 'ru').format(tempDate);
      leftDate = '';
    } else {
      leftDate = '';
    }
    if (doc['time'] != null) {
      DateTime tempTime;
      Timestamp timeTimestamp;
      if (Platform.isIOS) {
        timeTimestamp = doc['time'];
        tempTime = timeTimestamp.toDate();
      }
      if (Platform.isAndroid) {
        tempTime = doc['time'];
      }

      time = DateFormat('HH:mm', 'ru').format(tempTime);
      leftTime = '';
    } else {
      leftTime = '';
    }
    if(doc['status']!=null){
      status= doc['status'].toString();
    }
    matchInfo =
        new MatchInfo(matchID, name, date, time, img, leftDate, leftTime, status);
    return matchInfo;
  }

  fetchMatchesInfo() async {
    List<MatchInfo> list = new List<MatchInfo>();
    QuerySnapshot snapshot = await _db
        .collection(mainPath).orderBy('date',descending: true)
        .getDocuments()
        .timeout(Duration(seconds: 10));
    for (DocumentSnapshot doc in snapshot.documents) {
      try {
        MatchInfo match = await fetchMatchInfoByID(doc.documentID);
        if (match != null) {
          list.add(match);
        }
      } catch (e) {
        print(e);
        return null;
      }
    }
    return list;
  }

  @override
  String toString() => 'MatchInfoRepository';
}
