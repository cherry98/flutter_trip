import 'package:flutter/material.dart';
import 'navigator/tab_navigator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter携程',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Container(
        child: TabNavigator(),
      ),
//      debugShowCheckedModeBanner: false,
    );
  }
}
