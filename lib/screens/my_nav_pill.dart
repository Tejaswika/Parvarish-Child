import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:child/services/snackbar_service.dart';
import 'package:child/route_test_screen.dart';
import 'package:child/constants/db_constants.dart';
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
    print("#################################################");
    print(childData);
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
        title: Text('Parvarish'),
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
      body: Navigator(
        key: _navKey,
        onGenerateRoute: (_) => MaterialPageRoute(
          builder: (_) => TabBarView(
            controller: _tabController,
            children: [
              _FirstPage(
                apps: apps,
              ),
              AssignedQuizScreen(childQuizData: childQuizData),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);
  final String x;
  final int y;
}

class _FirstPage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  final Map<String, dynamic>? apps;

  const _FirstPage({Key? key, required this.apps}) : super(key: key);

  @override
  FirstPageState createState() => FirstPageState();
}

class FirstPageState extends State<_FirstPage> {
  late List<_ChartData> childApps = [];
  late TooltipBehavior _tooltip;
  late Future<Map<String, dynamic>?> appsData;
  late num totalAppHrs = 0;
  late String totalScreenTime = '';
  List<_ChartData> list2 = [];

  @override
  void initState() {
    _tooltip = TooltipBehavior(enable: true);
    _generateAppData();

    super.initState();
  }

  void _generateAppData() {
    widget.apps?.forEach((key, app) {
      childApps
          .add(_ChartData(app['app_name'], app['current_day_screen_time']));
      totalAppHrs = totalAppHrs + app['current_day_screen_time'];
    });
    totalAppHrs = totalAppHrs ~/ 60;
    totalScreenTime = totalAppHrs.toString();

    list2 = childApps.where((map) => map.y > 20).toList();

    print("**********************************************************");
    print(totalAppHrs);
    print("**********************************************************");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Wrap(
          runSpacing: 5.0,
          spacing: 10.0,
          children: [
            Container(
                child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: 'Total Screen Time \n',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 23,
                          color: Color.fromARGB(255, 0, 0, 0))),
                  TextSpan(
                      text: totalScreenTime,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color.fromARGB(255, 0, 0, 0))),
                  TextSpan(
                      text: ' hours',
                      style: TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 190, 190, 190))),
                ],
              ),
            )),
            Container(
              height: 280,
              child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  primaryYAxis: NumericAxis(),
                  tooltipBehavior: _tooltip,
                  series: <CartesianSeries>[
                    ColumnSeries<_ChartData, String>(
                        dataSource: list2,
                        xValueMapper: (_ChartData list2, _) => list2.x,
                        yValueMapper: (_ChartData list2, _) => list2.y,
                        width: 0.6,
                        spacing: 0.3,
                        sortingOrder: SortingOrder.descending,
                        // Sorting based on the specified field
                        sortFieldValueMapper: (_ChartData list2, _) => list2.y),
                  ]),
            ),
            Container(
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.video_call),
                    title: Text('YouTube'),
                  ),
                  ListTile(
                    leading: Icon(Icons.chat),
                    title: Text('WhatsApp'),
                  ),
                  ListTile(
                    leading: Icon(Icons.snapchat),
                    title: Text('SnapChat'),
                  ),
                ],
              ),
            ),
            Container(
                child: RichText(
              text: TextSpan(
                children: const <TextSpan>[
                  TextSpan(
                      text: 'Your Goal',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Color.fromARGB(255, 0, 0, 0))),
                ],
              ),
            )),
          ],
        ),
      ),
    ));
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: 27,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.assistant_photo_rounded),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "27",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25),
                              ),
                              Text("Quiz\nPassed")
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.check_circle),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Maths",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25),
                              ),
                              Text("Last Quiz")
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 27,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.radar),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "30",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25),
                              ),
                              Text("Quiz\nAttempted")
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.sports_score),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "26",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25),
                              ),
                              Text("Avg Score")
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Stack(
              children: [
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 81, 170, 243),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 10,
                      right: 50,
                      left: 50,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        const TextField(
                          decoration: InputDecoration(
                            hintText: "Chapter",
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        const TextField(
                          decoration: InputDecoration(
                            hintText: "Topic",
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        const TextField(
                          decoration: InputDecoration(
                            hintText: "Difficulty Level",
                          ),
                        ),
                        SizedBox(
                          height: 35,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 22),
                          child: MaterialButton(
                            minWidth: double.infinity,
                            height: 50,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RouteTestScreen()));
                            },
                            color: Color.fromARGB(255, 243, 245, 246),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Text(
                              'Create Quiz For Myself',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
