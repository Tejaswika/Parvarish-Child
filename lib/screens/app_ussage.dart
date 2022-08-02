import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'dart:async';
import 'package:app_usage/app_usage.dart';

class FirstScreen extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _FirstScreen();
  }
}

class _FirstScreen extends State<FirstScreen> {
  List apps = [];
  List<AppUsageInfo> _infos = [];
  void initState() {
    super.initState();
  }

  void getUsageStats() async {
    try {
      DateTime endDate = new DateTime.now();
      DateTime startDate = endDate.subtract(Duration(hours: 1));
      List<AppUsageInfo> infoList =
          await AppUsage.getAppUsage(startDate, endDate);
      setState(() {
        _infos = infoList;
      });

      for (var info in infoList) {
        print(info.toString());
      }
    } on AppUsageException catch (exception) {
      print(exception);
    }
  }

  Future<void> getApp() async {
    List _apps = await DeviceApps.getInstalledApplications();

    setState(() {
      apps = _apps;
    });
  }
 @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('App Usage Example'),
          backgroundColor: Colors.green,
        ),
        body: ListView.builder(
            itemCount: _infos.length,
            itemBuilder: (context, index) {
              return ListTile(
                  title: Text(_infos[index].appName),
                  trailing: Text(_infos[index].usage.toString()));
            }),
        floatingActionButton: FloatingActionButton(
            onPressed: getUsageStats, child: Icon(Icons.file_download)),
      ),
    );
  }

}
