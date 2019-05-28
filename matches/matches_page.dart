import 'dart:async';

import 'package:Zenit/auth/repo/user_repo.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:Zenit/matches/bloc/matches_bloc.dart';

import 'package:Zenit/matches/repo/match_info_repo.dart';

import 'package:Zenit/matches/match/match_page.dart';

import 'bloc/matches_event.dart';
import 'models/matches_info_model.dart';

class MatchesPage extends StatefulWidget {
  final UserRepository _userRepository;

  MatchesPage(this._userRepository);

  @override
  _MatchesPageState createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> {
  MatchesBloc _matchesBloc;
  Completer<void> _refreshCompleter;
  MatchInfoRepository _matchesRepo;

  @override
  void dispose() {
    _matchesBloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _matchesRepo = new MatchInfoRepository();
    _matchesBloc = new MatchesBloc(_matchesRepo);
    _matchesBloc.dispatchEvent(UpdateMatchesInfo());
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MatchInfo>>(
      initialData: List<MatchInfo>(),
      stream: _matchesBloc.matches,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Ошибка'),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text('Загрузка матчей...'));
        }
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Center(child: Text('Нет доступных матчей'));
          }

          return _matchesList(snapshot.data);
        } else {
          return Center(child: Text('Нет данных'));
        }
      },
    );
  }

  _matchesList(List<MatchInfo> matchInfo) {
    _refreshCompleter?.complete();
    _refreshCompleter = Completer();
    return RefreshIndicator(
      onRefresh: () {
        _matchesBloc.dispatchEvent(UpdateMatchesInfo());
        return _refreshCompleter.future;
      },
      child: ListView.builder(
        key: PageStorageKey(0),
        itemCount: matchInfo.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: new InkWell(
              onTap: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) {
                  return MatchPage(_matchesRepo, widget._userRepository, matchInfo[index].getID);
                }));
              },
              child: new Card(
                elevation: 5.0,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(16.0)),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new ClipRRect(
                      child: CachedNetworkImage(
                          fit: BoxFit.contain,
                          imageUrl: matchInfo[index].getImg,
                          placeholder: (context, _) => Container(
                              height: 150,
                              child: Align(
                                  alignment: FractionalOffset.center,
                                  child: CircularProgressIndicator()))),
                      borderRadius: BorderRadius.only(
                          topLeft: new Radius.circular(16.0),
                          topRight: new Radius.circular(16.0)),
                    ),
                    new Padding(
                      padding: new EdgeInsets.all(16.0),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text(
                            matchInfo[index].getName,
                            style: new TextStyle(fontSize: 20.0),
                          ),
                          new SizedBox(
                            height: 10.0,
                          ),
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              new Text(matchInfo[index].getDate),
                              new Text('Сбор ' + matchInfo[index].getTime),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
