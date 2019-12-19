import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter/rendering.dart';
import 'package:news_project/constant/ConstantFile.dart';
import 'page_home.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class DetailNews extends StatefulWidget {
  String titleDetail, contentDetail, imageDetail, idDetail;
  DetailNews({
    this.titleDetail,
    this.contentDetail,
    this.imageDetail,
    this.idDetail,
  });

  @override
  _DetailNewsState createState() => _DetailNewsState();
}

class _DetailNewsState extends State<DetailNews> {
  TextEditingController titleNewsDetail = new TextEditingController();

  // Widget Background Image App Bar
  Widget _buildWidget(MediaQueryData mediaQueryData) {
    return Container(
        width: double.infinity,
        height: mediaQueryData.size.height / 1.8,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(48),
            ),
            image: image == null
                ? DecorationImage(
                    image: NetworkImage(
                        ConstantFile().imageUrl + widget.imageDetail),
                    fit: BoxFit.cover)
                : DecorationImage(image: FileImage(image), fit: BoxFit.cover)));
  }

  // Widget Title Detail
  Widget _titleNews(MediaQueryData mediaQuery) {
    return SizedBox(
      height: mediaQuery.size.height / 2,
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Stack(
              children: <Widget>[
                Positioned(
                  child: Text(
                    widget.titleDetail,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'CoralPen',
                        fontSize: 72.0),
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                  top: constraints.maxHeight - 100,
                ),
                Positioned(
                  child: SizedBox(
                    width: 100,
                    height: 25,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      color: Colors.deepPurple,
                      onPressed: () {},
                      child: Text(
                        "Politic",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Campton_Light',
                        ),
                      ),
                    ),
                  ),
                  top: constraints.maxHeight - 30,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  File image;
  var loading = false;

  // Function Take Image
  Future _takeImage() async {
    print('Picker is Called');
    var imagefile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imagefile != null) {
      setState(() {
        image = imagefile;
      });
    }
  }

  void confirm() {
    AlertDialog alertDialog = new AlertDialog(
      content: Text("Are You Sure Delete This Item ?"),
      actions: <Widget>[
        RaisedButton(
          color: Colors.green,
          onPressed: () {
            deleteData();
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => new PageHome()));
          },
          child: Text("Yes"),
        ),
        RaisedButton(
          color: Colors.red,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel"),
        ),
      ],
    );
    showDialog(context: context, child: alertDialog);
  }

  // Edit Button Take Image and Edit Title
  Widget _editButton(MediaQueryData mediaQuery) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: EdgeInsets.only(
            top: mediaQuery.size.height / 1.8 - 32.0, right: 32),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              child: FloatingActionButton(
                heroTag: 'btnTag1',
                child: Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
                backgroundColor: Colors.deepPurple,
                onPressed: () {
                  _showDialog();
                },
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Container(
              child: new FloatingActionButton(
                heroTag: 'tagBtn2',
                child: Icon(
                  Icons.camera,
                  color: Colors.white,
                ),
                backgroundColor: Colors.deepPurple,
                onPressed: () {
                  _takeImage();
                },
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Container(
              child: new FloatingActionButton(
                heroTag: 'tagBtn3',
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                backgroundColor: Colors.deepPurple,
                onPressed: () {
                  confirm();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Date Detail
  Widget _dateNews(MediaQueryData mediaQuery) {
    return Padding(
      padding: EdgeInsets.only(
          left: 20.0,
          top: mediaQuery.size.height / 1.79 + 24.0,
          right: 20.0,
          bottom: mediaQuery.padding.bottom + 16),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[Text("Jakarta, 13 Desember 2019")],
          ),
        ],
      ),
    );
  }

  // Function Edit Title
  void updateNews() {
    http.post(
      ConstantFile().baseUrl + "updateNews",
      body: {"idnews": widget.idDetail, "titlenews": titleNewsDetail.text},
    );
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
    request.fields['id'] = widget.idDetail;

    var response = await request.send();
    if (response.statusCode == 200) {
      print("Image Uploaded");
    } else {
      print("Upload Failed");
    }
  }

  // Dialog Edit Data
  Future<Widget> _showDialog() async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 250,
                    child: Center(
                      child: image == null
                          ? Center(child: Text("Not Image Selected"))
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                image,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),
                  TextFormField(
                    controller: titleNewsDetail,
                    decoration: InputDecoration(
                      labelText: "Title News",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide()),
                    ),
                  )
                ],
              ),
            ),
            title: Center(
              child: Text("Edit Information"),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  if (titleNewsDetail == null || image == null) {
                    Navigator.pop(context);
                  } else {
                    updateNews();
                    updateImage1(image);
                    Navigator.pop(context);
                    setState(() {
                      Navigator.pop(context);
                    });
                  }
                },
                child: Text("Update"),
              ),
              FlatButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
          return <Widget>[
            // Custom Appbar (Title, Image Etc)
            SliverAppBar(
              backgroundColor: Colors.transparent,
              floating: true,
              pinned: false,
              snap: false,
              expandedHeight: MediaQuery.of(context).size.height / 1.63,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                background: Stack(
                  children: <Widget>[
                    _buildWidget(mediaQuery),
                    _editButton(mediaQuery),
                    _titleNews(mediaQuery),
                    _dateNews(mediaQuery)
                  ],
                ),
              ),
            )
          ];
        },

        // Detail Content
        body: ListView(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
              child: Container(
                child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(widget.contentDetail),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void deleteData() async {
    await http.post(ConstantFile().baseUrl + "deleteNews", body: {
      'id': widget.idDetail,
    });
  }
}
