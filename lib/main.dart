import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:background_fetch/background_fetch.dart';
import 'package:child/services/local_storage_service.dart';
import 'package:child/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:child/route_test_screen.dart';

import 'package:child/services/background_service.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  LocalStorageService.init();
  NotificationService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RouteTestScreen(),
    );
  }
}
