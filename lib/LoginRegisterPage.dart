import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'Model/LoginModel.dart';
import 'MainScreen.dart';
import 'RegisterPage.dart';

class LoginRegisterPage extends StatefulWidget {
  @override
  _LoginRegisterPageState createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
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
        MaterialPageRoute(builder: (_context) => MainScreen()),
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
  bool _passwordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Class Room'),
        ),
        body: SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("bg4.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),
                  Padding(
                      padding: EdgeInsets.all(26.0),
                      child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          keyboardType: TextInputType.text,
                          controller: classname,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 2.0,
                              ),
                            ),
                            border: OutlineInputBorder(),
                            errorText: _validatepassword
                                ? null
                                : 'ClassName Can\'t Be Empty',
                            labelText: 'ClassName',
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            hintText: 'Enter your ClassName',
                          ))),
                  Padding(
                      padding: EdgeInsets.all(26.0),
                      child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          keyboardType: TextInputType.text,
                          controller: password,
                          obscureText:
                              !_passwordVisible, //This will obscure text dynamically
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 2.0,
                              ),
                            ),
                            border: OutlineInputBorder(),
                            errorText: _validatepassword
                                ? null
                                : 'Password Can\'t Be Empty',
                            labelText: 'Password',
                            hintText: 'Enter your password',
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            // Here is key idea
                            suffixIcon: IconButton(
                              icon: Icon(
                                // Based on passwordVisible state choose the icon
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                // Update the state i.e. toogle the state of passwordVisible variable
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                          ))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          MaterialButton(
                            height: 40.0,
                            minWidth: 100.0,
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            splashColor: Colors.redAccent,
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
                                if (_validatename == true &&
                                    _validatepassword == true) {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      });
                                  loginFunction(inputClassname, inputPassword,
                                      rememberme);
                                } else {
                                  return null;
                                }
                                // _futureAlbum =
                              });
                              // DataModel data = await submitdata(title, body, userId);
                            },
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          MaterialButton(
                            height: 40.0,
                            minWidth: 100.0,
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            splashColor: Colors.redAccent,
                            child: Text('Register'),
                            onPressed: () {
                              setState(() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_context) => RegisterPage()),
                                );
                              });
                              // DataModel data = await submitdata(title, body, userId);
                            },
                          )
                        ],
                      )
                    ],
                  )
                ],
              )),
        ));
  }
}
