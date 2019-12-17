import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:news_project/constant/ConstantFile.dart';
import 'package:news_project/ui_page/detail_news.dart';

class ListUpdate extends StatefulWidget {
  @override
  _ListUpdateState createState() => _ListUpdateState();
}

class _ListUpdateState extends State<ListUpdate> {
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
              Text(
                'Exclusive Hotels',
                style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5),
              ),
              GestureDetector(
                onTap: () {
                  // Make Action you need
                },
                child: Text(
                  'See All',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 300,
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
        scrollDirection: Axis.vertical,
        itemCount: list == null ? 0 : list.length,
        itemBuilder: (BuildContext context, int index) {
          final dataList = list[index];
          return Padding(
            padding: const EdgeInsets.all(8),
            child: GestureDetector(
              onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                  builder: (context) => DetailNews(
                      titleDetail: dataList['news_title'],
                      imageDetail: dataList['news_image'],
                      contentDetail: dataList['news_content'],
                      idDetail: dataList['news_id']))),
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
                              ConstantFile().imageUrl + dataList['news_image'],
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
                              dataList['news_title'],
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),

                            //Content
                            Text(
                              dataList['news_content'],
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
