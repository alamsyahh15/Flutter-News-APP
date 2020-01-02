import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_project/constant/ConstantFile.dart';
import 'package:news_project/model/model_token.dart';
import 'package:news_project/service/base_auth.dart';

class AddNews extends StatefulWidget {
  @override
  _AddNewsState createState() => _AddNewsState();
}

class _AddNewsState extends State<AddNews> {
  File image;
  bool _isValid = true;
  String keyword1 = "";
  String keyword2 = "";

  BaseAuth network = Authentication();
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  String serverToken = "AAAAvNr9L_g:APA91bGfbvMewuhdfph2lyUNuo_mkMe7vG5KtEgDn3b1K_42fdeapfAPuiYFbo9HVhrLop8IrtYkmG2kRRkjcMcJeOXx0nfHgTnf-ThFq26Q8Eij-NGR8YE8qJQ3vSSx2CVdD8LrO5mE";

  Future<Map<String, dynamic>> sendMessage() async{
    await _firebaseMessaging.requestNotificationPermissions(
      IosNotificationSettings(sound: true,badge: true, alert: true, provisional: false)
    );

    await http.post(ConstantFile().firebaseUrl,
        headers: { 'Content-Type': 'application/json',
          'Authorization': 'key=$serverToken',},
      body: jsonEncode(
        <String, dynamic>{
          'registration_ids' : ["evrDhi9jIvI:APA91bGz9xZwoDXSng3NadAV_SosMJDu_evJszDhtJiSC_UoTJWDOh-05ZCWYi2N3DSZpVcqrEOroiG3g9y4O1Dj39f2n9t5POZbs7ryqpNQ_lTNSn4p-gVHY_7TDmCqbRNHB5yb2r2d","cyz4KmlBMLc:APA91bGM6VKRBDU6Vf39Z2ZHWN2u1RKZBY2g3OOzmLMOxGYckpJBPIUaEtRRpRfhykAWWXfkA2guRaFNogGXqQn1A0tI-kEl8D8_ip1N6nih-5_8OLL6GJMeeUtJvYTDkUWJWn8oGbMc","fjpJ-NK5TiI:APA91bEk3KHetOgjk1gq9UpEDRaXYDZkX8YE-bT73GmCggl9z3b0sJIupuH8cN0f3Y3ySBioFWxHdynhbJbDJPBS86wZ-F5j_ewHDRevQvsythQOkH0U71WCgsjBt_lzyb0wl7MFglxC"],
//          'to' : '$tokenMe',
          'collapse_key' : 'type_a',
          'notification': <String, dynamic>{
            "body" : "Please press this notification for looking new a News",
            "title": "Guys Ada Update Berita Baru Lohh..."
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
        },
      ),
    );
    final Completer<Map<String, dynamic>> completer =
    Completer<Map<String, dynamic>>();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        completer.complete(message);
      },
    );
    return completer.future;
  }




  // Function Take Image Form Camera
  Future _takeImage() async {
    print('Picker is Called');
    var imagefile = await ImagePicker.pickImage(source: ImageSource.camera);
    if (imagefile != null) {
      setState(() {
        image = imagefile;
      });
    }
  }

  // Function Take Image Form Galery
  Future _takeImage1() async {
    print('Picker is Called');
    var imagefile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imagefile != null) {
      setState(() {
        image = imagefile;
      });
    }
  }

  // Function Edit Image / Upload Image
  saveData(File imageFile) async {
    // open a bytestream
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse(ConstantFile().baseUrl + "addNews");
    var request = new http.MultipartRequest('POST', uri);
    var multipart = new http.MultipartFile('userfile', stream, length,
        filename: image.path);
    request.files.add(multipart);
    request.fields['title'] = _etTitleNews.text;
    request.fields['content'] = _etContentNews.text;

    var response = await request.send();
    if (response.statusCode == 200) {
      print("Image Uploaded");
    } else {
      print("Upload Failed");
    }
  }

  TextEditingController _etTitleNews = new TextEditingController();
  TextEditingController _etContentNews = new TextEditingController();
  _AddNewsState() {
    _etTitleNews.addListener(() {
      if (_etTitleNews.text.isEmpty) {
        setState(() {
          _isValid = true;
          keyword1 = "";
        });
      } else {
        setState(() {
          _isValid = false;
          keyword1 = _etTitleNews.text;
        });
      }
    });

    _etContentNews.addListener(() {
      if (_etContentNews.text.isEmpty) {
        setState(() {
          _isValid = true;
          keyword2 = "";
        });
      } else {
        setState(() {
          _isValid = false;
          keyword2 = _etContentNews.text;
        });
      }
    });
  }

  String tokenMe = "";
  var myToken = '';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, alert: true, badge: true));
    _firebaseMessaging.getToken().then((token) {
      //updateToken Notifications
      printOut(token);
      print(token);
    });
  }

  printOut(String token) {
    print(token);
    myToken = token;
    tokenMe = myToken;
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Data"),
        backgroundColor: Colors.deepPurple,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: FlatButton(
              onPressed: _isValid
                  ? null
                  : () {
                      saveData(image);
                      Navigator.pop(context);
                      sendMessage();
                    },
              child: _isValid
                  ? Text(
                      "Posting",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    )
                  : Text(
                      "Posting",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
            ),
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 32, left: 24, right: 24, bottom: 16),
                  child: Text(
                    "Form Add News",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.deepPurple),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 8, left: 16, right: 16, bottom: 8),
                child: TextFormField(
                  controller: _etTitleNews,
                  decoration: InputDecoration(
                    labelText: "Title News",
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide()),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 8, left: 16, right: 16, bottom: 8),
                child: TextFormField(
                  controller: _etContentNews,
                  decoration: InputDecoration(
                    labelText: "Content News",
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide()),
                  ),
                  maxLines: 15,
                ),
              ),
              Center(
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                  child: image == null
                      ? null
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(image)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                      width: 140,
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        color: Colors.deepPurple,
                        onPressed: _takeImage1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Icon(
                              Icons.image,
                              color: Colors.white,
                            ),
                            Text(
                              "Form Gallery",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    SizedBox(
                      height: 50,
                      width: 145,
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        color: Colors.deepPurple,
                        onPressed: _takeImage,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Icon(
                              Icons.camera,
                              color: Colors.white,
                            ),
                            Text(
                              "Form Camera",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
