// import 'package:flutter/material.dart';
// import 'package:device_apps/device_apps.dart';
// import 'dart:async';
// import 'package:app_usage/app_usage.dart';

// class FirstScreen extends StatefulWidget {
//   State<StatefulWidget> createState() {
//     return _FirstScreen();
//   }
// }

// class _FirstScreen extends State<FirstScreen> {
//   List apps = [];

//   late List<AppUsageInfo> infoListForToday;
//   late List<AppUsageInfo> infoListForWeek;
//   late List<AppUsageInfo> infoListForMonth;

//   void initState() {
//     getInstalledApps();
//     super.initState();
//   }

 
//   void getUsageStats(List<Application> installedApps) async {
//     final List<String> installAppPackageNames = [];
//     installedApps.forEach((app) => installAppPackageNames.add(app.packageName));

//     try {
//       DateTime endDate = DateTime(
//           DateTime.now().year, DateTime.now().month, DateTime.now().day);
//       DateTime startDateToday = endDate.subtract(const Duration(days: 1));
//       int currentWeekDay = DateTime.now().weekday;

//       // Getting App usage stats for current Day
//       infoListForToday = await AppUsage.getAppUsage(startDateToday, endDate);
//       print(infoListForToday);

//       // Getting App usage stats for current Week
//       infoListForWeek = await AppUsage.getAppUsage(
//           endDate.subtract(Duration(days: currentWeekDay - 1)), endDate);

//       // Getting App usage stats for current Month
//       infoListForMonth = await AppUsage.getAppUsage(
//           endDate.subtract(Duration(days: DateTime.now().day - 1)), endDate);

//       // Filtering app usage stats for getting only externally installed apps
//       infoListForToday.where(
//           (element) => installAppPackageNames.contains(element.packageName));
//       print(infoListForToday);

//       infoListForWeek.where(
//           (element) => installAppPackageNames.contains(element.packageName));
//       infoListForMonth.where(
//           (element) => installAppPackageNames.contains(element.packageName));
//     } on AppUsageException catch (exception) {
//       print(exception);
//     }
//   }

//   Future<void> getInstalledApps() async {
//     List<Application> _apps = await DeviceApps.getInstalledApplications();

//     getUsageStats(_apps);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('App Usage Example'),
//           backgroundColor: Colors.green,
//         ),
//         body: ListView.builder(
//             itemCount: _infos.length,
//             itemBuilder: (context, index) {
//               return ListTile(
//                   title: Text(_infos[index].appName),
//                   trailing: Text(_infos[index].usage.toString()));
//             }),
//         floatingActionButton: FloatingActionButton(
//             onPressed: getInstalledApps, child: Icon(Icons.file_download)),
//       ),
//     );
//   }
// }
