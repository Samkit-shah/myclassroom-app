import 'dart:async';

import 'package:classmanager/LoginRegisterPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'MainScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var loggedin = prefs.getString('admin');
  print(loggedin);
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
    var loggedin = prefs.getString('admin');
    print(loggedin);
    setState(() {
      if (loggedin != '') {
        callbackmodel = LoginRegisterPage();
      } else {
        callbackmodel = MainScreen();
      }
    });
  }

  var callbackmodel;
  @override
  initState() {
    super.initState();
    checksession();
    Timer(
        Duration(seconds: 4),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => callbackmodel)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
          // margin: EdgeInsets.symmetric(vertical: 45, horizontal: 30),
          child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 45),
          child: Image.asset("welcome.gif"),
        ),
      )),
    );
  }
}
