import 'package:child/screens/screen_time_report.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:child/services/snackbar_service.dart';
import 'package:child/route_test_screen.dart';
import 'package:child/constants/db_constants.dart';
import '../widget/home_appdrawer.dart';
import './quiz_screens/assigned_quiz_screen.dart';

class MyNavPill extends StatefulWidget {
  final String? uid;
  const MyNavPill({Key? key, required this.uid}) : super(key: key);

  @override
  MyNavPillState createState() => MyNavPillState();
}

class MyNavPillState extends State<MyNavPill>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final CollectionReference _quizCollection =
      _firestore.collection(DBConstants.quizCollectionName);
//Store this globally

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference _childCollection =
      _firestore.collection(DBConstants.childCollectionName);

  Map<String, dynamic>? childData;
  Map<String, dynamic> apps = {};
  List<Map<String, dynamic>> childQuizData = [];
  bool _loading = true;

  final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    readchildData(widget.uid);
    super.initState();
  }

  void readchildData(uid) async {
    DocumentReference documentReferencer = _childCollection.doc(uid);
    DocumentSnapshot childDataSnapshot = await documentReferencer.get().onError(
        (error, stackTrace) =>
            SnackbarService.showErrorSnackbar(context, error.toString()));

    childData = childDataSnapshot.data() as Map<String, dynamic>;
    if (childData != null) {
      setState(() {
        childData![ChildDataConstants.quizes].forEach((childQuiz) {
          childQuizData.add(childQuiz as Map<String, dynamic>);
        });
        apps = childData!['apps'];
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parvarish'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              child: Text('Report'),
            ),
            Tab(
              child: Text('Assigned Quizzes'),
            ),
          ],
        ),
      ),
      drawer: HomeAppDrawer(
          childQuizData: childQuizData, childData: childData, apps: apps),
      body: Navigator(
        key: _navKey,
        onGenerateRoute: (_) => MaterialPageRoute(
          builder: (_) => TabBarView(
            controller: _tabController,
            children: [
              ScreenTimeReport(
                UID: widget.uid,
              ),
              AssignedQuizScreen(childQuizData: childQuizData),
            ],
          ),
        ),
      ),
    );
  }
}

final List<String> imagesList = [
  'https://cdn-icons-png.flaticon.com/512/2922/2922561.png',
  'https://cdn-icons-png.flaticon.com/512/2922/2922510.png',
  'https://cdn-icons-png.flaticon.com/512/2922/2922575.png',
];
final List<String> titles = [
  ' Neha Singh ',
  ' Raj Kumar ',
  ' Preeti Pandey ',
];
