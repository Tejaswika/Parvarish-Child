import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:child/services/local_storage_service.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:child/constants/db_constants.dart';
import 'package:device_apps/device_apps.dart';
import 'dart:async';
import 'package:app_usage/app_usage.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// Creating a reference to the collection
late final CollectionReference _childCollection =
    _firestore.collection(DBConstants.childCollectionName);

List<AppUsageInfo> infoListForToday = [];
List<AppUsageInfo> infoListForWeek = [];
List<AppUsageInfo> infoListForMonth = [];

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
  print("getUsageStats");
  installedApps.forEach((app) => installAppPackageNames.add(app.packageName));

  try {
    DateTime endDate =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
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

void _updateDocument(uid) async {
  // Creating a refrence(Anchor) to the document we want to access
  DocumentReference documentReferencer = _childCollection.doc(uid);
  await getInstalledApps();
  Map<String, dynamic> childAppStats = formatAppStats();

  // Creating data to be stored

  Map<String, dynamic> data = <String, dynamic>{
    "apps": childAppStats,
  };

  // Pushing data to the document
  await documentReferencer
      .update(data)
      .whenComplete(() => print("Apps data updated to the database"))
      .catchError((e) => print(e));
}

Future<void> getInstalledApps() async {
  List<Application> _apps = await DeviceApps.getInstalledApplications();
  print("getInstalledApps");
  getUsageStats(_apps);

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
    // _updateDocument(prefs.getString('UserId'));
  }
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
  service.startService();
}

// to ensure this is executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch
bool onIosBackground(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();
  print('FLUTTER BACKGROUND FETCH');

  return true;
}

void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  // For flutter prior to version 3.0.0
  // We have to register the plugin manually

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString("hello", "world");

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // bring to foreground
  // Timer.periodic(const Duration(minutes: 10), (timer) async {
  //   final hello = preferences.getString("hello");
  //   print(hello);

  //   if (service is AndroidServiceInstance) {
  //     service.setForegroundNotificationInfo(
  //       title: "Child DataBase Updated",
  //       content: "Updated at ${DateTime.now()}",
  //     );
  //   }
  //   getInstalledApps();

  //   /// you can see this log in logcat
  //   print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');

  //   // test using external plugin
  //   final deviceInfo = DeviceInfoPlugin();
  //   String? device;
  //   if (Platform.isAndroid) {
  //     final androidInfo = await deviceInfo.androidInfo;
  //     device = androidInfo.model;
  //   }

  //   if (Platform.isIOS) {
  //     final iosInfo = await deviceInfo.iosInfo;
  //     device = iosInfo.model;
  //   }

  //   service.invoke(
  //     'update',
  //     {
  //       "current_date": DateTime.now().toIso8601String(),
  //       "device": device,
  //     },
  //   );
  // });
}

// class BackgroundServices extends StatefulWidget {
//   const BackgroundServices({Key? key}) : super(key: key);

//   @override
//   State<BackgroundServices> createState() => _BackgroundServicesState();
// }

// class _BackgroundServicesState extends State<BackgroundServices> {
//   String text = "Stop Service";
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Service App'),
//         ),
//         body: Column(
//           children: [
//             StreamBuilder<Map<String, dynamic>?>(
//               stream: FlutterBackgroundService().on('update'),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }

//                 final data = snapshot.data!;
//                 String? device = data["device"];
//                 DateTime? date = DateTime.tryParse(data["current_date"]);
//                 return Column(
//                   children: [
//                     Text(device ?? 'Unknown'),
//                     Text(date.toString()),
//                   ],
//                 );
//               },
//             ),
//             ElevatedButton(
//               child: const Text("Foreground Mode"),
//               onPressed: () {
//                 FlutterBackgroundService().invoke("setAsForeground");
//               },
//             ),
//             ElevatedButton(
//               child: const Text("Background Mode"),
//               onPressed: () {
//                 FlutterBackgroundService().invoke("setAsBackground");
//               },
//             ),
//             ElevatedButton(
//               child: Text(text),
//               onPressed: () async {
//                 final service = FlutterBackgroundService();
//                 var isRunning = await service.isRunning();
//                 if (isRunning) {
//                   service.invoke("stopService");
//                 } else {
//                   service.startService();
//                 }

//                 if (!isRunning) {
//                   text = 'Stop Service';
//                 } else {
//                   text = 'Start Service';
//                 }
//                 setState(() {});
//               },
//             ),
//           ],
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {},
//           child: const Icon(Icons.play_arrow),
//         ),
//       ),
//     );
//   }
// }
