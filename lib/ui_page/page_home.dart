import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:news_project/constant/ConstantFile.dart';
import 'package:news_project/ui_page/add_news.dart';
import 'package:news_project/ui_view/all/all_list_page.dart';
import 'package:news_project/ui_view/culinary/culinary_list_page.dart';
import 'package:news_project/ui_view/seacrh/search_page.dart';
import 'package:news_project/ui_view/sport/sport_list_page.dart';
import 'package:news_project/ui_view/travel/travel_list_page.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class PageHome extends StatefulWidget {
  final drawerItem = [
    new DrawerItem("Cart", Icons.add_shopping_cart),
    new DrawerItem("Travel", Icons.card_travel),
    new DrawerItem("Info", Icons.info),
  ];
  @override
  _PageHomeState createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome>
    with SingleTickerProviderStateMixin {
  TabController controllerTab;
  List listToken = [];

  Future<List> getData()async{
    final response = await http.get(ConstantFile().baseUrl+"getToken");
    var data = jsonDecode(response.body);
    var finalData = data['data'];
    print('dataToken, $finalData');
    return finalData;
  }

  Widget myToken(){
    return FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return listToken = snapshot.data;
        });
  }
//  void finalToken(){
//    for(int index = listToken.length; index > 0; index++){
//      var finalData = listToken[index];
//
//      print('finalToken Data : ${finalData['token']}');
//      print('finalToken Data : ${}');
//    }
//  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controllerTab = new TabController(vsync: this, length: 4);
    getData();
//    finalToken();
  }

  @override
  void dispose() {  
    // TODO: implement dispose
    super.dispose();
    controllerTab.dispose();
  }
  int _selectedDrawerIndex = 0;



  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }


  @override
  Widget build(BuildContext context) {
    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.drawerItem.length; i++) {
      var d = widget.drawerItem[i];
      drawerOptions.add(
          new ListTile(
            leading: new Icon(d.icon),
            title: new Text(d.title),
            trailing: new Icon(Icons.arrow_right),
            selected: i == _selectedDrawerIndex,
            onTap: () => _onSelectItem(i),
          )
      );
    }

    return Scaffold(
      drawer: Drawer(
         child: new Column(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                accountName: Text("Muhamad Alamsyah"),
                accountEmail: Text("muhamad.alamsyah@udacoding.com"),
                currentAccountPicture: CircleAvatar(
                  backgroundColor:
                  Theme.of(context).platform == TargetPlatform.iOS
                      ? Colors.blue
                      : Colors.white,
                  child: Text("A",style: TextStyle(fontSize: 40.0),
                  ),
                ),
                otherAccountsPictures: <Widget>[
                  CircleAvatar(
                    backgroundColor:
                    Theme.of(context).platform == TargetPlatform.iOS
                        ? Colors.blue
                        : Colors.white,
                    child: Icon(Icons.exit_to_app,size: 25,),
                  ),
                ],
              ),
              new Column(children: drawerOptions)
            ],
          ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: <Widget>[
            SizedBox(
              width: 160,
              height: 30,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Text(
                  "MBACA WEWARA",
                  style: TextStyle(color: Colors.deepPurple),
                ),
                color: Colors.white,
                onPressed: () {},
              ),
            ),
            Text(
              "The News Application",
              style: TextStyle(fontSize: 10, color: Colors.white),
            )
          ],
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: IconButton(
              icon: Icon(FontAwesomeIcons.search),
              iconSize: 20,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchPage()));
              },
            ),
          )
        ],
      ),
      body: TabBarView(
        controller: controllerTab,
        children: <Widget>[
          AllPage(),
          CulinerPage(),
          SportPage(),
          TravelPage(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF512DA8),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddNews()));
        },
        tooltip: 'Increment',
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        elevation: 2.0,
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 32,
        // color: Colors.deepPurpleAccent,
        color: Color(0xFF512DA8),
        shape: CircularNotchedRectangle(),
        child: new TabBar(
          controller: controllerTab,
          unselectedLabelColor: Colors.white,
          indicatorColor: Colors.purpleAccent,
          // labelColor: Color(0xFF512DA8),
          labelColor: Colors.white60,
          tabs: <Widget>[
            Tab(icon: Icon(Icons.dashboard)),
            Padding(
              padding: const EdgeInsets.only(right: 32),
              child: Tab(icon: Icon(FontAwesomeIcons.birthdayCake)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: Tab(
                icon: Icon(FontAwesomeIcons.basketballBall),
              ),
            ),
            Tab(
              icon: Icon(FontAwesomeIcons.planeDeparture),
            )
          ],
        ),
      ),
    );
  }
}
