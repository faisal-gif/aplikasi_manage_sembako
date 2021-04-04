import 'package:flutter/material.dart';
import 'Home.dart';
import 'Login.dart';

//package letak folder Anda
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    Home.tag: (context) => Home(),
  };
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tambahkan Item',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: LoginPage(),
      routes: routes,
    );
  }
}
