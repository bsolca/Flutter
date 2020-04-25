import 'package:flutter/material.dart';
import 'package:simpledynamicinput/MyText.dart';

class TextController extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TextControllerState();
}

class _TextControllerState extends State<TextController> {
  String _mainText = 'My first Text';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RaisedButton(
            child: Text('Pressed'),
            onPressed: () {
              setState(() {
                _mainText = 'My second Text has replaced the first one';
              });
            }),
        MyText(_mainText)
      ],
    );
  }
}
