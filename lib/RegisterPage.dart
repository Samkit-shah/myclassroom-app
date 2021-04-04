import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'LoginRegisterPage.dart';
import 'Model/RegisterModel.dart';

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
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_context) => LoginRegisterPage()),
        (Route<dynamic> route) => false,
      );
    } else if (response.statusCode == 406) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Error"),
                content: Text(
                    "The ClassName is already used. \n Please provide other ClassName"),
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
      print(response.reasonPhrase);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Failed To Register \n Please Try Again later.")));
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_context) => LoginRegisterPage()),
        (Route<dynamic> route) => false,
      );
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
          title: Text("Register Now"),
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
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.black87,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black12,
                          width: 2.0,
                        ),
                      ),
                      labelText: 'ClassName',
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      hintText: 'Enter The Name Of Your Class/Batch'),
                )),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: TextField(
                  controller: adminpassword,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.black87,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black12,
                          width: 2.0,
                        ),
                      ),
                      labelText: 'Admin Password',
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      hintText: 'Password To Be used by the Admin(Cr/Sr)'),
                )),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: TextField(
                  controller: academicyear,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.black87,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black12,
                          width: 2.0,
                        ),
                      ),
                      labelText: 'Academic Year',
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      hintText: 'Academic Year'),
                )),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: TextField(
                  controller: classdivision,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.black87,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black12,
                          width: 2.0,
                        ),
                      ),
                      labelText: 'Class Division',
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      hintText: 'Class Division'),
                )),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: TextField(
                  controller: crname,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.black87,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black12,
                          width: 2.0,
                        ),
                      ),
                      labelText: 'CR Name',
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      hintText: 'Enter the Cr Name'),
                )),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: TextField(
                  controller: srname,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.black87,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black12,
                          width: 2.0,
                        ),
                      ),
                      labelText: 'SR Name',
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      hintText: 'Enter Sr Name'),
                )),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: TextField(
                  controller: contactnumber,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.black87,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black12,
                          width: 2.0,
                        ),
                      ),
                      labelText: 'Contact Number',
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      hintText: 'Contact Number'),
                )),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: TextField(
                  controller: classpassword,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.black87,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black12,
                          width: 2.0,
                        ),
                      ),
                      labelText: 'Class Password',
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      hintText: 'Password To Be used by the students'),
                )),
            ElevatedButton(
              child: Text('Register Class'),
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
