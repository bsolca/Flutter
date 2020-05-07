import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveFlatButton extends StatelessWidget {
  final String textButton;
  final Function onPressedFunction;

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            child: Text(
              textButton,
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
            ),
            onPressed: onPressedFunction,
          )
        : FlatButton(
            child: Text(
              textButton,
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
            ),
            onPressed: onPressedFunction,
          );
  }

  AdaptiveFlatButton(this.textButton, this.onPressedFunction);
}
