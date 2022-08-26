import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:child/constants/db_constants.dart';
import 'package:child/widget/leaderboard_tile.dart';

class FriendLeaderboardScreen extends StatefulWidget {
  final Map<String, dynamic>? parentData;
  const FriendLeaderboardScreen({Key? key, required this.parentData})
      : super(key: key);

  @override
  State<FriendLeaderboardScreen> createState() => _FriendLeaderboardScreenState();
}

class _FriendLeaderboardScreenState extends State<FriendLeaderboardScreen> {
  bool isLoading = true;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference childCollection =
      _firestore.collection(DBConstants.childCollectionName);
  Map<String, num> leaderboardData = {};
  late Map<String, dynamic> sorted = {};
  @override
  void initState() {
    getLeaderboardData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Siblings Leaderboard",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: sorted.keys.length,
              itemBuilder: (((context, index) => LeaderboardTile(
                    leaderboard: sorted,
                    index: index,
                  ))),
            ),
    );
  }

  void getLeaderboardData() async {
    // print(widget.parentData);
    widget.parentData?[DBConstants.childCollectionName]
        .asMap()
        .forEach((index, childId) async {
      DocumentReference documentReferencer = childCollection.doc(childId);
      DocumentSnapshot documentSnapshot = await documentReferencer.get();
      double sum = 0;
      Map<String, dynamic> childData =
          documentSnapshot.data() as Map<String, dynamic>;
      // print(childData);
      childData["apps"].values.forEach((appData) {
        sum = sum + appData["current_day_screen_time"];
        // print(sum);
      });
      leaderboardData[childData["name"]] = sum;
      if (leaderboardData.length ==
          widget.parentData?[DBConstants.childCollectionName].length) {
        sorted = SplayTreeMap.from(
            leaderboardData,
            (key1, key2) =>
                leaderboardData[key1]!.compareTo(leaderboardData[key2] ?? 0));
        setState(() {
          isLoading = false;
        });
      }
    });
    // if (!isLoading) {
    // }
  }
}
