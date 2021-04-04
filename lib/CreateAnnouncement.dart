import 'dart:convert';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'Model/CreateAnnouncementModel.dart';

class CreateAnnouncement extends StatefulWidget {
  @override
  _CreateAnnouncementState createState() => _CreateAnnouncementState();
}

class _CreateAnnouncementState extends State<CreateAnnouncement> {
  createAnnouncementFunction(String inputtitle, String inputdetails,
      String inputlabel, String inputdeadline) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var classid = prefs.getString('classid');
    var url =
        Uri.parse('https://myclassmanager.herokuapp.com/api/makeannouncement');
    var response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'title': inputtitle,
          'details': inputdetails,
          'label': inputlabel,
          'deadline': inputdeadline,
          'classid': classid,
        }));
    String jsonData = response.body;
    print(response.body);
    if (response.statusCode == 201) {
      CreateAnnouncementModel responsedata =
          createAnnouncementModelFromJson(jsonData);
      print(responsedata);

      // Navigator.pushAndRemoveUntil(
      //   context,
      //   MaterialPageRoute(
      //     builder: (_context) => MainScreen(),
      //   ),
      //   (Route<dynamic> route) => false,
      // );
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      print(response.reasonPhrase);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text("Failed To Make Announcement Please Try Again Later.")));
      // _showAlert(context);
    }
  }

  final format = DateFormat("yyyy-MM-dd HH:mm");
  TextEditingController title = TextEditingController();
  TextEditingController details = TextEditingController();
  TextEditingController label = TextEditingController();
  TextEditingController deadline = TextEditingController();
  List<String> _labels = [
    'Urgent',
    'Submission',
    'Reschedule',
    'Other'
  ]; // Option 2
  String _selectedLabel; // Option 2
  bool _dropdownSelected = false; // Option 2

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Make Announcement"),
        ),
        body: Container(
            child: Padding(
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
              child: Column(children: [
            Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: TextField(
                  controller: title,
                  decoration: InputDecoration(
                      disabledBorder:
                          UnderlineInputBorder(borderSide: BorderSide.none),
                      contentPadding: EdgeInsets.only(top: 0.0),
                      hintText: 'Title of the announcement'),
                )),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: TextField(
                  controller: details,
                  decoration: InputDecoration(
                      disabledBorder:
                          UnderlineInputBorder(borderSide: BorderSide.none),
                      contentPadding: EdgeInsets.only(top: 0.0),
                      hintText: 'Details'),
                )),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: DateTimeField(
                format: format,
                decoration: InputDecoration(
                    hintText: 'Deadline or Date of annoucement'),
                controller: deadline,
                onShowPicker: (context, currentValue) async {
                  final date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100));
                  if (date != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(
                          currentValue ?? DateTime.now()),
                    );
                    return DateTimeField.combine(date, time);
                  } else {
                    return currentValue;
                  }
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: DropdownButton(
                  isExpanded: true,
                  hint: Text(
                      'Choose the appropriate label'), // Not necessary for Option 1
                  value: _selectedLabel,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedLabel = newValue;
                      _dropdownSelected = true;
                      print(_dropdownSelected);
                    });
                  },
                  items: _labels.map((label) {
                    return DropdownMenuItem(
                      child: new Text(label),
                      value: label,
                    );
                  }).toList()),
            ),
            ElevatedButton(
              child: Text('Make Announcement'),
              onPressed: () {
                print(_dropdownSelected);
                String inputtitle = title.text;
                String inputdetails = details.text;
                String inputlabel = _selectedLabel;
                String inputdeadline = deadline.text;
                setState(() {
                  if (inputtitle.isEmpty ||
                      inputdetails.isEmpty ||
                      inputdeadline.isEmpty ||
                      _dropdownSelected != true) {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text("Error"),
                              content: Text("Please Fill In all the Details"),
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
                    createAnnouncementFunction(
                        inputtitle, inputdetails, inputlabel, inputdeadline);
                  }

                  // _futureAlbum =
                });
                // DataModel data = await submitdata(title, body, userId);
              },
            )
          ])),
        )));
  }
}
