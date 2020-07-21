import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> _operator = ['+', '-', '*', '/'];
  String _currentItemSelected = '+';
  final TextEditingController _acontroller = TextEditingController();
  final TextEditingController _bcontroller = TextEditingController();
  final TextEditingController _ccontroller = TextEditingController();
  final TextEditingController _dcontroller = TextEditingController();
  double a = 0.0, b = 0.0, c = 0.0, d = 0.0, e = 0.0, f = 0.0, result = 0.0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fraction Calculator',
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
          appBar: AppBar(
            title: Text('Fraction Calculator'),
            backgroundColor: Colors.orange,
            centerTitle: true,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                      child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                      controller: _acontroller,
                    ),
                  )),
                  Flexible(
                      child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                      controller: _bcontroller,
                    ),
                  ))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Text('______________________'),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Text('______________________'),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                      child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                      controller: _ccontroller,
                    ),
                  )),
                  Flexible(
                      child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                      controller: _dcontroller,
                    ),
                  )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(50, 0, 0, 30),
                    child: Text("Choose Operator:"),
                  ),
                  Flexible(
                      child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 50, 30),
                    child: DropdownButton<String>(
                      items: _operator.map((String dropdownStringItem) {
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
                      onChanged: (String newValueSelected) {
                        _ondropDownSelectedItem(newValueSelected);
                      },
                      value: _currentItemSelected,
                    ),
                  )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: RaisedButton(
                      child: Text('Calculate'),
                      onPressed: _onpressed,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: RaisedButton(
                      child: Text('Clear'),
                      onPressed: _reset,
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text('='),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(1),
                        child: Text("$e"),
                      ),
                      Padding(
                        padding: EdgeInsets.all(1),
                        child: Text('_____'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(1),
                        child: Text("$f"),
                      )
                    ],
                  )
                ],
              )
            ],
          )),
    );
  }

  void _ondropDownSelectedItem(String newValueSelected) {
    setState(() {
      this._currentItemSelected = newValueSelected;
    });
  }

  void _onpressed() {
    setState(() {
      a = double.parse(_acontroller.text);
      b = double.parse(_bcontroller.text);
      c = double.parse(_ccontroller.text);
      d = double.parse(_dcontroller.text);
      if (_currentItemSelected == '+') {
        e = gcd(a, b);
        e = (a * d) + (b * c);
        f = (c * d);
      } else if (_currentItemSelected == '-') {
        e = (a * d) + (b * c);
        f = (c * d);
      } else if (_currentItemSelected == '*') {
        e = (a * d) + (b * c);
        f = (c * d);
      } else if (_currentItemSelected == '/') {
        e = (a * d) + (b * c);
        f = (c * d);
      }
      simplestform();
    });
  }

  double gcd(double a, double b) {
    if (a == 0) {
      return b;
    } else {
      return gcd(b % a, a);
    }
  }

  void simplestform() {
    double commonFactor = gcd(e, f);
    e = e / commonFactor;
    f = f / commonFactor;
  }

  void _reset() {
    setState(() {
      _acontroller.text = "";
      _bcontroller.text = "";
      _ccontroller.text = "";
      _dcontroller.text = "";
      e = 0.0;
      f = 0.0;
    });
  }
}
