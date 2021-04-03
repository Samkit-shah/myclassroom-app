import 'package:classmanager/MyDrawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'ClassDataModel.dart';
import 'main.dart';

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
        MaterialPageRoute(builder: (_context) => ClassManager()),
        (Route<dynamic> route) => false,
      );
    }
  }

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
    return Scaffold(
        appBar: AppBar(
          title: Text("Dashboard"),
        ),
        body: FutureBuilder(
            future: getClassData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                    child: Card(
                  elevation: 15,
                  margin: EdgeInsets.all(30),
                  borderOnForeground: true,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.thumbs_up_down,
                          color: Colors.black,
                          size: 24.0,
                          semanticLabel:
                              'Text to announce in accessibility modes',
                        ),
                        title: Text(snapshot.data.classname != null
                            ? snapshot.data.classname
                            : 'ClassName'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(snapshot.data.id.toString() != null
                            ? 'Class Id :-' + snapshot.data.id.toString()
                            : 'Class Id'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                            snapshot.data.academicyear.toString() != null
                                ? 'Academic year :-' +
                                    snapshot.data.academicyear.toString()
                                : 'Academic year'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                            snapshot.data.classdivision.toString() != null
                                ? 'Division :-' +
                                    snapshot.data.classdivision.toString()
                                : 'Division'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(snapshot.data.crname.toString() != null
                            ? 'CR Name :-' + snapshot.data.crname.toString()
                            : 'CR Name'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(snapshot.data.srname.toString() != null
                            ? 'SR Name :-' + snapshot.data.srname.toString()
                            : 'SR Name'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                            snapshot.data.contactnumber.toString() != null
                                ? 'Contact Number :-' +
                                    snapshot.data.contactnumber.toString()
                                : 'Contact Number'),
                      ),
                    ],
                  ),
                ));
              } else
                return Center(child: CircularProgressIndicator());
            }),
        drawer: MyDrawer());
  }
}
