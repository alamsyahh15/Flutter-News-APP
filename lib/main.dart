import 'package:flutter/material.dart';
import 'package:news_project/ui_page/page_home.dart';
import 'package:news_project/ui_view/login_signup/login_register.dart';

void main() => runApp(MaterialApp(
  home: PageHome(),
  debugShowCheckedModeBanner: false,
  theme: ThemeData(
        primaryColor: Color(0xFF512DA8),
        accentColor: Color(0xFFEDE7F6),
        scaffoldBackgroundColor: Color(0xFFF3F5F7),
      ),
));

