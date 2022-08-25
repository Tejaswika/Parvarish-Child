import 'package:child/screens/screen_time_report.dart';
import 'package:child/services/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../screens/my_nav_pill.dart';
import '../screens/quiz_screens/assigned_quiz_screen.dart';
import 'drawer_item.dart';
import '../../constants/db_constants.dart';

class HomeAppDrawer extends StatefulWidget {
    List<Map<String, dynamic>> childQuizData;
    Map<String, dynamic>? apps;
    Map<String, dynamic>? childData;
    final String? uid;
  HomeAppDrawer({Key? key, required this.childQuizData, required this.childData, required this.apps, required this.uid}) : super(key: key);

  @override
  State<HomeAppDrawer> createState() => _HomeAppDrawerState();
}

class _HomeAppDrawerState extends State<HomeAppDrawer> {
  Future exitDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to exit from the app?'),
        actions: [
          TextButton(
              onPressed: () => SystemNavigator.pop(),
              child: const Text('EXIT')),
          TextButton(
            child: const Text('CANCEL'),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              // Navigator.of(context).pop(false);
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        child: Padding(
          padding: const EdgeInsets.only(top: 24, bottom: 2),
          child: Column(children: [
            //headerWidget(),
            UserAccountsDrawerHeader(
              accountName: Text(
                widget.childData?[ChildDataConstants.name] ?? "Parent",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                widget.childData?[ChildDataConstants.email] ??
                    "parent@gmail.com",
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white30,
                child: Text('${widget.childData?[ChildDataConstants.name][0]}'),
              ),
            ),

            DrawerItem(
              name: 'Report',
              icon: Icons.book,
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                              ScreenTimeReport(UID:widget.uid)));
                        //builder: (context) => FirstPage(apps: widget.apps)));

              },
            ),
            const Divider(thickness: 1),

            DrawerItem(
              name: 'Assigned Quizes',
              icon: Icons.quiz,
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AssignedQuizScreen(
                              childQuizData: widget.childQuizData,
                              childData: widget.childData,
                            )));
              },
            ),
            const Spacer(),
            DrawerItem(
              name: 'Contat Us',
              icon: Icons.email,
              onPressed: () {
                String? encodeQueryParameters(Map<String, String> params) {
                  return params.entries
                      .map((MapEntry<String, String> e) =>
                          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                      .join('&');
                }

                final Uri emailLaunchUri = Uri(
                  scheme: 'mailto',
                  path: ' parvarishsih@gmail.com',
                  query: encodeQueryParameters(<String, String>{
                    'subject': 'Query/Feedback',
                  }),
                );
                launchUrl(emailLaunchUri);
                Navigator.pop(context);
              },
            ),
            const Divider(thickness: 1),

            DrawerItem(
              name: 'Log out',
              icon: Icons.logout,
              onPressed: () {
                LocalStorageService.setData("UserId", "");
                exitDialog();
              },
            ),
          ]),
        ),
      ),
    );
  }
}
