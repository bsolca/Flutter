import 'package:flutter/material.dart';
import 'package:simpledynamicinput/TextController.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Simple Dynamic input'),
          centerTitle: true,
        ),
        body: TextController(),
      ),
    );
  }
}
