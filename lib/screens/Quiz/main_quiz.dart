import 'package:flutter/material.dart';
import './quiz.dart';
import './result.dart';

class MainQuiz extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainQuizState();
  }
}

class _MainQuizState extends State<MainQuiz> {
  //_ means private in dart
  var questionIndex = 0;
  var _totalScore = 0;
  final questions = const [
    {
      "questionText":
          "What are two numbers called having only 1 as a common factor",
      'answers': [
        {'text': 'co-prime numbers', 'score': 0},
        {'text': 'twin prime numbers', 'score': 0},
        {'text': 'composite numbers', 'score': 1},
        {'text': 'prime numbers.', 'score': 1},
      ],
    },
    {
      "questionText": "Question 2",
      'answers': [
        {'text': 'Correct', 'score': 1},
        {'text': 'Wrong', 'score': 0},
        {'text': 'Wrong', 'score': 0},
      ]
    },
    {
      "questionText": "Question 3",
      'answers': [
        {'text': 'Wrong', 'score': 0},
        {'text': 'Wrong', 'score': 0},
        {'text': 'Correct', 'score': 1},
      ]
    }
  ];
  void answerQuestion(int score) {
    if (questionIndex < questions.length) {}
    _totalScore = _totalScore + score;
    print(_totalScore);
    setState(() {
      questionIndex = questionIndex + 1;
    });
    print(questionIndex);
  }

  void resetQuiz() {
    setState(() {
      questionIndex = 0;
      _totalScore = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    //home is named arg

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          title: Text("Quiz"),
        ),
        body: questionIndex < questions.length
            ? Quiz(answerQuestion, questions, questionIndex)
            : Result(_totalScore, resetQuiz, questions.length),
      ),
    );
  }
}
