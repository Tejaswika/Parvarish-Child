// ignore_for_file: avoid_unnecessary_containers



import 'package:child/screens/card_for_kids_resources.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import '../constants/db_constants.dart';

class KidsResources extends StatefulWidget {
  const KidsResources({Key? key}) : super(key: key);

  @override
  State<KidsResources> createState() => _KidsResourcesState();
}

class _KidsResourcesState extends State<KidsResources> {
  List<String> resourseDataKids=[];
   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference resourceCollection =
      _firestore.collection(DBConstants.resourceCollectionName);
     Map<String, dynamic> resources={};
  List<bool> checkIndex=[false, false, false, false];
  Map<String, dynamic> resourcesData ={};
  String? resourceId;
  bool isLoading=false;
 Future readResourceData() async {
    DocumentReference documentReferencer = resourceCollection.doc('UbGuNIBBPHmH7aS7jobN');
    
    await documentReferencer.get().then((DocumentSnapshot resourcesSnapshot) {
     resources = resourcesSnapshot.data() as Map<String, dynamic>;
      resourcesData = resources['resources'] as Map<String,dynamic>;
      setState(() {
        isLoading=true;
      });
      print(resourcesData);
    });
  }
  @override
  void initState() {
    readResourceData();
    
    super.initState();
  }
  @override

  List<Widget> generateResources(){
    List<Widget> resources=[];
    resourcesData.keys.forEach((String key) =>resources.add(ListTile(title: Text(key))));
    return resources;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        width: double.infinity,
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // children: isLoading? 
          //  generateResources.map(
          //               (Widget appData) => Card(
          //                 child: ListTile(
          //                   title: Text(),
          //                   trailing: Text(),
          //                 ),
          //               ),
          //             ), : [const CircularProgressIndicator(),]    ),
      ),
    ));
  } 
}
          
          
          





            //1
            // (checkIndex[0] == false)
            //     ? Padding(
            //         padding: const EdgeInsets.all(20),
            //         child: Container(
            //             padding: const EdgeInsets.all(16),
            //             color: const Color.fromARGB(255, 165, 194, 218),
            //             child: GestureDetector(
            //               onTap: () {
            //                setState(() {
                  
            //                  checkIndex[0]=;
            //                  checkIndex[1]=true;
            //                  checkIndex[2]=true;
            //                  checkIndex[3]=true;
            //                });
            //               },
            //               child: Container(
            //                   child: const Text(
            //                 "Fun Games",
            //                 style: TextStyle(color: Colors.black),
            //               )),
            //             )),
            //       )
            //     : Padding(
            //         padding: const EdgeInsets.all(20),
            //         child: Container(
            //             height: 100,
            //             width: 200,
            //             padding: const EdgeInsets.all(16),
            //             color: const Color.fromARGB(255, 165, 194, 218),
            //             child: Column(
            //               children: [
            //                  GestureDetector(
            //               onTap: () {
            //                setState(() {
                             
            //                });
            //               },
            //               child: Container(
            //                   child: const Text(
            //                 "Rhymes",
            //                 style: TextStyle(color: Colors.black),
            //               )),
            //             )
            //               ],
            //             )),
            //       ),


            //       //2
            //       (checkIndex[1]== false)
            //     ? Padding(
            //         padding: const EdgeInsets.all(20),
            //         child: Container(
            //             padding: const EdgeInsets.all(16),
            //             color: const Color.fromARGB(255, 165, 194, 218),
            //             child: GestureDetector(
            //               onTap: () {
            //                setState(() {
                            
            //                  checkIndex[0]=false;
            //                  checkIndex[1]=true;
            //                  checkIndex[2]=false;
            //                  checkIndex[3]=false;
            //                });
            //               },
            //               child: Container(
            //                   child: const Text(
            //                 "Fun Games",
            //                 style: TextStyle(color: Colors.black),
            //               )),
            //             )),
            //       )
            //     : Padding(
            //         padding: const EdgeInsets.all(20),
            //         child: Container(
            //             height: 100,
            //             width: 200,
            //             padding: const EdgeInsets.all(16),
            //             color: const Color.fromARGB(255, 165, 194, 218),
            //             child: Column(
            //               children: [
            //                  GestureDetector(
            //               onTap: () {
            //                setState(() {
                             
            //                });
            //               },
            //               child: Container(
            //                   child: const Text(
            //                 "Data",
            //                 style: TextStyle(color: Colors.black),
            //               )),
            //             )
            //               ],
            //             )),
            //       ),


            //       (checkIndex[2] == false)
            //     ? Padding(
            //         padding: const EdgeInsets.all(20),
            //         child: Container(
            //             padding: const EdgeInsets.all(16),
            //             color: const Color.fromARGB(255, 165, 194, 218),
            //             child: GestureDetector(
            //               onTap: () {
            //                setState(() {
                            
            //                  checkIndex[0]=false;
            //                  checkIndex[1]=false;
            //                  checkIndex[2]=true;
            //                  checkIndex[3]=false;
            //                });
            //               },
            //               child: Container(
            //                   child: const Text(
            //                 "Scrrible",
            //                 style: TextStyle(color: Colors.black),
            //               )),
            //             )),
            //       )
            //     : Padding(
            //         padding: const EdgeInsets.all(20),
            //         child: Container(
            //             height: 100,
            //             width: 200,
            //             padding: const EdgeInsets.all(16),
            //             color: const Color.fromARGB(255, 165, 194, 218),
            //             child: Column(
            //               children: [
            //                  GestureDetector(
            //               onTap: () {
            //                setState(() {
                             
            //                });
            //               },
            //               child: Container(
            //                   child: const Text(
            //                 "Data",
            //                 style: TextStyle(color: Colors.black),
            //               )),
            //             )
            //               ],
            //             )),
            //       ),


            //       (checkIndex[3] == false)
            //     ? Padding(
            //         padding: const EdgeInsets.all(20),
            //         child: Container(
            //             padding: const EdgeInsets.all(16),
            //             color: const Color.fromARGB(255, 165, 194, 218),
            //             child: GestureDetector(
            //               onTap: () {
            //                setState(() {
                            
            //                  checkIndex[0]=false;
            //                  checkIndex[1]=false;
            //                  checkIndex[2]=false;
            //                  checkIndex[3]=true;
            //                });
            //               },
            //               child: Container(
            //                   child: const Text(
            //                 "Video",
            //                 style: TextStyle(color: Colors.black),
            //               )),
            //             )),
            //       )
            //     : Padding(
            //         padding: const EdgeInsets.all(20),
            //         child: Container(
            //             height: 100,
            //             width: 200,
            //             padding: const EdgeInsets.all(16),
            //             color: const Color.fromARGB(255, 165, 194, 218),
            //             child: Column(
            //               children: [
            //                  GestureDetector(
            //               onTap: () {
            //                setState(() {
                             
            //                });
            //               },
            //               child: Container(
            //                   child: const Text(
            //                 "Data",
            //                 style: TextStyle(color: Colors.black),
            //               )),
            //             )
            //               ],
            //             )),
            //       ),
          
    

