import 'package:child/services/snackbar_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:child/constants/db_constants.dart';

import 'main_quiz.dart';

class ResourceScreen extends StatefulWidget {
  final Map<String, dynamic> quizData;
  const ResourceScreen({Key? key, required this.quizData}) : super(key: key);

  @override
  State<ResourceScreen> createState() => _ResourceScreenState();
}

class _ResourceScreenState extends State<ResourceScreen> {
  launchResources(Uri resourceLink) async {
    if (await canLaunchUrl(resourceLink)) {
      await launchUrl(resourceLink);
    } else {
      SnackbarService.showErrorSnackbar(context, "Could not launch resources");
      throw "Could not launch $resourceLink";
    }
  }

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
      body: Padding(
        padding: const EdgeInsets.only(top: 15, left: 40),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Resources for ${widget.quizData[ChildDataConstants.topicName]}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () => launchResources(
                      Uri.parse(
                        widget.quizData[ChildDataConstants.quizData]
                            [QuizDataConstants.resources],
                      ),
                    ),
                child: const Text("Tap here to read the resources"))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MainQuiz(
                    questions: widget.quizData[ChildDataConstants.quizData]
                        [QuizDataConstants.questions]))),
        label: const Text("Start quiz"),
        icon: const Icon(Icons.quiz),
      ),
    );
  }
}
