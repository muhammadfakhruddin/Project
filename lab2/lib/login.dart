import 'package:flutter/material.dart';
import 'package:grocery/User.dart';
import 'MainScreen.dart';
import 'register.dart';
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(LoginPage());
bool rememberMe = false;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double screenHeight;

  String urlLogin = "http://jarfp.com/sleepsoundly/login_user.php";
  TextEditingController _pass = new TextEditingController();
  TextEditingController _email = new TextEditingController();

  var prefs;
  @override
  void initState() {
    super.initState();
    this.loadPref();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Color.fromRGBO(41, 167, 199, 20),
        body: new Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/icon.png',
              scale: 1.5,
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 40),
              child: Container(
                  child: Column(
                children: <Widget>[
                  Padding(
                    child: TextField(
                      controller: _email,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          labelText: "Email",
                          icon: Icon(Icons.email)),
                    ),
                    padding: EdgeInsets.all(10),
                  ),
                  Padding(
                    child: TextField(
                      controller: _pass,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          labelText: "Password",
                          icon: Icon(Icons.lock)),
                      obscureText: true,
                    ),
                    padding: EdgeInsets.all(10),
                  ),
                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: rememberMe,
                        onChanged: (bool value) {
                          _onchange(value);
                        },
                      ),
                      Text('Remember Me', style: TextStyle(fontSize: 16))
                    ],
                  ),
                ],
              )),
            ),
            SizedBox(height: 10),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              minWidth: 150,
              height: 50,
              child: Text('Login'),
              color: Colors.black,
              textColor: Colors.white,
              elevation: 20,
              onPressed: _login,
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: _onRegister,
              child: Text(
                'Register New Account',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            SizedBox(height: 10),
            Text('Forgot Password',
                style: TextStyle(fontSize: 16, color: Colors.white))
          ],
        )));
  }

  void _login() async {
    print(_email.text);
    print(_pass.text);
    try {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Log in ...");
      pr.show();
      String email = _email.text;
      String password = _pass.text;
      http.post(urlLogin, body: {
        "email": email,
        "password": password,
      }).then((res) {
        print(res.body);
        var string = res.body;
        List userdata = string.split(",");
        if (userdata[0] == "success") {
          User _user = new User(
              name: userdata[1],
              email: email,
              password: password,
              phone: userdata[3]);
          pr.hide();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => MainScreen(
                        user: _user,
                      )));
        } else {
          pr.hide();
          Toast.show("Login Failed", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }).catchError((err) {
        print(err);
        pr.hide();
      });
    } on Exception catch (_) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _onchange(bool value) {
    setState(() {
      rememberMe = value;
      print('Check value $value');
      if (rememberMe) {
        savepref(true);
      } else {
        savepref(false);
      }
    });
  }

  void _onRegister() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Register()));
  }

  void savepref(bool value) async {
    String email = _email.text;
    String password = _pass.text;
    if (value) {
      await prefs.setString('email', email);
      await prefs.setString('pass', password);
      Toast.show("Prefferenced have beend saved", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } else {
      await prefs.setString('email', '');
      await prefs.setString('pass', '');
      setState(() {
        _email.text = '';
        _pass.text = '';
        rememberMe = false;
      });
      Toast.show("Prefferences have removed", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    if (email.length > 1) {
      setState(() {
        _email.text = email;
        _pass.text = password;
        rememberMe = true;
      });
    }
  }
}
