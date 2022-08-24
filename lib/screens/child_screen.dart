import 'package:child/services/snackbar_service.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:child/screens/my_nav_pill.dart';
import 'package:flutter/services.dart';

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Wrap(
            runSpacing: 5.0,
            spacing: 10.0,
            children: [
              const Text('Welcome To Parvarish',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      color: Color.fromARGB(255, 0, 0, 0))),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Steps to link your profile with parent:-',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    Divider(),
                    Text(
                      'Step 1 -> Copy your unique id given below.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blueGrey,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Step 2 -> Open Parvarish Parent on the parent device.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blueGrey,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Step 3 -> Sigup/Login in Parents app.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blueGrey,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Step 4 -> Click on add child.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blueGrey,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Step 5 -> Paste the unique id you copied.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blueGrey,
                      ),
                    ),
                    Divider(),
                  ]),
              const SizedBox(
                height: 5,
              ),
              const Text(
                "Copy your unique id :-",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: DottedDecoration(
                      shape: Shape.box,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Text(
                      widget.uid ?? '',
                      style: const TextStyle(
                          fontSize: 16, color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: widget.uid));
                        SnackbarService.showInfoSnackbar(
                            context, "Unique Id copied successfully");
                      },
                      icon: const Icon(Icons.copy))
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyNavPill(uid: widget.uid),
            ),
          );
        },
        label: const Text("Done"),
        icon: const Icon(Icons.done),
      ),
    );
  }
}
