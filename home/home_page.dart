import 'package:Zenit/auth/repo/user_repo.dart';
import 'package:Zenit/home/widget/drawer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Zenit/home/bloc/home_bloc.dart';
import 'package:Zenit/auth/bloc/auth_bloc.dart';
import 'package:Zenit/matches/matches_page.dart';

class HomePage extends StatefulWidget {
  final AuthBloc _authBloc;
  final UserRepository _userRepository;
  HomePage(this._authBloc, this._userRepository, {Key key})
      : assert(_authBloc != null, _userRepository != null),
        super(key: key);
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeBloc _homeBloc;

  @override
  void dispose() {
    _homeBloc.dispose();
    super.dispose();
  }

  void initState() {
    _homeBloc = HomeBloc(widget._userRepository);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      initialData: 'MATCHES',
      stream: _homeBloc.nav,
      builder: (context, snapshot) {
        return Scaffold(
            drawer: HomeDrawer(widget._authBloc, _homeBloc),
            appBar: AppBar(
              title: Text(snapshot.data),
              centerTitle: true,
              backgroundColor: Colors.lightBlueAccent,
            ),
            body: _decision(snapshot.data));
      },
    );
  }

  _decision(String page) {
    if (page == 'MATCHES') {
      return MatchesPage(widget._userRepository);
    } 
  }
}
