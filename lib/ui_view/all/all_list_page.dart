import 'package:flutter/material.dart';
import 'image_slider_home.dart';
import 'list_update_all.dart';



class AllPage extends StatelessWidget {

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
            ListUpdate()
          ],
        ),
      );
  }
}