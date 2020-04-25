import 'package:flutter/material.dart';
import 'package:quizzapp/Result.dart';
import 'package:quizzapp/answer.dart';

import './question.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  var _questionIndex = 0;
  var _totalScore = 0;

  void _resetQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
    });
  }

  void _answerQuestion(int score) {
    _totalScore += score;
    setState(() {
      if (_questionIndex < _questions.length) _questionIndex++;
    });
    print('questionIndex is [$_questionIndex]');
    print('Answer choosen');
  }

  final _questions = const [
    {
      'questionText': 'What\'s your favorite color between?',
      'answers': [
        {'text': 'Black', 'score': 10},
        {'text': 'Red', 'score': 5},
        {'text': 'Blue', 'score': 3},
        {'text': 'White', 'score': 1},
      ],
    },
    {
      'questionText': 'What\'s your favorite animal between?',
      'answers': [
        {'text': 'Snake', 'score': 8},
        {'text': 'Dog', 'score': 5},
        {'text': 'Cat', 'score': 2},
      ],
    },
    {
      'questionText': 'What\'s your favorite programming language?',
      'answers': [
        {'text': 'Flutter', 'score': 2},
        {'text': 'Flutter', 'score': 2},
        {'text': 'Flutter', 'score': 2},
      ],
    },
  ];

  @override
  Widget build(BuildContext ctx) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('My First App'),
        ),
        body: _questionIndex < _questions.length
            ? Column(
                children: <Widget>[
                  Question(_questions[_questionIndex]['questionText']),
                  ...(_questions[_questionIndex]['answers']
                          as List<Map<String, Object>>)
                      .map((answer) {
                    return Answer(
                        () => _answerQuestion(answer['score']), answer['text']);
                  }).toList(),
                ],
              )
            : Center(
                child: Column(
                  children: <Widget>[Result(_totalScore, _resetQuiz)],
                ),
              ),
      ),
    );
  }
}
