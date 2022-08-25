import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';


class KidsResources extends StatefulWidget {
  const KidsResources({Key? key}) : super(key: key);

  @override
  State<KidsResources> createState() => _KidsResourcesState();
}

class _KidsResourcesState extends State<KidsResources> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(16),
              color: const Color.fromARGB(255, 165, 194, 218),
              child: const Text(
                "Fun Games",
                style: TextStyle(color: Colors.black),
              ),

            ),
           ),
           Container(
            child: Column(children: [
              
            ]),
           )
      ],
      ),
    );
  }
}