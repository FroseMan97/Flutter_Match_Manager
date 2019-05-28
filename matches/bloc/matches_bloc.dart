import 'dart:async';
import 'package:Zenit/matches/bloc/matches_event.dart';
import 'package:Zenit/matches/repo/match_info_repo.dart';
import 'package:Zenit/matches/models/matches_info_model.dart';
import 'package:rxdart/rxdart.dart';

class MatchesBloc {
  MatchInfoRepository _matchesRepository;

  MatchesBloc(this._matchesRepository){
    _event.listen((event){
      if(event is UpdateMatchesInfo){
        _loadMatches();
      }
    });
  }

  BehaviorSubject _matchesSubject = BehaviorSubject<List<MatchInfo>>();
  StreamSink get _matchesSink => _matchesSubject.sink;
  Stream get matches => _matchesSubject.stream;

  BehaviorSubject _eventSubject = BehaviorSubject();
  StreamSink get _eventSink => _eventSubject.sink;
  Stream get _event => _eventSubject.stream;

  dispatchEvent(MatchesEvent event){
    _eventSink.add(event);
  }

  _loadMatches() async {
    List<MatchInfo> list = await _matchesRepository.fetchMatchesInfo();
    _matchesSink.add(list);
  }

  dispose() {
    _eventSubject?.close();
    _matchesSubject?.close();
  }
}
