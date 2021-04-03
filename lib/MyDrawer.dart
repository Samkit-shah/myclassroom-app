import 'package:classmanager/Dashboard.dart';
import 'package:classmanager/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'GetAnnouncement.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('admin', '');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_context) => ClassManager()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          FutureBuilder(
              future: SharedPreferences.getInstance(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return new UserAccountsDrawerHeader(
                      accountName: new Text(
                          'Welcome to ' + snapshot.data.getString('classname')),
                      accountEmail: (snapshot.data.getString('admin') == '1')
                          ? new Text('Role:- CR/SR')
                          : new Text('Role:- Student'));
                } else {
                  return new UserAccountsDrawerHeader(
                      accountName: new Text('ClassName'), accountEmail: null);
                }
              }),
          ListTile(
            title: Text('DashBoard'),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_context) => Dashboard()),
                (Route<dynamic> route) => false,
              );
            },
          ),
          ListTile(
            title: Text('Announcements'),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_context) => GetAnnouncement()),
                (Route<dynamic> route) => false,
              );
            },
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () {
              logout();
            },
          ),
        ],
      ),
    );
  }
}
