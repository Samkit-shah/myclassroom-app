import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'Model/AnnouncementModel.dart';
import 'CreateAnnouncement.dart';
import 'LoginRegisterPage.dart';
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
        MaterialPageRoute(builder: (_context) => LoginRegisterPage()),
        (Route<dynamic> route) => false,
      );
    }
  }

  deletetAnnouncements(int id) async {
    var url = Uri.parse(
        'https://myclassmanager.herokuapp.com/api/deleteannouncement/' +
            id.toString());
    var response = await http.delete(url);
    // String jsonData = response.body;
    if (response.statusCode == 204) {
      print(response.statusCode);
      return true;
    } else {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed To Delete Announcement")));
      return false;
    }
  }

  getaccessright() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isadmin = prefs.getString('admin');
    if (isadmin != '') {
      return true;
    } else {
      return false;
    }
  }

  @override
  initState() {
    super.initState();
    _response = getAnnouncements();
    _accessadmin = getaccessright();
  }

  Future _response;
  bool _accessadmin;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _response = getAnnouncements();
              });
              await new Future.delayed(const Duration(seconds: 2), () {});
            },
            child: FutureBuilder(
                future: _response,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (snapshot.data.isEmpty) {
                    return ListView(
                        physics: const AlwaysScrollableScrollPhysics(), // new
                        children: [
                          Container(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text("No Announcements"),
                              ),
                            ),
                          )
                        ]);
                  } else {
                    return ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, i) {
                          return Card(
                            child: Dismissible(
                              direction: _accessadmin
                                  ? DismissDirection.endToStart
                                  : null,
                              key: Key(snapshot.data[i].id.toString()),
                              background: Container(
                                alignment: AlignmentDirectional.centerEnd,
                                color: Colors.red,
                                child: Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              confirmDismiss: (direction) async {
                                final bool res = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: Text(
                                            "Are you sure you want to delete?"),
                                        actions: <Widget>[
                                          ElevatedButton(
                                            child: Text(
                                              "Cancel",
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.red, // background
                                              onPrimary:
                                                  Colors.black, // foreground
                                            ),
                                            child: Text(
                                              "Delete",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            onPressed: () {
                                              deletetAnnouncements(
                                                  snapshot.data[i].id);
                                              // print(responsefromfunction);

                                              setState(() {
                                                snapshot.data.removeAt(i);
                                              });
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "Announcement Deleted")));

                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    });
                                return res;
                              },
                              onDismissed: (direction) {
                                deletetAnnouncements(snapshot.data[i].id);

                                setState(() {
                                  snapshot.data.removeAt(i);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text("Announcement Deleted")));
                              },
                              child: ListTile(
                                leading: const Icon(Icons.add_circle),
                                title: Text(snapshot.data[i].title),
                                subtitle: Text(snapshot.data[i].label),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailScreen(
                                          announcement: snapshot.data[i]),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        });
                  }
                })),
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
        title: Text('Announcement Details'),
      ),
      body: Container(
          height: 400,
          child: Card(
            elevation: 15,
            margin: EdgeInsets.all(30),
            borderOnForeground: true,
            child: Column(
              children: [
                Ink(
                  color: Colors.indigo.shade100,
                  child: ListTile(
                    leading: Icon(
                      Icons.import_contacts,
                      color: Colors.pink,
                      size: 30.0,
                      semanticLabel: 'Title',
                    ),
                    title: Text(
                      announcement.title != null
                          ? announcement.title
                          : 'Announcement Title',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: Text(
                      announcement.details != null
                          ? 'Details: \n' + announcement.details
                          : 'details',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: Text(
                      announcement.label != null
                          ? 'Label: \n' + announcement.label
                          : 'label',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: Text(
                      DateFormat('yyyy-MM-dd – kk:mm')
                                  .format(announcement.deadline) !=
                              null
                          ? 'Deadline/Important Date : \n' +
                              DateFormat('dd/MM/yyyy  hh:mm a')
                                  .format(announcement.deadline)
                          : 'Deadline/Important Date',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: Text(
                      DateFormat('dd/MM/yyyy  hh:mm a')
                                  .format(announcement.createdAt) !=
                              null
                          ? 'Announcement Date : \n' +
                              DateFormat('dd/MM/yyyy  hh:mm a')
                                  .format(announcement.createdAt)
                          : 'Announcement Date',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
