import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  final String _mainText;

  MyText(this._mainText);

  @override
  Widget build(BuildContext context) {
    return Text(_mainText);
  }
}
