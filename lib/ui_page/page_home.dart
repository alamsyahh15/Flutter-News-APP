import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:news_project/ui_view/image_slider_home.dart';
import '../constant/ConstantFile.dart';
import 'add_news.dart';
import 'detail_news.dart';

class PageHome extends StatefulWidget {
  @override
  _PageHomeState createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  List _dataListBerita = new List();
  var loading = false;

  void getNews() async {
    loading = true;
    var response =
        await http.get(Uri.encodeFull(ConstantFile().baseUrl + 'getNews'));

    List tempList;
    var data = jsonDecode(response.body);
    tempList = data['data'];
    setState(() {
      _dataListBerita = tempList;
      print('data: $_dataListBerita');
    });
    loading = false;
  }

  Future<List> getAllData() async {
    final response = await http.get(ConstantFile().baseUrl + "getNews");
    var data = jsonDecode(response.body);
    List finalData = data['data'];
    return finalData;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: new FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: ()=> Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => AddNews())
        ),
      ),
      drawer: Drawer(
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Container(
          margin: EdgeInsets.only(top: 4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 160,
                height: 30,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Text(
                    "MBACA WEWARA",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.deepPurple,
                  onPressed: () {},
                ),
              ),
              Text(
                "The News Application",
                style: TextStyle(fontSize: 12, color: Colors.deepPurple),
              )
            ],
          ),
        ),
        actions: <Widget>[
          Icon(
            Icons.search,
            size: 40,
            color: Colors.black,
          )
        ],
        backgroundColor: Colors.white,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 0.0),
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.arrow_forward,
                  size: 40,
                  color: Colors.deepPurple,
                ),
                Text(
                  "News Top Rated",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          // List Top Rated
          Container(
            height: 270,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 4, left: 8.0),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _dataListBerita.length,
                itemBuilder: (context, position) {
                  final nDataListNews1 = _dataListBerita[position];
                  return ImageSliderHome(
                      title: nDataListNews1['news_title'], // Untuk Title
                      image: ConstantFile().imageUrl +
                          nDataListNews1['news_image']); // Untuk Image
                }),
          ),

          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.arrow_forward,
                  size: 40,
                  color: Colors.deepPurple,
                ),
                Text(
                  "News Update",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),

          // List Update 1
          Container(
            padding: EdgeInsets.only(top: 8, left: 8),
            height: 500,
            width: MediaQuery.of(context).size.width,
            child: new FutureBuilder(
                future: getAllData(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  return snapshot.hasData
                      ? new ItemList(
                          list: snapshot.data,
                        )
                      : new Center(
                          child: CircularProgressIndicator(),
                        );
                }),
          ),

        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class ItemList extends StatelessWidget {
  List list;
  ItemList({this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: list == null ? 0 : list.length,
        itemBuilder: (context, position) {
          final nDataListNews = list[position];
          return Padding(
            padding: const EdgeInsets.all(8),
            child: GestureDetector(
              onTap: () => Navigator.of(context).push(
                new MaterialPageRoute(builder: (context) => DetailNews(
                    titleDetail : nDataListNews['news_title'],
                    imageDetail : nDataListNews['news_image'],
                    contentDetail : nDataListNews['news_content'],
                    idDetail: nDataListNews['news_id']
                ))
              ),
              child: Container(
                child: Row(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          width: 150,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              ConstantFile().imageUrl +
                                  nDataListNews['news_image'],
                              height: 90.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      ],
                    ),
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: 100,
                              height: 25,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                                color: Colors.deepPurple,
                                onPressed: () {},
                                child: Text(
                                  "Politic",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),

                            //Title
                            Text(
                              nDataListNews['news_title'],
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),

                            //Content
                            Text(
                              nDataListNews['news_content'],
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              maxLines: 3,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}








//List Update
//          Container(
//            padding: EdgeInsets.only(top: 8, left: 8),
//            height: 500,
//            width: MediaQuery.of(context).size.width,
//            child: ListView.builder(
//                itemCount: _dataListBerita.length,
//                itemBuilder:(context,postion){
//                  final nDataListNews = _dataListBerita[postion];
//                  return Padding(
//                    padding: const EdgeInsets.all(8),
//                    child: InkWell(
//                      onTap: (){
//
////                        Navigator.push(context, MaterialPageRoute(builder: (context) => DetailNews(
////                          titleDetail : nDataListNews['news_title'],
////                          imageDetail : nDataListNews['news_image'],
////                          contentDetail : nDataListNews['news_content'],
////                          idDetail: nDataListNews['news_id']
////                        )));
//                      },
//
//                      child: Container(
//                        child: Row(
//                          children: <Widget>[
//                            Stack(
//                              children: <Widget>[
//                                Container(
//                                  width: 150,
//                                  child: ClipRRect(
//                                    borderRadius: BorderRadius.circular(10),
//                                    child: Image.network(
//                                      ConstantFile().imageUrl + nDataListNews['news_image'],
//                                      height: 90.0,
//                                      fit: BoxFit.cover,
//                                    ),
//                                  ),
//                                )
//                              ],
//                            ),
//                            Flexible(
//                              child: Padding(
//                                padding: EdgeInsets.only(left: 8,right: 8),
//                                child: Column(
//                                  crossAxisAlignment: CrossAxisAlignment.start,
//                                  children: <Widget>[
//                                    SizedBox(
//                                      width: 100,
//                                      height: 25,
//                                      child: RaisedButton(
//                                        shape: RoundedRectangleBorder(
//                                          borderRadius: BorderRadius.circular(16)
//                                        ),
//                                        color: Colors.deepPurple,
//                                        onPressed: (){},
//                                        child: Text("Politic",
//                                        style: TextStyle(color: Colors.white),),
//                                      ),
//                                    ),
//
//                                    //Title
//                                    Text(
//                                      nDataListNews['news_title'],
//                                      overflow: TextOverflow.ellipsis,
//                                      softWrap: false,
//                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                                    ),
//
//
//                                    //Content
//                                    Text(
//                                      nDataListNews['news_content'],
//                                      overflow: TextOverflow.ellipsis,
//                                      softWrap: false,
//                                      maxLines: 3,
//                                    )
//                                  ],
//                                ),
//                              ),
//                            )
//                          ],
//                        ),
//                      ),
//                    ),
//                  );
//                }
//            ),
//          )