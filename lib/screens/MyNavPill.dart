import 'dart:math';

import 'package:flutter/material.dart';
import 'package:child/route_test_screen.dart';
import 'package:child/screens/signUp_screen.dart';
import 'package:child/screens/app_timer.dart';
import 'package:child/screens/screentime.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:carousel_slider/carousel_slider.dart';

import 'package:child/constants/db_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// void main() {
//   runApp(MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData.dark().copyWith(
//         elevatedButtonTheme: ElevatedButtonThemeData(
//             style: ButtonStyle(
//           backgroundColor: MaterialStateProperty.all(Colors.blueGrey[800]),
//         )),
//       ),
//       home: MyNavPill()));
// }

//Store this globally

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
late final CollectionReference _childCollection =
    _firestore.collection(DBConstants.childCollectionName);

Map<String, dynamic>? childData;
Map<String, dynamic>? apps;
bool _loading = true;

final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();

class MyNavPill extends StatefulWidget {
  final String? uid;
  const MyNavPill({Key? key, required this.uid}) : super(key: key);

  @override
  _MyNavPillState createState() => _MyNavPillState();
}

class _MyNavPillState extends State<MyNavPill>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parvarish'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Text('Report'),
            ),
            Tab(
              child: Text('Quiz'),
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
              _FirstPage(UID: widget.uid),
              SecondPage(),
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
  final String? UID;

  const _FirstPage({Key? key, required this.UID}) : super(key: key);

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

  Future readchildData(uid) async {
    DocumentReference documentReferencer = _childCollection.doc(uid);
    DocumentSnapshot childDataSnapshot = await documentReferencer.get();

    childData = childDataSnapshot.data() as Map<String, dynamic>;

    apps = childData!['apps'];
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    readchildData(widget.UID);
    if (_loading == false) {
      apps?.forEach((key, app) {
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

    _tooltip = TooltipBehavior(enable: true);

    super.initState();
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
            Container(
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.lock_clock),
                    title: Text('Screen Timer'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TimeScreen()));
                    },
                  ),
                ],
              ),
            )
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

class _ThirdPage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  _ThirdPage({Key? key}) : super(key: key);

  @override
  ThirdPageState createState() => ThirdPageState();
}

class ThirdPageState extends State<_ThirdPage> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Wrap(runSpacing: 5.0, spacing: 10.0, children: [
          Container(
              height: 200,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: false,
                    // enlargeCenterPage: true,
                    //scrollDirection: Axis.vertical,
                    onPageChanged: (index, reason) {
                      setState(
                        () {
                          _currentIndex = index;
                        },
                      );
                    },
                  ),
                  items: imagesList
                      .map(
                        (item) => Padding(
                            padding: const EdgeInsets.all(20),
                            child: Container(
                              height: 40,
                              child: Card(
                                margin: EdgeInsets.all(5),
                                elevation: 20.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                  child: Stack(
                                    children: <Widget>[
                                      Image.network(
                                        item,
                                      ),
                                      Center(
                                        child: Text(
                                          '${titles[_currentIndex]}',
                                          style: TextStyle(
                                            fontSize: 24.0,
                                            fontWeight: FontWeight.bold,
                                            backgroundColor: Colors.black45,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )),
                      )
                      .toList(),
                )
              ])),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imagesList.map((urlOfItem) {
              int index = imagesList.indexOf(urlOfItem);
              return Container(
                width: 10.0,
                height: 10.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == index
                      ? Color.fromRGBO(0, 0, 0, 0.8)
                      : Color.fromRGBO(0, 0, 0, 0.3),
                ),
              );
            }).toList(),
          ),
          Container(
              child: RichText(
            text: TextSpan(
              children: const <TextSpan>[
                TextSpan(
                    text: 'Account Settings',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Color.fromARGB(255, 0, 0, 0))),
              ],
            ),
          )),
          Container(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                ListTile(
                  title: Text('Edit Profile'),
                  trailing: const Icon(Icons.arrow_forward),
                ),
                ListTile(
                  title: Text('Change Password'),
                  trailing: const Icon(Icons.arrow_forward),
                ),
                ListTile(
                  title: Text('Add Classes'),
                  trailing: const Icon(Icons.arrow_forward),
                ),
                ListTile(
                  title: Text('Add Mental Games'),
                  trailing: const Icon(Icons.arrow_forward),
                ),
              ],
            ),
          ),
        ])
      ],
    ));
  }
}
