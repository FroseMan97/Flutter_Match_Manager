import 'dart:async';

import 'package:Zenit/auth/model/user_model.dart';
import 'package:Zenit/auth/repo/user_repo.dart';
import 'package:Zenit/matches/match/bloc/match_event.dart';
import 'package:Zenit/matches/models/matches_emp_model.dart';
import 'package:Zenit/matches/models/matches_info_model.dart';
import 'package:Zenit/matches/repo/match_emp_repo.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:Zenit/matches/repo/match_info_repo.dart';
import 'package:Zenit/matches/match/bloc/match_bloc.dart';

class MatchPage extends StatefulWidget {
  final UserRepository _userRepository;
  final MatchInfoRepository _matchesRepo;
  final String _matchID;

  MatchPage(this._matchesRepo, this._userRepository, this._matchID);

  @override
  _MatchPageState createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  MatchEmpRepository _matchEmpRepository;
  MatchBloc _matchBloc;
  Completer<void> _refreshCompleter;
  bool _requestsIsClosed = false, _workersIsClosed = false;

  var _tileTextStyle = TextStyle(fontSize: 18.0);
  var _expandedTileTextStyle =
      TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic);

  @override
  void dispose() {
    _matchBloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _matchEmpRepository = new MatchEmpRepository(widget._userRepository);
    _matchBloc = new MatchBloc(
        widget._matchesRepo, _matchEmpRepository, widget._matchID);
    _matchBloc.dispatchEvent(UpdateMatchInfo());
    _matchBloc.dispatchEvent(UpdateMatchEmp());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Полная информация о матче'),
          centerTitle: true,
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: _matchInfo());
  }

  _matchInfo() {
    return StreamBuilder<MatchInfo>(
      stream: _matchBloc.matchInfo,
      builder: (context, snapshot) {
        print('Info stream builder, ${snapshot.data}');
        if (snapshot.data == null) {
          return Container(
            height: 150,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          MatchInfo matchInfo = snapshot.data;
          _refreshCompleter?.complete();
          _refreshCompleter = Completer();
          return RefreshIndicator(
            onRefresh: () {
              _matchBloc.dispatchEvent(UpdateMatchInfo());
              _matchBloc.dispatchEvent(UpdateMatchEmp());
              return _refreshCompleter.future;
            },
            child: ListView(
              children: <Widget>[
                Container(
                  child: CachedNetworkImage(
                      fit: BoxFit.contain,
                      imageUrl: matchInfo.getImg,
                      placeholder: (context, _) => Container(
                          height: 150,
                          child: Align(
                              alignment: FractionalOffset.center,
                              child: CircularProgressIndicator()))),
                ),
                ExpansionTile(
                  title: Text(
                    'Информация о матче',
                    style: _expandedTileTextStyle,
                  ),
                  initiallyExpanded: true,
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        matchInfo.getName,
                        style: _tileTextStyle,
                      ),
                      leading: Icon(Icons.title),
                    ),
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            matchInfo.getDate,
                            style: _tileTextStyle,
                          ),
                          Text(matchInfo.getLeftDate,
                              style: TextStyle(color: Colors.red))
                        ],
                      ),
                      leading: Icon(Icons.date_range),
                    ),
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Сбор ' + matchInfo.getTime,
                            style: _tileTextStyle,
                          ),
                          Text(
                            matchInfo.getLeftTime,
                            style: TextStyle(color: Colors.red),
                          )
                        ],
                      ),
                      leading: Icon(Icons.timelapse),
                    ),
                    ListTile(
                      title: Text(
                        matchInfo.getStatus,
                        style: _tileTextStyle,
                      ),
                      leading: Icon(Icons.settings_backup_restore),
                    ),
                  ],
                ),
                _matchEmp(matchInfo.getStatus)
              ],
            ),
          );
        }
      },
    );
  }

  _matchEmp(String status) {
    return StreamBuilder<MatchEmp>(
        stream: _matchBloc.matchEmp,
        builder: (context, snapshot) {
          print('Emp stream builder, ${snapshot.data}');
          if (snapshot.data == null) {
            return Container(
              height: 150,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            MatchEmp matchEmp = snapshot.data;
            return Column(
              children: <Widget>[
                ExpansionTile(
                  onExpansionChanged: (requestsIsClosed) {
                    _requestsIsClosed = requestsIsClosed;
                  },
                  initiallyExpanded: _requestsIsClosed,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Заявки',
                        style: _expandedTileTextStyle,
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.yellowAccent,
                        child: Text(
                          matchEmp.getRequests.length.toString(),
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  children: <Widget>[
                    _requestsList(matchEmp.getRequests, status)
                  ],
                ),
                Divider(),
                status == 'Выход'
                    ? ExpansionTile(
                        onExpansionChanged: (workersIsClosed) {
                          _workersIsClosed = workersIsClosed;
                        },
                        initiallyExpanded: _workersIsClosed,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'На матч выходят',
                              style: _expandedTileTextStyle,
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.green,
                              child: Text(
                                snapshot.data.getWorkers.length.toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                        children: <Widget>[
                          _workersList(matchEmp.getWorkers),
                          Divider()
                        ],
                      )
                    : Container(),
              ],
            );
          }
        });
  }

  _requestsList(List<User> list, String status) {
    return Column(
      children: <Widget>[
        status == 'Заявка'
            ? ListTile(
                title: RaisedButton(
                  child: Text(
                    'Готов / Не готов',
                    style: TextStyle(fontSize: 18),
                  ),
                  color: Colors.lightGreen,
                  onPressed: () {
                    _matchBloc.dispatchEvent(RequestButtonPressed());
                  },
                ),
              )
            : Container(),
        list.isNotEmpty ? _userList(list) : _emptyRequests()
      ],
    );
  }

  _workersList(List<User> list) {
    return list.isNotEmpty ? _userList(list) : _emptyWorkers();
  }

  _userList(List<User> list) {
    return ListView.builder(
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: list.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: (){},
          child: ListTile(
            leading: CircleAvatar(
              radius: 20,
              backgroundImage:
                  CachedNetworkImageProvider(list[index].getAvatar),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  (index + 1).toString() + '.',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  list[index].getSurname + ' ' + list[index].getName,
                  style: _tileTextStyle,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  _emptyWorkers() {
    return ListTile(title: Center(child: Text('Пока никого нет')));
  }

  _emptyRequests() {
    return ListTile(title: Center(child: Text('Пока никто не заявился')));
  }
}
