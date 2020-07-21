import 'package:flutter/material.dart';
import 'package:grocery/Payment.dart';
import 'package:grocery/SleepBox.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:grocery/MainScreen.dart';
import 'package:grocery/User.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'MainScreen.dart';
import 'EditInfo.dart';

class Info extends StatefulWidget {
  final SleepBox sleepBox;
  final User user;

  const Info({Key key, this.sleepBox, this.user}) : super(key: key);

  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  List sleepBox;
  bool _isadmin = false;
  @override
  void initState() {
    super.initState();
    if (widget.user.email == "alanberamboi@gmail.com") {
      _isadmin = true;
    }
    print("sleepbox");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("SleepBox Information"),
          backgroundColor: Colors.cyan,
        ),
        body: Container(
          padding: EdgeInsets.all(5),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  child: CachedNetworkImage(
                    fit: BoxFit.fill,
                    imageUrl:
                        "http://jarfp.com/sleepsoundly/images/${widget.sleepBox.id}.jpg",
                    placeholder: (context, url) =>
                        new CircularProgressIndicator(),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                  ),
                ),
                SizedBox(height: 6),
                Container(
                  child: Card(
                    elevation: 6,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Table(
                            defaultColumnWidth: FlexColumnWidth(1),
                            children: [
                              TableRow(children: [
                                TableCell(
                                    child: Container(
                                  alignment: Alignment.centerLeft,
                                  height: 30,
                                  child: Text("Name:" + widget.sleepBox.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      )),
                                ))
                              ]),
                              TableRow(children: [
                                TableCell(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 30,
                                    child:
                                        Text("Adress:" + widget.sleepBox.adress,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            )),
                                  ),
                                )
                              ]),
                              TableRow(children: [
                                TableCell(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 30,
                                    child:
                                        Text("Price:" + widget.sleepBox.price,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            )),
                                  ),
                                )
                              ]),
                              TableRow(children: [
                                TableCell(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 30,
                                    child:
                                        Text("Phone:" + widget.sleepBox.phone,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            )),
                                  ),
                                )
                              ]),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ButtonBar(
                  children: <Widget>[
                    RaisedButton(
                      onPressed: _launchPhone,
                      child: Text("CALL"),
                    ),
                    RaisedButton(child: Text("BOOK NOW"), onPressed: _book)
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Visibility(
                  visible: _isadmin,
                  child: Column(
                    children: <Widget>[
                      MaterialButton(
                        child: Text("EDIT INFORMATION"),
                        onPressed: _editInfo,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _book() {
    showDialog(
        context: context,
        // ignore: missing_return
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: EdgeInsets.all(20),
            title: new Text(
              "BOOKING",
              textAlign: TextAlign.center,
            ),
            content: new Container(
                child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        child: Text("Check In"),
                        onPressed: () async {
                          DateTime newDateTime = await showRoundedDatePicker(
                              context: context,
                              theme: ThemeData.dark(),
                              initialDate: DateTime.now(),
                              firstDate: DateTime(DateTime.now().year - 1),
                              lastDate: DateTime(DateTime.now().year + 1),
                              borderRadius: 16);
                        },
                      ),
                      SizedBox(width: 30),
                      RaisedButton(
                        child: Text("Check Out"),
                        onPressed: () async {
                          DateTime newDateTime = await showRoundedDatePicker(
                              context: context,
                              theme: ThemeData.dark(),
                              initialDate: DateTime.now(),
                              firstDate: DateTime(DateTime.now().year - 1),
                              lastDate: DateTime(DateTime.now().year + 1),
                              borderRadius: 16);
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        child: Text(
                          "BOOK NOW",
                        ),
                        onPressed: () => {
                          Navigator.pop(context),
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => Payment()))
                        },
                      ),
                    ],
                  ),
                ],
              ),
            )),
          );
        });
  }

  // ignore: missing_return
  Future<bool> _onBackPressAppBar() async {
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => MainScreen(
                  user: widget.user,
                )));
  }

  _launchPhone() async {
    String tel = 'tel:' + widget.sleepBox.phone;
    print(tel);
    if (await canLaunch(tel)) {
      await launch(tel);
    } else {
      throw 'Could not launch $tel';
    }
  }

  void _editInfo() async {
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => EditInfo(
                  sleepBox: widget.sleepBox,
                )));
  }
}
