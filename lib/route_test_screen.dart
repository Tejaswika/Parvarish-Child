import 'dart:convert';

import 'package:child/screens/add_friend_screen.dart';
import 'package:child/services/local_storage_service.dart';
import 'package:device_policy_manager/device_policy_manager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:child/screens/welcome_screen.dart';
import './screens/quiz_screens/main_quiz.dart';

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
                      builder: (context) => AddFriend(uid:LocalStorageService.getData('UserId')),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.red,
                  child: const Text(
                    'Add Friend',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () async{
                  // sendPushMessage();
                  
                  
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.red,
                  child: const Text(
                    'Lock',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
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
