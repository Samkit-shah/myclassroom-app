import 'dart:async';

import 'package:classmanager/LoginRegisterPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'MainScreen.dart';

void main() {
  runApp(MaterialApp(home: MyHomePage()));
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  checksession() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var loggedin = prefs.getString('loggedin');
    if (loggedin != 'false' && loggedin != null) {
      setState(() {
        callbackmodel = MainScreen();
      });
    } else {
      setState(() {
        callbackmodel = LoginRegisterPage();
      });
    }
  }

  var callbackmodel;

  @override
  initState() {
    super.initState();
    checksession();
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => callbackmodel)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          margin: EdgeInsets.symmetric(vertical: 100, horizontal: 0),
          child: Center(
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 45),
                    child: Image.asset("welcome.gif"),
                  ),
                  // Text(
                  //   'Loading.....',
                  //   style: TextStyle(color: Colors.white.withOpacity(0.6)),
                  // )
                ],
              ),
            ),
          )),
    );
  }
}
