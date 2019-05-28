import 'package:Zenit/auth/bloc/auth_bloc.dart';
import 'package:Zenit/auth/bloc/auth_events.dart';
import 'package:Zenit/auth/model/user_model.dart';
import 'package:Zenit/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeDrawer extends StatefulWidget {
  final AuthBloc _authBloc;
  final HomeBloc _homeBloc;

  HomeDrawer(this._authBloc, this._homeBloc);

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          StreamBuilder<User>(
            initialData: User('-1', 'Загрузка', '', 'Загрузка', null),
            stream: widget._homeBloc.user,
            builder: (context, snapshot) {
              return UserAccountsDrawerHeader(
                accountName: Text(
                  snapshot.data.getName + ' ' + snapshot.data.getSurname,
                  style: TextStyle(fontSize: 20),
                ),
                accountEmail: Text(snapshot.data.getPhone),
                currentAccountPicture: snapshot.data.getAvatar != null
                    ? CircleAvatar(
                        backgroundImage:
                            CachedNetworkImageProvider(snapshot.data.getAvatar),
                      )
                    : null,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        colorFilter:
                            ColorFilter.mode(Colors.black45, BlendMode.darken),
                        image: CachedNetworkImageProvider(
                          'https://gorod-plus.tv/sites/default/files/styles/article/public/2018-12/f_3_u2gfqds.jpg?itok=HbwDk0SI',
                        ),
                        fit: BoxFit.fill)),
              );
            },
          ),
          ListTile(
            title: Text('VK беседа'),
            trailing: Icon(Icons.phone_in_talk),
            onTap: () {
              launch("vk://vk.com/im?sel=c44");
            },
          ),
          ListTile(
            title: Text('Матчи'),
            onTap: (){
              Navigator.pop(context);
              widget._homeBloc.navigationChange('MATCHES');
            },
          ),
         
          Divider(),
          
        
          ListTile(
            title: Text(
              'Выйти',
              style: TextStyle(color: Colors.red),
            ),
            trailing: Icon(Icons.exit_to_app),
            onTap: () {
              Navigator.pop(context);
              widget._authBloc.eventSink.add(Logout());
            },
          ),
          
        ],
      ),
    );
  }
}
