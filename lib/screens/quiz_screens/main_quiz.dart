import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../../constants/db_constants.dart';
import './quiz.dart';
import './result.dart';
import 'package:child/services/local_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainQuiz extends StatefulWidget {
  MainQuiz({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _MainQuizState();
  }
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// Creating a reference to the collection
late final CollectionReference _childCollection =
    _firestore.collection(DBConstants.childCollectionName);

Future<void> getQuiz() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAcypiXEDRZ3rsx78gspfxtuYpNRTPURg4",
        appId: "1:238970681958:web:69c6a3749087144b7b0ba7",
        messagingSenderId: "238970681958",
        projectId: "parvarish-e8a53",
        storageBucket: "parvarish-e8a53.appspot.com",
        authDomain: "parvarish-e8a53.firebaseapp.com",
      ),
    );
  } catch (error) {
    print(error);
  }

  if (prefs.getString('UserId') != "") {
    print(prefs.getString('UserId'));
    QuestionList(prefs.getString('UserId'));
  }
}

void QuestionList(uid) async {
  DocumentReference documentReferencer = _childCollection.doc(uid);
  DocumentSnapshot childDataSnapshot = await documentReferencer.get();

  // Getting data from Snapshot
  Map<String, dynamic>? childData =
      childDataSnapshot.data() as Map<String, dynamic>;
  // parentDataSnapshot.id;
  print(childData);
  List quizesAlloted = childData['quizes'];
  print("************************************************************");
  if (quizesAlloted != Null) {
    print(quizesAlloted);
  } else {
    print("N0 quiz id");
  }
  print("************************************************************");
}

class _MainQuizState extends State<MainQuiz> {
  //_ means private in dart
  @override
  void initState() {
    getQuiz();
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
