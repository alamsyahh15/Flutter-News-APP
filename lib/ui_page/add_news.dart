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

  void saveData()async {
    await http.post(ConstantFile().baseUrl+"addNews", body: {
      'title': titleNews.text,
      'content' : contentNews.text
    });
  }
  // Function Take Image
  Future _takeImage() async {
    print('Picker is Called');
    var imagefile = await ImagePicker.pickImage(source: ImageSource.camera);
    if (imagefile != null) {
      setState(() {
        image = imagefile;
      });
    }
  }
  // Function Edit Image / Upload Image
  updateImage1(File imageFile) async {
    // open a bytestream
    var stream =
    new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse(ConstantFile().baseUrl + "changeImage");
    var request = new http.MultipartRequest('POST', uri);
    var multipart = new http.MultipartFile('userfile', stream, length,
        filename: image.path);
    request.files.add(multipart);
    var response = await request.send();
    if (response.statusCode == 200) {
      print("Image Uploaded");
    } else {
      print("Upload Failed");
    }
  }

  TextEditingController titleNews = new TextEditingController();
  TextEditingController contentNews = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Data"),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Center(
                child: Container(
                  height: 200,
                  child: image == null
                      ? Text("No Image Picked")
                      : Image.file(image),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  MaterialButton(
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
                          "Take Image",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 8, left: 16, right: 16, bottom: 8),
                child: TextFormField(
                  controller: titleNews,
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
                  controller: contentNews,
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
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                      width: 100,
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        color: Colors.deepPurple,
                        onPressed: () {
                          updateImage1(image);
                          saveData();
                          Navigator.pop(context);
                        },
                        child: Text("Save",style: TextStyle(color: Colors.white),),
                      ),
                    ),

                    SizedBox(
                      width: 100,
                      height: 50,
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        color: Colors.deepPurple,
                        onPressed: (){},
                        child: Text("Cancel",style: TextStyle(color: Colors.white),),
                      ),
                    )
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
