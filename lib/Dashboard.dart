import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'Model/ClassDataModel.dart';
import 'LoginRegisterPage.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Future<ClassData> getClassData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var classid = prefs.getString('classid');
    var url =
        Uri.parse('https://myclassmanager.herokuapp.com/api/class/' + classid);
    var response = await http.get(url);
    String jsonData = response.body;
    if (response.statusCode == 200) {
      // print(imagesFromJson(jsonData));
      return classDataFromJson(jsonData);
    } else {
      return Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_context) => LoginRegisterPage()),
        (Route<dynamic> route) => false,
      );
    }
  }

  double elevation = 15;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: getClassData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: GestureDetector(
                    onLongPress: () {
                      setState(() {
                        elevation = 5;
                      });
                    },
                    onTap: () {
                      setState(() {
                        elevation = 35;
                      });
                    },
                    child: Card(
                      elevation: elevation,
                      margin: EdgeInsets.all(20),
                      borderOnForeground: true,
                      child: Column(
                        children: [
                          FutureBuilder(
                              future: SharedPreferences.getInstance(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Center(
                                    child: UserAccountsDrawerHeader(
                                        accountName: new Text('Welcome to ' +
                                            snapshot.data
                                                .getString('classname')
                                                .toUpperCase()),
                                        accountEmail: (snapshot.data
                                                    .getString('admin') ==
                                                '1')
                                            ? new Text('Logged in as CR/SR')
                                            : new Text('Logged in as Student')),
                                  );
                                } else {
                                  return Center(
                                    child: new UserAccountsDrawerHeader(
                                        accountName: new Text('ClassName'),
                                        accountEmail: null),
                                  );
                                }
                              }),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: Text(snapshot.data.id.toString() != null
                                  ? 'Class Id :-' + snapshot.data.id.toString()
                                  : 'Class Id'),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: Text(
                                  snapshot.data.academicyear.toString() != null
                                      ? 'Academic year :-' +
                                          snapshot.data.academicyear.toString()
                                      : 'Academic year'),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: Text(
                                  snapshot.data.classdivision.toString() != null
                                      ? 'Division :-' +
                                          snapshot.data.classdivision.toString()
                                      : 'Division'),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: Text(
                                  snapshot.data.crname.toString() != null
                                      ? 'CR Name :-' +
                                          snapshot.data.crname.toString()
                                      : 'CR Name'),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: Text(
                                  snapshot.data.srname.toString() != null
                                      ? 'SR Name :-' +
                                          snapshot.data.srname.toString()
                                      : 'SR Name'),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: Text(
                                  snapshot.data.contactnumber.toString() != null
                                      ? 'Contact Number :-' +
                                          snapshot.data.contactnumber.toString()
                                      : 'Contact Number'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ));
            } else
              return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
