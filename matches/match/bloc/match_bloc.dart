import 'dart:async';
import 'package:Zenit/matches/match/bloc/match_event.dart';
import 'package:Zenit/matches/repo/match_info_repo.dart';
import 'package:Zenit/matches/repo/match_emp_repo.dart';
import 'package:Zenit/matches/models/matches_info_model.dart';
import 'package:Zenit/matches/models/matches_emp_model.dart';
import 'package:rxdart/rxdart.dart';

class MatchBloc {
  MatchInfoRepository _matchInfoRepository;
  MatchEmpRepository _matchEmpRepository;
  String _matchID;

  MatchBloc(
      this._matchInfoRepository, this._matchEmpRepository, this._matchID) {
    _event.listen((event) async {
      if (event is UpdateMatchInfo) {
        await _loadInfo();
      } else if (event is UpdateMatchEmp) {
        await _loadEmp();
      } else if (event is RequestButtonPressed) {
        await _addRequest();
      }
    });
  }

  BehaviorSubject _eventSubject = BehaviorSubject();
  StreamSink get _eventSink => _eventSubject.sink;
  Stream get _event => _eventSubject.stream;

  BehaviorSubject<MatchInfo> _matchInfoController =
      BehaviorSubject<MatchInfo>();
  StreamSink get _matchInfoSink => _matchInfoController.sink;
  Stream<MatchInfo> get matchInfo => _matchInfoController.stream;

  BehaviorSubject<MatchEmp> _matchEmpController = BehaviorSubject<MatchEmp>();
  StreamSink get _matchEmpSink => _matchEmpController.sink;
  Stream<MatchEmp> get matchEmp => _matchEmpController.stream;

  dispatchEvent(MatchEvent event) {
    _eventSink.add(event);
  }

  _loadInfo() async {
    MatchInfo matchInfo =
        await _matchInfoRepository.fetchMatchInfoByID(_matchID);
    _matchInfoSink.add(matchInfo);
  }

  _loadEmp() async {
    MatchEmp matchEmp =
        await _matchEmpRepository.fetchUserWithHumanFaces(_matchID);
    _matchEmpSink?.add(matchEmp);
  }

  _addRequest() async {
    print(_matchID);
    _matchEmpSink.add(null);
    await _matchEmpRepository.addRequest(_matchID);

    await Future.delayed(Duration(seconds: 2));
    await _loadEmp();
  }

  dispose() {
    _eventSubject.close();
    _matchInfoController.close();
    _matchEmpController.close();
  }
}
