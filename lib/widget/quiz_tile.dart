import 'package:flutter/material.dart';

import '../constants/db_constants.dart';
import '../screens/quiz_screens/quiz_resource_screen.dart';

class QuizTile extends StatelessWidget {
  final Map<String, dynamic> quizData;
  const QuizTile({Key? key, required this.quizData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("###################################3");
    print(quizData);
    return ListTile(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
            builder: (context) => ResourceScreen(quizData: quizData)));
      },
      title: Text(quizData[ChildDataConstants.topicName]),
      subtitle: Text(quizData[ChildDataConstants.difficultyLevel]),
      trailing: const Icon(Icons.arrow_forward_ios),
    );
  }
}
