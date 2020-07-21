import 'package:flutter/material.dart';
import 'package:grocery/User.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'User.dart';
import 'package:intl/intl.dart';
import 'Booking.dart';
import 'Bookingdetails.dart';
import 'package:grocery/Bookingdetails.dart';
import 'package:grocery/Booking.dart';

void main() => runApp(PaymentHistory());

class PaymentHistory extends StatefulWidget {
  final User user;

  const PaymentHistory({Key key, this.user}) : super(key: key);
  @override
  _PaymentHistoryState createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  List _paymentData;
  String tittle = "Loading Payment History";
  final f = new DateFormat('dd-MM-yyyy hh:mm a');
  var parsedDate;
  double screenHeight, screenWidth;

  @override
  void initState() {
    super.initState();
    _loadPaymentHistory();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("PAYMENT HISTORY"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text(
              "Payment History",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            _paymentData == null
                ? Flexible(
                    child: Container(
                    child: Center(
                      child: Text(
                        tittle,
                        style: TextStyle(
                            color: Color.fromRGBO(101, 255, 218, 50),
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ))
                : Expanded(
                    child: ListView.builder(
                        //Step 6: Count the data
                        itemCount:
                            _paymentData == null ? 0 : _paymentData.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: EdgeInsets.fromLTRB(10, 1, 10, 1),
                              child: InkWell(
                                  onTap: () => loadOrderDetails(index),
                                  child: Card(
                                    elevation: 10,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                              (index + 1).toString(),
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )),
                                        Expanded(
                                            flex: 2,
                                            child: Text(
                                              "RM " +
                                                  _paymentData[index]['total'],
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )),
                                        Expanded(
                                            flex: 4,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  _paymentData[index]
                                                      ['orderid'],
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                Text(
                                                  _paymentData[index]['billid'],
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            )),
                                        Expanded(
                                          child: Text(
                                            f.format(DateTime.parse(
                                                _paymentData[index]['date'])),
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          flex: 3,
                                        ),
                                      ],
                                    ),
                                  )));
                        }))
          ],
        ),
      ),
    );
  }

  Future<void> _loadPaymentHistory() async {
    String urlLoadJobs =
        "https://jarfp.com/sleepsoundly/load_paymenthistory.php";
    await http
        .post(urlLoadJobs, body: {"email": widget.user.email}).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        setState(() {
          _paymentData = null;
          tittle = "No Previous Payment";
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          _paymentData = extractdata["payment"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  loadOrderDetails(int index) {
    Booking booking = new Booking(
        billid: _paymentData[index]['billid'],
        orderid: _paymentData[index]['orderid'],
        total: _paymentData[index]['total'],
        dateorder: _paymentData[index]['date']);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => BookingDetails(
                  booking: booking,
                )));
  }
}
