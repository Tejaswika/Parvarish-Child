import 'package:flutter/material.dart';

class QuizResource extends StatefulWidget {
  final int? index;
  final Map<String, dynamic>? quizResource;
  const QuizResource(
      {Key? key, required this.index, required this.quizResource})
      : super(key: key);

  @override
  State<QuizResource> createState() => _QuizResourceState();
}

class _QuizResourceState extends State<QuizResource> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.quizResource.toString());
  }
}
