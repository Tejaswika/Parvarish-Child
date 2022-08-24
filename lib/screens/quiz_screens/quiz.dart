import 'package:flutter/material.dart';
import '../../widget/question_text.dart';
import './answer.dart';

// Flutter Hope
class Quiz extends StatelessWidget {
  final List<dynamic> questions;
  final Function answerQuestion;
  final int questionIndex;
  const Quiz(this.answerQuestion, this.questions, this.questionIndex);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Question(questions[questionIndex]['Question'] as String),
        ...(questions[questionIndex]['Options'] as List<dynamic>).map((ans) {
          return Answer(() => answerQuestion(ans), ans as String);
        }).toList(),
      ],
    );
  }
}
