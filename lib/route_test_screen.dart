// ignore_for_file: unused_import, duplicate_import, prefer_const_constructors

import 'dart:convert';

import 'package:child/screens/Quiz/main_quiz.dart';
import 'package:child/screens/background_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:child/screens/WelcomeScreen.dart';

import 'package:child/services/local_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RouteTestScreen extends StatelessWidget {
  const RouteTestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Route Test Screen', style: TextStyle(fontSize: 36)),
            const SizedBox(height: 20),

            // Welcome Screen...........

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WelcomeScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.red,
                  child: const Text(
                    'Welcome Page',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainQuiz(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.red,
                  child: const Text(
                    'Quiz',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () {
                  sendPushMessage();
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.red,
                  child: const Text(
                    'Send Notification',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),

            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: TextButton(
            //     onPressed: () {
            //       BackgroundServices();
            //     },
            //     child: Container(
            //       padding: const EdgeInsets.all(16),
            //       color: Colors.red,
            //       child: const Text(
            //         'BackgroundServices',
            //         style: TextStyle(color: Colors.white),
            //       ),
            //     ),
            //   ),
            // ),
            // LOGIN PAGE ............
          ],
        ),
      ),
    );
  }

  void sendPushMessage() async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAN6PDOmY:APA91bFQ9RmZ9z6t2uwqy695724nwjnm5XPdTmygjL1R54T4AHdIQJAhRKteK4agmEfY87pTNYV22v9DPc__GMObXdvbR_8SHsL_6o_ec8ohyU9XwJ_Dh9xgm3LP2S_1VGB3k4QiQIWe',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': 'This is notification body',
              'title': 'Title',
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to":
                'c50Jx24ZQi-QxyIPZovxpM:APA91bHDUKQghJ_P6CHV2K0NsViZS8D-clKVOD0O-444eHuYXaJdF7fawJRh9dR0WGlbIbmUlHAP8TSDc7I2cTr25bY6RtAciT7svNm4AyJ0PneJkdJ7xiLFbfLCT49SMpWPFO4xdv4n',
          },
        ),
      );
      print('done');
    } catch (e) {
      print("error push notification");
    }
  }
}
