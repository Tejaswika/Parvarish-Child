import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:child/constants/db_constants.dart';
import 'package:child/services/snackbar_service.dart';


class AddFriend extends StatefulWidget {
  final String? uid;
  const AddFriend({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<AddFriend> createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  late String _uidfriend;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference _friendCollection =
      _firestore.collection(DBConstants.friendCollectionName);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 205, 122, 220),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 35, top: 50),
            child: const Text(
              'Add Friend Unique ID',
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.fromLTRB(50, 150, 50, 10),
            height: 600,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 163, 81, 180),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Container(
                      padding: const EdgeInsets.all(30),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'Enter UID',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _uidfriend = value.trim();
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      height: 50,
                      onPressed: () {
                        if (_formKey.currentState != null &&
                            _formKey.currentState!.validate()) {
                          if (!_loading) {
                            setState(() {
                              _loading = true;
                            });
                            _addFriend(_uidfriend, widget.uid);
                          }
                        }
                      },
                      color: const Color.fromARGB(255, 116, 49, 128),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: _loading
                          ? const Center(
                              child: SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : const Text(
                              'Save Profile',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _addFriend(_uidfriend, childUID) async {
    bool _isDuplicate = false;
    DocumentReference documentReferencer = _friendCollection.doc(childUID);
    DocumentSnapshot friendDataSnapshot = await documentReferencer.get();
    Map<String, dynamic>? friendData =
        friendDataSnapshot.data() as Map<String, dynamic>;
    List friend = friendData['friends'];
    for (int i = 0; i < friend.length; i++) {
      if (friend[i] == childUID) {
        _isDuplicate = true;
        SnackbarService.showInfoSnackbar(context, 'Friend already registered!!');
        setState(() {
          _loading = false;
        });
        break;
      }
    }
    if (!_isDuplicate) {
      friend.add(_uidfriend);
      Map<String, dynamic> data = <String, dynamic>{
        "friends": friend,
      };
      await documentReferencer.update(data).then((v) {
        SnackbarService.showSuccessSnackbar(context, 'Friend registered!!');
        Navigator.pop(context);
      }).onError((error, stackTrace) {
        SnackbarService.showErrorSnackbar(
            context, 'Some error occured!! Please try after some time.');
        setState(() {
          _loading = false;
        });
      });
    }
  }
}
