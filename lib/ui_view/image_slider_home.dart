// Widget Slider
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// ignore: must_be_immutable
class ImageSliderHome extends StatelessWidget {
  String image, title;
  ImageSliderHome({this.image, this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        elevation: 5,
        child: Container(
          width: 350,
          height: double.infinity,
          child: Column(
            children: <Widget>[
              Expanded(
                  flex: 8,
                  child: Container(
                      child: Image.network(
                    image,
                    fit: BoxFit.cover,
                  ))),
              Container(
                child: Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 16),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
