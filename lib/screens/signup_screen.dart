import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:child/screens/child_screen.dart';
import '../services/local_storage_service.dart';
import 'package:child/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:child/constants/db_constants.dart';
import 'package:device_apps/device_apps.dart';
import 'dart:async';
import 'package:app_usage/app_usage.dart';
import 'package:child/services/local_storage_service.dart';
import '../services/snackbar_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);
  @override
  State<SignUpPage> createState() => _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {
  late String _email, _password, _grade, _age, _phone, _name;
  final auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Creating a reference to the collection
  late final CollectionReference _childCollection =
      _firestore.collection(DBConstants.childCollectionName);

  late List<AppUsageInfo> infoListForToday;
  late List<AppUsageInfo> infoListForWeek;
  late List<AppUsageInfo> infoListForMonth;
  late String? fmcToken;
  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        fmcToken = token;
      });
    });
  }

  void initState() {
    getToken();
    getInstalledApps();
    super.initState();
  }

  Map<String, dynamic> formatAppStats() {
    Map<String, dynamic> _appStats = {};
    infoListForToday.forEach((app) {
      _appStats[app.packageName] = {
        "current_day_screen_time": app.usage.inMinutes,
        "app_name": app.appName
      };
    });
    infoListForWeek.forEach((app) {
      if (_appStats[app.packageName] == null) {
        _appStats[app.packageName] = {
          "current_day_screen_time": 0,
          "app_name": app.appName
        };
      }

      _appStats[app.packageName]["current_week_screen_time"] =
          app.usage.inMinutes;
    });
    infoListForMonth.forEach((app) {
      if (_appStats[app.packageName] == null) {
        _appStats[app.packageName] = {
          "current_day_screen_time": 0,
          "current_week_screen_time": 0,
          "app_name": app.appName
        };
      }
      _appStats[app.packageName]["current_month_screen_time"] =
          app.usage.inMinutes;
    });

    return _appStats;
  }

  void getUsageStats(List<Application> installedApps) async {
    final List<String> installAppPackageNames = [];
    installedApps.forEach((app) => installAppPackageNames.add(app.packageName));

    try {
      DateTime endDate = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);
      DateTime startDateToday = endDate.subtract(const Duration(days: 1));
      int currentWeekDay = DateTime.now().weekday;

      // Getting App usage stats for current Day
      infoListForToday = await AppUsage.getAppUsage(startDateToday, endDate);

      // Getting App usage stats for current Week
      infoListForWeek = await AppUsage.getAppUsage(
          endDate.subtract(Duration(days: currentWeekDay - 1)), endDate);

      // Getting App usage stats for current Month
      infoListForMonth = await AppUsage.getAppUsage(
          endDate.subtract(Duration(days: DateTime.now().day - 1)), endDate);

      // Filtering app usage stats for getting only externally installed apps
      infoListForToday = infoListForToday
          .where(
              (element) => installAppPackageNames.contains(element.packageName))
          .toList();

      infoListForWeek = infoListForWeek
          .where(
              (element) => installAppPackageNames.contains(element.packageName))
          .toList();
      infoListForMonth = infoListForMonth
          .where(
              (element) => installAppPackageNames.contains(element.packageName))
          .toList();
    } on AppUsageException catch (exception) {
      print(exception);
    }
  }

  Future<void> getInstalledApps() async {
    List<Application> _apps = await DeviceApps.getInstalledApplications();

    getUsageStats(_apps);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          backgroundColor: Color.fromARGB(255, 205, 122, 220),
          body: Stack(
            children: [
              Container(
                  padding: EdgeInsets.only(left: 35, top: 50),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  )),
              Container(
                  padding: EdgeInsets.only(left: 38, top: 90),
                  child: Text(
                    'Create your account',
                    style: TextStyle(color: Colors.white60, fontSize: 15),
                  )),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(50, 150, 50, 10),
                height: 600,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 163, 81, 180),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                    child: Container(
                  child: Column(children: [
                    Container(
                      padding: EdgeInsets.all(30),
                      child: TextField(
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.abc),
                          hintText: ' Name',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _name = value.trim();
                          });
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(30),
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.mail),
                          hintText: 'Email',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _email = value.trim();
                          });
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(30),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.numbers),
                          hintText: 'Age',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _age = value.trim();
                          });
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(30),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.school),
                          hintText: 'Class',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _grade = value.trim();
                          });
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(30),
                      child: TextField(
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.phone),
                          hintText: 'Phone No.',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _phone = value.trim();
                          });
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 30, top: 30, right: 30),
                      child: TextField(
                        obscureText: true, //password stays hidden
                        decoration: InputDecoration(
                            hintText: 'Password',
                            prefixIcon: Icon(Icons.key_outlined)),
                        onChanged: (value) {
                          setState(() {
                            _password = value.trim();
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(30),
                      child: MaterialButton(
                        minWidth: double.infinity,
                        height: 50,
                        onPressed: () {
                          _signUp();
                        },
                        color: const Color.fromARGB(255, 116, 49, 128),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      //giave space between 2 boxes
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 25),
                      child: Row(
                        children: [
                          Container(
                              child: Text(
                            'Already have an account?',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          )),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()));
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              )),
                        ],
                      ),
                    )
                  ]),
                )),
              )
            ],
          )),
    );
  }

  void _signUp() {
    auth
        .createUserWithEmailAndPassword(email: _email, password: _password)
        .then((UserCredential userCredential) {
      LocalStorageService.setData('UserId', userCredential.user?.uid ?? '');
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ChildScreen(uid: userCredential.user?.uid)));
      _createDocument(
          userCredential.user?.uid, _name, _email, _phone, _grade, _age);
    });
  }

  void _createDocument(uid, name, email, phone, grade, age) async {
    // Creating a document to Store Data To
    DocumentReference documentReferencer = _childCollection.doc(uid);

    Map<String, dynamic> childAppStats = formatAppStats();

    // Creating data to be stored

    Map<String, dynamic> data = <String, dynamic>{
      "class": _grade,
      "apps": childAppStats,
      "age": age,
      "email": email,
      "name": name,
      "phone": phone,
      "fmcToken": fmcToken,
      "quizes": [],
    };

    // Pushing data to the document
    await documentReferencer.set(data).onError((error, stackTrace) {
      SnackbarService.showErrorSnackbar(
          context, 'Some error occured!! Please try after some time.');
    });
  }
}
