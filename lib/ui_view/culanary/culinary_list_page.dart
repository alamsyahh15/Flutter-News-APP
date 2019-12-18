import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:news_project/ui_view/all/image_slider_home.dart';
import 'package:news_project/ui_view/culanary/list_update_culinary.dart';

class CulinerPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 30.0),
          children: <Widget>[
            SizedBox(
              height: 20.0,
            ),
            SliderHome(),
            SizedBox(
              height: 20.0,
            ),
            ListCuliner()
          ],
        ),
      );
  }
}