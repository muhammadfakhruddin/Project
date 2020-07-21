import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grocery/PaymentHistory.dart';
import 'package:grocery/SleepBox.dart';
import 'package:grocery/sleepboxinfo.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'User.dart';
import 'profile.dart';
import 'PaymentHistory.dart';
import 'AdminHotel.dart';
import 'package:grocery/AdminHotel.dart';

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, this.user}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;
  double screenHeight, screenWidth;
  List sleepbox;
  bool _isadmin = false;
  String server = "http://jarfp.com/sleepsoundly";
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
    if (widget.user.email == "alanberamboi@gmail.com") {
      _isadmin = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    if (sleepbox == null) {
      return Scaffold(
          drawer: mainDrawer(context),
          appBar: AppBar(
            title: Text("SLEEPBOX"),
            backgroundColor: Colors.cyan,
          ),
          body: Center(
            child: CircularProgressIndicator(),
          ));
    } else {
      return Scaffold(
          drawer: mainDrawer(context),
          appBar: AppBar(
            title: Text("SLEEPBOX"),
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
                                          _sleepBoxDetails(index)
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
          ));
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

  _sleepBoxDetails(int index) async {
    print(sleepbox[index]['id']);

    SleepBox sleepBox = new SleepBox(
      id: sleepbox[index]['id'],
      name: sleepbox[index]['name'],
      price: sleepbox[index]['price'],
      adress: sleepbox[index]['adress'],
      phone: sleepbox[index]['phone'],
      state: sleepbox[index]['verify'],
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

  Widget mainDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(widget.user.name),
            accountEmail: Text(widget.user.email),
            currentAccountPicture: CircleAvatar(
              backgroundColor:
                  Theme.of(context).platform == TargetPlatform.android
                      ? Colors.white
                      : Colors.white,
              backgroundImage:
                  NetworkImage(server + "/profile/${widget.user.email}.jpg?"),
            ),
            onDetailsPressed: () => {
              Navigator.pop(context),
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          Profile(user: widget.user)))
            },
          ),
          ListTile(
              title: Text(
                "SleepBox List",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => {
                    Navigator.pop(context),
                    _loadData(),
                  }),
          ListTile(
              title: Text(
                "User Profile",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => {
                    Navigator.pop(context),
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => Profile(
                                  user: widget.user,
                                )))
                  }),
          ListTile(
              title: Text(
                "Payment History",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: _paymentScreen),
          Visibility(
            visible: _isadmin,
            child: Column(
              children: <Widget>[
                Divider(
                  height: 2,
                  color: Colors.white,
                ),
                Center(
                  child: Text(
                    "Admin Menu",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                    title: Text(
                      "Manage SleepBox",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () => {
                          Navigator.pop(context),
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => AdminHotel(
                                        user: widget.user,
                                      )))
                        }),
                ListTile(
                  title: Text(
                    "Customer Book",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward),
                ),
                ListTile(
                  title: Text(
                    "Report",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _paymentScreen() {
    if (widget.user.email == "unregistered@sleepsoundly.com") {
      Toast.show("Please register to use this function", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else if (widget.user.email == "alanberamboi@gmail.com") {
      Toast.show("Admin mode!!!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => PaymentHistory(
                  user: widget.user,
                )));
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    _loadData();
    return null;
  }
}
