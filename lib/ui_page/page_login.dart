import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:news_project/ui_view/login_signup/login_register.dart';

class PageLogin extends StatefulWidget {
  PageLogin({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _PageLoginState createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin>
{
  @override
  Widget build(BuildContext context) {
    return LoginRegisterPage();
  }
}
