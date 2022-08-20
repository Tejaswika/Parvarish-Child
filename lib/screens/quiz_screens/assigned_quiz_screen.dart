import 'package:child/services/snackbar_service.dart';
import 'package:child/widget/quiz_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constants/db_constants.dart';

class AssignedQuizScreen extends StatefulWidget {
  final List<Map<String, dynamic>> childQuizData;
  const AssignedQuizScreen({
    Key? key,
    required this.childQuizData,
  }) : super(key: key);

  @override
  State<AssignedQuizScreen> createState() => AssignedQuizScreenState();
}

// List completedQuizData = [];

class AssignedQuizScreenState extends State<AssignedQuizScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> attemtedQuizData = [];
  List<Map<String, dynamic>> unattemtedQuizData = [];

  late final CollectionReference _quizDataCollection =
      _firestore.collection(DBConstants.quizDataCollectionName);
  bool isLoading = true;
  @override
  void initState() {
    print("Heloo initState");
    print(widget.childQuizData);
    if (attemtedQuizData.length + unattemtedQuizData.length !=
        widget.childQuizData.length) {
      generateQuizData();
    } else {
      setState(() {
        isLoading = false;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // generateQuizData();
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.only(top: 20, left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Attempted quiz",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                  ),
                  attemtedQuizData.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.only(top: 10, left: 20),
                          child: Text(
                            "No quiz attempted",
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: attemtedQuizData.length,
                          itemBuilder: (context, index) {
                            return QuizTile(quizData: attemtedQuizData[index]);
                          },
                        ),
                  const Divider(thickness: 1),
                  const Text(
                    "Unattempted quiz",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                  ),
                  unattemtedQuizData.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.only(top: 10, left: 15),
                          child: Text(
                            "No new quiz has been assigned",
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: unattemtedQuizData.length,
                          itemBuilder: (context, index) {
                            return QuizTile(
                                quizData: unattemtedQuizData[index]);
                          },
                        ),
                ],
              ),
            ),
    );
  }

  Future<Map<String, dynamic>> fetchQuizData(String quizId) async {
    // print("############################");
    // print(quizId);
    DocumentReference documentReferencer =
        _quizDataCollection.doc(quizId.trim());
    DocumentSnapshot quizDataSnapshot = await documentReferencer.get().onError(
        (error, stackTrace) =>
            SnackbarService.showErrorSnackbar(context, "Some error occured"));

    Map<String, dynamic> quizData =
        quizDataSnapshot.data() as Map<String, dynamic>;
    return quizData;
  }

  Future<void> generateQuizData() async {
    int i = 0;
    print("########################");
    print(++i);
    print("########################");
    widget.childQuizData
        .asMap()
        .forEach((int index, Map<String, dynamic> quiz) async {
      if (quiz[ChildDataConstants.attempted]) {
        await fetchQuizData(quiz[ChildDataConstants.quizId])
            .then((Map<String, dynamic> quizData) {
          quiz[ChildDataConstants.quizData] = quizData;
          attemtedQuizData.add(quiz);
        });
        if (index == widget.childQuizData.length - 1) {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        await fetchQuizData(quiz[ChildDataConstants.quizId])
            .then((Map<String, dynamic> quizData) {
          quiz["quiz_data"] = quizData;
          unattemtedQuizData.add(quiz);
        });
        if (index == widget.childQuizData.length - 1) {
          setState(() {
            isLoading = false;
          });
        }
      }
    });
    // print(attemtedQuizData);
    // print(unattemtedQuizData);
    // setState(() {
    //   isLoading = false;
    // });
  }
}
