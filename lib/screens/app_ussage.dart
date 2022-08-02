import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'dart:async';

class FirstScreen extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _FirstScreen();
  }
}

class _FirstScreen extends State<FirstScreen> {
  List apps = [];
  void initState() {
    super.initState();
  }

  Future<void> getApp() async {
    List _apps = await DeviceApps.getInstalledApplications();

    setState(() {
      apps = _apps;
    });
  }

  Widget build(BuildContext context) {
    getApp();
    return new Scaffold(
      body: new Container(
          child: new ListView.builder(
        itemCount: apps.length,
        itemBuilder: (context, index) {
          return new ListTile(
            title: new Text(apps[index].appName),
          );
        },
      )),
    );
  }
}
