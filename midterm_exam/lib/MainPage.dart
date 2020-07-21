import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:midterm_exam/InfoPage.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:midterm_exam/Location.dart';


class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class User {}

class _MainPageState extends State<MainPage> {
  double screenHeight, screenWidth;
  List locationName;
  List<String> _state = [
    'Kedah',
    'Kelantan',
    'Terengganu',
    'Perak',
    'Pulau Pinang',
    'Pahang',
    'Johor',
    'Selangor',
    'Melaka',
    'Negeri Sembilan',
    'Perlis',
    'Sabah',
    'Sarawak'
  ];
  String _currentState = 'Kedah';

  get index => null;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    if (locationName == null) {
      return Scaffold(
          appBar: AppBar(
            title: Text("WELCOME TO TOURISM MALAYSIA"),
                    backgroundColor: Colors.cyan,
          ),
          body: Center(
            child: CircularProgressIndicator(),
          ));
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text("WELCOME TO TOURISM MALAYSIA"),
            backgroundColor: Colors.cyan,
          ),
          body: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(5),
                  child: DropdownButton<String>(
                    items: _state.map((String dropdownStringItem) {
                      return DropdownMenuItem<String>(
                        value: dropdownStringItem,
                        child: Text(
                          dropdownStringItem,
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.cyan,
                              fontWeight: FontWeight.w400),
                        ),
                      );
                    }).toList(),
                    value: _currentState,
                    onChanged: (String _currentState) {
                      _onDropDownSelectedItem(_currentState);
                    },
                  ),
                ),
                Flexible(
                  child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 100 / 130,
                      children: List.generate(locationName.length, (index) {
                        return Container(
                          child: Card(
                              elevation: 10,
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap:() => 
                                      {Navigator.of(context).pop(),_onProductDetail(index)},
                                      child: Container(
                                        height: screenHeight / 5.9,
                                        width: screenWidth / 3.5,
                                        child: ClipOval(
                                            child: CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl:
                                              "http://slumberjer.com/visitmalaysia/images/${locationName[index]['imagename']}",
                                          placeholder: (context, url) =>
                                              new CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              new Icon(Icons.error),
                                        )),
                                      ),
                                    ),
                                    Text(
                                      locationName[index]['loc_name'],
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      "State :" + locationName[index]['state'],
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              )),
                        );
                      })),
                )
              ],
            ),
          ));
    }
  }

  void _loadData() {
    String urlLoadJobs =
        "http://slumberjer.com/visitmalaysia/load_destinations.php";
    http.post(urlLoadJobs, body: {}).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        locationName = extractdata["locations"];
      });
    }).catchError((err) {
      print(err);
    });
  }

  void _onDropDownSelectedItem(String newvalue){
    setState(() {
      this._currentState = newvalue;
      _sortItem();
    });
  }

    void _sortItem() {
    try {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: true);
      pr.style(message: "Searching...");
      pr.show();
      String urlLoadJobs =
          "http://slumberjer.com/visitmalaysia/load_destinations.php";
      http.post(urlLoadJobs, body: {
        'state': _currentState,
      }).then((res) {
        setState(() {
          var extractdata = json.decode(res.body);
          locationName = extractdata["locations"];
          FocusScope.of(context).requestFocus(new FocusNode());
          pr.hide();
        });
      }).catchError((err) {
        print(err);
        pr.hide();
      });
      pr.hide();
    } catch (e) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

    _onProductDetail(int index) async {
    print(locationName[index]['loc_name']);

    Location location = new Location(
      pid : locationName[index]['pid'],
      loc_name:locationName[index]['loc_name'],
      state : locationName[index]['state'],
      description : locationName[index]['description'],
      latitude : locationName[index]['latitude'],
      longitude : locationName[index]['longitude'],
      url : locationName[index]['url'],
      contact : locationName[index]['contact'],
      address : locationName[index]['address'],
      imagename : locationName[index]['imagename']);
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => InfoPage(
              location: location,
            )));
    _loadData();
  }

}
