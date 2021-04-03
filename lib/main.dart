import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'Dashboard.dart';
import 'LoginModel.dart';
import 'RegisterPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var loggedin = prefs.getString('admin');
  print(loggedin);
  runApp(MaterialApp(home: loggedin != '' ? Dashboard() : ClassManager()));
}

class ClassManager extends StatefulWidget {
  @override
  _ClassManagerState createState() => _ClassManagerState();
}

class _ClassManagerState extends State<ClassManager> {
  loginFunction(
      String inputClassname, String inputPassword, String rememberme) async {
    var url = Uri.parse('https://myclassmanager.herokuapp.com/api/login');
    var response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'classname': inputClassname,
          'password': inputPassword,
          'remember': rememberme
        }));
    String jsonData = response.body;
    print(response.body);
    if (response.statusCode == 201) {
      Login responsedata = loginFromJson(jsonData);
      print(responsedata.classname);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('loggedin', 'true');
      prefs.setString('admin', responsedata.admin.toString());
      prefs.setString('classname', responsedata.classname.toString());
      prefs.setString('classid', responsedata.classid.toString());
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_context) => Dashboard()),
        (Route<dynamic> route) => false,
      );
    } else {
      print(response.reasonPhrase);
      Navigator.pop(context);
      _showAlert(context);
    }
  }

  void _showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Error"),
              content: Text("Incorrect Password or ClassName"),
              actions: <Widget>[
                new ElevatedButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true)
                        .pop(); // dismisses only the dialog and returns nothing
                  },
                  child: new Text('Retry'),
                ),
              ],
            ));
  }

  TextEditingController classname = TextEditingController();
  TextEditingController password = TextEditingController();
  bool _validatename = true;
  bool _validatepassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Class Room'),
        ),
        body: Container(
            child: Column(
          children: [
            Padding(
                padding: EdgeInsets.all(26.0),
                child: TextField(
                  controller: classname,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Class Name',
                    errorText:
                        _validatename ? null : 'ClassName Can\'t Be Empty',
                  ),
                )),
            Padding(
                padding: EdgeInsets.all(26.0),
                child: TextField(
                  controller: password,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Class Password',
                    errorText:
                        _validatepassword ? null : 'Password Can\'t Be Empty',
                  ),
                )),
            ElevatedButton(
              child: Text('Login'),
              onPressed: () {
                String inputClassname = classname.text;
                String inputPassword = password.text;
                String rememberme = '0';
                setState(() {
                  inputClassname.isEmpty
                      ? _validatename = false
                      : _validatename = true;
                  inputPassword.isEmpty
                      ? _validatepassword = false
                      : _validatepassword = true;
                  if (_validatename == true && _validatepassword == true) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        });
                    loginFunction(inputClassname, inputPassword, rememberme);
                  } else {
                    return null;
                  }
                  // _futureAlbum =
                });
                // DataModel data = await submitdata(title, body, userId);
              },
            ),
            ElevatedButton(
              child: Text('Register'),
              onPressed: () {
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_context) => RegisterPage()),
                  );
                });
                // DataModel data = await submitdata(title, body, userId);
              },
            )
          ],
        )));
  }
}
