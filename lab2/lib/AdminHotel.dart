import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grocery/SleepBox.dart';
import 'package:grocery/sleepboxinfo.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'NewHotel.dart';
import 'User.dart';
import 'Booking.dart';

void main() => runApp(AdminHotel());

class AdminHotel extends StatefulWidget {
  final Booking booking;
  final User user;

  const AdminHotel({Key key, this.booking, this.user}) : super(key: key);
  @override
  _AdminHotelState createState() => _AdminHotelState();
}

class _AdminHotelState extends State<AdminHotel> {
  GlobalKey<RefreshIndicatorState> refreshKey;
  List sleepbox;
  double screenHeight, screenWidth;
  String titlecenter = "Loading Hotels...";
  String server = "https://jarfp.com/sleepsoundly";
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

  @override
  void initState() {
    super.initState();
    _loadData();
    refreshKey = GlobalKey<RefreshIndicatorState>();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    if (sleepbox == null) {
      return Scaffold(
          appBar: AppBar(
            title: Text("MANAGE SLEEPBOX"),
            backgroundColor: Colors.cyan,
          ),
          body: Center(
            child: CircularProgressIndicator(),
          ));
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text("MANAGE SLEEPBOX"),
            backgroundColor: Colors.cyan,
          ),
          body: RefreshIndicator(
            key: refreshKey,
            color: Color.fromRGBO(100, 150, 200, 50),
            onRefresh: () async {
              await refreshList();
            },
            child: Container(
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
                        children: List.generate(sleepbox.length, (index) {
                          return Container(
                            child: Card(
                                elevation: 10,
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () => {
                                          Navigator.of(context).pop(),
                                          _adminSleepBoxDetails(index)
                                        },
                                        child: Container(
                                          height: screenHeight / 5.9,
                                          width: screenWidth / 3.5,
                                          child: ClipOval(
                                              child: CachedNetworkImage(
                                            fit: BoxFit.fill,
                                            imageUrl:
                                                "http://jarfp.com/sleepsoundly/images/${sleepbox[index]['id']}.jpg",
                                            placeholder: (context, url) =>
                                                new CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    new Icon(Icons.error),
                                          )),
                                        ),
                                      ),
                                      Text(
                                        sleepbox[index]['name'],
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        "State :" + sleepbox[index]['state'],
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                            color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        "Adress :" + sleepbox[index]['adress'],
                                        maxLines: 3,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                            color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        "Price : RM " +
                                            sleepbox[index]['price'],
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                            color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        "Phone :" + sleepbox[index]['phone'],
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                            color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                )),
                          );
                        })),
                  )
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => NewHotel()));
            },
            icon: Icon(Icons.add_circle_outline),
            label: Text("Add SleepBox"),
          ));
    }
  }

  void _onDropDownSelectedItem(String newvalue) {
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
      String urlLoadJobs = "http://jarfp.com/sleepsoundly/load_hotel.php";
      http.post(urlLoadJobs, body: {
        'state': _currentState,
      }).then((res) {
        setState(() {
          var extractdata = json.decode(res.body);
          sleepbox = extractdata["hotel"];
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

  void _loadData() async {
    String urlLoadJobs = "http://jarfp.com/sleepsoundly/load_hotel.php";
    await http.post(urlLoadJobs, body: {}).then((res) {
      if (res.body == "nodata") {
        setState(() {
          sleepbox = null;
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          sleepbox = extractdata["hotel"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  _adminSleepBoxDetails(int index) async {
    print(sleepbox[index]['id']);

    SleepBox sleepBox = new SleepBox(
      id: sleepbox[index]['id'],
      name: sleepbox[index]['name'],
      price: sleepbox[index]['price'],
      adress: sleepbox[index]['adress'],
      phone: sleepbox[index]['phone'],
      state: sleepbox[index]['state'],
    );
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => Info(
                  sleepBox: sleepBox,
                  user: widget.user,
                )));
    _loadData();
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    //_getLocation();
    _loadData();
    return null;
  }
}
