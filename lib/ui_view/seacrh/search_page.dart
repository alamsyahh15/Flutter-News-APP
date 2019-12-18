import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:news_project/constant/ConstantFile.dart';
import 'package:news_project/ui_view/all/list_update_all.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool _isSearch = true;
  List filterList;
  TextEditingController _etSearch = new TextEditingController();
  List finalData;
  String keyword;

  Future<List> getSearchData() async{
    final response = await http.post(ConstantFile().baseUrl + "searchNews",
        body: {'keyword': _etSearch.text});
    var data = jsonDecode(response.body);
    finalData = data['data'];
    return finalData;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // finalData = finalData;
  }

  _SearchPageState() {
    _etSearch.addListener(() {
      if (_etSearch.text.isEmpty) {
        setState(() {
          _isSearch = true;
          keyword = "";
        });
      } else {
        setState(() {
          _isSearch = false;
          keyword = _etSearch.text;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _createSearchVIew(),
          _isSearch ? _createListView() : performSearch(),
        ],
      ),
    );
  }

  //Membuat Search View
  Widget _createSearchVIew() {
    return Card(
      margin: EdgeInsets.only(top: 8),
      elevation: 16,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _etSearch,
          textAlign: TextAlign.start,
          decoration: InputDecoration(hintText: "Search"),
        ),
      ),
    );
  }

  Widget _createListView() {
    return Flexible(
      child: FutureBuilder(
          future: getSearchData(),
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
    );
  }

  Widget performSearch() {
    // filterList = new List();
    // for (int i = 0; i < finalData.length;) {
    //   var item = finalData[i];
    //   if (item.toLowerCase().contains(keyword.toLowerCase())) {
    //     filterList.add(item);
    //   }
    // }
    // return _createFilterView();
     return Flexible(
      child: FutureBuilder(
          future: getSearchData(),
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
    );
  }

  // Widget _createFilterView() {
  //   return Flexible(
  //     child: ListView.builder(
  //         itemCount: filterList.length,
  //         itemBuilder: (BuildContext context, int index) {
  //           return filterList.length != null
  //               ? new ItemUpdate(
  //                   list: filterList,
  //                 )
  //               : new Center(
  //                   child: CircularProgressIndicator(),
  //                 );
  //         }),
  //   );
  // }
}
