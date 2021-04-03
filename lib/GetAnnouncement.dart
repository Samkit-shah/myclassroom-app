import 'package:classmanager/MyDrawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'AnnouncementModel.dart';
import 'CreateAnnouncement.dart';
import 'main.dart';
import 'package:intl/intl.dart';

class GetAnnouncement extends StatefulWidget {
  @override
  _GetAnnouncementState createState() => _GetAnnouncementState();
}

class _GetAnnouncementState extends State<GetAnnouncement> {
  getAnnouncements() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var classid = prefs.getString('classid');
    var url = Uri.parse(
        'https://myclassmanager.herokuapp.com/api/getannouncement/' + classid);
    var response = await http.get(url);
    String jsonData = response.body;
    if (response.statusCode == 201) {
      print(jsonData);
      return announcementModelFromJson(jsonData);
    } else {
      // print(jsonData);
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
          title: Text("Announcements"),
        ),
        body: FutureBuilder(
            future: getAnnouncements(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, i) {
                      return ListTile(
                        leading: const Icon(Icons.check),
                        title: Text(snapshot.data[i].title),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailScreen(announcement: snapshot.data[i]),
                            ),
                          );
                        },
                      );
                    });
              }
            }),
        drawer: MyDrawer(),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FutureBuilder(
              future: SharedPreferences.getInstance(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.getString('admin') == '1') {
                    return new Visibility(
                        visible: true,
                        child: new FloatingActionButton.extended(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CreateAnnouncement()));
                          },
                          label: Icon(Icons.add_circle_outline_outlined),
                          backgroundColor: Colors.black,
                        ));
                  } else {
                    return new Visibility(
                        visible: false,
                        child: new FloatingActionButton.extended(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CreateAnnouncement()));
                          },
                          label: Icon(Icons.add_circle_outline_outlined),
                          backgroundColor: Colors.black,
                        ));
                  }
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              })
        ]));
  }
}

class DetailScreen extends StatelessWidget {
  // Declare a field that holds the Todo.
  final AnnouncementModel announcement;

  // In the constructor, require a Todo.
  DetailScreen({Key key, @required this.announcement}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(
        title: Text(announcement.title.toString()),
      ),
      body: Container(
          child: Card(
        elevation: 15,
        margin: EdgeInsets.all(30),
        borderOnForeground: true,
        child: Column(
          children: [
            ListTile(
              leading: Icon(
                Icons.analytics,
                color: Colors.pink,
                size: 24.0,
                semanticLabel: 'Text to announce in accessibility modes',
              ),
              title: Text(announcement.title != null
                  ? announcement.title
                  : 'Announcement Title'),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(announcement.details != null
                  ? announcement.details
                  : 'details'),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                  announcement.label != null ? announcement.label : 'label'),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(DateFormat('yyyy-MM-dd – kk:mm')
                          .format(announcement.deadline) !=
                      null
                  ? DateFormat('yyyy-MM-dd – kk:mm')
                      .format(announcement.deadline)
                  : 'Deadline'),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(DateFormat('yyyy-MM-dd – kk:mm')
                          .format(announcement.createdAt) !=
                      null
                  ? DateFormat('yyyy-MM-dd – kk:mm')
                      .format(announcement.createdAt)
                  : 'Created Date'),
            ),
          ],
        ),
      )),
    );
  }
}
