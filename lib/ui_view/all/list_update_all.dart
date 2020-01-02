import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:news_project/constant/ConstantFile.dart';
import 'package:news_project/model/model_data.dart';
import 'package:news_project/ui_page/detail_news.dart';

class ListUpdate extends StatefulWidget {
  @override
  _ListUpdateState createState() => _ListUpdateState();
}

class _ListUpdateState extends State<ListUpdate> {
  Future<List<Datum>> getAllData() async {
    final response = await http.get(ConstantFile().baseUrl + "getNews");
    // List data = jsonDecode(response.body);
    ResultNews data = resultNewsFromJson(response.body);
    return data.data;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.deepPurple,
                  ),
                  Text(
                    'News Updated',
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        color: Colors.deepPurple),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  // Make Action you need
                },
                child: Row(
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.sortAmountDown,
                      color: Colors.deepPurple,
                      size: 15,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: FutureBuilder(
              future: getAllData(),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                return snapshot.hasData
                    ? new ItemUpdate(
                        list: snapshot.data,
                      )
                    : new Center(
                        child: CircularProgressIndicator(),
                      );
              }),
        ),
      ],
    );
  }
}

class ItemUpdate extends StatelessWidget {
  List list;
  ItemUpdate({this.list});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: list == null ? 0 : list.length,
        itemBuilder: (BuildContext context, int index) {
          final Datum data = list[index];
          return Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) => DetailNews(
                        // titleDetail: dataList['news_title'],
                        // imageDetail: dataList['news_image'],
                        // contentDetail: dataList['news_content'],
                        // idDetail: dataList['news_id']

                        titleDetail: data.newsTitle,
                        imageDetail: data.newsImage,
                        contentDetail: data.newsContent,
                        idDetail: data.newsId))),
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
                                ConstantFile().imageUrl + data.newsImage,
                                // dataList['news_image'],
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
                                data.newsTitle,
                                // dataList['news_title'],
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),

                              //Content
                              Text(
                                // dataList['news_content'],
                                data.newsContent,
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
            ),
          );
        });
  }
}
