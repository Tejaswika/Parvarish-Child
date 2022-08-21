import 'package:flutter/material.dart';
import 'package:child/screens/my_nav_pill.dart';

class ChildScreen extends StatefulWidget {
  final String? uid;
  const ChildScreen({Key? key, required this.uid}) : super(key: key);

  @override
  ChildScreenState createState() => ChildScreenState();
}

class ChildScreenState extends State<ChildScreen> {
  int _selected = 0;
  void changeSelected(int index) {
    setState(() {
      _selected = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Setup Screen'),
        ),
        // drawer: Drawer(
        //   child: ListView(
        //     padding: EdgeInsets.zero,
        //     // ignore: prefer_const_literals_to_create_immutables
        //     children: [
        //       const UserAccountsDrawerHeader(
        //         decoration: BoxDecoration(
        //           image: DecorationImage(
        //             image: AssetImage('images/bgDrawer.jpg'),
        //             fit: BoxFit.cover,
        //           ),
        //         ),
        //         accountName: Text('Neha Singh'),
        //         accountEmail: Text('test@test.com'),
        //         currentAccountPicture: CircleAvatar(
        //           backgroundColor: Colors.lightBlueAccent,
        //           child: Text(
        //             'NS',
        //             style: TextStyle(fontSize: 30),
        //           ),
        //         ),
        //       ),
        //       ListTile(
        //         selected: _selected == 0,
        //         leading: const Icon(Icons.home),
        //         title: const Text('Home'),
        //         onTap: () {
        //           changeSelected(0);
        //         },
        //         trailing: const Icon(Icons.arrow_forward_ios_rounded),
        //       ),
        //       const Divider(
        //         thickness: 1,
        //         indent: 10,
        //         endIndent: 10,
        //       ),
        //       ListTile(
        //         selected: _selected == 1,
        //         leading: const Icon(Icons.face),
        //         title: const Text('My Profile'),
        //         onTap: () {
        //           changeSelected(1);
        //         },
        //         trailing: const Icon(Icons.arrow_forward_ios_rounded),
        //       ),
        //       const Divider(
        //         thickness: 1,
        //         indent: 10,
        //         endIndent: 10,
        //       ),
        //       ListTile(
        //         selected: _selected == 2,
        //         leading: const Icon(Icons.quiz),
        //         title: const Text('Quiz'),
        //         onTap: () {
        //           changeSelected(2);
        //         },
        //         trailing: const Icon(Icons.arrow_forward_ios_rounded),
        //       ),
        //       const Divider(
        //         thickness: 1,
        //         indent: 10,
        //         endIndent: 10,
        //       ),
        //       ListTile(
        //         selected: _selected == 3,
        //         leading: const Icon(Icons.book),
        //         title: const Text('Report'),
        //         onTap: () {
        //           changeSelected(3);
        //         },
        //         trailing: const Icon(Icons.arrow_forward_ios_rounded),
        //       ),
        //       const Divider(
        //         thickness: 1,
        //         indent: 10,
        //         endIndent: 10,
        //       ),
        //       ListTile(
        //         selected: _selected == 4,
        //         leading: const Icon(Icons.settings),
        //         title: const Text('Settings'),
        //         onTap: () {
        //           changeSelected(4);
        //         },
        //         trailing: const Icon(Icons.arrow_forward_ios_rounded),
        //       ),
        //       const Divider(
        //         thickness: 1,
        //         indent: 10,
        //         endIndent: 10,
        //       ),
        //       const ListTile(),
        //       ListTile(
        //         selected: _selected == 5,
        //         leading: const Icon(Icons.phone_android_rounded),
        //         title: const Text('Contact Us'),
        //         onTap: () {
        //           changeSelected(5);
        //         },
        //         trailing: const Icon(Icons.arrow_forward_ios_rounded),
        //       ),
        //       const Divider(
        //         thickness: 1,
        //         indent: 20,
        //         endIndent: 10,
        //       ),
        //       ListTile(
        //         selected: _selected == 6,
        //         leading: const Icon(Icons.logout_sharp),
        //         title: const Text('Logout'),
        //         onTap: () {
        //           changeSelected(6);
        //         },
        //         trailing: const Icon(Icons.arrow_forward_ios_rounded),
        //       ),
        //     ],
        //   ),
        // ),
        body: SafeArea(
            child: Container(
                padding: const EdgeInsets.all(20),
                child: Wrap(
                  runSpacing: 5.0,
                  spacing: 10.0,
                  children: [
                    RichText(
                      text: const TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Welcome To Parvarish',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40,
                                  color: Color.fromARGB(255, 0, 0, 0))),
                        ],
                      ),
                    ),
                    RichText(
                      text: const TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                              text:
                                  'Enter Unique ID in the parent app for linking profile',
                              style: TextStyle(
                                  fontSize: 20, color: Colors.blueGrey)),
                        ],
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: <Widget>[
                                const CircleAvatar(
                                  radius: 40,
                                  backgroundImage: NetworkImage(
                                      'https://cdn-icons-png.flaticon.com/512/2922/2922561.png'),
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => MyNavPill(
                                                    uid: widget.uid,
                                                  )));
                                    },
                                    child: const Text(
                                      'Neha Singh',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Color.fromARGB(255, 0, 0, 0)),
                                    )),
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MyNavPill(uid: widget.uid)));

                                      print(widget.uid);
                                    },
                                    child: Text(
                                      widget.uid ?? '',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Color.fromARGB(255, 0, 0, 0)),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ))));
  }
}
