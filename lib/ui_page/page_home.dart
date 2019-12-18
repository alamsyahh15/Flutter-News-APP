import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:news_project/ui_view/all/all_list_page.dart';
import 'package:news_project/ui_view/culinary/culinary_list_page.dart';
import 'package:news_project/ui_view/seacrh/search_page.dart';
import 'package:news_project/ui_view/sport/sport_list_page.dart';
import 'package:news_project/ui_view/travel/travel_list_page.dart';

class PageHome extends StatefulWidget {
  @override
  _PageHomeState createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome>
    with SingleTickerProviderStateMixin {
  TabController controllerTab;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controllerTab = new TabController(vsync: this, length: 4);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controllerTab.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
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
      bottomNavigationBar: new TabBar(
        controller: controllerTab,
        unselectedLabelColor: Colors.black,
        indicatorColor: Colors.purpleAccent,
        labelColor: Colors.deepPurple,
        tabs: <Widget>[
          Tab(icon: Icon(Icons.dashboard)),
          Tab(icon: Icon(FontAwesomeIcons.birthdayCake)),
          Tab(
            icon: Icon(FontAwesomeIcons.basketballBall),
          ),
          Tab(
            icon: Icon(FontAwesomeIcons.planeDeparture),
          )
        ],
      ),
    );
  }
}
