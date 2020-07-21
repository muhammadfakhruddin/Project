import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';

void main() => runApp(NewHotel());

class NewHotel extends StatefulWidget {
  @override
  _NewHotelState createState() => _NewHotelState();
}

class _NewHotelState extends State<NewHotel> {
  String server = "http://jarfp.com/sleepsoundly";
  double screenHeight, screenWidth;
  File _image;
  String pathAsset = 'assets/images/icon.png';
  TextEditingController name = new TextEditingController();
  TextEditingController adress = new TextEditingController();
  TextEditingController price = new TextEditingController();
  TextEditingController state = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController id = new TextEditingController();
  final focus0 = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final focus4 = FocusNode();
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("New SleepBox"),
      ),
      body: Center(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () => {_choose()},
                  child: Container(
                    height: screenHeight / 3,
                    width: screenWidth / 1.8,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: _image == null
                            ? AssetImage(pathAsset)
                            : FileImage(_image),
                        fit: BoxFit.cover,
                      ),
                      border: Border.all(
                        width: 3.0,
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(
                              5.0) //         <--- border radius here
                          ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text("Click the above image to take picture of SleepBox",
                    style: TextStyle(fontSize: 10.0, color: Colors.white)),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: screenWidth / 1.2,
                  child: Card(
                    elevation: 6,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Table(
                            defaultColumnWidth: FlexColumnWidth(1.0),
                            children: [
                              TableRow(children: [
                                TableCell(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 30,
                                    child: Text("SleepBox ID",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        )),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    margin: EdgeInsets.all(5),
                                    height: 30,
                                    child: TextFormField(
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                        controller: id,
                                        keyboardType: TextInputType.number,
                                        textInputAction: TextInputAction.next,
                                        onFieldSubmitted: (v) {
                                          FocusScope.of(context)
                                              .requestFocus(focus0);
                                        },
                                        decoration: new InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.all(5),
                                          fillColor: Colors.white,
                                          border: new OutlineInputBorder(
                                            borderRadius:
                                                new BorderRadius.circular(5.0),
                                            borderSide: new BorderSide(),
                                          ),

                                          //fillColor: Colors.green
                                        )),
                                  ),
                                ),
                              ]),
                              TableRow(children: [
                                TableCell(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 30,
                                    child: Text(
                                      "SleepBox Name",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                                TableCell(
                                    child: Container(
                                  margin: EdgeInsets.all(5),
                                  height: 30,
                                  child: TextFormField(
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                      controller: name,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (v) {
                                        FocusScope.of(context)
                                            .requestFocus(focus1);
                                      },
                                      decoration: new InputDecoration(
                                        contentPadding: const EdgeInsets.all(5),
                                        fillColor: Colors.white,
                                        border: new OutlineInputBorder(
                                          borderRadius:
                                              new BorderRadius.circular(5.0),
                                          borderSide: new BorderSide(),
                                        ),

                                        //fillColor: Colors.green
                                      )),
                                ))
                              ]),
                              TableRow(children: [
                                TableCell(
                                    child: Container(
                                  alignment: Alignment.centerLeft,
                                  height: 30,
                                  child: Text(
                                    "SleepBox Adress",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                )),
                                TableCell(
                                    child: Container(
                                  margin: EdgeInsets.all(5),
                                  height: 30,
                                  alignment: Alignment.centerLeft,
                                  child: TextFormField(
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                      controller: adress,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (v) {
                                        FocusScope.of(context)
                                            .requestFocus(focus2);
                                      },
                                      decoration: new InputDecoration(
                                        contentPadding: const EdgeInsets.all(5),
                                        fillColor: Colors.white,
                                        border: new OutlineInputBorder(
                                          borderRadius:
                                              new BorderRadius.circular(5.0),
                                          borderSide: new BorderSide(),
                                        ),

                                        //fillColor: Colors.green
                                      )),
                                ))
                              ]),
                              TableRow(children: [
                                TableCell(
                                  child: Container(
                                    height: 30,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "State",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    margin: EdgeInsets.all(5),
                                    height: 30,
                                    alignment: Alignment.centerLeft,
                                    child: TextFormField(
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                        controller: state,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.next,
                                        onFieldSubmitted: (v) {
                                          FocusScope.of(context)
                                              .requestFocus(focus3);
                                        },
                                        decoration: new InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.all(5),
                                          fillColor: Colors.white,
                                          border: new OutlineInputBorder(
                                            borderRadius:
                                                new BorderRadius.circular(5.0),
                                            borderSide: new BorderSide(),
                                          ),

                                          //fillColor: Colors.green
                                        )),
                                  ),
                                )
                              ]),
                              TableRow(children: [
                                TableCell(
                                    child: Container(
                                  height: 30,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Phone",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                )),
                                TableCell(
                                    child: Container(
                                  margin: EdgeInsets.all(5),
                                  height: 30,
                                  alignment: Alignment.centerLeft,
                                  child: TextFormField(
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                      controller: phone,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (v) {
                                        FocusScope.of(context)
                                            .requestFocus(focus4);
                                      },
                                      decoration: new InputDecoration(
                                        contentPadding: const EdgeInsets.all(5),
                                        fillColor: Colors.white,
                                        border: new OutlineInputBorder(
                                          borderRadius:
                                              new BorderRadius.circular(5.0),
                                          borderSide: new BorderSide(),
                                        ),

                                        //fillColor: Colors.green
                                      )),
                                ))
                              ]),
                              TableRow(children: [
                                TableCell(
                                    child: Container(
                                  alignment: Alignment.centerLeft,
                                  height: 30,
                                  child: Text(
                                    "Price",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                )),
                                TableCell(
                                    child: Container(
                                  margin: EdgeInsets.all(5),
                                  height: 30,
                                  alignment: Alignment.centerLeft,
                                  child: TextFormField(
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                      controller: price,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      focusNode: focus0,
                                      onFieldSubmitted: (v) {
                                        FocusScope.of(context)
                                            .requestFocus(focus4);
                                      },
                                      decoration: new InputDecoration(
                                        fillColor: Colors.white,
                                        border: new OutlineInputBorder(
                                          borderRadius:
                                              new BorderRadius.circular(5.0),
                                          borderSide: new BorderSide(),
                                        ),
                                        //fillColor: Colors.green
                                      )),
                                ))
                              ])
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          MaterialButton(
                            shape: BeveledRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            minWidth: screenWidth / 1.5,
                            height: 40,
                            child: Text("Insert New SleepBox"),
                            color: Colors.amber,
                            elevation: 5,
                            onPressed: _insertNewHotel,
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
      ),
    );
  }

  void _choose() async {
    _image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 800, maxWidth: 800);
    setState(() {});
  }

  void _insertNewHotel() {
    if (_image == null) {
      Toast.show("Please take SleepBox photo", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (id.text.length < 1) {
      Toast.show("Please Enter SleepBox ID", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (name.text.length < 1) {
      Toast.show("Please Enter SleepBox Name", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (adress.text.length < 1) {
      Toast.show("Please Enter SleepBox Adress", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (phone.text.length < 1) {
      Toast.show("Please Enter Phone Number", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (price.text.length < 1) {
      Toast.show("Please Enter The Price", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Insert New SleepBox?  ",
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
                insertHotel();
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

  insertHotel() {
    double _price = double.parse(price.text);

    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Inserting new product...");
    pr.show();
    String base64Image = base64Encode(_image.readAsBytesSync());

    http.post(server + "/php/insert_product.php", body: {
      "id": id.text,
      "name": name.text,
      "adress": adress.text,
      "price": _price.toStringAsFixed(2),
      "phone": phone.text,
      "encoded_string": base64Image,
    }).then((res) {
      print(res.body);
      pr.hide();
      if (res.body == "found") {
        Toast.show("Product id already in database", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return;
      }
      if (res.body == "success") {
        Toast.show("Insert success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.of(context).pop();
      } else {
        Toast.show("Insert failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
      pr.hide();
    });
  }
}
