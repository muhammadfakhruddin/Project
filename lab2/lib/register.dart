import 'package:flutter/material.dart';
import 'login.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

final TextEditingController _nameController = new TextEditingController();
final TextEditingController _emailController = new TextEditingController();
final TextEditingController _phoneController = new TextEditingController();
final TextEditingController _passController = new TextEditingController();
bool _isChecked = false;
String urlRegister = "http://jarfp.com/sleepsoundly/register_user.php";
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
bool _autoValidate = false;
String name, email, phone, pass;

void main() => runApp(Register());

class Register extends StatefulWidget {
  const Register({Key key}) : super(key: key);
  @override
  _Register createState() => _Register();
}

class _Register extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
          backgroundColor: Color.fromRGBO(41, 167, 199, 20),
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text("Create New Account"),
            backgroundColor: Color.fromRGBO(8, 87, 114, 70),
          ),
          body: Container(
            padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
            child: RegisterWidget(),
          )),
    );
  }

  Future<bool> _onBackPressAppBar() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
    return Future.value(false);
  }
}

class RegisterWidget extends StatefulWidget {
  @override
  _RegisterWidgetState createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: Column(
          children: <Widget>[
            TextFormField(
                controller: _nameController,
                validator: validateName,
                onSaved: (String val) {
                  name = val;
                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  icon: Icon(Icons.people),
                  labelText: 'Enter Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  // icon: Icon(Icons.person)
                )),
            SizedBox(height: 10),
            TextFormField(
                controller: _emailController,
                validator: validateEmail,
                onSaved: (String val) {
                  email = val;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    labelText: 'Enter Email Adress',
                    icon: Icon(Icons.email))),
            SizedBox(height: 10),
            TextFormField(
                controller: _phoneController,
                validator: validatePhone,
                onSaved: (String val) {
                  phone = val;
                },
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    labelText: 'Enter Phone Number',
                    icon: Icon(Icons.phone))),
            SizedBox(height: 10),
            TextFormField(
              controller: _passController,
              validator: validatePass,
              onSaved: (String val) {
                pass = val;
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  labelText: 'Enter Password',
                  icon: Icon(Icons.person)),
              obscureText: true,
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Checkbox(
                    value: _isChecked,
                    onChanged: (bool value) {
                      _onChange(value);
                    }),
                GestureDetector(
                  onTap: _showEULA,
                  child: Text(
                    'I Agree To Terms',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            SizedBox(height: 10),
            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                minWidth: 150,
                height: 50,
                child: Text('SIGN UP'),
                color: Colors.black,
                textColor: Colors.white,
                elevation: 15,
                onPressed: _validateInputs),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Already Register?",
                  style: TextStyle(fontSize: 16),
                ),
                GestureDetector(
                  onTap: _onBackPress,
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )
          ],
        ));
  }

  void _onBackPress() {
    print('onBackPress From Register');
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
  }

  void _onChange(bool value) {
    setState(() {
      _isChecked = value;
      //savepref(value);
    });
  }

  void _onRegister() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Registration Confirmation",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: new Container(
            height: 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Are you sure you wants to register a new account?")
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
                child: new Text("Yes"),
                onPressed: () {
                  Navigator.of(context).pop();
                  _register();
                }),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _register() {
    name = _nameController.text;
    email = _emailController.text;
    phone = _phoneController.text;
    pass = _passController.text;
    http.post(urlRegister, body: {
      "name": name,
      "email": email,
      "password": pass,
      "phone": phone,
    }).then((res) {
      print("apakah" + res.body);
      if (res.body == "success") {
        _nameController.text = '';
        _emailController.text = '';
        _phoneController.text = '';
        _passController.text = '';
        Navigator.pop(context,
            MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
        Toast.show("Registration success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        Toast.show("Registration failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _showEULA() {
    _formKey.currentState.validate();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("EULA"),
          content: new Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: new SingleChildScrollView(
                    child: RichText(
                        softWrap: true,
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              //fontWeight: FontWeight.w500,
                              fontSize: 12.0,
                            ),
                            text:
                                'This End-User License Agreement ("EULA") is a legal agreement between you and YOYO This EULA agreement governs your acquisition and use of our SleepSoundly software ("Software") directly from YOYO or indirectly through a YOYO authorized reseller or distributor (a "Reseller"). Please read this EULA agreement carefully before completing the installation process and using the SleepSoundly software. It provides a license to use the SleepSoundly software and contains warranty information and liability disclaimers.If you register for a free trial of the SleepSoundly software, this EULA agreement will also govern that trial. By clicking "accept" or installing and/or using the SleepSoundly software, you are confirming your acceptance of the Software and agreeing to become bound by the terms of this EULA agreement.If you are entering into this EULA agreement on behalf of a company or other legal entity, you represent that you have the authority to bind such entity and its affiliates to these terms and conditions. If you do not have such authority or if you do not agree with the terms and conditions of this EULA agreement, do not install or use the Software, and you must not accept this EULA agreement.This EULA agreement shall apply only to the Software supplied by YOYO herewith regardless of whether other software is referred to or described herein. The terms also apply to any YOYO updates, supplements, Internet-based services, and support services for the Software, unless other terms accompany those items on delivery. If so, those terms apply. This EULA was created by EULA Template for SleepSoundly.License GrantYOYO hereby grants you a personal, non-transferable, non-exclusive licence to use the SleepSoundly software on your devices in accordance with the terms of this EULA agreement.You are permitted to load the SleepSoundly software (for example a PC, laptop, mobile or tablet) under your control. You are responsible for ensuring your device meets the minimum requirements of the SleepSoundly software.You are not permitted to:Edit, alter, modify, adapt, translate or otherwise change the whole or any part of the Software nor permit the whole or any part of the Software to be combined with or become incorporated in any other software, nor decompile, disassemble or reverse engineer the Software or attempt to do any such thing.Reproduce, copy, distribute, resell or otherwise use the Software for any commercial purpose.Allow any third party to use the Software on behalf of or for the benefit of any third party.Use the Software in any way which breaches any applicable local, national or international law use the Software for any purpose that YOYO considers is a breach of this EULA agreemetIntellectual Property and Ownership.YOYO shall at all times retain ownership of the Software as originally downloaded by you and all subsequent downloads of the Software by you. The Software (and the copyright, and other intellectual property rights of whatever nature in the Software, including any modifications made thereto) are and shall remain the property of YOYO.YOYO reserves the right to grant licences to use the Software to third parties.Termination This EULA agreement is effective from the date you first use the Software and shall continue until terminated. You may terminate it at any time upon written notice to YOYO.It will also terminate immediately if you fail to comply with any term of this EULA agreement. Upon such termination, the licenses granted by this EULA agreement will immediately terminate and you agree to stop all access and use of the Software. The provisions that by their nature continue and survive will survive any termination of this EULA agreement.Governing Law.This EULA agreement, and any dispute arising out of or in connection with this EULA agreement, shall be governed by and construed in accordance with the laws of my.'
                            //children: getSpan(),
                            )),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void _validateInputs() {
    if (_formKey.currentState.validate()) {
      //    If all data are correct then save data to out variables
      _formKey.currentState.save();
      _onRegister();
    } else {
      //    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
    if (_autoValidate != true) {
      if (!_isChecked) {
        Toast.show("Please Accept Term", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return;
      }
    }
  }

  String validateName(String value) {
    if (value.length < 3)
      return 'Name must be more than 2 charater';
    else
      return null;
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  String validatePhone(String value) {
    if (value.length <= 10 && (value.length <= 11))
      return 'Mobile Number must be 10-11 digit';
    else
      return null;
  }

  String validatePass(String value) {
    if (value.length < 4)
      return 'Your Password Too Weak';
    else
      return null;
  }
}
