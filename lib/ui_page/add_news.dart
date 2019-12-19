import 'dart:io';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_project/constant/ConstantFile.dart';

class AddNews extends StatefulWidget {
  @override
  _AddNewsState createState() => _AddNewsState();
}

class _AddNewsState extends State<AddNews> {
  File image;
  bool _isValid = true;
  String keyword1 = "";
  String keyword2 = "";

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
