import 'package:child/widget/quiz_resource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../../constants/db_constants.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ResourcesScreen extends StatefulWidget {
  final List<Map<String, dynamic>> childQuizData;
  const ResourcesScreen({
    Key? key,
    required this.childQuizData,
  }) : super(key: key);

  @override
  State<ResourcesScreen> createState() => ResourcesScreenState();
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
List<Map<String, dynamic>> attemtedQuizData = [];
List<Map<String, dynamic>> unattemtedQuizData = [];

late final CollectionReference _quizDataCollection =
    _firestore.collection(DBConstants.quizDataCollectionName);
// List completedQuizData = [];

class ResourcesScreenState extends State<ResourcesScreen> {
  bool isLoading = true;
  @override
  void initState() {
    generateQuizData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // generateQuizData();
    return Scaffold(
        body: isLoading
            ? const CircularProgressIndicator()
            : ListView.builder(
                itemCount: unattemtedQuizData.length,
                itemBuilder: (context, index) {
                  return QuizTile(quizData: unattemtedQuizData[index]);
                }));
  }

  Future<Map<String, dynamic>> fetchQuizData(String quizId) async {
    debugPrint("############################");
    debugPrint(quizId);
    DocumentReference documentReferencer =
        _quizDataCollection.doc(quizId.trim());
    DocumentSnapshot quizDataSnapshot = await documentReferencer.get();

    Map<String, dynamic> quizData =
        quizDataSnapshot.data() as Map<String, dynamic>;
    return quizData;
  }

  void generateQuizData() async {
    debugPrint(isLoading.toString());
    widget.childQuizData.forEach((Map<String, dynamic> quiz) {
      if (quiz[ChildDataConstants.attempted]) {
        fetchQuizData(quiz[ChildDataConstants.quizId])
            .then((Map<String, dynamic> quizData) {
          quiz["quiz_data"] = quizData;
          attemtedQuizData.add(quiz);
        });
      } else {
        fetchQuizData(quiz[ChildDataConstants.quizId])
            .then((Map<String, dynamic> quizData) {
          quiz["quiz_data"] = quizData;
          unattemtedQuizData.add(quiz);
        });
      }
    });
    debugPrint(attemtedQuizData.toString());
    debugPrint(unattemtedQuizData.toString());
    setState(() {
      isLoading = false;
    });
  }
}
