import 'package:Zenit/auth/widgets/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './auth/bloc/auth_bloc.dart';
import './auth/bloc/auth_events.dart';
import './auth/repo/user_repo.dart';
import './auth/bloc/auth_states.dart';
import './splash/splash.dart';
import './login/login_page.dart';
import './home/home_page.dart';
import 'dart:async';



void main() {
  runApp(App());
}

class App extends StatefulWidget {
  App({Key key}) : super(key: key);

  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final UserRepository _userRepository = UserRepository();
  AuthBloc _authBloc;

  @override
  void dispose() {
    _authBloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _authBloc = AuthBloc(_userRepository);
    _authBloc.eventSink.add(Decision());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.lightBlueAccent,
      home: StreamBuilder<AuthState>(
        stream: _authBloc.stateStream,
          initialData: UnInitialized(),
          builder: (context, state) {
            if (state.data is UnInitialized) {
              return SplashPage();
            }
            if (state.data is UnAuthenticated) {
              return LoginPage(_authBloc);
            }
            if (state.data is Authenticated) {
              return HomePage(_authBloc, _userRepository);
            }
            if (state.data is AuthLoading) {
              return LoadingIndicator();
            }
          }),
    );
  }
}
