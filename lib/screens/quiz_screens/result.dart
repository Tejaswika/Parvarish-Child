import 'package:child/services/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../constants/db_constants.dart';

class Result extends StatefulWidget {
  final int resultScore;
  final int QuizLength;
  final VoidCallback resetQuizHandler;
  final Map<String, dynamic> quizData;
  final Function callback;
  const Result({
    Key? key,
    required this.resultScore,
    required this.QuizLength,
    required this.resetQuizHandler,
    required this.quizData,
    required this.callback,
  }) : super(key: key);
  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  @override
  void initState() {
    String uid = LocalStorageService.getData('UserId');
    update(uid);
    super.initState();
  }

  void update(uid) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    late final CollectionReference _childCollection =
        _firestore.collection(DBConstants.childCollectionName);
    DocumentReference documentReferencer = _childCollection.doc(uid);
    DocumentSnapshot ChildrenDataSnapshot = await documentReferencer.get();
    Map<String, dynamic>? childData =
        ChildrenDataSnapshot.data() as Map<String, dynamic>;

    childData['quizes'].forEach((quiz) {
      if (quiz['quiz_id'] == widget.quizData['quiz_id']) {
        quiz['is_attempted'] = true;
        quiz[ChildDataConstants.minScore] =
            widget.resultScore < quiz[ChildDataConstants.minScore] ||
                    quiz[ChildDataConstants.minScore] == 0
                ? widget.resultScore
                : quiz[ChildDataConstants.minScore];
      }
    });

    await documentReferencer.update(childData).then((val) {
      // Navigator.pop(context);
      widget.callback();
    }).catchError((e) => print(e));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(12),
            child: Wrap(
              runSpacing: 5.0,
              spacing: 20.0,
              children: [
                Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(10),
                    child: RichText(
                      text: TextSpan(
                        children: const <TextSpan>[
                          TextSpan(
                              text: 'Quiz Analysis \n',
                              style: TextStyle(
                                  fontSize: 40,
                                  color: Color.fromARGB(255, 0, 0, 0))),
                        ],
                      ),
                    )),
                Container(
                    padding: const EdgeInsets.only(top: 60, bottom: 40),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Color.fromARGB(255, 0, 0, 0), width: 3),
                      color: Color.fromARGB(54, 255, 255, 255),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: 100.0,
                              width: 130.0,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color.fromARGB(54, 1, 29, 74),
                                    width: 3),
                                color: Color.fromARGB(54, 108, 147, 188),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              alignment: Alignment.center,
                              padding: new EdgeInsets.all(5.0),
                              margin:
                                  new EdgeInsets.symmetric(horizontal: 10.0),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'Correct\n',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Color.fromARGB(
                                                255, 45, 21, 21))),
                                    TextSpan(
                                        text: '\n',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color:
                                                Color.fromARGB(255, 0, 0, 0))),
                                    TextSpan(
                                        text: ((widget.resultScore).toInt())
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            color:
                                                Color.fromARGB(255, 0, 0, 0))),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 100.0,
                              width: 130.0,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color.fromARGB(54, 1, 29, 74),
                                    width: 3),
                                color: Color.fromARGB(54, 108, 147, 188),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              alignment: Alignment.center,
                              padding: new EdgeInsets.all(5.0),
                              margin:
                                  new EdgeInsets.symmetric(horizontal: 10.0),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'Incorrect\n',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color:
                                                Color.fromARGB(255, 0, 0, 0))),
                                    TextSpan(
                                        text: '\n',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color:
                                                Color.fromARGB(255, 0, 0, 0))),
                                    TextSpan(
                                        text: ((widget.QuizLength -
                                                    widget.resultScore)
                                                .toInt())
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            color:
                                                Color.fromARGB(255, 0, 0, 0))),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: 100.0,
                              width: 130.0,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color.fromARGB(54, 1, 29, 74),
                                    width: 3),
                                color: Color.fromARGB(54, 108, 147, 188),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              alignment: Alignment.center,
                              padding: new EdgeInsets.all(5.0),
                              margin:
                                  new EdgeInsets.symmetric(horizontal: 10.0),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'Percentage\n',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color:
                                                Color.fromARGB(255, 0, 0, 0))),
                                    TextSpan(
                                        text: 'Scored',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color:
                                                Color.fromARGB(255, 0, 0, 0))),
                                    TextSpan(
                                        text: '\n',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color:
                                                Color.fromARGB(255, 15, 6, 6))),
                                    TextSpan(
                                        text: (((widget.resultScore /
                                                        widget.QuizLength) *
                                                    100)
                                                .toInt())
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            color:
                                                Color.fromARGB(255, 0, 0, 0))),
                                    TextSpan(
                                        text: ("%"),
                                        style: TextStyle(
                                            fontSize: 20,
                                            color:
                                                Color.fromARGB(255, 0, 0, 0))),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 100.0,
                              width: 130.0,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color.fromARGB(54, 1, 29, 74),
                                    width: 3),
                                color: Color.fromARGB(54, 108, 147, 188),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              alignment: Alignment.center,
                              padding: new EdgeInsets.all(5.0),
                              margin:
                                  new EdgeInsets.symmetric(horizontal: 10.0),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'Total\n',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Color.fromARGB(
                                                255, 55, 17, 17))),
                                    TextSpan(
                                        text: 'Questions',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color:
                                                Color.fromARGB(255, 0, 0, 0))),
                                    TextSpan(
                                        text: '\n',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color:
                                                Color.fromARGB(255, 0, 0, 0))),
                                    TextSpan(
                                        text: ((widget.QuizLength).toInt())
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            color:
                                                Color.fromARGB(255, 0, 0, 0))),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 20),
                          child: (((widget.resultScore / widget.QuizLength) *
                                      100 >=
                                  60)
                              ? Text("Passed")
                              : Text("Failed")),
                        ),
                      ],
                    )),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(15),
                  child: ElevatedButton(
                    child:
                        (((widget.resultScore / widget.QuizLength) * 100 >= 60)
                            ? Text("Enjoy")
                            : Text("Re-Test")),
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 155, 173, 240),
                      //onPrimary: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
