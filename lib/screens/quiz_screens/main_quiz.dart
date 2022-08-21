import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../../constants/db_constants.dart';
import './quiz.dart';
import './result.dart';
import 'package:child/services/local_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainQuiz extends StatefulWidget {
  final List<dynamic> questions;
  const MainQuiz({Key? key, required this.questions}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _MainQuizState();
  }
}

class _MainQuizState extends State<MainQuiz> {
  @override
  void initState() {
    print("######################3");
    print(widget.questions);
    super.initState();
  }

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
