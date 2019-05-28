import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:Zenit/login/bloc/login_bloc.dart';
import 'package:Zenit/login/bloc/login_event.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:Zenit/auth/bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  final AuthBloc _authBloc;

  LoginPage(this._authBloc);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginBloc _loginBloc;

  @override
  void dispose() {
    _loginBloc.dispose();

    super.dispose();
  }

  @override
  void initState() {
    _loginBloc = LoginBloc(widget._authBloc);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        body: LayoutBuilder(builder: (context, size) {
          return SingleChildScrollView(
            child: Container(
              width: size.maxWidth,
              height: size.maxHeight,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[_topLogo(), _loginForm()],
              ),
            ),
          );
        }));
  }

  _loginForm() {
    return Positioned(
      top: 350,
      left: 30,
      right: 30,
      child: Container(
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.9),
              offset: Offset(1.0, 6.0),
              blurRadius: 15.0,
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Color(0xFF00a8e8).withOpacity(0.7),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              _inputPhone(),
              SizedBox(
                height: 20,
              ),
              _toNextButton()
            ]),
      ),
    );
  }

  _topLogo() {
    return CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl:
          'https://pic5.fc-zenit.ru/upload/iblock/9bb/9bb9e16008ea909b581ec3173826e550.jpg',
    );
  }

  _inputPhone() {
    return Theme(
      data: new ThemeData(
        primaryColor: Colors.lightBlueAccent,
        primaryColorDark: Colors.blue,
      ),
      child: TextFormField(
        cursorColor: Color(0xFFcfb92b),
        decoration: new InputDecoration(
            border: new OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            prefixIcon: const Icon(
              Icons.phone_android,
              color: Colors.lightBlueAccent,
            ),
            hintText: '+7(999)111-22-33',
            labelText: 'Номер телефона',
            fillColor: Colors.white.withOpacity(0.7),
            filled: true),
        keyboardType: TextInputType.phone,
      ),
    );
  }

  _toNextButton() {
    return RaisedButton(
      onPressed: () {
        _loginBloc.eventSink.add(LoginPressed());
      },
      color: Color(0xFFcfb92b),
      child: Text('Далее',
          style: TextStyle(
            fontSize: 15,
          )),
    );
  }
}
