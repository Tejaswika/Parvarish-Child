import 'package:flutter/material.dart';

class QuizResource extends StatefulWidget {
  final Map<String, dynamic>? quizData;
  const QuizResource({Key? key, required this.quizData}) : super(key: key);

  @override
  State<QuizResource> createState() => _QuizResourceState();
}

class _QuizResourceState extends State<QuizResource> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.quizData.toString());
  }
}
