import 'package:child/screens/MyNavPill.dart';
import 'package:child/screens/UseID.dart';
import 'package:child/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:child/screens/SignUp_Screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:child/constants/db_constants.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {
  late String _email, _password, _class, _age, _phone, _name;
  final auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Creating a reference to the collection
  late final CollectionReference _childCollection =
      _firestore.collection(DBConstants.childCollectionName);

      
  void _createDocument(uid, name, email, phone, _class, age) async {
    // Creating a document to Store Data To
    DocumentReference documentReferencer = _childCollection.doc(uid);

    // Creating data to be stored
    Map<String, dynamic> data = <String, dynamic>{
      "class": _class,
      "age": age,
      "email": email,
      "name": name,
      "phone": phone,
    };

    // Pushing data to the document
    await documentReferencer
        .set(data)
        .whenComplete(() => print("Notes item added to the database"))
        .catchError((e) => print(e));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          backgroundColor: Color.fromARGB(255, 205, 122, 220),
          body: Stack(
            children: [
              Container(
                  padding: EdgeInsets.only(left: 35, top: 50),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  )),
              Container(
                  padding: EdgeInsets.only(left: 38, top: 90),
                  child: Text(
                    'Create your account',
                    style: TextStyle(color: Colors.white60, fontSize: 15),
                  )),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(50, 150, 50, 10),
                height: 600,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 163, 81, 180),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                    child: Container(
                  child: Column(children: [
                    Container(
                      padding: EdgeInsets.all(30),
                      child: TextField(
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.abc),
                          hintText: ' Name',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _name = value.trim();
                          });
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(30),
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.mail),
                          hintText: 'Email',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _email = value.trim();
                          });
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(30),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.numbers),
                          hintText: 'Age',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _age = value.trim();
                          });
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(30),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.school),
                          hintText: 'Class',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _class = value.trim();
                          });
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(30),
                      child: TextField(
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.phone),
                          hintText: 'Phone No.',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _phone = value.trim();
                          });
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 30, top: 30, right: 30),
                      child: TextField(
                        obscureText: true, //password stays hidden
                        decoration: InputDecoration(
                            hintText: 'Password',
                            prefixIcon: Icon(Icons.key_outlined)),
                        onChanged: (value) {
                          setState(() {
                            _password = value.trim();
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(30),
                      child: MaterialButton(
                        minWidth: double.infinity,
                        height: 50,
                        onPressed: () {
                          auth
                              .createUserWithEmailAndPassword(
                                  email: _email, password: _password)
                              .then((UserCredential userCredential) {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => ChildID(
                                        uid: userCredential.user?.uid)));
                            _createDocument(userCredential.user?.uid, _name,
                                _email, _phone, _class, _age);
                          });
                        },
                        color: const Color.fromARGB(255, 116, 49, 128),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      //giave space between 2 boxes
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 25),
                      child: Row(
                        children: [
                          Container(
                              child: Text(
                            'Already have an account?',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          )),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()));
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              )),
                        ],
                      ),
                    )
                  ]),
                )),
              )
            ],
          )),
    );
  }
}
