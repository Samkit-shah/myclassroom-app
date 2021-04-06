import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Dashboard.dart';
import 'GetAnnouncement.dart';
import 'LoginRegisterPage.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    Dashboard(),
    GetAnnouncement(),
    // GetAnnouncement(),
  ];

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('admin', '');
    prefs.setString('loggedin', 'false');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_context) => LoginRegisterPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  initState() {
    super.initState();
    _title = 'Class Profile';
    // print(_title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_title), actions: <Widget>[
        Tooltip(
          message: 'LogOut',
          child: ElevatedButton(
            onPressed: () async {
              logout();
            },
            child: Column(
              // Replace with a Row for horizontal icon + text
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 1),
                  child: Icon(Icons.logout),
                )
              ],
            ),
            // shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ),
      ]),
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.supervised_user_circle_sharp),
            label: 'Announcements',
            activeIcon: Icon(
              Icons.supervised_user_circle_sharp,
              size: 36,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.dashboard,
              semanticLabel: 'Profile',
            ),
            label: 'Profile',
            activeIcon: Icon(
              Icons.dashboard,
              size: 36,
            ),
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          onTabTapped(_selectedIndex);
        },
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }

  String _title;
  void onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          {
            _title = 'Class Profile';
          }
          break;
        case 1:
          {
            _title = 'Announcements';
          }
          break;
      }
    });
  }
}
