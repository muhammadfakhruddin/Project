import 'package:flutter/material.dart';
import 'package:grocery/SleepBox.dart';
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';
import 'User.dart';

void main() => runApp(Payment());

class Payment extends StatefulWidget {
  final User user;
  final SleepBox sleepBox;
  final String orderid, val;

  const Payment({Key key, this.user, this.orderid, this.val, this.sleepBox})
      : super(key: key);
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('PAYMENT'),
          // backgroundColor: Colors.deepOrange,
        ),
        body: Column(
          children: <Widget>[
            /*
            Expanded(
              child: WebView(
                initialUrl: 'http://jarfp.com/sleepsoundly/payment.php?email=' +
                    widget.user.email +
                    '&mobile=' +
                    widget.user.phone +
                    '&name=' +
                    widget.user.name +
                    '&amount=' +
                    widget.val +
                    '&orderid=' +
                    widget.orderid,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
              ),
            )*/
          ],
        ));
  }
}
