import 'package:child/constants/db_constants.dart';
import 'package:flutter/material.dart';

import 'main_quiz.dart';

class ResourceScreen extends StatefulWidget {
  final Map<String, dynamic> quizData;
  const ResourceScreen({Key? key, required this.quizData}) : super(key: key);

  @override
  State<ResourceScreen> createState() => _ResourceScreenState();
}

class _ResourceScreenState extends State<ResourceScreen> {
  @override
  Widget build(BuildContext context) {
    print("################################");
    print(widget.quizData);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Parvarish"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Text(widget.quizData[ChildDataConstants.quizData]
              [QuizDataConstants.resources] ??
          "Error"),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MainQuiz(
                    questions: widget.quizData[ChildDataConstants.quizData]
                        [QuizDataConstants.questions]))),
        label: const Text("Start quiz"),
      ),
    );
  }
}
