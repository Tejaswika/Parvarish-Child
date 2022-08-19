import 'package:flutter/material.dart';

class QuizTile extends StatelessWidget {
  final Map<String, dynamic> quizData;
  const QuizTile({Key? key, required this.quizData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(quizData.toString());
  }
}
