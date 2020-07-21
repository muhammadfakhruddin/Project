import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grocery/SleepBox.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() => runApp(EditInfo());

class EditInfo extends StatefulWidget {
  final SleepBox sleepBox;

  const EditInfo({Key key, this.sleepBox}) : super(key: key);
  @override
  _EditInfoState createState() => _EditInfoState();
}

class _EditInfoState extends State<EditInfo> {
  String server = "https://jarfp.com/sleepsoundly";
  TextEditingController name = new TextEditingController();
  TextEditingController adress = new TextEditingController();
  TextEditingController price = new TextEditingController();
  TextEditingController state = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  double screenHeight, screenWidth;
  final focus0 = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final focus4 = FocusNode();
  File _image;
  bool _takepicture = true;
  bool _takepicturelocal = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Update SleepBox Information'),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: _choose,
                child: Column(
                  children: <Widget>[
                    Visibility(
                      visible: _takepicture,
                      child: Container(
                        height: screenHeight / 3,
                        width: screenWidth / 1.5,
                        child: CachedNetworkImage(
                          imageUrl:
                              server + "/images/${widget.sleepBox.id}.jpg",
                          placeholder: (context, url) =>
                              new CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              new Icon(Icons.error),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _takepicturelocal,
                      child: Container(
                        height: screenHeight / 3,
                        width: screenWidth / 1.5,
                        decoration: BoxDecoration(
                            image: new DecorationImage(
                                colorFilter: new ColorFilter.mode(
                                    Colors.black.withOpacity(0.6),
                                    BlendMode.dstATop),
                                image: _image == null
                                    ? AssetImage('assets/images/icon.png')
                                    : FileImage(_image),
                                fit: BoxFit.cover)),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 6,
              ),
              Container(
                width: screenHeight / 1.2,
                child: Card(
                  elevation: 6,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Divider(
                          height: 5,
                          color: Colors.red,
                          thickness: 5,
                        ),
                        TextField(
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          controller: name,
                          decoration:
                              InputDecoration(hintText: widget.sleepBox.name),
                        ),
                        TextField(
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          controller: adress,
                          decoration:
                              InputDecoration(hintText: widget.sleepBox.adress),
                        ),
                        TextField(
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          controller: phone,
                          decoration:
                              InputDecoration(hintText: widget.sleepBox.phone),
                        ),
                        TextField(
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          controller: price,
                          decoration:
                              InputDecoration(hintText: widget.sleepBox.price),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        RaisedButton(
                          child: Text("Update"),
                          onPressed: _updateDialog,
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _choose() async {
    _image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 800, maxWidth: 800);
    setState(() {});
  }

  void _updateDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Update SleepBox Id " + widget.sleepBox.id,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content:
              new Text("Are you sure?", style: TextStyle(color: Colors.white)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                updateProduct();
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  updateProduct() {
    if (name.text.length < 1) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Updating product...");
      pr.show();
      String base64Image;

      if (_image != null) {
        base64Image = base64Encode(_image.readAsBytesSync());
        http.post(server + "/update_product.php", body: {
          "id": widget.sleepBox.id,
          "name": name.text,
          "adress": adress.text,
          "price": price.text,
          "phone": phone.text,
          "encoded_string": base64Image,
        }).then((res) {
          print(res.body);
          pr.hide();
          if (res.body == "success") {
            Toast.show("Update success", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            Navigator.of(context).pop();
          } else {
            Toast.show("Update failed", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          }
        }).catchError((err) {
          print(err);
          pr.hide();
        });
      } else {
        http.post(server + "/update_hotel.php", body: {
          "id": widget.sleepBox.id,
          "name": name.text,
          "adress": adress.text,
          "price": price.text,
          "phone": phone.text,
        }).then((res) {
          print(res.body);
          pr.hide();
          if (res.body == "success") {
            Toast.show("Update success", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            Navigator.of(context).pop();
          } else {
            Toast.show("Update failed", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          }
        }).catchError((err) {
          print(err);
          pr.hide();
        });
      }
    }
  }
}
