import 'dart:async';
import 'package:flutter/material.dart';
import 'package:midterm_exam/Location.dart';
import 'package:midterm_exam/MainPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoPage extends StatefulWidget {
  final Location location;
  const InfoPage({Key key, this.location}) : super(key: key);
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  List locationName;
  @override
  void initState() {
    super.initState();
    print("location");
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
          //backgroundColor: Colors.cyan,
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text("Details Information"),
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
                        "http://slumberjer.com/visitmalaysia/images/${widget.location.imagename}",
                    placeholder: (context, url) =>
                        new CircularProgressIndicator(),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                  )),
                  SizedBox(height: 6),
                  Container(
                      child: Card(
                          elevation: 6,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: <Widget>[
                                Table(
                                  defaultColumnWidth: FlexColumnWidth(1.0),
                                  children: [
                                    TableRow(children: [
                                      TableCell(
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 30,
                                          child: Text(
                                              "Location:" +
                                                  widget.location.loc_name,
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
                                          child: Text(
                                              "State:" + widget.location.state,
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
                                          child: Text(
                                              "Description:" +
                                                  widget.location.description,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              )),
                                        ),
                                      ),
                                    ]),
                                    TableRow(children: [
                                      TableCell(
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 30,
                                          child:
                                              Text("URL:" + widget.location.url,
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
                                          child: Text(
                                              "Contact:" +
                                                  widget.location.contact,
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
                                          child: Text(
                                              "Address:" +
                                                  widget.location.address,
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
                          ))),
                  SizedBox(
                    height: 10,
                  ),
                  RaisedButton(
                    onPressed: _launchURL,
                    child: Text('Open Website'),
                  ),
                  RaisedButton(
                    onPressed: _launchPhone,
                    child: Text('Call'),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Future<bool> _onBackPressAppBar() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MainPage()));
    return Future.value(false);
  }

  _launchURL() async {
    String url = 'http:' + widget.location.url;
    print(widget.location.url);
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchPhone() async {
    String tel = 'tel:' + widget.location.contact;
    print(widget.location.url);
    print(tel);
    if (await canLaunch(tel)) {
      await launch(tel);
    } else {
      throw 'Could not launch $tel';
    }
  }
}
