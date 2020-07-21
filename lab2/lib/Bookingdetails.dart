import 'package:flutter/material.dart';
import 'User.dart';
import 'Booking.dart';

void main() => runApp(BookingDetails());

class BookingDetails extends StatefulWidget {
  final User user;
  final Booking booking;

  const BookingDetails({Key key, this.user, this.booking}) : super(key: key);
  @override
  _BookingDetailsState createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: Center(
          child: Container(
            child: Text('Hello World'),
          ),
        ),
      ),
    );
  }
}
