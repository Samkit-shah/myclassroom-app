import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'RegisterModel.dart';
import 'main.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  registerFunction(
      String inputClassname,
      String inputadminpassword,
      String inputacademicyear,
      String inputclassdivision,
      String inputcrname,
      String inputsrname,
      String inputcontactnumber,
      String inputclasspassword) async {
    var url =
        Uri.parse('https://myclassmanager.herokuapp.com/api/register-class');
    var response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'classname': inputClassname,
          'adminpassword': inputadminpassword,
          'academicyear': inputacademicyear,
          'classdivision': inputclassdivision,
          'crname': inputcrname,
          'srname': inputsrname,
          'contactnumber': inputcontactnumber,
          'classpassword': inputclasspassword,
        }));
    String jsonData = response.body;
    print(response.body);
    if (response.statusCode == 201) {
      RegisterModel responsedata = registerModelFromJson(jsonData);
      print(responsedata);
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.setString('loggedin', 'true');
      // prefs.setString('admin', responsedata.admin.toString());
      // prefs.setString('classname', responsedata.classname.toString());
      // prefs.setString('classid', responsedata.classid.toString());
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_context) => ClassManager()),
        (Route<dynamic> route) => false,
      );
    } else {
      print(response.reasonPhrase);
      Navigator.pop(context);
      // _showAlert(context);
    }
  }

  TextEditingController classname = TextEditingController();
  TextEditingController adminpassword = TextEditingController();
  TextEditingController academicyear = TextEditingController();
  TextEditingController classdivision = TextEditingController();
  TextEditingController crname = TextEditingController();
  TextEditingController srname = TextEditingController();
  TextEditingController contactnumber = TextEditingController();
  TextEditingController classpassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Dashboard"),
        ),
        body: Container(
            child: Padding(
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
              child: Column(children: [
            Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: TextField(
                  controller: classname,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Class Name'),
                )),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: TextField(
                  controller: adminpassword,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Admin Password'),
                )),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: TextField(
                  controller: academicyear,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Academic Year'),
                )),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: TextField(
                  controller: classdivision,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Class Division'),
                )),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: TextField(
                  controller: crname,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: 'CR Name'),
                )),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: TextField(
                  controller: srname,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: 'SR Name'),
                )),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: TextField(
                  controller: contactnumber,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Contact Number'),
                )),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: TextField(
                  controller: classpassword,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Class Password'),
                )),
            ElevatedButton(
              child: Text('Register Classroom'),
              onPressed: () {
                String inputClassname = classname.text;
                String inputadminpassword = adminpassword.text;
                String inputacademicyear = academicyear.text;
                String inputclassdivision = classdivision.text;
                String inputcrname = crname.text;
                String inputsrname = srname.text;
                String inputcontactnumber = contactnumber.text;
                String inputclasspassword = classpassword.text;
                setState(() {
                  if (inputClassname.isEmpty ||
                      inputadminpassword.isEmpty ||
                      inputacademicyear.isEmpty ||
                      inputsrname.isEmpty ||
                      inputcontactnumber.isEmpty ||
                      inputclasspassword.isEmpty ||
                      inputcrname.isEmpty) {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text("Error"),
                              content: Text(
                                  "All the Fields are Compulsory.Please Enter All the details"),
                              actions: <Widget>[
                                Center(
                                  child: new ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop(); // dismisses only the dialog and returns nothing
                                    },
                                    child: new Text('Ok I\'will '),
                                  ),
                                ),
                              ],
                            ));
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        });
                    registerFunction(
                        inputClassname,
                        inputadminpassword,
                        inputacademicyear,
                        inputclassdivision,
                        inputcrname,
                        inputsrname,
                        inputcontactnumber,
                        inputclasspassword);
                    // _futureAlbum =
                  }
                });
                // DataModel data = await submitdata(title, body, userId);
              },
            )
          ])),
        )));
  }
}
