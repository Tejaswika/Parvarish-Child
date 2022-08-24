import 'package:flutter/material.dart';
import './quiz.dart';
import './result.dart';

class MainQuiz extends StatefulWidget {
  final Map<String, dynamic> quizData;
  final List<dynamic> questions;
  final Function callback;
  const MainQuiz({
    Key? key,
    required this.questions,
    required this.quizData,
    required this.callback,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _MainQuizState();
  }
}

class _MainQuizState extends State<MainQuiz> {
  var questionIndex = 0;
  var _totalScore = 0;

  void answerQuestion(ans) {
    if (questionIndex < widget.questions.length) {}
    if (widget.questions[questionIndex]['Correct Option'] == ans) {
      _totalScore = _totalScore + 1;
    }
    setState(() {
      questionIndex = questionIndex + 1;
    });
  }

  Future<void> resetQuiz() async {
    setState(() {
      questionIndex = 0;
      _totalScore = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          title: Text("Quiz"),
        ),
        body: questionIndex < widget.questions.length
            ? Quiz(answerQuestion, widget.questions, questionIndex)
            : Result(
                resultScore: _totalScore,
                resetQuizHandler: resetQuiz,
                QuizLength: widget.questions.length,
                quizData: widget.quizData,
                callback: widget.callback,
              ),
      ),
    );
  }
}
