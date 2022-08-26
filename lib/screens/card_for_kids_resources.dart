import 'package:flutter/material.dart';


class CardKidsResources extends StatefulWidget {
  List<Widget> generateResources;
  CardKidsResources({Key? key, required this.generateResources}) : super(key: key);

  @override
  State<CardKidsResources> createState() => _CardKidsResourcesState();
}

class _CardKidsResourcesState extends State<CardKidsResources> {
  @override
  Widget build(BuildContext context) {
    return Card( //defaut color is white
                  margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: ListTile(

                    leading: Text(
                    widget.generateResources.toString()),
                    
                  )
                );
  }
}