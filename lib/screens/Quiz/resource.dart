import 'package:child/widget/quiz_resource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../../constants/db_constants.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({Key? key}) : super(key: key);

  @override
  State<ResourcesScreen> createState() => ResourcesScreenState();
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
Map<String, Map<String, dynamic>> quizData = {};

late final CollectionReference _childCollection =
    _firestore.collection(DBConstants.childCollectionName);
late final CollectionReference _quizDataCollection =
    _firestore.collection(DBConstants.quizDataCollectionName);
List resource = [];
List quizID = [];

Future<void> getUID() async {
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
    QuizID(prefs.getString('UserId'));
  }
}

void QuizID(uid) async {
  DocumentReference documentReferencer = _childCollection.doc(uid);
  DocumentSnapshot childDataSnapshot = await documentReferencer.get();

  Map<String, dynamic>? childData =
      childDataSnapshot.data() as Map<String, dynamic>;
  print(childData);
  Map<String, dynamic> quizesAlloted = childData['quizes'];
  print("************************************************************");
  if (quizesAlloted != Null) {
    print(quizesAlloted);
    getResource(quizesAlloted);
  } else {
    print("N0 quiz id");
  }
  print("************************************************************");
}

void getResource(quizesAlloted) async {
  quizesAlloted.forEach((quiz) {
    quizID.add(quiz[ChildDataConstants.quizId]);
  });
  quizID.forEach((id) {
    fetchQuizData(id);
  });
}

void fetchQuizData(id) async {
  DocumentReference documentReferencer = _quizDataCollection.doc(id);
  DocumentSnapshot quizDataSnapshot = await documentReferencer.get();
  Map<String, dynamic>? data = quizDataSnapshot.data() as Map<String, dynamic>;
  quizData[id] = data;
}

class ResourcesScreenState extends State<ResourcesScreen> {
  @override
  void initState() {
    getUID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            itemCount: quizData.length,
            itemBuilder: (context, index) {
              return QuizResource(
                  index: index, quizResource: quizData[resource]);
            })
            );
  }
}
